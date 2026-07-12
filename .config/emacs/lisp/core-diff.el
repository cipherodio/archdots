;;; core-diff.el --- Git indicators -*- lexical-binding: t; -*-

;;; Commentary:
;; Configure Git change indicators, including support for the bare
;; dotfiles repository whose working tree is the home directory.

;;; Code:

(use-package vc-git
  :ensure nil
  :preface
  (defconst cipher/dotfiles-git-dir
    (file-name-as-directory
     (expand-file-name "~/.config/.dots"))
    "Git directory of the bare dotfiles repository.")

  (defconst cipher/dotfiles-work-tree
    (file-name-as-directory
     (expand-file-name "~/"))
    "Working tree of the bare dotfiles repository.")

  (defun cipher/path-inside-directory-p (path directory)
    "Return non-nil when PATH is inside DIRECTORY."
    (string-prefix-p
     (file-name-as-directory
      (expand-file-name directory))
     (file-name-as-directory
      (expand-file-name path))))

  (defun cipher/dotfiles-vc-context-p ()
    "Return non-nil when Git should use the bare dotfiles repository."
    ;; The current directory is below home.
    (and (cipher/path-inside-directory-p
          default-directory cipher/dotfiles-work-tree)
         ;; Do not treat the bare Git directory itself as part of the work tree.
         (not (cipher/path-inside-directory-p
               default-directory cipher/dotfiles-git-dir))
         ;; Prefer a normal nested Git repository when one exists.
         (not (vc-find-root default-directory ".git"))
         ;; The bare dotfiles repository exists.
         (file-directory-p cipher/dotfiles-git-dir)))

  (defun cipher/vc-git-root (original-function file)
    "Find the Git root for FILE using ORIGINAL-FUNCTION.
Use the home directory as the fallback root for the bare dotfiles repository."
    (or (funcall original-function file)
        (when (and (cipher/path-inside-directory-p
                    file cipher/dotfiles-work-tree)
                   (not (cipher/path-inside-directory-p
                         file cipher/dotfiles-git-dir))
                   (file-directory-p cipher/dotfiles-git-dir))
          cipher/dotfiles-work-tree)))

  (defun cipher/vc-git-command-dotfiles-args (arguments)
    "Add bare dotfiles options to `vc-git-command' ARGUMENTS."
    (if (cipher/dotfiles-vc-context-p)
        (pcase-let ((`(,buffer ,okstatus ,file-or-list . ,flags) arguments))
          `(,buffer
            ,okstatus
            ,file-or-list
            ,(concat "--git-dir=" cipher/dotfiles-git-dir)
            ,(concat "--work-tree=" cipher/dotfiles-work-tree)
            ,@flags)) arguments))
  (defun cipher/vc-git-call-dotfiles-args (arguments)
    "Add bare dotfiles options to `vc-git--call' ARGUMENTS."
    (if (cipher/dotfiles-vc-context-p)
        (pcase-let ((`(,buffer ,command . ,command-arguments) arguments))
          `(,buffer
            ,(concat "--git-dir=" cipher/dotfiles-git-dir)
            ,(concat "--work-tree=" cipher/dotfiles-work-tree)
            ,command
            ,@command-arguments)) arguments))
  :demand t
  :config
  ;; Emacs VC normally recognizes Git repositories by locating .git.
  ;; Fall back to the bare dotfiles repository for files below home.
  (advice-add 'vc-git-root
              :around #'cipher/vc-git-root)
  ;; Pass --git-dir and --work-tree directly to Git when operating on
  ;; dotfiles. Normal nested Git repositories remain unaffected.
  (advice-add 'vc-git-command
              :filter-args #'cipher/vc-git-command-dotfiles-args)
  (advice-add 'vc-git--call
              :filter-args #'cipher/vc-git-call-dotfiles-args))

(use-package diff-hl
  :functions
  (diff-hl-update
   diff-hl-margin-mode
   global-diff-hl-mode
   diff-hl-flydiff-mode)
  :preface
  (defun cipher/diff-hl-update-preserve-window-start
      (original-function &rest arguments)
    "Run ORIGINAL-FUNCTION without moving visible buffer positions."
    (let ((window-positions
           (mapcar
            (lambda (window)
              (list window
                    (copy-marker (window-start window))
                    (window-vscroll window t)))
            (get-buffer-window-list nil nil t))))
      (unwind-protect
          (apply original-function arguments)
        (dolist (position window-positions)
          (let ((window (nth 0 position))
                (start (nth 1 position))
                (vscroll (nth 2 position)))
            (when (and (window-live-p window) (marker-position start))
              (set-window-start window start)
              (set-window-vscroll window vscroll t))
            (set-marker start nil))))))
  :custom
  ;; Use distinct symbols temporarily while testing.
  (diff-hl-margin-symbols-alist
   '((insert . "▕")
     (delete . "▕")
     (change . "▕")
     (unknown . "▕")
     (ignored . "▕")
     (reference . "▕")))
  ;; Refresh shortly after editing.
  (diff-hl-flydiff-delay 0.05)
  :custom-face
  ;; Show colored characters instead of solid background blocks.
  (diff-hl-insert
   ((t (:background unspecified :foreground "#b8bb26" :slant normal))))
  (diff-hl-delete
   ((t (:background unspecified :foreground "#fb4934" :slant normal))))
  (diff-hl-change
   ((t (:background unspecified :foreground "#fabd2f" :slant normal))))
  :demand t
  :config
  ;; Preserve the visible position during save and Flydiff updates.
  (unless
      (advice-member-p
       #'cipher/diff-hl-update-preserve-window-start 'diff-hl-update)
    (advice-add 'diff-hl-update
                :around #'cipher/diff-hl-update-preserve-window-start))
  ;; Install margin rendering before enabling Diff-HL buffers.
  (diff-hl-margin-mode 1)
  ;; Enable indicators in version-controlled file buffers.
  (global-diff-hl-mode 1)
  ;; Update indicators while editing.
  (diff-hl-flydiff-mode 1))

(provide 'core-diff)
;;; core-diff.el ends here
