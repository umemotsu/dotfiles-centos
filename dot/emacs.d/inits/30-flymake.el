;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; コードチェッカー
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'flymake)
(load-library "flymake-cursor")
(set-face-background 'flymake-errline "Gray30")
(set-face-background 'flymake-warnline "Gray20")
(when (load "flymake" t)
  (global-set-key "\C-cd" 'flymake-goto-next-error)
  ;; for Python
  (defun flymake-python-init ()
    (let* ((temp-file (flymake-init-create-temp-buffer-copy
                       'flymake-create-temp-with-folder-structure))
           (local-file (file-relative-name
                        temp-file
                        (file-name-directory buffer-file-name))))
      (list (expand-file-name "~/bin/pycheckers") (list local-file))))
  (add-to-list 'flymake-allowed-file-name-masks
               '("\\.py$" flymake-python-init))
  (add-hook 'python-mode-hook (lambda () (flymake-mode t)))
  ;; for Ruby
  (defun flymake-ruby-init ()
    (let* ((temp-file (flymake-init-create-temp-buffer-copy
                       'flymake-create-temp-with-folder-structure))
           (local-file (file-relative-name
                        temp-file
                        (file-name-directory buffer-file-name))))
      (list "ruby" (list "-c" local-file))))
  (add-to-list 'flymake-allowed-file-name-masks
               '("\\.rb$" flymake-ruby-init))
  (add-hook 'ruby-mode-hook (lambda () (flymake-mode t)))
  (push '("^\\(.*\\):\\([0-9]+\\): \\(.*\\)$" 1 2 nil 3) flymake-err-line-patterns)
  ;; for JavaScript
  (defun flymake-javascript-init ()
    (let* ((temp-file (flymake-init-create-temp-buffer-copy
                       'flymake-create-temp-with-folder-structure))
           (local-file (file-relative-name
                        temp-file
                        (file-name-directory buffer-file-name))))
      (list "jsl" (list "-process" local-file))))
  (add-to-list 'flymake-allowed-file-name-masks
               '("\\.js$" flymake-javascript-init))
  (setq flymake-err-line-patterns
        (cons (quote ("\(.+\)(\([0-9]+\)): \(?:lint \)?\(\(?:warning\|SyntaxError\):.+\)" 1 2 nil 3))
              flymake-err-line-patterns))
  (add-hook 'javascript-mode-hook (lambda () (flymake-mode t)))
  (add-hook 'js2-mode-hook (lambda () (flymake-mode t)))
)

;; Flymakeの構文チェックが異常終了しても無視
(defadvice flymake-post-syntax-check (before flymake-force-check-was-interrupted)
  (setq flymake-check-was-interrupted t))
(ad-activate 'flymake-post-syntax-check)
