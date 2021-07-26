;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Python
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; python-mode
(require 'python)

(add-hook 'python-mode-hook
          '(lambda()
             ;; indent設定
             (setq indent-tabs-mode nil)
             (setq indent-level 4)
             (setq python-indent 4)
             (setq python-indent-guess-indent-offset 4)
             (setq tab-width 4)
             ;; 閉じ括弧の補完
             (define-key python-mode-map "\"" 'electric-pair)
             (define-key python-mode-map "\'" 'electric-pair)
             (define-key python-mode-map "(" 'electric-pair)
             (define-key python-mode-map "[" 'electric-pair)
             (define-key python-mode-map "{" 'electric-pair)))

;;;; 終了時のプロンプト無視とか
(add-hook 'inferior-python-mode-hook
          '(lambda()
             (define-key inferior-python-mode-map "\C-c\C-f" 'python-describe-symbol)
             (define-key inferior-python-mode-map "\C-c\C-z" 'kill-buffer-and-window)
             (process-kill-without-query (get-process "Python"))
             ))
