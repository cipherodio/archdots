;;; core-completion.el --- Minibuffer completion -*- lexical-binding: t; -*-

;;; Commentary:
;; Minibuffer completion, searching, navigation, and contextual actions.

;;; Code:

(use-package vertico
  :init
  ;; Display minibuffer completion candidates vertically.
  (vertico-mode 1))

(use-package orderless
  :custom
  ;; Use Orderless for commands, buffers, symbols, and most other
  ;; minibuffer completion categories.
  (completion-styles '(orderless basic))

  ;; Do not use package-provided category defaults automatically.
  (completion-category-defaults nil)

  ;; Use normal path-oriented completion for files.
  ;;
  ;; This makes input such as:
  ;;   ~/.config/emacs/l
  ;;
  ;; complete to:
  ;;   ~/.config/emacs/lisp/
  ;;
  ;; instead of matching `elpa' merely because it contains an `l'.
  (completion-category-overrides
   '((file (styles partial-completion))
     (cape-dict (style basic)))))

(use-package marginalia
  :bind
  (:map minibuffer-local-map
        ;; Cycle between available annotation levels.
        ("M-A" . marginalia-cycle))
  :init
  ;; Show information beside minibuffer candidates.
  (marginalia-mode 1))

(use-package consult
  :demand t
  :preface
  (defun cipher/consult-rg-files (directory prompt &optional ignore-file)
  "Find a file below DIRECTORY using Ripgrep.
Use IGNORE-FILE when it is non-nil."
  (let* ((default-directory (file-name-as-directory
                             (expand-file-name directory)))
         (arguments (append '("--files" "--hidden")
                            (when ignore-file
                              (list "--ignore-file" ignore-file))))
         (files (apply #'process-lines "rg" arguments))
         (file (consult--read files
                              :prompt prompt
                              :require-match t
                              :category 'file
                              :history 'file-name-history
                              :sort nil
                              :state (consult--file-preview))))
    (find-file (expand-file-name file default-directory))))

  (defun cipher/consult-find-current ()
    "Find a file below the current project or directory using Ripgrep."
    (interactive)
    (require 'project)
    (cipher/consult-rg-files
     (if-let ((project (project-current nil)))
         (project-root project)
       default-directory)
     "Find current: "))

  (defun cipher/consult-find-home ()
    "Find a file below home using ignore list."
    (interactive)
    (cipher/consult-rg-files
     (expand-file-name "~/")
     "Find home: " (expand-file-name "~/.config/ripgrep/ignore")))

  (defun cipher/consult-find-notes ()
    "Find a file in my notes directory."
    (interactive)
    (cipher/consult-rg-files
     (expand-file-name "~/hub/src/mdnotes")
     "Find notes: "))
  :bind
  (;; Replace the default buffer switcher.
   ("C-x b" . consult-buffer)

   ;; Search the current buffer with live preview.
   ("M-s l" . consult-line)

   ;; Find files below the project or current directory.
   ("M-s f" . cipher/consult-find-current)

   ;; Search file contents using ripgrep.
   ("M-s w" . consult-ripgrep)

   ;; Search home with ignore list
   ("M-s h" . cipher/consult-find-home)

   ;; Search notes
   ("M-s n" . cipher/consult-find-notes)

   ;; Jump to a line with live preview.
   ("M-g g" . consult-goto-line))
  :custom
  (consult-async-min-input 1)
  (consult-async-refresh-delay 0.05)
  (consult-async-input-throttle 0.05)
  (consult-async-input-debounce 0.05))

(use-package emacs
  :ensure nil
  :custom
  ;; Let TAB indent first and complete when completion is available.
  (tab-always-indent 'complete))

(use-package corfu
  :custom
  ;; Show completion candidates automatically while typing.
  (corfu-auto t)

  ;; Wait briefly before showing the completion popup.
  (corfu-auto-delay 0.2)

  ;; Start automatic completion after typing two characters.
  (corfu-auto-prefix 2)

  ;; Cycle from the final candidate back to the first.
  (corfu-cycle t)

  ;; Do not select the first candidate automatically.
  (corfu-preselect 'prompt)

  :hook
  ((prog-mode . corfu-mode)
   (conf-mode . corfu-mode)))

(use-package cape
  :commands (cape-dict cape-capf-sort)
  :custom
  ;; Match the maxmimum number of spelling suggestion in your
  ;; previous Neovim configuration.
  (cape-dict-limit 1000))

(provide 'core-completion)
;;; core-completion.el ends here
