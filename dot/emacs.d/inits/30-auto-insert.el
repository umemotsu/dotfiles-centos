;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; テンプレートの自動挿入
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun my-short-buffer-file-coding-system (&optional default-coding)
  (let ((coding-str (format "%S" buffer-file-coding-system)))
    (cond ((string-match "shift-jis" coding-str) 'shift_jis)
          ((string-match "euc-jp" coding-str) 'euc-jp)
          ((string-match "utf-8" coding-str) 'utf-8)
          (t (or default-coding 'utf-8)))))

(require 'autoinsert)
(setq auto-insert-directory "~/.emacs.d/auto-insert/template/")
(setq auto-insert-alist
      (nconc '(
               ("\\.py$" . ["template.py" my-template])
               ) auto-insert-alist))
(setq auto-insert-alist
      (nconc '(
               ("\\.pyx$" . ["template.pyx" my-template])
               ) auto-insert-alist))
(setq auto-insert-alist
      (nconc '(
               ("\\.rb$" . ["template.rb" my-template])
               ) auto-insert-alist))

(require 'cl)
(defvar template-replacements-alists
  '(("%file%" . (lambda () (file-name-nondirectory (buffer-file-name))))
    ("%file-without-ext%" . (lambda () (file-name-sans-extension (file-name-nondirectory (buffer-file-name)))))
    ("%encoding%" . (lambda () (format "%S" (my-short-buffer-file-coding-system))))))
(defun my-template ()
  (time-stamp)
  (mapc #'(lambda (c)
            (progn
              (goto-char (point-min))
              (replace-string (car c) (funcall (cdr c)) nil)))
        template-replacements-alists)
  (goto-char (point-max))
  (message "done."))
(add-hook 'find-file-not-found-hooks 'auto-insert)
