;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; TypeScript
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; settings for TypeScript
(add-to-list 'auto-mode-alist '("\\.ts\\'" . typescript-mode))
(autoload 'typescript-mode "TypeScript" "Major mode for editing typescript." t)
;;;; 閉じ括弧の補完
(add-hook 'typescript-mode-hook
          (lambda()
            (define-key typescript-mode-map "\"" 'electric-pair)
            (define-key typescript-mode-map "\'" 'electric-pair)
            (define-key typescript-mode-map "(" 'electric-pair)
            (define-key typescript-mode-map "[" 'electric-pair)
            (define-key typescript-mode-map "{" 'electric-pair)))
