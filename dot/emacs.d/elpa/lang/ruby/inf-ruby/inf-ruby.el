;;; inf-ruby.el --- Run a Ruby process in a buffer

;; Copyright (C) 1999-2008 Yukihiro Matsumoto, Nobuyoshi Nakada

;; Author: Yukihiro Matsumoto
;;         Nobuyoshi Nakada
;;         Cornelius Mika <cornelius.mika@gmail.com>
;;         Dmitry Gutov <dgutov@yandex.ru>
;;         Kyle Hargraves <pd@krh.me>
;; URL: http://github.com/nonsequitur/inf-ruby
;; Created: 8 April 1998
;; Keywords: languages ruby
;; Version: 20131222.1633
;; X-Original-Version: 2.3.2

;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;; This file is not part of GNU Emacs.

;;; Commentary:
;;
;; inf-ruby provides a REPL buffer connected to a Ruby subprocess.
;;
;; If you're installing manually, you'll need to:
;; * drop the file somewhere on your load path (perhaps ~/.emacs.d)
;; * Add the following lines to your .emacs file:
;;
;;    (autoload 'inf-ruby "inf-ruby" "Run an inferior Ruby process" t)
;;    (add-hook 'ruby-mode-hook 'inf-ruby-minor-mode)
;;
;; Or, for enh-ruby-mode:
;;
;;    (add-hook 'enh-ruby-mode-hook 'inf-ruby-minor-mode)
;;
;; Installation via ELPA interface does the above for you
;; automatically.
;;
;; Additionally, consider adding
;;
;;    (add-hook 'after-init-hook 'inf-ruby-switch-setup)
;;
;; to your init file to easily switch from common Ruby compilation
;; modes to interact with a debugger.

;;; Code:

(require 'comint)
(require 'compile)
(require 'ruby-mode)
(require 'thingatpt)

(defgroup inf-ruby nil
  "Run Ruby process in a buffer"
  :group 'languages)

(defcustom inf-ruby-prompt-read-only t
  "If non-nil, the prompt will be read-only.

Also see the description of `ielm-prompt-read-only'.")

(defvar inf-ruby-default-implementation "ruby"
  "Which Ruby implementation to use if none is specified.")

(defconst inf-ruby-prompt-format
  (concat
   (mapconcat
    #'identity
    '("\\(^%s> *\\)"                      ; Simple
      "\\(^(rdb:1) *\\)"                  ; Debugger
      "\\(^\\(irb([^)]+)"                 ; IRB default
      "\\([[0-9]+] \\)?[Pp]ry ?([^)]+)"   ; Pry
      "\\(jruby-\\|JRUBY-\\)?[1-9]\\.[0-9]\\.[0-9]+\\(-?p?[0-9]+\\)?" ; RVM
      "^rbx-head\\)")                     ; RVM continued
    "\\|")
   ;; Statement and nesting counters, common to the last four.
   " ?[0-9:]* ?%s *\\)")
  "Format string for the prompt regexp pattern.
Two placeholders: first char in the Simple prompt, and the last
graphical char in all other prompts.")

(defvar inf-ruby-first-prompt-pattern (format inf-ruby-prompt-format ">" ">")
  "First prompt regex pattern of Ruby interpreter.")

(defvar inf-ruby-prompt-pattern (format inf-ruby-prompt-format "[?>]" "[\]>*\"'/`]")
  "Prompt regex pattern of Ruby interpreter.")

(defvar inf-ruby-mode-hook nil
  "Hook for customizing `inf-ruby-mode'.")

(defvar inf-ruby-mode-map
  (let ((map (copy-keymap comint-mode-map)))
    (define-key map (kbd "C-c C-l") 'ruby-load-file)
    (define-key map (kbd "C-x C-e") 'ruby-send-last-sexp)
    (define-key map (kbd "TAB") 'inf-ruby-complete)
    (define-key map (kbd "C-x C-q") 'inf-ruby-maybe-switch-to-compilation)
    map)
  "Mode map for `inf-ruby-mode'.")

(defvar inf-ruby-implementations
  '(("ruby"     . "irb --prompt default -r irb/completion")
    ("jruby"    . "jruby -S irb --prompt default -r irb/completion")
    ("rubinius" . "rbx -r irb/completion")
    ("yarv"     . "irb1.9 -r irb/completion")
    ("macruby"  . "macirb -r irb/completion")
    ("pry"      . "pry"))
  "An alist of ruby implementations to irb executable names.")

;;;###autoload
(defvar ruby-source-modes '(ruby-mode enh-ruby-mode)
  "Used to determine if a buffer contains Ruby source code.
If it's loaded into a buffer that is in one of these major modes, it's
considered a ruby source file by `ruby-load-file'.
Used by these commands to determine defaults.")

(defvar ruby-prev-l/c-dir/file nil
  "Caches the last (directory . file) pair.
Caches the last pair used in the last `ruby-load-file' command.
Used for determining the default in the
next one.")

(defvar inf-ruby-at-top-level-prompt-p t)

(defconst inf-ruby-error-regexp-alist
  '(("SyntaxError: \\(?:compile error\n\\)?\\([^\(].*\\):\\([1-9][0-9]*\\):" 1 2)
    ("^\tfrom \\([^\(].*\\):\\([1-9][0-9]*\\)\\(:in `.*'\\)?$" 1 2)))

;;;###autoload
(defun inf-ruby-setup-keybindings ()
  "Hook up `inf-ruby-minor-mode' to each of `ruby-source-modes'."
  (warn "`inf-ruby-setup-keybindings' is deprecated, please don't use it anymore.")
  (warn "If you're using `inf-ruby' from Git, please look up the new usage instructions."))

(make-obsolete 'inf-ruby-setup-keybindings 'add-hook "2.3.1")

(defvar inf-ruby-minor-mode-map
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "C-M-x") 'ruby-send-definition)
    (define-key map (kbd "C-x C-e") 'ruby-send-last-sexp)
    (define-key map (kbd "C-c C-b") 'ruby-send-block)
    (define-key map (kbd "C-c M-b") 'ruby-send-block-and-go)
    (define-key map (kbd "C-c C-x") 'ruby-send-definition)
    (define-key map (kbd "C-c M-x") 'ruby-send-definition-and-go)
    (define-key map (kbd "C-c C-r") 'ruby-send-region)
    (define-key map (kbd "C-c M-r") 'ruby-send-region-and-go)
    (define-key map (kbd "C-c C-z") 'ruby-switch-to-inf)
    (define-key map (kbd "C-c C-l") 'ruby-load-file)
    (define-key map (kbd "C-c C-s") 'inf-ruby)
    map))

;;;###autoload
(define-minor-mode inf-ruby-minor-mode
  "Minor mode for interacting with the inferior process buffer.

The following commands are available:

\\{inf-ruby-minor-mode-map}"
  :lighter "" :keymap inf-ruby-minor-mode-map)

(defvar inf-ruby-buffer nil "Current Ruby process buffer.")

(defun inf-ruby-mode ()
  "Major mode for interacting with an inferior Ruby REPL process.

A simple IRB process can be fired up with \\[inf-ruby].

To launch a REPL with project-specific console instead, type
\\[inf-ruby-console-auto].  It recognizes several
project types, including Rails, gems and anything with `racksh'
in their Gemfile.

Customization: When entered, this mode runs `comint-mode-hook' and
`inf-ruby-mode-hook' (in that order).

You can send text to the inferior Ruby process from other buffers containing
Ruby source.

    `ruby-switch-to-inf' switches the current buffer to the ruby process buffer.
    `ruby-send-definition' sends the current definition to the ruby process.
    `ruby-send-region' sends the current region to the ruby process.
    `ruby-send-definition-and-go' and `ruby-send-region-and-go'
        switch to the ruby process buffer after sending their text.

Commands:
`RET' after the end of the process' output sends the text from the
    end of process to point.
`RET' before the end of the process' output copies the sexp ending at point
    to the end of the process' output, and sends it.
`DEL' converts tabs to spaces as it moves back.
`TAB' completes the input at point. IRB, Pry and Bond completion is supported.
`C-M-q' does `TAB' on each line starting within following expression.
Paragraphs are separated only by blank lines.  # start comments.
If you accidentally suspend your process, use \\[comint-continue-subjob]
to continue it.

The following commands are available:

\\{inf-ruby-mode-map}"
  (interactive)
  (let ((orig-mode-line-process mode-line-process))
    (comint-mode)
    (when orig-mode-line-process
      (setq mode-line-process orig-mode-line-process)))
  (setq comint-prompt-regexp inf-ruby-prompt-pattern)
  (ruby-mode-variables)
  (setq major-mode 'inf-ruby-mode)
  (setq mode-name "Inf-Ruby")
  (use-local-map inf-ruby-mode-map)
  (add-hook 'comint-output-filter-functions 'inf-ruby-output-filter nil t)
  (setq comint-get-old-input 'inf-ruby-get-old-input)
  (set (make-local-variable 'compilation-error-regexp-alist)
       inf-ruby-error-regexp-alist)
  (set (make-local-variable 'comint-prompt-read-only) inf-ruby-prompt-read-only)
  (when (eq system-type 'windows-nt)
    (setq comint-process-echoes t))
  (compilation-shell-minor-mode t)
  (run-hooks 'inf-ruby-mode-hook))

(defun inf-ruby-output-filter (output)
  "Check if the current prompt is a top-level prompt."
  (unless (zerop (length output))
    (setq inf-ruby-at-top-level-prompt-p
          (string-match inf-ruby-first-prompt-pattern
                        (car (last (split-string output "\n")))))))

;; adapted from replace-in-string in XEmacs (subr.el)
(defun inf-ruby-remove-in-string (str regexp)
  "Remove all matches in STR for REGEXP and returns the new string."
  (let ((rtn-str "") (start 0) match prev-start)
    (while (setq match (string-match regexp str start))
      (setq prev-start start
            start (match-end 0)
            rtn-str (concat rtn-str (substring str prev-start match))))
    (concat rtn-str (substring str start))))

(defun inf-ruby-get-old-input ()
  "Snarf the sexp ending at point."
  (save-excursion
    (let ((end (point)))
      (re-search-backward inf-ruby-first-prompt-pattern)
      (inf-ruby-remove-in-string (buffer-substring (point) end)
                                 inf-ruby-prompt-pattern))))

;;;###autoload
(defun inf-ruby (&optional impl)
  "Run an inferior Ruby process in a buffer.
With prefix argument, prompts for which Ruby implementation
\(from the list `inf-ruby-implementations') to use.  Runs the
hooks `inf-ruby-mode-hook' \(after the `comint-mode-hook' is
run)."

  (interactive (list (if current-prefix-arg
                         (completing-read "Ruby Implementation: "
                                          (mapc #'car inf-ruby-implementations))
                       inf-ruby-default-implementation)))
  (setq impl (or impl "ruby"))

  (let ((command (cdr (assoc impl inf-ruby-implementations))))
    (run-ruby command impl)))

;;;###autoload
(defun run-ruby (&optional command name)
  "Run an inferior Ruby process, input and output via buffer `*NAME*'.
If there is a process already running in `*NAME*', switch to that buffer.

NAME defaults to \"ruby\". COMMAND defaults to the default entry
in `inf-ruby-implementations'.

\(Type \\[describe-mode] in the process buffer for the list of commands.)"

  (interactive)
  (setq command (or command (cdr (assoc inf-ruby-default-implementation
                                        inf-ruby-implementations))))
  (setq name (or name "ruby"))

  (if (not (comint-check-proc inf-ruby-buffer))
      (let ((commandlist (split-string-and-unquote command))
            (process-environment process-environment))
        ;; http://debbugs.gnu.org/15775
        (setenv "PAGER" (executable-find "cat"))
        (set-buffer (apply 'make-comint name (car commandlist)
                           nil (cdr commandlist)))
        (inf-ruby-mode)))
  (pop-to-buffer (setq inf-ruby-buffer (format "*%s*" name))))

(defun inf-ruby-proc ()
  "Return the current inferior Ruby process.

See variable `inf-ruby-buffer'."
  (or (get-buffer-process (if (eq major-mode 'inf-ruby-mode)
                              (current-buffer)
                            inf-ruby-buffer))
      (error "No current process. See variable inf-ruby-buffer")))

;; These commands are added to the ruby-mode keymap:

(defconst ruby-send-terminator "--inf-ruby-%x-%d-%d-%d--"
  "Template for irb here document terminator.
Must not contain ruby meta characters.")

(defconst inf-ruby-eval-binding
  (concat "(IRB.conf[:MAIN_CONTEXT] && IRB.conf[:MAIN_CONTEXT].workspace.binding) || "
          "(defined?(Pry) && Pry.toplevel_binding)"))

(defconst ruby-eval-separator "")

(defun ruby-send-region (start end)
  "Send the current region to the inferior Ruby process."
  (interactive "r")
  (let (term (file (or buffer-file-name (buffer-name))) line)
    (save-excursion
      (save-restriction
        (widen)
        (goto-char start)
        (setq line (+ start (forward-line (- start)) 1))
        (goto-char start)
        (while (progn
                 (setq term (apply 'format ruby-send-terminator (random) (current-time)))
                 (re-search-forward (concat "^" (regexp-quote term) "$") end t)))))
    ;; compilation-parse-errors parses from second line.
    (save-excursion
      (let ((m (process-mark (inf-ruby-proc))))
        (set-buffer (marker-buffer m))
        (goto-char m)
        (insert ruby-eval-separator "\n")
        (set-marker m (point))))
    (comint-send-string (inf-ruby-proc) (format "eval <<'%s', %s, %S, %d\n"
                                                term inf-ruby-eval-binding
                                                file line))
    (comint-send-region (inf-ruby-proc) start end)
    (comint-send-string (inf-ruby-proc) (concat "\n" term "\n"))))

(defun ruby-send-definition ()
  "Send the current definition to the inferior Ruby process."
  (interactive)
  (save-excursion
    (ruby-end-of-defun)
    (let ((end (point)))
      (ruby-beginning-of-defun)
      (ruby-send-region (point) end))))

(defun ruby-send-last-sexp ()
  "Send the previous sexp to the inferior Ruby process."
  (interactive)
  (ruby-send-region (save-excursion (ruby-backward-sexp) (point)) (point)))

(defun ruby-send-block ()
  "Send the current block to the inferior Ruby process."
  (interactive)
  (save-excursion
    (ruby-end-of-block)
    (end-of-line)
    (let ((end (point)))
      (ruby-beginning-of-block)
      (ruby-send-region (point) end))))

(defun ruby-switch-to-inf (eob-p)
  "Switch to the ruby process buffer.
With argument, positions cursor at end of buffer."
  (interactive "P")
  (if (and inf-ruby-buffer (get-buffer inf-ruby-buffer))
      (pop-to-buffer inf-ruby-buffer)
    (error "No current process buffer, see variable inf-ruby-buffer"))
  (cond (eob-p
         (push-mark)
         (goto-char (point-max)))))

(defun ruby-send-region-and-go (start end)
  "Send the current region to the inferior Ruby process.
Then switch to the process buffer."
  (interactive "r")
  (ruby-send-region start end)
  (ruby-switch-to-inf t))

(defun ruby-send-definition-and-go ()
  "Send the current definition to the inferior Ruby.
Then switch to the process buffer."
  (interactive)
  (ruby-send-definition)
  (ruby-switch-to-inf t))

(defun ruby-send-block-and-go ()
  "Send the current block to the inferior Ruby.
Then switch to the process buffer."
  (interactive)
  (ruby-send-block)
  (ruby-switch-to-inf t))

(defun ruby-load-file (file-name)
  "Load a Ruby file into the inferior Ruby process."
  (interactive (comint-get-source "Load Ruby file: " ruby-prev-l/c-dir/file
                                  ruby-source-modes t)) ;; T because LOAD needs an exact name
  (comint-check-source file-name) ; Check to see if buffer needs saved.
  (setq ruby-prev-l/c-dir/file (cons (file-name-directory    file-name)
                                     (file-name-nondirectory file-name)))
  (comint-send-string (inf-ruby-proc) (concat "(load \""
                                              file-name
                                              "\"\)\n")))

(defun ruby-escape-single-quoted (str)
  "Escape single quotes, double quotes and newlines in STR."
  (replace-regexp-in-string "'" "\\\\'"
    (replace-regexp-in-string "\n" "\\\\n"
      (replace-regexp-in-string "\\\\" "\\\\\\\\" str))))

(defun inf-ruby-completions (expr)
  "Return a list of completions for the Ruby expression starting with EXPR."
  (let* ((proc (inf-ruby-proc))
         (line (buffer-substring (save-excursion (beginning-of-thing 'line))
                                 (point)))
         (comint-filt (process-filter proc))
         (kept "") completions
         ;; Guard against running completions in parallel:
         inf-ruby-at-top-level-prompt-p)
    (set-process-filter proc (lambda (proc string) (setq kept (concat kept string))))
    (unwind-protect
        (let ((completion-snippet
               (format (concat "proc { |expr, line| "
                           "if defined?(Pry.config) then "
                           "completor = Pry.config.completer"
                           ".build_completion_proc(binding, defined?(_pry_) ? _pry_ : Pry.new)"
                           " elsif defined?(Bond.agent) && Bond.started? then "
                           "completor = Bond.agent"
                           " end ? (puts completor.call(expr, line).compact) : "
                           "if defined?(IRB::InputCompletor::CompletionProc) then "
                           "puts IRB::InputCompletor::CompletionProc.call(expr).compact "
                           "end }.call('%s', '%s')\n")
                   (ruby-escape-single-quoted expr)
                   (ruby-escape-single-quoted line))))
          (process-send-string proc completion-snippet)
          (while (and (not (string-match inf-ruby-prompt-pattern kept))
                      (accept-process-output proc 2)))
          (setq completions (butlast (split-string kept "\r?\n") 2))
          ;; Subprocess echoes output on Windows and OS X.
          (when (and completions (string= (concat (car completions) "\n") completion-snippet))
            (setq completions (cdr completions))))
      (set-process-filter proc comint-filt))
    completions))

(defconst inf-ruby-ruby-expr-break-chars " \t\n\"\'`><,;|&{(")

(defun inf-ruby-completion-bounds-of-expr-at-point ()
  "Return bounds of expression at point to complete."
  (save-excursion
    (let ((end (point)))
      (skip-chars-backward (concat "^" inf-ruby-ruby-expr-break-chars))
      (cons (point) end))))

(defun inf-ruby-completion-expr-at-point ()
  "Return expression at point to complete."
  (let ((bounds (inf-ruby-completion-bounds-of-expr-at-point)))
    (buffer-substring (car bounds) (cdr bounds))))

(defun inf-ruby-completion-at-point ()
  "Retrieve the list of completions and prompt the user.
Returns the selected completion or nil."
  (if inf-ruby-at-top-level-prompt-p
      (let* ((expr (inf-ruby-completion-expr-at-point))
             (completions (inf-ruby-completions expr)))
        (if completions
            (if (= (length completions) 1)
                (car completions)
              (completing-read "possible completions: "
                               completions nil t expr))))
    (message "Completion aborted: Not at a top-level prompt")
    nil))

(defun inf-ruby-complete ()
  "Complete the Ruby code at point.
Uses the first one available of Pry, Bond and the default IRB
completion."
  (interactive)
  (let ((replacement (inf-ruby-completion-at-point)))
    (when replacement
      (inf-ruby-complete-replace-expr replacement))))

(defun inf-ruby-complete-replace-expr (str)
  "Replace expression at point with STR."
  (let ((bounds (inf-ruby-completion-bounds-of-expr-at-point)))
    (delete-region (car bounds) (cdr bounds)))
  (insert str))

(defun inf-ruby-complete-or-tab ()
  "Complete the Ruby code at point or call `indent-for-tab-command'."
  (interactive)
  (let ((replacement (inf-ruby-completion-at-point)))
    (if (not replacement)
        (call-interactively 'indent-for-tab-command)
      (inf-ruby-complete-replace-expr replacement))))

(defvar inf-ruby-orig-compilation-mode nil
  "Original compilation mode before switching to `inf-ruby-mode'.")

(defvar inf-ruby-orig-process-filter nil
  "Original process filter before switching to `inf-ruby-mode`.")

(defun inf-ruby-switch-from-compilation ()
  "Make the buffer writable and switch to `inf-ruby-mode'.
Recommended for use when the program being executed enters
interactive mode, i.e. hits a debugger breakpoint."
  (interactive)
  (setq buffer-read-only nil)
  (buffer-enable-undo)
  (let ((mode major-mode))
    (inf-ruby-mode)
    (make-local-variable 'inf-ruby-orig-compilation-mode)
    (setq inf-ruby-orig-compilation-mode mode))
  (let ((proc (get-buffer-process (current-buffer))))
    (when proc
      (make-local-variable 'inf-ruby-orig-process-filter)
      (setq inf-ruby-orig-process-filter (process-filter proc))
      (set-process-filter proc 'comint-output-filter))
    (when (looking-back inf-ruby-prompt-pattern (line-beginning-position))
      (let ((line (match-string 0)))
        (delete-region (match-beginning 0) (point))
        (comint-output-filter proc line)))))

(defun inf-ruby-maybe-switch-to-compilation ()
  "Switch to compilation mode this buffer was in before
`inf-ruby-switch-from-compilation' was called, if it was.
Otherwise, just toggle read-only status."
  (interactive)
  (if inf-ruby-orig-compilation-mode
      (let ((orig-mode-line-process mode-line-process)
            (proc (get-buffer-process (current-buffer)))
            (filter inf-ruby-orig-process-filter))
        (funcall inf-ruby-orig-compilation-mode)
        (setq mode-line-process orig-mode-line-process)
        (when proc
          (set-process-filter proc filter)))
    (toggle-read-only)))

;;;###autoload
(defun inf-ruby-switch-setup ()
  "Modify `rspec-compilation-mode' and `ruby-compilation-mode'
keymaps to bind `inf-ruby-switch-from-compilation' to `??-x C-q'."
  (eval-after-load 'rspec-mode
    '(define-key rspec-compilation-mode-map (kbd "C-x C-q")
       'inf-ruby-switch-from-compilation))
  (eval-after-load 'ruby-compilation
    '(define-key ruby-compilation-mode-map (kbd "C-x C-q")
       'inf-ruby-switch-from-compilation)))

(defvar inf-ruby-console-patterns-alist
  '(("config/application.rb" . rails)
    ("*.gemspec" . gem)
    ("Gemfile" . default))
  "Mapping from file name patterns to name symbols.
`inf-ruby-console-auto' walks up from the current directory until
one of the patterns matches, then calls `inf-ruby-console-NAME',
passing it the found directory.")

(defun inf-ruby-console-match (dir)
  "Find matching console command for DIR, if any."
  (catch 'type
    (dolist (pair inf-ruby-console-patterns-alist)
      (let ((default-directory dir))
        (when (file-expand-wildcards (car pair))
          (throw 'type (cdr pair)))))))

;;;###autoload
(defun inf-ruby-console-auto ()
  "Run the appropriate Ruby console command.
The command and and the directory to run it from are detected
automatically."
  (interactive)
  (let* ((dir (locate-dominating-file default-directory
                                      #'inf-ruby-console-match))
         (type (inf-ruby-console-match dir))
         (fun (intern (format "inf-ruby-console-%s" type))))
    (unless type (error "No matching directory found"))
    (funcall fun dir)))

;;;###autoload
(defun inf-ruby-console-rails (dir)
  "Run Rails console in DIR."
  (interactive "D")
  (let ((default-directory dir))
    (run-ruby "rails console" "rails")))

;;;###autoload
(defun inf-ruby-console-gem (dir)
  "Run IRB console for the gem in DIR.
The main module should be loaded automatically.  If DIR contains a
Gemfile, it should use the `gemspec' instruction."
  (interactive "D")
  (let* ((default-directory dir)
         (base-command (if (file-exists-p "Gemfile")
                           "bundle exec irb"
                         "irb -I lib"))
         files)
    (unless (file-exists-p "lib")
      (error "The directory must contain a 'lib' subdirectory"))
    (dolist (item (directory-files "lib"))
      (unless (file-directory-p item)
        (setq files (cons item files))))
    (run-ruby (concat base-command " "
                      ;; If there are several files under 'lib'
                      ;; (unlikely), load them all.
                      (mapconcat
                       (lambda (file)
                         (concat " -r " (file-name-sans-extension file)))
                       files
                       ""))
              "gem")))

;;;###autoload
(defun inf-ruby-console-default (dir)
  "Run racksh, custom console.rb, or just IRB, in DIR."
  (interactive "D")
  (let ((default-directory dir))
    (unless (file-exists-p "Gemfile")
      (error "The directory must contain a Gemfile"))
    (cond
     ((with-temp-buffer
        (insert-file-contents "Gemfile")
        (re-search-forward "[\"']racksh[\"']" nil t))
      (run-ruby "bundle exec racksh" "racksh"))
     ((file-exists-p "console.rb")
      (run-ruby "ruby console.rb" "console.rb"))
     (t
      (run-ruby "bundle console")))))

;;;###autoload (dolist (mode ruby-source-modes) (add-hook (intern (format "%s-hook" mode)) 'inf-ruby-minor-mode))

(provide 'inf-ruby)
;;; inf-ruby.el ends here
