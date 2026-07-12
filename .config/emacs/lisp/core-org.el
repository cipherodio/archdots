;;; core-org.el --- Org mode configuration -*- lexical-binding: t; -*-

;;; Commentary:
;; Org mode writing, spelling, and word completion settings.

;;; Code:

(use-package org
  :ensure nil
  :functions
  (cape-capf-sort
   cipher/cape-dict-prefix
   corfu-mode)
  :preface
  (defun cipher/org-mode-setup ()
    "Configure Org buffers for writing."
    ;; Wrap paragraphs at 72 columns while typing.
    (setq-local fill-column 72)
    (auto-fill-mode)
    ;; Use English and Tagalog word lists for completion.
    (setq-local cape-dict-file
                (list
                 (expand-file-name
                  "spell/dict/en_US.txt" user-emacs-directory)
                 (expand-file-name
                  "spell/dict/tl_PH.txt" user-emacs-directory)
                 (expand-file-name
                  "spell/user/en_US.add" user-emacs-directory)
                 (expand-file-name
                  "spell/user/tl_PH.add" user-emacs-directory)))
    ;; Display no more than 15 candidates in the Corfu popup.
    (setq-local corfu-count 15)
    ;; Add dictionary completion only to this Org buffer.
    ;; `cape-capf-sort' lets Corfu rank candidates instead of
    ;; preserving their dictionary-file order.
    (add-hook 'completion-at-point-functions
              (cape-capf-sort #'cipher/cape-dict-prefix) 90 t)
    ;; Display automatic completion candidates through Corfu.
    (corfu-mode 1)
    ;; Check and underline misspelled words while writing.
    (flyspell-mode 1))
  :custom
  (org-link-descriptive nil)
  (org-hide-emphasis-markers nil)
  :hook
  (org-mode . cipher/org-mode-setup))

(provide 'core-org)
;;; core-org.el ends here
