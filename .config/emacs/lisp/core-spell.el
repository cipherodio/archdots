;;; core-spell.el --- Spelling configuration -*- lexical-binding: t; -*-

;;; Commentary:
;; Spell checking settings for text-oriented buffers.

;;; Code:

(use-package ispell
  :ensure nil

  :custom
  ;; Use Hunspell as the spelling engine.
  (ispell-program-name "hunspell")

  ;; Use the installed US English dictionary.
  (ispell-dictionary "en_US"))

(use-package text-mode
  :ensure nil

  :custom
  ;; Disable Emacs' built-in Ispell completion interface.
  ;; Cape and Corfu provide word completion instead.
  (text-mode-ispell-word-completion nil))

(use-package flyspell
  :ensure nil
  :commands flyspell-mode

  :custom
  ;; Do not display routine Flyspell messages in the echo area.
  (flyspell-issue-message-flag nil)

  :config
  ;; Display a red wave underneath misspelled words.
  (set-face-attribute
   'flyspell-incorrect nil
   :underline '(:style wave :color "#fb4934")))

(provide 'core-spell)
;;; core-spell.el ends here
