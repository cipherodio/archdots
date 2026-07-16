;;; core-interface.el --- User interface configuration -*- lexical-binding: t; -*-

;;; Commentary:
;; Font and theme configuration.

;;; Code:

(use-package emacs
  :ensure nil
  :preface
  (defun cipher/apply-frame-font (frame)
    "Apply the configured font to graphical FRAME."
    (when (display-graphic-p frame)
      (set-face-attribute 'default frame
                          :family "Monospace"
                          :height 140)
      (set-face-attribute 'fixed-pitch frame
                          :family "Monospace"
                          :height 140)))
  :config
  ;; Apply the font to the initial graphical frame.
  (cipher/apply-frame-font (selected-frame))
  ;; Apply the font to frames created later, including frames created
  ;; with `emacsclient -c'.
  (add-hook 'after-make-frame-functions
            #'cipher/apply-frame-font))

(use-package gruvbox-theme
  :demand t
  :config
  ;; Load the high-contrast Gruvbox dark theme during startup.
  ;; values: gruvbox-light-soft | gruvbox-dark-hard
  (load-theme 'gruvbox-dark-hard t))

(provide 'core-interface)
;;; core-interface.el ends here
