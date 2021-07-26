;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; powerline
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; powerlineの設定
(add-to-list 'load-path "~/.emacs.d/site-lisp/emacs-powerline")
(require 'powerline)

(defun git-branch-mode-line ()
  (let* ((branch (replace-regexp-in-string
                  "[\r\n]+\\'" ""
                  (shell-command-to-string "git symbolic-ref -q HEAD")))
         (mode-line-str (if (string-match "^refs/heads/" branch)
                            (format "  %s " (substring branch 11)) "")))
    (propertize mode-line-str 'face 'mode-line-2-fg)))

(defun get-coding-type ()
  (labels
      ((remove-os-info (string)
                       (replace-regexp-in-string "-\\(dos\\|unix\\|mac\\)$" "" string)))
    (lexical-let
        ((string (replace-regexp-in-string
                  "-with-signature" "(bom)"
                  (remove-os-info  (symbol-name buffer-file-coding-system)))))
      (if (string-match-p "(bom)" string)
          (downcase string)
        (upcase string)))))

(defun get-eol-type ()
  (case (coding-system-eol-type buffer-file-coding-system)
    (0 "LF")
    (1 "CRLF")
    (2 "CR")
    (otherwise "??")))

(defun buffer-type-mode-line ()
  (let* ((mode-line-str (format " %s[%s] " (get-coding-type) (get-eol-type))))
    (propertize mode-line-str 'face 'mode-line-2-fg)))

(defun buffer-status-mode-line ()
  (let* ((mode-line-str (format " %s%s%s:%s "
                                (if (file-readable-p buffer-file-name) "r" "-")
                                (if (file-writable-p buffer-file-name) "w" "-")
                                (if (file-executable-p buffer-file-name) "x" "-")
                                (if (buffer-modified-p) "*" "-"))))
    (propertize mode-line-str 'face 'mode-line-2-fg)))

(setq-default mode-line-format '(
  (:propertize " %b "           face mode-line-1-fg)
  (:propertize ""              face mode-line-1-bg)
  (:eval (buffer-type-mode-line))
  (:eval (buffer-status-mode-line))
  (:eval (git-branch-mode-line))
  (:propertize ""              face mode-line-2-bg)
  (:propertize " %m "           face mode-line-4-fg)
  (:propertize ""             face mode-line-4-fg)
  (:propertize minor-mode-alist face mode-line-4-fg)
  (:propertize " "              face mode-line-4-fg)
  (:propertize ""              face mode-line-4-bg)
  (:eval (propertize " " 'display '((space :align-to (- right-fringe 24)))))
  (:propertize ""              face mode-line-5-bg)
  (:propertize "  "            face mode-line-2-fg)
  (:propertize "%5l"             face mode-line-2-fg)
  (:propertize ":%4c "            face mode-line-2-fg)
  (:propertize ""              face mode-line-6-bg)
  (:propertize " %6p "           face mode-line-4-fg)))

(set-face-attribute 'mode-line nil
  :foreground "#005f5f" :background "white" :box nil)
(set-face-attribute 'mode-line-inactive nil
  :foreground "#005f5f" :background "white" :box nil)
;; (set-face-attribute 'mode-line-inactive nil
;;   :foreground "#005f5f" :background "#87d7ff" :box nil)

(defun make/set-face (face-name fg-color bg-color weight)
  (make-face face-name)
  (set-face-attribute face-name nil
    :foreground fg-color :background bg-color :box nil :weight weight))
(make/set-face 'mode-line-1-fg "#005f5f" "#ffffff" 'bold)
(make/set-face 'mode-line-1-bg "#ffffff" "#0087af" 'normal)
(make/set-face 'mode-line-2-fg "#87d7ff" "#0087af" 'normal)
(make/set-face 'mode-line-2-bg "#0087af" "#005f87" 'normal)
(make/set-face 'mode-line-4-fg "#87d7ff" "#005f87" 'normal)
(make/set-face 'mode-line-4-bg "#005f87" "white" 'normal)
(make/set-face 'mode-line-5-fg "#005f5f" "#87d7ff" 'normal)
(make/set-face 'mode-line-5-bg "#0087af" "white" 'normal)
(make/set-face 'mode-line-6-bg "#005f87" "#0087af" 'normal)

;; (add-to-list 'load-path "~/.emacs.d/site-lisp/powerline")
;; (require 'powerline)
;; (require 'powerline-my-theme)
;; (powerline-my-theme)

;; モード名を短縮表示
(defvar mode-line-cleaner-alist
  '( ;; For minor-mode, first char is 'space'
    (yas-minor-mode . " Ys")
    (paredit-mode . " Pe")
    (eldoc-mode . "")
    (abbrev-mode . "")
    (undo-tree-mode . " Ut")
    (elisp-slime-nav-mode . " EN")
    (helm-gtags-mode . " HG")
    (flymake-mode . " Fm")
    (ruby-block-mode . " RB")
    (rinari-minor-mode . " RR")
    ;; Major modes
    (lisp-interaction-mode . "Li")
    (python-mode . "Py")
    (cython-mode . "Cy")
    (ruby-mode   . "Rb")
    (emacs-lisp-mode . "El")
    (yatex-mode . "TeX")
    (js2-mode . "JS")
    (json-mode . "JSON")
    (coffee-mode . "CS")
    (csharp-mode . "C#")
    (R-mode . "R")
    (typescript-mode . "TS")
    (html-mode . "HTML")
    (git-commit-mode . "Git")
    (markdown-mode . "Md")))

(defun clean-mode-line ()
  (interactive)
  (loop for (mode . mode-str) in mode-line-cleaner-alist
        do
        (let ((old-mode-str (cdr (assq mode minor-mode-alist))))
          (when old-mode-str
            (setcar old-mode-str mode-str))
          ;; major mode
          (when (eq mode major-mode)
            (setq mode-name mode-str)))))

(add-hook 'after-change-major-mode-hook 'clean-mode-line)
