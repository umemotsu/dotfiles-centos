;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Git
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; git-commit-mode
(add-hook 'git-commit-mode-hook
          '(lambda()
             (setq mode-name "Git")
             ;; コミットメッセージ 1行目のカラー表示を解除
             ;; (set-face-foreground 'git-commit-summary-face nil)
             ;; コミットメッセージ 1行目の太字を解除
             ;; (set-face-bold-p 'git-commit-summary-face nil)
             ;; コミットメッセージ 2行目のカラー表示を解除
             (set-face-foreground 'git-commit-nonempty-second-line-face nil)
             ;; コミットメッセージ 2行目の太字を解除
             (set-face-bold-p 'git-commit-nonempty-second-line-face nil)))
