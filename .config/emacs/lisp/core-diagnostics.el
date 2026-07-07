;;; core-diagnostics.el --- Diagnostic configuration -*- lexical-binding: t; -*-

;;; Commentary:
;; Configure Flymake diagnostics, navigation, and external diagnostic
;; backends.

;;; Code:

(use-package flymake
  :ensure nil

  :preface
  (defun cipher/flymake-disable-eldoc-diagnostics ()
    "Do not include Flymake diagnostics in ElDoc output."
    (remove-hook 'eldoc-documentation-functions
                 #'flymake-eldoc-function
                 t))

  (defun cipher/flymake-show-buffer-diagnostics ()
    "Show Flymake diagnostics and select their window."
    (interactive)
    (when-let ((window
                (flymake-show-buffer-diagnostics)))
      (select-window window)))

  (defun cipher/flymake-preview-diagnostic ()
    "Preview the Flymake diagnostic at point in its source buffer."
    (when (tabulated-list-get-id)
      (flymake-show-diagnostic (point) t)))

  (defun cipher/flymake-diagnostics-next ()
    "Move to the next diagnostic and preview it."
    (interactive)
    (let ((previous-position (point)))
      (forward-line 1)
      (if (tabulated-list-get-id)
          (cipher/flymake-preview-diagnostic)
        (goto-char previous-position))))

  (defun cipher/flymake-diagnostics-previous ()
    "Move to the previous diagnostic and preview it."
    (interactive)
    (let ((previous-position (point)))
      (forward-line -1)
      (if (tabulated-list-get-id)
          (cipher/flymake-preview-diagnostic)
        (goto-char previous-position))))

  :bind
  (nil :map flymake-mode-map
       ;; Display diagnostics and focus their buffer.
       ("C-c d" . cipher/flymake-show-buffer-diagnostics)

       :map flymake-diagnostics-buffer-mode-map
       ;; Navigate diagnostics and preview them in the source buffer.
       ("C-n" . cipher/flymake-diagnostics-next)
       ("C-p" . cipher/flymake-diagnostics-previous))

  :hook
  (flymake-mode . cipher/flymake-disable-eldoc-diagnostics))

(use-package flymake-ruff
  :hook
  (eglot-managed-mode . flymake-ruff-load))

(provide 'core-diagnostics)
;;; core-diagnostics.el ends here
