;;; core-modeline.el --- Minimal bottom modeline -*- lexical-binding: t; -*-

;;; Commentary:
;; Custom bottom modeline inspired by Nano Modeline.

;;; Code:

(require 'flymake)
(require 'subr-x)

(declare-function eglot-managed-p "eglot")
(declare-function lsp-workspaces "lsp-mode")

(defface cipher/modeline-green
  '((t (:foreground "#b8bb26" :weight bold)))
  "Green modeline face.")

(defface cipher/modeline-yellow
  '((t (:foreground "#fabd2f" :weight bold)))
  "Yellow modeline face.")

(defface cipher/modeline-red
  '((t (:foreground "#fb4934" :weight bold)))
  "Red modeline face.")

(defface cipher/modeline-blue
  '((t (:foreground "#83a598" :weight bold)))
  "Blue modeline face.")

(defconst cipher/modeline-dotfiles-git-dir
  (expand-file-name "~/.config/.dots")
  "Git directory of the bare dotfiles repository.")

(defconst cipher/modeline-dotfiles-work-tree
  (file-name-as-directory (expand-file-name "~/"))
  "Working tree of the bare dotfiles repository.")

(defvar-local cipher/modeline-git-info nil
  "Per-file Git information for the current buffer.")

(defvar-local cipher/modeline-git-process nil
  "Running asynchronous Git process for the current buffer.")

(defvar-local cipher/modeline-position-text "1:1 | Top"
  "Neovim-style cursor position for the current buffer.")

(defun cipher/modeline-active-p ()
  "Return non-nil for the selected window's modeline."
  (mode-line-window-selected-p))

(defun cipher/modeline-status ()
  "Return the current buffer status."
  (propertize
   (cond
    ((and buffer-read-only (buffer-modified-p)) " RO* ")
    (buffer-read-only " RO ")
    ((buffer-modified-p) " MOD ")
    (t " RW "))
   'face
   (if (cipher/modeline-active-p)
       '(:inherit mode-line :inverse-video t :weight bold :box nil)
     '(:inherit mode-line-inactive :weight bold :box nil))))

(defun cipher/modeline-buffer-name ()
  "Return the current buffer name."
  (propertize
   (truncate-string-to-width (buffer-name) 40 nil nil "…")
   'face
   (if (cipher/modeline-active-p)
       'mode-line-emphasis
     'mode-line-inactive)
   'help-echo
   (or buffer-file-name (buffer-name))))

(defun cipher/modeline-inside-p (file directory)
  "Return non-nil when FILE is inside DIRECTORY."
  (string-prefix-p
   (file-name-as-directory (expand-file-name directory))
   (expand-file-name file)))

(defun cipher/modeline-git-context ()
  "Return Git context for the current file."
  (when (and buffer-file-name
             (not (file-remote-p buffer-file-name))
             (executable-find "git"))
    (let* ((file (expand-file-name buffer-file-name))
           (directory (file-name-directory file))
           (root (locate-dominating-file directory ".git")))
      (cond
       (root
        (setq root
              (file-name-as-directory
               (expand-file-name root)))
        (list :root root
              :path (file-relative-name file root)))
       ((and
         (file-directory-p cipher/modeline-dotfiles-git-dir)
         (cipher/modeline-inside-p
          file
          cipher/modeline-dotfiles-work-tree)
         (not
          (cipher/modeline-inside-p
           file
           cipher/modeline-dotfiles-git-dir)))
        (list
         :root cipher/modeline-dotfiles-work-tree
         :git-dir cipher/modeline-dotfiles-git-dir
         :path
         (file-relative-name
          file
          cipher/modeline-dotfiles-work-tree)))))))

(defun cipher/modeline-git-command ()
  "Return the shell command used to inspect one Git file."
  (concat
   "branch=$(git symbolic-ref --quiet --short HEAD 2>/dev/null "
   "|| git rev-parse --short HEAD 2>/dev/null); "
   "printf '%s\\036' \"$branch\"; "
   "git diff --no-ext-diff --no-color --numstat HEAD -- "
   "\"$CIPHER_MODELINE_PATH\" 2>/dev/null; "
   "printf '\\036'; "
   "git status --porcelain=v1 --untracked-files=all -- "
   "\"$CIPHER_MODELINE_PATH\" 2>/dev/null; "
   "printf '\\036'; "
   "if git ls-files --error-unmatch -- \"$CIPHER_MODELINE_PATH\" "
   ">/dev/null 2>&1; "
   "then printf tracked; "
   "else printf untracked; "
   "fi"))

(defun cipher/modeline-buffer-lines ()
  "Return the number of logical lines in the current buffer."
  (save-restriction
    (widen)
    (cond
     ((= (point-min) (point-max))
      0)
     ((eq (char-before (point-max)) ?\n)
      (line-number-at-pos
       (1- (point-max))))
     (t
      (line-number-at-pos
       (point-max))))))

(defun cipher/modeline-git-parse (context output)
  "Parse per-file Git OUTPUT using CONTEXT."
  (let* ((parts
          (split-string output "\036"))
         (branch
          (string-trim
           (or (nth 0 parts) "")))
         (numstat
          (or (nth 1 parts) ""))
         (status
          (string-trim-right
           (or (nth 2 parts) "")))
         (tracked
          (string=
           (string-trim
            (or (nth 3 parts) ""))
           "tracked"))
         (added 0)
         (modified 0)
         (deleted 0))
    (when
        (and
         (not (string-empty-p branch))
         (not
          (and
           (plist-get context :git-dir)
           (not tracked)))
         (or
          tracked
          (not (string-empty-p status))))
      (cond
       ((string-prefix-p "??" status)
        (setq added
              (cipher/modeline-buffer-lines)))
       ((string-match
         "\\`\\([0-9]+\\)\t\\([0-9]+\\)"
         numstat)
        (let* ((raw-added
                (string-to-number
                 (match-string 1 numstat)))
               (raw-deleted
                (string-to-number
                 (match-string 2 numstat)))
               (changed
                (min raw-added raw-deleted)))
          (setq added (- raw-added changed)
                modified changed
                deleted (- raw-deleted changed))))
       ((string-match-p "A" status)
        (setq added 1))
       ((string-match-p "D" status)
        (setq deleted 1))
       ((not (string-empty-p status))
        (setq modified 1)))
      (list
       :branch branch
       :added added
       :modified modified
       :deleted deleted))))

(defun cipher/modeline-git-stop ()
  "Stop the current buffer's Git process."
  (when (and
         cipher/modeline-git-process
         (process-live-p
          cipher/modeline-git-process))
    (delete-process
     cipher/modeline-git-process))
  (setq cipher/modeline-git-process nil))

(defun cipher/modeline-git-sentinel (process _event)
  "Update the owning buffer after Git PROCESS exits."
  (when (memq
         (process-status process)
         '(exit signal))
    (let ((target
           (process-get
            process
            'target-buffer))
          (context
           (process-get
            process
            'git-context))
          (output
           (process-buffer process)))
      (unwind-protect
          (when (buffer-live-p target)
            (with-current-buffer target
              (when
                  (eq
                   process
                   cipher/modeline-git-process)
                (setq
                 cipher/modeline-git-process
                 nil
                 cipher/modeline-git-info
                 (and
                  (= (process-exit-status process) 0)
                  (buffer-live-p output)
                  (cipher/modeline-git-parse
                   context
                   (with-current-buffer output
                     (buffer-string)))))
                (force-mode-line-update))))
        (when (buffer-live-p output)
          (kill-buffer output))))))

(defun cipher/modeline-git-refresh ()
  "Refresh per-file Git information asynchronously."
  (interactive)
  (cipher/modeline-git-stop)
  (setq cipher/modeline-git-info nil)
  (when-let ((context
              (cipher/modeline-git-context)))
    (let ((default-directory
           (plist-get context :root))
          (process-environment
           (copy-sequence process-environment))
          (output
           (generate-new-buffer
            " *cipher-modeline-git*")))
      (setenv "LC_ALL" "C")
      (setenv "GIT_DIR" nil)
      (setenv "GIT_WORK_TREE" nil)
      (setenv
       "CIPHER_MODELINE_PATH"
       (plist-get context :path))
      (when-let ((git-dir
                  (plist-get context :git-dir)))
        (setenv "GIT_DIR" git-dir)
        (setenv
         "GIT_WORK_TREE"
         (plist-get context :root)))
      (condition-case error-data
          (let ((process
                 (make-process
                  :name
                  (generate-new-buffer-name
                   "cipher-modeline-git")
                  :buffer output
                  :command
                  (list
                   shell-file-name
                   shell-command-switch
                   (cipher/modeline-git-command))
                  :connection-type 'pipe
                  :noquery t
                  :sentinel
                  #'cipher/modeline-git-sentinel)))
            (process-put
             process
             'target-buffer
             (current-buffer))
            (process-put
             process
             'git-context
             context)
            (setq
             cipher/modeline-git-process
             process))
        (error
         (kill-buffer output)
         (message
          "Modeline Git error: %s"
          (error-message-string
           error-data))))))
  (force-mode-line-update))

(defun cipher/modeline-count (prefix count face)
  "Format PREFIX and COUNT using FACE."
  (when (> count 0)
    (concat
     " "
     (propertize
      (format "%s%d" prefix count)
      'face face))))

(defun cipher/modeline-vc ()
  "Return per-file Git information."
  (when-let* ((info
               cipher/modeline-git-info)
              (branch
               (plist-get info :branch)))
    (concat
     "  "
     (propertize
      (concat "🍀 " branch)
      'face
      (if (cipher/modeline-active-p)
          'mode-line
        'mode-line-inactive))
     (cipher/modeline-count
      "+"
      (plist-get info :added)
      'cipher/modeline-green)
     (cipher/modeline-count
      "~"
      (plist-get info :modified)
      'cipher/modeline-yellow)
     (cipher/modeline-count
      "-"
      (plist-get info :deleted)
      'cipher/modeline-red))))

(defun cipher/modeline-diagnostic-kind (diagnostic)
  "Return the standard severity of DIAGNOSTIC."
  (let* ((type
          (flymake-diagnostic-type diagnostic))
         (category
          (or
           (get type 'flymake-category)
           type)))
    (cond
     ((memq
       category
       '(:error flymake-error))
      'error)
     ((memq
       category
       '(:warning flymake-warning))
      'warning)
     ((memq
       category
       '(:note flymake-note))
      'note))))

(defun cipher/modeline-diagnostics ()
  "Return Flymake error, warning, and note counts."
  (when (bound-and-true-p flymake-mode)
    (let ((errors 0)
          (warnings 0)
          (notes 0))
      (dolist
          (diagnostic
           (flymake-diagnostics))
        (pcase
            (cipher/modeline-diagnostic-kind
             diagnostic)
          ('error
           (setq errors
                 (1+ errors)))
          ('warning
           (setq warnings
                 (1+ warnings)))
          ('note
           (setq notes
                 (1+ notes)))))
      (let ((items
             (delq
              nil
              (list
               (and
                (> errors 0)
                (propertize
                 (format "E:%d" errors)
                 'face
                 'cipher/modeline-red))
               (and
                (> warnings 0)
                (propertize
                 (format "W:%d" warnings)
                 'face
                 'cipher/modeline-yellow))
               (and
                (> notes 0)
                (propertize
                 (format "N:%d" notes)
                 'face
                 'cipher/modeline-blue))))))
        (when items
          (concat
           (string-join items " ")
           " "))))))

(defun cipher/modeline-lsp ()
  "Return an LSP indicator when the current buffer is managed."
  (when (or
         (and (fboundp 'eglot-managed-p)
              (eglot-managed-p))
         (and (bound-and-true-p lsp-mode)
              (fboundp 'lsp-workspaces)
              (lsp-workspaces)))
    (propertize
     "LSP "
     'face
     (if (cipher/modeline-active-p)
         'mode-line-emphasis
       'mode-line-inactive)
     'help-echo
     "Language server active")))

(defun cipher/modeline-major-mode ()
  "Return the current major mode and process status."
  (propertize
   (string-trim
    (format-mode-line
     '("" mode-name mode-line-process)))
   'face
   (if (cipher/modeline-active-p)
       'mode-line-emphasis
     'mode-line-inactive)))

(defun cipher/modeline-update-position ()
  "Update the Neovim-style cursor position."
  (save-restriction
    (widen)
    (let* ((total
            (max
             1
             (cipher/modeline-buffer-lines)))
           (line
            (min
             (line-number-at-pos)
             total))
           (column
            (1+ (current-column)))
           (position
            (cond
             ((= line 1)
              "Top")
             ((= line total)
              "End")
             (t
              (format
               "%d%%%%"
               (floor
                (/ (* line 100.0)
                   total)))))))
      (setq
       cipher/modeline-position-text
       (format
        "%d:%d | %s"
        line
        column
        position))))
  (force-mode-line-update))

(defun cipher/modeline-position ()
  "Return the stored cursor position."
  (propertize
   cipher/modeline-position-text
   'face
   (if (cipher/modeline-active-p)
       'mode-line
     'mode-line-inactive)))

(defvar cipher/modeline-format
  '("%e"
    (:eval
     (cipher/modeline-status))
    " "
    (:eval
     (cipher/modeline-buffer-name))
    (:eval
     (cipher/modeline-vc))
    mode-line-format-right-align
    (:eval
     (cipher/modeline-diagnostics))
    (:eval
     (cipher/modeline-lsp))
    (:eval
     (cipher/modeline-major-mode))
    "  "
    (:eval
     (cipher/modeline-position))
    " ")
  "Format used by the custom bottom modeline.")

(defun cipher/modeline-enable ()
  "Enable the custom modeline in the current buffer."
  (setq-local
   mode-line-format
   cipher/modeline-format)
  (cipher/modeline-update-position))

(set-face-attribute
 'mode-line nil
 :box nil
 :underline nil
 :overline nil
 :height 0.95)

(set-face-attribute
 'mode-line-inactive nil
 :box nil
 :underline nil
 :overline nil
 :height 0.95)

(setq-default
 mode-line-format
 cipher/modeline-format)

(add-hook
 'after-change-major-mode-hook
 #'cipher/modeline-enable)

(add-hook
 'post-command-hook
 #'cipher/modeline-update-position)

(add-hook
 'find-file-hook
 #'cipher/modeline-git-refresh)

(add-hook
 'after-save-hook
 #'cipher/modeline-git-refresh)

(add-hook
 'after-revert-hook
 #'cipher/modeline-git-refresh)

(add-hook
 'kill-buffer-hook
 #'cipher/modeline-git-stop)

(provide 'core-modeline)

;;; core-modeline.el ends here
