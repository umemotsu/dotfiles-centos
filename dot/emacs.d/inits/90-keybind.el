;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; キーバインド設定
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; C-hでBackspace
(global-set-key "\C-h" 'delete-backward-char)
;; 改行後にインデント
(global-set-key "\C-m" 'newline-and-indent)
(global-set-key "\C-j" 'newline-and-indent)
;; C-aで行の本当に先頭ではなく，行の非空白文字の先頭へ
(defun back-to-indentation-or-beginning ()
  (interactive)
  (if (= (point) (save-excursion (back-to-indentation) (point)))
      (beginning-of-line) (back-to-indentation)))
(global-set-key "\C-a" 'back-to-indentation-or-beginning)
;; C-xkで現在バッファを削除
(global-set-key "\C-xk" 'kill-this-buffer)
;; C-x:で指定行数にジャンプ
(global-set-key "\C-x:" 'goto-line)
;; C-c C-cでリージョンをコメント
(global-set-key "\C-c\C-c" 'comment-region)
;; C-c C-uでリージョンをコメントアウト
(global-set-key "\C-c\C-u" 'uncomment-region)
;; C-c C-iでリージョンをインデント
(global-set-key "\C-c\C-i" 'indent-region)
;; C-c C-qで問い合わせ型置換
(global-set-key "\C-c\C-q" 'query-replace)

;; 折り返し表示ON/OFF
(defun toggle-truncate-lines ()
  (interactive)
  (if truncate-lines
      (setq truncate-lines nil)
    (setq truncate-lines t))
  (recenter))
(global-set-key "\C-c\C-l" 'toggle-truncate-lines)

;; 分割バッファのサイズ調整
(defun window-resizer ()
  "Controll window size and position with [hjkl]."
  (interactive)
  (let ((window-obj (selected-window))
        (current-width (window-width))
        (current-height (window-height))
        (dx (if (= (nth 0 (window-edges)) 0) 1
              -1))
        (dy (if (= (nth 1 (window-edges)) 0) 1
              -1))
        action c)
    (catch 'end-flag
      (while t
        (setq action
              (read-key-sequence-vector (format "size[%dx%d]"
                                               (window-width)
                                               (window-height))))
        (setq c (aref action 0))
        (cond ((= c ?l)
               (enlarge-window-horizontally dx))
              ((= c ?h)
               (shrink-window-horizontally dx))
              ((= c ?j)
               (enlarge-window dy))
              ((= c ?k)
               (shrink-window dy))
              (t
               (let ((last-command-char (aref action 0))
                     (command (key-binding action)))
                 (when command
                   (call-interactively command)))
               (message "Quit")
               (throw 'end-flag t)))))))
;; C-c C-wでバッファサイズ調整モードに
(global-set-key "\C-c\C-w" 'window-resizer)

;; バッファ分割履歴を有効に
(winner-mode)
;; C-c C-pでバッファ分割をundo
(global-set-key "\C-c\C-p" 'winner-undo)
;; C-c C-nでバッファ分割をredo
(global-set-key "\C-c\C-n" 'winner-redo)
;; C-c C-aでバッファ先頭へ
(global-set-key "\C-c\C-a" 'beginning-of-buffer)
;; C-c C-eでバッファ末尾へ
(global-set-key "\C-c\C-e" 'end-of-buffer)
;; C-x pでC-x oの逆の動作
(define-key ctl-x-map "p"
  #'(lambda(arg) (interactive "p")
      (other-window (- arg))))
;; M-nで次のバッファ
(global-set-key "\M-n" 'other-window)
;; M-pで前のバッファ
(global-set-key "\M-p"
  #'(lambda(arg) (interactive "p")
      (other-window (- arg))))
