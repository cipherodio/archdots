;;; core-treesit.el --- Native Tree-sitter configuration -*- lexical-binding: t; -*-

;;; Commentary:
;; Install native Tree-sitter grammars and replace traditional major
;; modes with their Tree-sitter equivalents.

;;; Code:

(use-package treesit
  :ensure nil
  :demand t

  :preface
  (defconst cipher/treesit-languages
    '(bash javascript json lua python yaml)
    "Tree-sitter grammars that should be installed.")

  (defun cipher/treesit-install-missing-grammars ()
    "Install missing grammars listed in `cipher/treesit-languages'."
    (dolist (language cipher/treesit-languages)
      (unless (treesit-language-available-p language)
        (condition-case error-data
            (progn
              (message "Installing Tree-sitter grammar for %s..."
                       language)
              (treesit-install-language-grammar language))
          (error
           (message "Failed to install Tree-sitter grammar for %s: %s"
                    language
                    (error-message-string error-data)))))))

  :init
  ;; Sources used when installing Tree-sitter grammars.
  (setq treesit-language-source-alist
        '((bash
           . ("https://github.com/tree-sitter/tree-sitter-bash"))

          (javascript
           . ("https://github.com/tree-sitter/tree-sitter-javascript"))

          (json
           . ("https://github.com/tree-sitter/tree-sitter-json"))

          (lua
           . ("https://github.com/tree-sitter-grammars/tree-sitter-lua"))

          (python
           . ("https://github.com/tree-sitter/tree-sitter-python"))

          (yaml
           . ("https://github.com/tree-sitter-grammars/tree-sitter-yaml"))))

  :config
  ;; Download and compile only grammars that are not installed.
  (cipher/treesit-install-missing-grammars)

  ;; Replace traditional modes with Tree-sitter modes.
  (add-to-list 'major-mode-remap-alist
               '(sh-mode . bash-ts-mode))

  (add-to-list 'major-mode-remap-alist
               '(python-mode . python-ts-mode))

  :custom
  ;; Use the maximum Tree-sitter syntax-highlighting level.
  (treesit-font-lock-level 4))

(provide 'core-treesit)
;;; core-treesit.el ends here
