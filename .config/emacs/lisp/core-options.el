;;; core-options.el --- General editor behavior -*- lexical-binding: t; -*-

;;; Commentary:
;; General editing and display behavior.

;;; Code:

(use-package emacs
  :ensure nil

  :preface
  (defun cipher/code-buffer-setup ()
    "Configure display behavior for code and configuration buffers."
    (setq-local truncate-lines t)
    (display-line-numbers-mode 1)
    (display-fill-column-indicator-mode 1))

  :init
  ;; Do not automatically display byte-compilation warnings.
  ;; Preserve any other warning-suppression rules.
  (add-to-list 'warning-suppress-types '(bytecomp))

  :custom
  ;; Do not create backup files such as `file~'.
  (make-backup-files nil)

  ;; Scroll only enough to keep the cursor visible.
  (scroll-conservatively most-positive-fixnum)

  ;; Display literal tab characters using four columns.
  (tab-width 4)

  ;; Insert spaces instead of tab characters when indenting.
  (indent-tabs-mode nil)

  ;; Search case-insensitively by default.
  (case-fold-search t)

  ;; Make searches case-sensitive when they contain uppercase letters.
  (search-upper-case t)

  ;; Use absolute line numbers where line numbers are enabled.
  (display-line-numbers-type 'absolute)

  ;; Display the vertical indicator at column 80.
  (display-fill-column-indicator-column 80)

  ;; Accept y or n instead of requiring yes or no.
  (use-short-answers t)

  ;; Select help window
  (help-window-select t)

  ;; Replace selected text when typing.
  (delete-selection-mode 1)

  ;; Automatically insert matching delimiters such as (), [], and {}.
  (electric-pair-mode 1)

  ;; Show the current column number in the mode line.
  (column-number-mode 1)

  :hook
  ((prog-mode . cipher/code-buffer-setup)
   (conf-mode . cipher/code-buffer-setup)))

(provide 'core-options)
;;; core-options.el ends here
