;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; direx
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; direx, direx-project
(require 'direx)
(require 'direx-project)
(setq direx:leaf-icon "  "
            direx:open-icon "▾ "
                  direx:closed-icon "▸ ")
(push '(direx:direx-mode :position left :width 50 :dedicated t)
      popwin:special-display-config)
(global-set-key (kbd "C-x C-j") 'direx-project:jump-to-project-root-or-directory-other-window)
;; (global-set-key (kbd "C-x C-j") 'direx:jump-to-directory-other-window)
;; (global-set-key (kbd "C-x C-j") 'direx-project:jump-to-project-root)
