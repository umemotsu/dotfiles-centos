;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Color theme
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; 色の設定
(if (null window-system)
    (progn
      (set-face-foreground 'highlight "yellow")
      (set-face-background 'highlight "unspecified-bg")
      (set-face-foreground 'isearch "unspecified-bg")
      (set-face-background 'isearch "cyan")
      ;; (set-face-foreground 'isearch-lazy-highlight-face "black")
      ;; (set-face-background 'isearch-lazy-highlight-face "gray")
      (set-face-foreground 'minibuffer-prompt "green")
      (set-face-foreground 'font-lock-string-face "yellow")
      (set-face-foreground 'font-lock-variable-name-face "blue")
      (set-face-bold-p 'font-lock-variable-name-face t)
      (set-face-foreground 'font-lock-keyword-face "cyan")
      (set-face-foreground 'font-lock-function-name-face "green")
      (setq hl-line-face 'underline)
      (set-face-bold-p 'font-lock-keyword-face nil))
  (set-background-color "Black")
  (set-foreground-color "White")
  (set-cursor-color "Gray")
  (set-frame-parameter nil 'alpha 90)
)
