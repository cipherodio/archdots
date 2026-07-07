;;; core-org.el --- Org mode configuration -*- lexical-binding: t; -*-

;;; Commentary:
;; Org mode writing, spelling, and word completion settings.

;;; Code:

(use-package org
  :ensure nil

  :preface
  (defun cipher/org-mode-setup ()
    "Configure Org buffers for writing."
    ;; Use US English for spell checking in this Org buffer.
    (setq-local ispell-local-dictionary "en_US")

    ;; Use the generated plain English word list for completion.
    (setq-local cape-dict-file
                (expand-file-name
                 "dict/en_US.txt"
                 user-emacs-directory))

    ;; Use prefix matching for dictionary words.
    ;;
    ;; Typing `take' matches words beginning with `take', such as
    ;; `taken' and `takes'.
    (setq-local completion-category-overrides
                (cons '(cape-dict (styles basic))
                      completion-category-overrides))

    ;; Display no more than 15 candidates in the Corfu popup.
    (setq-local corfu-count 15)

    ;; Add dictionary completion only to this Org buffer.
    ;;
    ;; `cape-capf-sort' lets Corfu rank candidates instead of
    ;; preserving their dictionary-file order.
    (add-hook 'completion-at-point-functions
              (cape-capf-sort #'cape-dict)
              90
              t)

    ;; Display automatic completion candidates through Corfu.
    (corfu-mode 1)

    ;; Check and underline misspelled words while writing.
    (flyspell-mode 1))

  :hook
  (org-mode . cipher/org-mode-setup))

(provide 'core-org)
;;; core-org.el ends here
