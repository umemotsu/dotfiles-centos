;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 自動補完
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; auto-completeの設定
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/elpa/auto-complete/dict/")
(ac-config-default)
;; C-nやC-pで候補を選択
(define-key ac-complete-mode-map "\C-n" 'ac-next)
(define-key ac-complete-mode-map "\C-p" 'ac-previous)
;; ac-pythonの設定
;; (require 'ac-python)
;; (add-to-list 'ac-modes 'python-2-mode)
;; (global-set-key "\M-/" 'ac-start)
