;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; multiple cursors
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'multiple-cursors)
(global-set-key (kbd "C-c RET") 'mc/edit-lines)
(global-set-key (kbd "C-c q") 'mc/mark-all-in-region)
(global-set-key (kbd "C-c *") 'mc/mark-all-like-this)
(global-set-key (kbd "C-c i") 'mc/insert-numbers)
(global-set-key (kbd "C-c o") 'mc/sort-regions)
(global-set-key (kbd "C-c O") 'mc/reverse-regions)
(smartrep-define-key
    global-map "C-c" '(("n" . 'mc/mark-next-like-this)
                       ("p" . 'mc/mark-previous-like-this)
                       ("u" . 'mc/unmark-next-like-this)
                       ("U" . 'mc/unmark-previous-like-this)
                       ("s" . 'mc/skip-to-next-like-this)
                       ("S" . 'mc/skip-to-previous-like-this)))
