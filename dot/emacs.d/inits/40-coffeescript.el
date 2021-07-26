;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; CoffeeScript
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; coffee-mode
(add-to-list 'auto-mode-alist '("\\.coffee$" . coffee-mode))
(add-to-list 'auto-mode-alist '("Cakefile" . coffee-mode))
(add-hook 'coffee-mode-hook
          (lambda()
            (define-key coffee-mode-map "\"" 'electric-pair)
            (define-key coffee-mode-map "\'" 'electric-pair)
            (define-key coffee-mode-map "(" 'electric-pair)
            (define-key coffee-mode-map "[" 'electric-pair)
            (define-key coffee-mode-map "{" 'electric-pair)))
