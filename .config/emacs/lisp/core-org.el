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
  (defun cipher/org-variable-pitch ()
    "Use variable-pitch prose while preserving fixed-width Org elements."
    (variable-pitch-mode 1)
    (dolist (face
             '(org-block
               org-block-begin-line
               org-block-end-line
               org-checkbox
               org-code
               org-date
               org-drawer
               org-formula
               org-indent
              ;; org-list-dt
               org-meta-line
               org-priority
               org-property-value
               org-special-keyword
               org-table
               org-tag
               org-todo
               org-verbatim))
      (face-remap-add-relative face 'fixed-pitch)))

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
  ;;(org-hide-leading-stars t)
  :custom-face
  (org-document-title
   ((t (:inherit variable-pitch
                 :height 1.5
                 :weight bold))))
  (org-level-1
   ((t (:inherit variable-pitch
                 :height 1.3
                 :weight bold))))
  (org-level-2
   ((t (:inherit variable-pitch
                 :height 1.2
                 :weight bold))))
  (org-level-3
   ((t (:inherit variable-pitch
                 :height 1.1
                 :weight bold))))
  (org-level-4
   ((t (:inherit variable-pitch
                 :weight bold))))
  (org-level-5
   ((t (:inherit variable-pitch
                 :weight bold))))
  (org-level-6
   ((t (:inherit variable-pitch
                 :weight bold))))
  (org-level-7
   ((t (:inherit variable-pitch
                 :weight bold))))
  (org-level-8
   ((t (:inherit variable-pitch
                 :weight bold))))
  :hook
  ((org-mode . cipher/org-mode-setup)
   (org-mode . cipher/org-variable-pitch)))

(provide 'core-org)
;;; core-org.el ends here
