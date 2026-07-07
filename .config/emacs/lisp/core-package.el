;;; core-package.el --- Package configuration -*- lexical-binding: t; -*-

;;; Commentary:
;; Configure package archives and load `use-package`.

;;; Code:

;; Load Emacs' built-in package manager.
(require 'package)

;; Package repositories used when installing packages.
(setq package-archives
      '(("gnu"    . "https://elpa.gnu.org/packages/")
        ("nongnu" . "https://elpa.nongnu.org/nongnu/")
        ("melpa"  . "https://melpa.org/packages/")))

;; Prefer official GNU and NonGNU archives when the same package
;; is available from multiple repositories.
(setq package-archive-priorities
      '(("gnu"    . 30)
        ("nongnu" . 20)
        ("melpa"  . 10)))

;; `use-package` is built into Emacs 30.2.
(require 'use-package)

(use-package use-package
  :ensure nil
  :custom
  (use-package-always-ensure t)
  (use-package-always-defer t))

(provide 'core-package)
;;; core-package.el ends here
