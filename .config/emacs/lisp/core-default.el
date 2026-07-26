;;; core-default.el --- General editor behavior -*- lexical-binding: t; -*-

;;; Commentary:
;; General editing and display behavior.

;;; Code:

(use-package emacs
  :ensure nil
  :preface
  (defconst cipher/trusted-content-directory
    (abbreviate-file-name (expand-file-name "lisp/" user-emacs-directory)))

  (defun cipher/code-buffer-setup ()
    "Configure display behavior for code and configuration buffers."
    (setq-local truncate-lines t)
    (display-line-numbers-mode 1)
    (display-fill-column-indicator-mode 0))

  (defun cipher/keyboard-quit ()
    "Change default behavior of `keyboard-quit'.
The behavior of this command is as follows:
- When the region is active, disable it.
- When a minibuffer is open, but not focused, closed the minibuffer.
- When the completion buffer is selected, close it.
- In every other case use the regular `keyboard-quit'."
    (interactive)
    (cond
     ((region-active-p)
      (keyboard-quit))
     ((derived-mode-p 'completion-list-mode)
      (delete-completion-window))
     ((> (minibuffer-depth) 0)
      (abort-recursive-edit))
     (t
      (keyboard-quit))))
  :init
  (add-to-list 'warning-suppress-types '(bytecomp))
  :custom
  ;; Trust the configuration files
  (trusted-content (list cipher/trusted-content-directory))
  ;; Encoding
  (set-default-coding-systems 'utf-8)
  ;; Do not create backup files such as `file~'.
  (make-backup-files nil)
  ;; Scroll only enough to keep the cursor visible.
  (scroll-conservatively most-positive-fixnum)
  ;; Defer fontification while moving rapidly through new text.
  (jit-lock-defer-time 0.1)
  ;; Skip unnecessary fontification while keyboard input is pending.
  (redisplay-skip-fontification-on-input t)
  ;; Display literal tab characters using four columns.
  (tab-width 4)
  ;; Insert spaces instead of tab characters when indenting.
  (indent-tabs-mode nil)
  ;; Let TAB indent first and complete when completion is available.
  (tab-always-indent 'complete)
  ;; Use absolute line numbers where line numbers are enabled.
  (display-line-numbers-type 'absolute)
  ;; Adjust width of number line
  (display-line-numbers-width 3)
  ;; Accept y or n instead of requiring yes or no.
  (use-short-answers t)
  ;; Select help window
  (help-window-select t)
  ;; Show the current column number in the mode line.
  (column-number-mode 1)
  :bind
  (("<escape>" . cipher/keyboard-quit))
  :hook
  ((prog-mode . cipher/code-buffer-setup)
   (conf-mode . cipher/code-buffer-setup)))


(provide 'core-default)
;;; core-default.el ends here
