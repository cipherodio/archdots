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
  (defface cipher/org-body
    '((t (:inherit variable-pitch
                   :height 1.2)))
    "Face used for ordinary Org body text.")

  (defface cipher/org-planning
    '((t (:height 0.95 :weight normal)))
    "Face used for scheduled timestamps in Org buffers.")

  (defconst cipher/org-planning-font-lock-keywords
    '(("^[ \t]*\\(?:SCHEDULED\\|DEADLINE\\):[ \t]+<[^>\n]+>"
       (0 'cipher/org-planning prepend)))
    "Font Lock rules for Org scheduling and deadline lines.")

  (defun cipher/org-variable-pitch ()
    "Use variable-pitch prose while preserving fixed-width Org elements."
    ;;(variable-pitch-mode 1)
    (buffer-face-set 'cipher/org-body)
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
               org-priority
               org-property-value
               org-table
               org-tag
               org-todo
               org-verbatim))
      (face-remap-set-base face 'fixed-pitch face)))

  (defun cipher/org-mode-setup ()
    "Configure Org buffers for writing."
    ;; Adjust only SCHEDULED lines.
    (font-lock-add-keywords
     nil cipher/org-planning-font-lock-keywords 'append)
    ;; Wrap paragraphs at 72 columns while typing.
    (setq-local fill-column 72)
    (auto-fill-mode 1)
    (display-line-numbers-mode 1)
    ;; Check and underline misspelled words while writing.
    (flyspell-mode 1)
    (flyspell-buffer))
  :custom
  (org-link-descriptive nil)
  (org-hide-emphasis-markers nil)
  ;;(org-hide-leading-stars t)
  :custom-face
  (org-document-title
   ((t (:inherit variable-pitch
                 :height 1.2
                 :weight bold))))
  (org-level-1
   ((t (:inherit variable-pitch
                 :weight bold))))
  (org-level-2
   ((t (:inherit variable-pitch
                 :weight bold))))
  (org-level-3
   ((t (:inherit variable-pitch
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
  ((org-mode . cipher/org-mode-setup)))
   ;; (org-mode . cipher/org-variable-pitch)))

(provide 'core-org)
;;; core-org.el ends here
