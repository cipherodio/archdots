;;; core-lsp.el --- Language server configuration -*- lexical-binding: t; -*-

;;; Commentary:
;; Configure Eglot for language-server support.

;;; Code:

(use-package eglot
  :ensure nil

  :preface
  (defun cipher/python-eglot-setup ()
    "Configure Pylsp and start Eglot for the current Python buffer."
    (setq-local
     eglot-workspace-configuration
     '(:pylsp
       (:plugins
        (:pyflakes
         (:enabled :json-false)

         :pycodestyle
         (:enabled :json-false)

         :autopep8
         (:enabled :json-false)

         :yapf
         (:enabled :json-false)

         :mccabe
         (:enabled :json-false)

         :pylsp_mypy
         (:enabled :json-false)

         :pylsp_black
         (:enabled :json-false)

         :pylsp_isort
         (:enabled :json-false)))))

    (eglot-ensure))

  (defun cipher/eldoc-display-in-buffer-and-focus (docs interactive)
    "Display DOCS in the ElDoc buffer.
Focus its window when the documentation was requested interactively."
    (let ((window
           (eldoc-display-in-buffer docs interactive)))
      (when (and interactive
                 (window-live-p window))
        (select-window window))))

  (defun cipher/eglot-eldoc-buffer-only ()
    "Prevent ElDoc from automatically using the echo area."
    (setq-local
     eldoc-display-functions
     '(cipher/eldoc-display-in-buffer-and-focus)))

  :bind
  (:map eglot-mode-map
        ;; Manually display documentation or signature help at point.
        ("C-c h" . eldoc))

  :hook
  ((bash-ts-mode . eglot-ensure)
   (lua-ts-mode . eglot-ensure)
   (python-ts-mode . cipher/python-eglot-setup)
   (json-ts-mode . eglot-ensure)
   (yaml-ts-mode . eglot-ensure)
   (markdown-mode . eglot-ensure)

   ;; Keep ElDoc available without displaying it in the echo area.
   (eglot-managed-mode . cipher/eglot-eldoc-buffer-only))

  :config
  ;; Use Rumdl's language server for Markdown.
  (add-to-list 'eglot-server-programs
               '(markdown-mode . ("rumdl" "server"))))

(provide 'core-lsp)
;;; core-lsp.el ends here
