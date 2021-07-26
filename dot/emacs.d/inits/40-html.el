;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; HTML
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; html-mode
(require 'zencoding-mode)
(require 'html-fold)
(add-hook 'html-mode-hook 'zencoding-mode)
(add-hook 'html-mode-hook 'html-fold-mode)
(add-hook 'html-mode-hook
          (lambda()
            (setq mode-name "HTML")
            ;; 閉じ括弧の補完
            (define-key html-mode-map "\"" 'electric-pair)
            (define-key html-mode-map "\'" 'electric-pair)
            (define-key html-mode-map "<" 'electric-pair)
            (define-key html-mode-map "(" 'electric-pair)
            (define-key html-mode-map "[" 'electric-pair)
            (define-key html-mode-map "{" 'electric-pair)))
