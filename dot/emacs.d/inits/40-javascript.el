;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; JavaScript
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; js2-mode
(autoload 'js2-mode "js2-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))
(when (load "js2" t)
  (setq js2-cleanup-whitespace nil
        js2-mirror-mode nil
        js2-bounce-indent-flag nil)
  (set-face-foreground 'js2-function-param-face (face-foreground font-lock-variable-name-face))
  (defun indent-and-back-to-indentation ()
    (interactive)
    (indent-for-tab-command)
    (let ((point-of-indentation
           (save-excursion
             (back-to-indentation)
             (point))))
      (skip-chars-forward "\s " point-of-indentation)))
  (define-key js2-mode-map (kbd "\C-i") 'indent-and-back-to-indentation)
  (define-key js2-mode-map (kbd "\C-m") nil)
)
(add-hook 'js2-mode-hook
          '(lambda ()
             ;; インデント関係
             (setq-default c-basic-offset 4)
             (setq-default js2-basic-offset 4)
             (require 'js)
             (setq js-indent-level 4
                   js-expr-indent-offset 4
                   indent-tabs-mode nil)
             (set (make-local-variable 'indent-line-function) 'js-indent-line)
             (define-key js2-mode-map "\"" 'electric-pair)
             (define-key js2-mode-map "\'" 'electric-pair)
             (define-key js2-mode-map "(" 'electric-pair)
             (define-key js2-mode-map "[" 'electric-pair)
             (define-key js2-mode-map "{" 'electric-pair)))
