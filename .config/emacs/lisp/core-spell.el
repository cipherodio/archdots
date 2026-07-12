;;; core-spell.el --- Spelling configuration -*- lexical-binding: t; -*-

;;; Commentary:
;; Spell checking settings for text-oriented buffers.

;;; Code:

(use-package ispell
  :ensure nil
  :functions
  (flyspell-get-word
   flyspell-unhighlight-at
   ispell-set-spellchecker-params
   ispell-hunspell-add-multi-dic)
  :preface
  (defconst cipher/spell-english-add-file
    (expand-file-name "spell/user/en_US.add" user-emacs-directory)
    "File containing personal English words.")

  (defconst cipher/spell-tagalog-add-file
    (expand-file-name "spell/user/tl_PH.add" user-emacs-directory)
    "File containing personal Tagalog words.")

  (defconst cipher/spell-combined-file
    (expand-file-name "spell/user/en-tl.spell" user-emacs-directory)
    "Generated personal dictionary used by Hunspell.")

  (defun cipher/ispell-init-process-silently
      (original-function &rest arguments)
    "Run ORIGINAL-FUNCTION without displaying progress messages."
    (let ((inhibit-message t))
      (apply original-function arguments)))

  (defun cipher/spell-read-words (file)
    "Return the words stored one per line in FILE."
    (unless (file-readable-p file)
      (user-error "Spelling file is missing or unreadable: %s" file))
    (with-temp-buffer
      (insert-file-contents file)
      (split-string (buffer-string) "\n" t "[[:space:]]+")))

  (defun cipher/spell-write-words (file words)
    "Write WORDS alphabetically to FILE without duplicates."
    (unless (and (file-exists-p file) (file-writable-p file))
      (user-error "Spelling file is missing or not writable: %s" file))
    (let ((coding-system-for-write 'utf-8-unix))
      (with-temp-file file
        (dolist (word (sort (delete-dups words) #'string-lessp))
          (insert word "\n")))))

  (defun cipher/spell-sync-combined-file ()
    "Rebuild the combined personal dictionary used by Hunspell."
    (interactive)
    (cipher/spell-write-words
     cipher/spell-combined-file
     (append
      (cipher/spell-read-words
       cipher/spell-english-add-file)
      (cipher/spell-read-words
       cipher/spell-tagalog-add-file))))

  (defun cipher/spell-word-at-point ()
    "Return the word at point and its buffer boundaries."
    (let ((word-data (flyspell-get-word)))
      (unless (and word-data
                   (<= (nth 1 word-data) (point))
                   (<= (point) (nth 2 word-data)))
        (user-error "Place point on or immediately after a word"))
      word-data))

  (defun cipher/spell-add-word (file language)
    "Add the word at point to FILE for LANGUAGE."
    (pcase-let* ((`(,word ,start ,_end)
                  (cipher/spell-word-at-point))
                 (words (cipher/spell-read-words file)))
      (if (member word words)
          (message "%s is already in the %s word list" word language)
        ;; Add the word to its language-specific file.
        (cipher/spell-write-words file (cons word words))
        ;; Rebuild the personal dictionary read by Hunspell.
        (cipher/spell-sync-combined-file)
        ;; Restart Hunspell so the new word becomes available.
        (ispell-kill-ispell t)
        ;; Remove the current misspelling underline.
        (flyspell-unhighlight-at start)
        (message "Added %s to the %s word list" word language))))

  (defun cipher/spell-add-english-word ()
    "Add the word at point to the personal English word list."
    (interactive)
    (cipher/spell-add-word
     cipher/spell-english-add-file "English"))

  (defun cipher/spell-add-tagalog-word ()
    "Add the word at point to the personal Tagalog word list."
    (interactive)
    (cipher/spell-add-word
     cipher/spell-tagalog-add-file "Tagalog"))
  :custom
  ;; Use Hunspell as the spelling engine.
  (ispell-program-name "hunspell")
  ;; Check English and Tagalog words simultaneously.
  (ispell-dictionary "en_US,tl_PH")
  ;; Use the generated union of the personal language word lists.
  (ispell-personal-dictionary cipher/spell-combined-file)
  :init
  ;; Let Hunspell find the locally installed Tagalog dictionary and
  ;; the system-wide English dictionary.
  (setenv "DICPATH"
          (concat (expand-file-name "spell/hunspell" user-emacs-directory)
                  ":/usr/share/hunspell"))
  ;; Select the combined dictionary before Emacs initializes Hunspell.
  (setenv "DICTIONARY" "en_US,tl_PH")
  :demand t
  :config
  ;; Hide the Hunspell process startup message from the echo area.
  (unless (advice-member-p #'cipher/ispell-init-process-silently
                           'ispell-init-process)
    (advice-add 'ispell-init-process
                :around #'cipher/ispell-init-process-silently))
  ;; Discover the installed Hunspell dictionaries.
  (ispell-set-spellchecker-params)
  ;; Register the English and Tagalog dictionary combination.
  (ispell-hunspell-add-multi-dic "en_US,tl_PH"))

(use-package text-mode
  :ensure nil
  :custom
  ;; Disable Emacs' built-in Ispell completion interface.
  ;; Cape and Corfu provide word completion instead.
  (text-mode-ispell-word-completion nil))

(use-package flyspell
  :ensure nil
  :custom
  ;; Do not display routine Flyspell messages in the echo area.
  (flyspell-issue-message-flag nil)
  :bind
  (:map flyspell-mode-map
        ;; Add the word at point to the English word list.
        ("C-c e" . cipher/spell-add-english-word)
        ;; Add the word at point to the Tagalog word list.
        ("C-c t" . cipher/spell-add-tagalog-word))
  :commands flyspell-mode
  :config
  ;; Display a red wave underneath misspelled words.
  (set-face-attribute 'flyspell-incorrect nil
                      :underline '(:style wave :color "#fb4934")))

(use-package flyspell-correct
  :after flyspell
  :bind
  (:map flyspell-mode-map
        ("C-c s" . flyspell-correct-wrapper)))

(provide 'core-spell)
;;; core-spell.el ends here
