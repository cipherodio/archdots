;;; core-keymaps.el --- Keybinding assistance -*- lexical-binding: t; -*-

;;; Commentary:
;; Display available keybindings after entering a prefix key.

;;; Code:

(use-package which-key
  :ensure nil
  :custom
  (which-key-idle-delay 0.3)
  ;;(which-key-idle-delay 50)
  ;;(which-key-idle-secondary-delay 0.5)
  ;; Prevent the popup from changing visible buffer position
  (which-key-preserve-window-configuration t)
  :demand t
  :config
  (which-key-mode 1))

(provide 'core-keymaps)
;;; core-keymaps.el ends here
