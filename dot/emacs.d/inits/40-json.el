;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; JSON
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; json-mode
(require 'json-mode)
(setq auto-mode-alist
      (append '(("\\.json$" . json-mode)) auto-mode-alist))
(add-hook 'json-mode-hook
          (lambda()
            (define-key json-mode-map "\"" 'electric-pair)
            (define-key json-mode-map "\'" 'electric-pair)
            (define-key json-mode-map "(" 'electric-pair)
            (define-key json-mode-map "[" 'electric-pair)
            (define-key json-mode-map "{" 'electric-pair)))
