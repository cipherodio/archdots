;;; init.el --- Main Emacs configuration -*- lexical-binding: t; -*-

;;; Commentary:
;; Main Emacs configuration.

;;; Code:

;; Add personal configuration modules to `load-path`.
;;(add-to-list 'load-path
;;             (expand-file-name "lisp" user-emacs-directory))
(eval-and-compile
          (add-to-list
           'load-path
           (expand-file-name "lisp/" user-emacs-directory)))

;; Keep Customize-generated settings out of this file.
(setq custom-file
      (expand-file-name "custom.el" user-emacs-directory))

(when (file-exists-p custom-file)
  (load custom-file nil 'nomessage))

;; Package management `use-package'.
(require 'core-package)
;; Startup report
(require 'core-startup)
;; General editor behavior.
(require 'core-default)
;; Interface
(require 'core-interface)
;; Minibuffer completion, searching, and navigation.
(require 'core-completion)
;; Keymaps
(require 'core-keymaps)
;; Git change indicators.
(require 'core-diff)
;; Magit
(require 'core-git)
;; Native Tree-sitter parsing for programming languages.
(require 'core-treesit)
;; Language modes and file associations.
(require 'core-lang)
;; Language-server support.
(require 'core-lsp)
;; Diagnostics, and linting.
(require 'core-diagnostics)
;; Automatic formatting with external command-line tools.
(require 'core-format)
;; Spell checking.
(require 'core-spell)
;; Org mode.
(require 'core-org)

;;; init.el ends here
