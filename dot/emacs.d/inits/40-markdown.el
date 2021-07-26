;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Markdown
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; settings for Markdown
(autoload 'markdown-mode "markdown-mode" "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))
(add-hook 'markdown-mode-hook
          '(lambda()
             ;; 行末の空白文字を削除する機能をオフに
             (remove-hook 'before-save-hook 'delete-trailing-whitespace)
             ;; 閉じ括弧の補完
             (define-key markdown-mode-map "\"" 'electric-pair)
             (define-key markdown-mode-map "\'" 'electric-pair)
             (define-key markdown-mode-map "(" 'electric-pair)
             (define-key markdown-mode-map "[" 'electric-pair)
             (define-key markdown-mode-map "{" 'electric-pair)))
