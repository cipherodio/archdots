;;; early-init.el --- Early startup config -*- lexical-binding: t; -*-

;;; Commentary:
;; Early Emacs startup settings.

;;; Code:

;; Faster startup.
(setq gc-cons-threshold most-positive-fixnum
      gc-cons-percentage 0.6)

;; Start graphical frames with Gruvbox Dark Hard colors.
;; This prevents a white flash before the full theme loads.
(setq default-frame-alist
      '((background-color . "#1d2021")
        (foreground-color . "#ebdbb2")
        (menu-bar-lines . 0)
        (tool-bar-lines . 0)
        (vertical-scroll-bars . nil)
        (horizontal-scroll-bars . nil)
        (alpha-background . 100)))

;; Cleaner startup.
(setq inhibit-startup-screen t
      initial-scratch-message nil)

;; Avoid resizing the frame at startup.
(setq frame-inhibit-implied-resize t)

;; Prefer newer source files over outdated compiled files.
(setq load-prefer-newer t)

;; Keep asynchronous native-compilation warnings in the log without
;; automatically displaying the warnings buffer.
(setq native-comp-async-report-warnings-errors 'silent)

;; Restore garbage collection after startup.
(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (* 100 1024 1024)
                  gc-cons-percentage 0.1)))

;;; early-init.el ends here
