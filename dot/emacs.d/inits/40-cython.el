;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Cython
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; cython-mode
(require 'cython-mode)
(add-hook 'cython-mode-hook
          (lambda()
            ;; 自動補完の切り替え
            (global-set-key "\C-ce" 'auto-complete-mode)
            ;; 閉じ括弧の補完
            (define-key cython-mode-map "\"" 'electric-pair)
            (define-key cython-mode-map "\'" 'electric-pair)
            (define-key cython-mode-map "(" 'electric-pair)
            (define-key cython-mode-map "[" 'electric-pair)
            (define-key cython-mode-map "{" 'electric-pair)))
