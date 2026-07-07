;;; core-format.el --- Automatic code formatting -*- lexical-binding: t; -*-

;;; Commentary:
;; Automatically format supported buffers using external command-line
;; formatters.

;;; Code:

(use-package apheleia
  :demand t

  :preface
  (defun cipher/apheleia-shfmt-arguments ()
    "Return additional Shfmt arguments for the current buffer."
    ;; Let Shfmt read indentation settings from .editorconfig when one
    ;; exists. Otherwise, match the current Emacs indentation settings.
    (unless (or indent-tabs-mode
                (locate-dominating-file
                 default-directory
                 ".editorconfig"))
      (list "-i" (number-to-string tab-width))))

  (defun cipher/apheleia-toggle-autoformat ()
    "Toggle automatic formatting globally."
    (interactive)
    (if (bound-and-true-p apheleia-global-mode)
        (progn
          (apheleia-global-mode -1)
          (message "Autoformat: OFF"))
      (apheleia-global-mode 1)
      (message "Autoformat: ON")))

  :config
  ;; Format shell scripts with Shfmt.
  ;;
  ;; When no .editorconfig exists, use spaces and the current value of
  ;; `tab-width', which is globally configured as four.
  (setf (alist-get 'cipher-shfmt apheleia-formatters)
        '("shfmt"
          "-filename"
          filepath
          (cipher/apheleia-shfmt-arguments)))

  ;; Apply automatic ShellCheck fixes.
  ;;
  ;; ShellCheck generates a patch instead of formatted text, so run it
  ;; against Apheleia's temporary file and apply the generated patch.
  (setf (alist-get 'cipher-shellcheck apheleia-formatters)
        '("zsh"
          "-c"
          (concat
           "patch_file=$(mktemp) || exit 1; "
           "trap 'rm -f \"$patch_file\"' EXIT; "
           "shellcheck \"$1\" --format=diff > \"$patch_file\"; "
           "shellcheck_status=$?; "
           "(( status <= 1 )) || exit \"$status\"; "
           "[[ ! -s \"$patch_file\" ]] || "
           "patch -s -p1 \"$1\" < \"$patch_file\"")
          "zsh"
          inplace))

  ;; Format Lua while searching parent directories for StyLua
  ;; configuration and respecting ignore files.
  (setf (alist-get 'cipher-stylua apheleia-formatters)
        '("stylua"
          "--search-parent-directories"
          "--respect-ignores"
          "--stdin-filepath"
          filepath
          "-"))

  ;; Apply all automatically fixable Ruff lint corrections.
  (setf (alist-get 'cipher-ruff-fix apheleia-formatters)
        '("ruff"
          "check"
          "--fix"
          "--force-exclude"
          "--exit-zero"
          "--no-cache"
          "--stdin-filename"
          filepath
          "-"))

  ;; Organize Python imports with Ruff.
  (setf (alist-get 'cipher-ruff-organize-imports
                   apheleia-formatters)
        '("ruff"
          "check"
          "--fix"
          "--force-exclude"
          "--select=I001"
          "--exit-zero"
          "--no-cache"
          "--stdin-filename"
          filepath
          "-"))

  ;; Format Python source code with Ruff.
  (setf (alist-get 'cipher-ruff-format apheleia-formatters)
        '("ruff"
          "format"
          "--force-exclude"
          "--stdin-filename"
          filepath
          "-"))

  ;; Format Markdown with Rumdl.
  (setf (alist-get 'cipher-rumdl apheleia-formatters)
        '("rumdl" "fmt" "-"))

  ;; Format XML using two spaces for indentation.
  (setf (alist-get 'cipher-xmlstarlet apheleia-formatters)
        '("xmlstarlet"
          "format"
          "--indent-spaces"
          "2"
          "-"))

  ;; Associate file names and major modes with formatter chains.
  ;;
  ;; Zsh files appear before `bash-ts-mode' so that files such as
  ;; .zshrc use only ShellCheck, matching the Neovim zsh formatter
  ;; configuration.
  (setq apheleia-mode-alist
        '(("\\(?:^\\|/\\)\\.z\\(?:shenv\\|shrc\\|profile\\|login\\|logout\\)\\'"
           . cipher-shellcheck)

          ("\\.zsh\\'"
           . cipher-shellcheck)

          (bash-ts-mode
           . (cipher-shfmt
              cipher-shellcheck))

          (lua-ts-mode
           . cipher-stylua)

          (python-ts-mode
           . (cipher-ruff-fix
              cipher-ruff-organize-imports
              cipher-ruff-format))

          (markdown-mode
           . cipher-rumdl)

          (nxml-mode
           . cipher-xmlstarlet)))

  ;; Automatically format configured buffers when saving.
  (apheleia-global-mode 1))

(provide 'core-format)
;;; core-format.el ends here
