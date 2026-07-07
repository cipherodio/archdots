;;; core-keymaps.el --- Keybinding assistance -*- lexical-binding: t; -*-

;;; Commentary:
;; Display available keybindings after entering a prefix key.

;;; Code:

(use-package which-key
  :ensure nil
  :demand t
  :config
  (which-key-mode 1)
  :custom
  (which-key-idle-delay 0.3)
  (which-key-idle-secondary-delay 0.5))

(provide 'core-keymaps)
;;; core-keymaps.el ends here
