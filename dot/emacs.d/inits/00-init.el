;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; 文字コードと実行パス関係
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; 日本語環境用
(set-language-environment "Japanese")
(set-default-coding-systems 'utf-8)
(setq default-buffer-file-coding-system 'utf-8)
(set-buffer-file-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-clipboard-coding-system 'utf-8)
(prefer-coding-system 'utf-8-unix)

;; Cocoa Emacsでパスが引き継がれない問題を解消
;; 下のパスほど優先度が高い
(if (and (window-system) (eq system-type 'darwin))
    (dolist (dir (list
                  "/sbin"
                  "/usr/sbin"
                  "/bin"
                  "/usr/bin"
                  "/usr/local/bin"
                  (expand-file-name "~/bin")
                  (expand-file-name "~/.pyenv/bin")
                  (expand-file-name "~/.pyenv/shims")
                  (expand-file-name "~/.rbenv/bin")
                  (expand-file-name "~/.rbenv/shims")))
      ;; exec-pathをPATHと同じに
      (when (and (file-exists-p dir) (not (member dir exec-path)))
        ;; (setenv "PATH" (concat dir ":" (getenv "PATH")))
        (setq exec-path (append (list dir) exec-path)))))
