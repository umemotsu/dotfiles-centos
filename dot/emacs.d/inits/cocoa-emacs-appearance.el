;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Cocoa Emacs用の見た目の設定
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; ツールバーを表示しない
(tool-bar-mode -1)
;; スクロールバーを表示しない
;; (set-scroll-bar-mode nil)
;; Macのキーバインドを使う
(setq mac-option-modifier 'meta)
;; フォント設定
(if (eq window-system 'mac)
    (require 'carbon-font)
)
;; フォントをRictyに
(set-face-attribute 'default nil :family "Ricty" :height 140)
(set-fontset-font "fontset-default"
                  'japanese-jisx0208 '("Ricty" . "iso10646-*"))
(setq-default line-spacing 2)

;; カラーテーマをSolarizedに
(require 'solarized-theme)
(load-theme 'solarized-dark t)
