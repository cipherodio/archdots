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
                          :family "Monospace")
      (set-face-attribute 'variable-pitch frame
                          :family "Atkinson Hyperlegible"
                          :weight 'regular
                          :slant 'normal)
      (set-face-attribute 'bold frame
                          :family "Monospace"
                          :weight 'bold
                          :slant 'normal)
      (set-face-attribute 'italic frame
                          :family "Monospace"
                          :weight 'regular
                          :slant 'italic)
      (set-face-attribute 'bold-italic frame
                          :family "Monospace"
                          :weight 'bold
                          :slant 'italic)))
  :config
  ;; Apply the font to the initial graphical frame.
  (cipher/apply-frame-font (selected-frame))
  ;; Apply the font to frames created later, including frames created
  ;; with `emacsclient -c'.
  (add-hook 'after-make-frame-functions #'cipher/apply-frame-font))

(use-package gruvbox-theme
  :demand t
  :config
  ;; Load the high-contrast Gruvbox dark theme during startup.
  ;; values: gruvbox-light-soft | gruvbox-dark-hard
  (load-theme 'gruvbox-dark-hard t)
  ;; Override face colors after loading Gruvbox.
  (custom-set-faces
   '(line-number
     ((t (:foreground "#665c54"
                      :background unspecified))))
   '(line-number-current-line
     ((t (:foreground "#ebdbb2"
                      :background unspecified))))
   '(mode-line
     ((t (:foreground "#ebdbb2"
                      :background "#3c3836"))))
   '(mode-line-inactive
     ((t (:foreground "#928374"
                      :background "#282828"))))
   '(org-level-1
     ((t (:foreground "#83a598"))))
   '(org-level-2
     ((t (:foreground "#8ec07c"))))
   '(org-level-3
     ((t (:foreground "#b8bb26"))))
   '(org-level-4
     ((t (:foreground "#fabd2f"))))
   '(org-level-5
     ((t (:foreground "#fe8019"))))
   '(org-level-6
     ((t (:foreground "#fb4934"))))
   '(org-level-7
     ((t (:foreground "#d3869b"))))
   '(org-level-8
     ((t (:foreground "#ebdbb2"))))
   '(org-block
     ((t (:foreground "#ebdbb2"
                      :background "#282828"
                      :extend t))))
   '(org-block-begin-line
     ((t (:inherit org-block
                   :foreground "#665c54"
                   :background "#282828"
                   :extend t))))
   '(org-block-end-line
     ((t (:inherit org-block
                   :foreground "#665c54"
                   :background "#282828"
                   :extend t))))
   '(org-tag
     ((t (:inherit shadow))))
   '(vertico-current
     ((t (:foreground "#ebdbb2"
                      :background "#3c3836"
                      :weight normal
                      :extend t))))))

(provide 'core-interface)
;;; core-interface.el ends here
