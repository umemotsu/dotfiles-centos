;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Look & Feel
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; 起動時の画面を表示しない
(setq inhibit-splash-screen t)
;; 自動バックアップを抑制
(setq backup-inhibited t)
;; オートセーブファイルを自動削除
(setq delete-auto-save-files t)
;; 変更のあったファイルの自動再読み込み
(global-auto-revert-mode 1)
;; インデントTAB文字を使わない（空白文字を使う）
(setq-default indent-tabs-mode nil)
;; C-kで改行文字も削除
(setq kill-whole-line t)
;; タブキー設定
(setq default-tab-width 4)
(setq indent-line-function 'indent-relative-maybe)
;; 保存時に自動で最終行に改行を追加
(setq require-final-newline t)
;; 暫定マーク時に色を表示しない
(setq transient-mark-mode nil)
;; 終了時の画面を保存する
;; (desktop-save-mode 1)
;; メニューバーを表示しない
(menu-bar-mode -1)
;; 行数・列数をモードラインに表示
(line-number-mode t)
(column-number-mode t)
;; バッテリー残量表示
;; (display-battery-mode 1)
;; 時間をモードラインに表示
(display-time-mode t)
;; 時間を24時間表記で表示
(setq display-time-24hr-format t)
;; 現在行の下に下線を表示
(global-hl-line-mode t)
;; partial-completionを使う
;; (partial-completion-mode t)
;; 保存時に自動で行末にある無駄な空白を削除
(add-hook 'before-save-hook 'delete-trailing-whitespace)
;; 保存時に自動で実行可能スクリプトならファイルを実行可能にする
(add-hook 'after-save-hook
          'executable-make-buffer-file-executable-if-script-p)
;; 対応する括弧を光らせる
(show-paren-mode 1)

;; iswitchbを使う（C-xbによるバッファ選択が進化）
(iswitchb-mode 1)
;; iswitchbの際に無視するバッファリスト
(setq iswitchb-buffer-ignore (append iswitchb-buffer-ignore '("*Messages*" "*scratch*" "*Completions*" "*Kill Ring*")))

;; 行番号を表示
(require 'linum)
(global-linum-mode t)
(set-face-attribute 'linum nil
                    :foreground "color-240")
(setq linum-format "%4d: ")
;; (require 'wb-line-number)
;; (wb-line-number-toggle)
;; (global-set-key "\C-x3" 'wb-line-number-split-window-horizontally)
;; (setq wb-line-number-scroll-bar t)
;; (setq truncate-partial-width-windows nil)

;; スクロールを１行ずつに
(setq scroll-step 1)
;; マウスホイールでも1行ずつスクロール
(defun scroll-down-with-lines()
  ""
  (interactive)
  (scroll-down 1)
)
(defun scroll-up-with-lines()
  ""
  (interacrive)
  (scroll-up 1)
)
(global-set-key [mouse-4] 'scroll-down-with-lines)
(global-set-key [mouse-5] 'scroll-up-with-lines)
;; 「shift + 矢印キー」でバッファ移動
(setq windmove-wrap-around t)
(windmove-default-keybindings)

;; コピペにクリップボードを利用
(defun copy-from-osx ()
  (shell-command-to-string "pbpaste"))

(defun paste-to-osx (text &optional push)
  (let ((process-connection-type nil))
    (let ((proc (start-process "pbcopy" "*Messages*" "pbcopy")))
      (process-send-string proc text)
      (process-send-eof proc))))

(setq interprogram-cut-function 'paste-to-osx)
(setq interprogram-paste-function 'copy-from-osx)

;; 重複ファイルを区別
(require 'uniquify)
(setq uniquify-buffer-name-style 'post-forward-angle-brackets)

;; 読み込み権限しかないときにsudoするか確認
(defun th-rename-tramp-buffer ()
  (when (file-remote-p (buffer-file-name))
    (rename-buffer
     (format "%s:%s"
             (file-remote-p (buffer-file-name) 'method)
             (buffer-name)))))

(add-hook 'find-file-hook
          'th-rename-tramp-buffer)

(defadvice find-file (around th-find-file activate)
  "Open FILENAME using tramp's sudo method if it's read-only."
  (if (and (not (file-writable-p (ad-get-arg 0)))
           (y-or-n-p (concat "File "
                             (ad-get-arg 0)
                             " is read-only.  Open it as root? ")))
      (th-find-file-sudo (ad-get-arg 0))
    ad-do-it))

(defun th-find-file-sudo (file)
  "Opens FILE with root privileges."
  (interactive "F")
    (set-buffer (find-file (concat "/sudo::" file))))
