;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; YaTeX
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; yatex-mode
(setq auto-mode-alist
      (cons (cons "\\.tex$" 'yatex-mode) auto-mode-alist))
(autoload 'yatex-mode "yatex" "Yet Another LaTeX mode" t)
(when (eq system-type 'darwin)
  (setq tex-command "~/Library/TeXShop/bin/platex2pdf-utf8"
        dvi-command "open -a Preview"))
(setq YaTeX-kanji-code nil)
