;;; core-spell.el --- Spelling configuration -*- lexical-binding: t; -*-

;;; Commentary:
;; Hunspell, Flyspell, and Flyspell Correct configuration.

;;; Code:

(use-package ispell
  :ensure nil
  :functions
  (flyspell-do-correct
   flyspell-get-word
   ispell-hunspell-add-multi-dic
   ispell-set-spellchecker-params)
  :preface
  (defconst cipher/spell-directory
    (expand-file-name "spell" user-emacs-directory)
    "Directory containing Hunspell dictionaries.")

  (defconst cipher/spell-personal-dictionary
    (expand-file-name "spell/user.add" user-emacs-directory)
    "Hunspell personal dictionary.")

  (defun cipher/ispell-init-process-silently
      (original-function &rest arguments)
    "Run ORIGINAL-FUNCTION without displaying echo area messages."
    (let ((inhibit-message t))
      (apply original-function arguments)))

  (defun cipher/spell-add-word ()
    "Add the word at point to the Hunspell personal dictionary."
    (interactive)
    (let ((current-location (point))
          (word (flyspell-get-word)))
      (when (consp word)
        (flyspell-do-correct
         'save
         nil
         (car word)
         current-location
         (cadr word)
         (caddr word)
         current-location))))

  :custom
  ;; Use Hunspell.
  (ispell-program-name "hunspell")

  ;; Check English and Tagalog simultaneously.
  (ispell-dictionary "en_US,tl_PH")

  ;; Personal dictionary.
  (ispell-personal-dictionary
   cipher/spell-personal-dictionary)

  :init
  ;; Search the local Tagalog dictionary before the system ones.
  (setenv
   "DICPATH"
   (mapconcat
    #'identity
    (list
     cipher/spell-directory
     "/usr/share/hunspell")
    path-separator))

  ;; Default dictionary.
  (setenv
   "DICTIONARY"
   "en_US,tl_PH")

  :config
  ;; Hide Hunspell startup messages.
  (advice-add
   'ispell-init-process
   :around
   #'cipher/ispell-init-process-silently)

  ;; Discover installed Hunspell dictionaries.
  (ispell-set-spellchecker-params)

  ;; Register the English + Tagalog combination.
  (ispell-hunspell-add-multi-dic
   "en_US,tl_PH"))

(use-package flyspell
  :ensure nil
  :commands flyspell-mode
  :custom
  ;; Do not display routine Flyspell messages.
  (flyspell-issue-message-flag nil)
  ;; Do not mark duplicated words.
  (flyspell-mark-duplications-flag nil)
  (flyspell-duplicate-distance 0)
  :bind
  (:map flyspell-mode-map
        ("C-c s a" . cipher/spell-add-word)
        ("C-c s c" . flyspell-correct-wrapper))
  :config
  ;; Display misspelled words with a red wave underline.
  (set-face-attribute 'flyspell-incorrect nil
   :underline '(:color "#fb4934" :style wave)))

(use-package flyspell-correct
  :after flyspell)

(provide 'core-spell)
;;; core-spell.el ends here
