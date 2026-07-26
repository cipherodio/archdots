;;; core-git.el --- Git repository interface -*- lexical-binding: t; -*-

;;; Commentary:
;; Configure Magit for regular repositories and the bare dotfiles
;; repository whose working tree is the home directory.

;;; Code:

(require 'seq)

(use-package magit
  :functions
  (magit-process-environment
   magit-status-goto-initial-section)
  :defines
  (magit-mode-map
   magit-section-initial-visibility-alist
   magit-status-initial-section
   magit-status-show-untracked-files)
  :commands
  (magit-status
   magit-push)
  :bind
  (("C-x g" . cipher/magit-status)
   :map magit-mode-map
   ("p" . magit-push))
  :preface
  (defconst cipher/magit-dotfiles-git-dir
    (file-name-as-directory
     (expand-file-name "~/.config/.dots"))
    "Git directory of the bare dotfiles repository.")

  (defconst cipher/magit-dotfiles-work-tree
    (file-name-as-directory
     (expand-file-name "~/"))
    "Working tree of the bare dotfiles repository.")

  (defun cipher/magit-status ()
    "Open Magit and move point to the first changed section."
    (interactive)
    (call-interactively #'magit-status)
    (when (derived-mode-p 'magit-status-mode)
      (magit-status-goto-initial-section)))

  (defun cipher/magit-path-inside-directory-p (path directory)
    "Return non-nil when PATH is inside DIRECTORY."
    (string-prefix-p
     (file-name-as-directory
      (expand-file-name directory))
     (file-name-as-directory
      (expand-file-name path))))

  (defun cipher/magit-normal-repository-p ()
    "Return non-nil when the current directory is in a regular repository."
    (locate-dominating-file default-directory ".git"))

  (defun cipher/magit-dotfiles-context-p ()
    "Return non-nil when Magit should use the bare dotfiles repository."
    (and
     (not (file-remote-p default-directory))
     (file-directory-p cipher/magit-dotfiles-git-dir)
     (or
      (cipher/magit-path-inside-directory-p
       default-directory
       cipher/magit-dotfiles-git-dir)
      (and
       (cipher/magit-path-inside-directory-p
        default-directory
        cipher/magit-dotfiles-work-tree)
       (not
        (cipher/magit-path-inside-directory-p
         default-directory
         cipher/magit-dotfiles-git-dir))
       (not (cipher/magit-normal-repository-p))))))

  (defun cipher/magit-clean-git-environment (environment)
    "Remove repository-location variables from ENVIRONMENT."
    (seq-remove
     (lambda (entry)
       (or
        (string-prefix-p "GIT_DIR=" entry)
        (string-prefix-p "GIT_WORK_TREE=" entry)))
     environment))

  (defun cipher/magit-process-environment (original-function)
    "Run ORIGINAL-FUNCTION with the appropriate Git environment."
    (let ((environment (funcall original-function)))
      (if (not (cipher/magit-dotfiles-context-p))
          environment
        (append
         (list
          (concat
           "GIT_DIR="
           (directory-file-name
            cipher/magit-dotfiles-git-dir))
          (concat
           "GIT_WORK_TREE="
           (directory-file-name
            cipher/magit-dotfiles-work-tree)))
         (cipher/magit-clean-git-environment
          environment)))))

  (defun cipher/magit-status-setup ()
    "Show untracked files in the current Magit status buffer."
    (setq-local magit-status-show-untracked-files t))

  :custom
  ;; Disable red highlighting for long commit summaries.
  (git-commit-summary-max-length 1000)
  ;; Expand the Untracked files section when the status buffer is created.
  (magit-section-initial-visibility-alist
   '((untracked . show)))

  ;; Initially place point at Unstaged changes, then Untracked or Staged.
  (magit-status-initial-section
   '(((unstaged) (status))
     ((untracked) (status))
     ((staged) (status))
     1))

  :hook
  (magit-status-mode . cipher/magit-status-setup)

  :config
  (unless
      (advice-member-p
       #'cipher/magit-process-environment
       'magit-process-environment)
    (advice-add
     'magit-process-environment
     :around
     #'cipher/magit-process-environment)))

(provide 'core-git)

;;; core-git.el ends here
