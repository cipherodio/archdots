;;; core-lang.el --- Language mode configuration -*- lexical-binding: t; -*-

;;; Commentary:
;; File associations and language-specific major-mode settings.

;;; Code:

(use-package lua-ts-mode
  :ensure nil
  :mode
  ("\\.lua\\'" . lua-ts-mode))

(use-package yaml-ts-mode
  :ensure nil
  :mode
  ("\\.ya?ml\\'" . yaml-ts-mode))

(use-package js
  :ensure nil
  :mode
  (("\\.js\\'" . js-ts-mode)
   ("\\.mjs\\'" . js-ts-mode)
   ("\\.cjs\\'" . js-ts-mode)))

(use-package json-ts-mode
  :ensure nil
  :mode
  ("\\.json\\'" . json-ts-mode))

(use-package markdown-mode
  :preface
  (defun cipher/markdown-mode-setup ()
    "Configure Markdown buffers."
    ;; Wrap paragraphs at 72 columns while typing.
    (setq-local fill-column 72)
    (auto-fill-mode 1))

  :mode
  (("\\.md\\'" . markdown-mode)
   ("\\.markdown\\'" . markdown-mode))

  :hook
  (markdown-mode . cipher/markdown-mode-setup)

  :custom
  ;; Recognize and highlight Pandoc-style YAML front matter.
  (markdown-use-pandoc-style-yaml-metadata t))

(provide 'core-lang)
;;; core-lang.el ends here
