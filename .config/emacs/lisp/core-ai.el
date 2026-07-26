;;; core-ai.el --- AI chat and editing -*- lexical-binding: t; -*-

;;; Commentary:
;; Configure gptel with separate DeepSeek backends for writing and
;; coding, plus story writing, inline rewriting, and commit-message
;; generation.

;;; Code:

(require 'subr-x)

(declare-function magit-git-output "magit-git" (&rest args))

(use-package gptel
  :functions
  (gptel
   gptel-abort
   gptel-make-openai
   gptel-menu
   gptel-request
   gptel-send)
  :defines
  (gptel--system-message
   gptel-backend
   gptel-include-reasoning
   gptel-log-level
   gptel-max-tokens
   gptel-mode-map
   gptel-model
   gptel-post-stream-hook
   gptel-stream
   gptel-system-prompt
   gptel-temperature)
  :commands
  (gptel-abort
   gptel-send)
  :bind
  (("C-c a a" . cipher/gptel-actions)
   ("C-c a s" . cipher/gptel-writing-chat)
   ("C-c a c" . cipher/gptel-coding-chat)
   ("C-c a t" . cipher/gptel-toggle-chat)
   ("C-c a w" . cipher/gptel-write-story)
   ("C-c a m" . cipher/gptel-generate-commit))
  :preface
  (defvar cipher/gptel-deepseek-flash nil
    "DeepSeek Flash backend used for writing.")

  (defvar cipher/gptel-deepseek-pro nil
    "DeepSeek Pro backend used for coding.")

  (defvar cipher/gptel-last-chat-buffer nil
    "Most recently opened gptel chat buffer.")

  (defvar-local cipher/gptel-scroll-timer nil
    "Timer used to follow streamed gptel output in the current buffer.")

  (defconst cipher/gptel-story-system-prompt
    (concat
     "## About you\n"
     "You are an ordinary Filipino writing your own experience of Tagalog horror\n"
     "stories using only diegetic narration or indirect discourse. No direct\n"
     "speech or quoted dialogue is permitted under any circumstances. Using\n"
     "first first-person point of view.\n\n"
     "## Requirement\n"
     "- Minimum of 1500 words.\n"
     "- Interrogative question should be diegetic.\n"
     "- Speech or quoted dialogue should be diegetic.\n"
     "- Avoid overly poetic words.\n"
     "- Avoid generic AI-style introductions.\n"
     "- Build tension gradually.\n"
     "- Filipino culture, beliefs, traditions, or superstitions naturally.\n\n"
     "## When writing the story\n"
     "1. Introduce name, age and current life status.\n"
     "2. Introduce small unusual events.\n"
     "3. Gradually increase the danger.\n"
     "4. Reach a clear climax.\n"
     "5. No closing remarks after the end of the story.\n")
    "System prompt used by the Tagalog horror-story command.")

  (defconst cipher/gptel-commit-system-prompt
    (concat
     "# You are an expert at writing Conventional Commits.\n\n"
     "## Guidelines:\n"
     "1. Use the format: <type>(<scope>): <subject>\n"
     "2. Types: feat, fix, docs, style, refactor, perf, test, "
     "build, ci, chore, revert.\n"
     "3. Use the imperative, present tense: change, not changed "
     "nor changes.\n"
     "4. Do not capitalize the first letter.\n"
     "5. No dot (.) at the end.\n"
     "Return only the commit message without Markdown fences "
     "or explanation.")
    "System prompt used to generate Conventional Commit messages.")

  (defconst cipher/gptel-action-alist
    '(("Open writing chat" . cipher/gptel-writing-chat)
      ("Open coding chat" . cipher/gptel-coding-chat)
      ("Toggle last chat" . cipher/gptel-toggle-chat)
      ("Write new Tagalog horror story" . cipher/gptel-write-story)
      ("Generate commit message" . cipher/gptel-generate-commit)
      ("Stop current generation" . cipher/gptel-abort)
      ("Open gptel options" . cipher/gptel-options))
    "Actions displayed by `cipher/gptel-actions'.")

  (defun cipher/gptel-deepseek-api-key ()
    "Return the DeepSeek API key from the environment."
    (let ((key (getenv "DEEPSEEK_API_KEY")))
      (if (and key (not (string-empty-p key)))
          key
        (user-error "DEEPSEEK_API_KEY is not available to Emacs"))))

  (defun cipher/gptel-set-system-prompt (prompt)
    "Set the buffer-local gptel system PROMPT compatibly."
    (let ((set-prompt nil))
      (when (boundp 'gptel--system-message)
        (setq-local gptel--system-message prompt)
        (setq set-prompt t))
      (when (boundp 'gptel-system-prompt)
        (setq-local gptel-system-prompt prompt)
        (setq set-prompt t))
      (unless set-prompt
        (user-error
         "This gptel version has no supported system-prompt variable"))))

  (defun cipher/gptel-follow-stream-now (buffer)
    "Move the visible window for BUFFER to the latest output."
    (when (buffer-live-p buffer)
      (with-current-buffer buffer
        (setq cipher/gptel-scroll-timer nil)
        (when-let ((window (get-buffer-window buffer 'visible)))
          (when (window-live-p window)
            (with-selected-window window
              (goto-char (point-max))
              (recenter -1)))))))

  (defun cipher/gptel-auto-scroll ()
    "Follow streamed output after gptel finishes inserting each chunk."
    (when (timerp cipher/gptel-scroll-timer)
      (cancel-timer cipher/gptel-scroll-timer))
    (setq cipher/gptel-scroll-timer
          (run-at-time
           0 nil
           #'cipher/gptel-follow-stream-now
           (current-buffer))))

  (defun cipher/gptel-open-chat
      (name backend model
            &optional system-prompt initial max-tokens temperature)
    "Open a new chat named NAME using BACKEND and MODEL.
Use SYSTEM-PROMPT when non-nil and insert INITIAL after the prompt.
MAX-TOKENS and TEMPERATURE configure the chat buffer."
    (let* ((buffer-name (generate-new-buffer-name name))
           (buffer (gptel buffer-name)))
      (with-current-buffer buffer
        (setq-local gptel-backend backend)
        (setq-local gptel-model model)
        (setq-local gptel-stream t)
        (setq-local gptel-max-tokens max-tokens)
        (setq-local gptel-temperature temperature)
        (when system-prompt
          (cipher/gptel-set-system-prompt system-prompt))
        (goto-char (point-max))
        (when initial
          (insert initial)))
      (setq cipher/gptel-last-chat-buffer buffer)
      (pop-to-buffer buffer)
      buffer))

  (defun cipher/gptel-writing-chat ()
    "Open a new DeepSeek Flash writing chat."
    (interactive)
    (require 'gptel)
    (cipher/gptel-open-chat
     "*DeepSeek Writing*"
     cipher/gptel-deepseek-flash
     'deepseek-v4-flash
     nil
     nil
     8192
     0.6))

  (defun cipher/gptel-coding-chat ()
    "Open a new DeepSeek Pro coding chat."
    (interactive)
    (require 'gptel)
    (cipher/gptel-open-chat
     "*DeepSeek Coding*"
     cipher/gptel-deepseek-pro
     'deepseek-v4-pro
     nil
     nil
     8192
     nil))

  (defun cipher/gptel-toggle-chat ()
    "Toggle the most recently opened gptel chat buffer."
    (interactive)
    (unless (buffer-live-p cipher/gptel-last-chat-buffer)
      (user-error "No gptel chat buffer has been opened"))
    (if-let ((window
              (get-buffer-window cipher/gptel-last-chat-buffer t)))
        (quit-window nil window)
      (pop-to-buffer cipher/gptel-last-chat-buffer)))

  (defun cipher/gptel-options ()
    "Open the gptel options menu."
    (interactive)
    (require 'gptel)
    (require 'gptel-transient)
    (call-interactively #'gptel-menu))

  (defun cipher/gptel-story-send ()
    "Send the story request using the fixed DeepSeek Flash settings."
    (interactive)
    (require 'gptel)
    (setq-local gptel-backend cipher/gptel-deepseek-flash)
    (setq-local gptel-model 'deepseek-v4-flash)
    (setq-local gptel-stream t)
    (setq-local gptel-max-tokens 8192)
    (setq-local gptel-temperature 0.6)
    (setq-local gptel-include-reasoning nil)
    (cipher/gptel-set-system-prompt
     cipher/gptel-story-system-prompt)
    (call-interactively #'gptel-send))

  (defun cipher/gptel-write-story ()
    "Open a Flash chat using the Tagalog horror-story prompt."
    (interactive)
    (require 'gptel)
    (let ((buffer
           (cipher/gptel-open-chat
            "*DeepSeek Story*"
            cipher/gptel-deepseek-flash
            'deepseek-v4-flash
            cipher/gptel-story-system-prompt
            "Gumawa ng tagalog horror story tungkol sa:\n"
            8192
            0.6)))
      (with-current-buffer buffer
        (local-set-key
         (kbd "C-c RET")
         #'cipher/gptel-story-send))))

  (defun cipher/gptel-abort ()
    "Stop the active gptel request in the current buffer."
    (interactive)
    (when (timerp cipher/gptel-scroll-timer)
      (cancel-timer cipher/gptel-scroll-timer)
      (setq cipher/gptel-scroll-timer nil))
    (require 'gptel-request)
    (if (fboundp 'gptel-abort)
        (gptel-abort (current-buffer))
      (user-error
       "This gptel version does not provide `gptel-abort'")))

  (defun cipher/gptel-clean-commit-message (response)
    "Return a clean commit message from RESPONSE."
    (let ((message (string-trim response)))
      (when (string-prefix-p "```" message)
        (setq message
              (replace-regexp-in-string
               "\\````[^\n]*\n" "" message))
        (setq message
              (replace-regexp-in-string
               "\n```\\'" "" message)))
      (string-trim message)))

  (defun cipher/gptel-generate-commit ()
    "Generate a Conventional Commit message from staged changes."
    (interactive)
    (when buffer-read-only
      (user-error
       "Run this command in a writable commit-message buffer"))
    (require 'gptel)
    (require 'magit-git)
    (let* ((diff
            (magit-git-output
             "diff" "--no-ext-diff" "--staged"))
           (replace-region (use-region-p))
           (begin
            (copy-marker
             (if replace-region
                 (region-beginning)
               (point))))
           (end
            (copy-marker
             (if replace-region
                 (region-end)
               (point))
             t))
           (target-buffer (current-buffer)))
      (unless (stringp diff)
        (user-error "Unable to read the staged Git changes"))
      (when (string-empty-p (string-trim diff))
        (user-error "There are no staged changes"))
      (deactivate-mark)
      (let ((gptel-backend cipher/gptel-deepseek-pro)
            (gptel-model 'deepseek-v4-pro)
            (gptel-max-tokens 8192)
            (gptel-temperature nil)
            (gptel-stream nil)
            (gptel-include-reasoning nil))
        (gptel-request
         (concat
          "Write a conventional commit message for these staged "
          "changes:\n\n```diff\n"
          diff
          "\n```")
         :system cipher/gptel-commit-system-prompt
         :stream nil
         :callback
         (lambda (response info)
           (cond
            ((stringp response)
             (let ((message
                    (cipher/gptel-clean-commit-message response)))
               (when (buffer-live-p target-buffer)
                 (with-current-buffer target-buffer
                   (delete-region begin end)
                   (goto-char begin)
                   (insert message))
                 (message "Generated commit message"))))
            ((and (null response)
                  (plist-get info :error))
             (message
              "Commit generation failed: %s"
              (plist-get info :status))))
           (unless (consp response)
             (set-marker begin nil)
             (set-marker end nil)))))))

  (defun cipher/gptel-actions ()
    "Choose and run an AI action."
    (interactive)
    (let* ((choice
            (completing-read
             "AI action: "
             cipher/gptel-action-alist
             nil
             t))
           (command
            (alist-get
             choice
             cipher/gptel-action-alist
             nil
             nil
             #'string=)))
      (call-interactively command)))

  :custom
  ;; Match the DEBUG logging used by CodeCompanion.
  (gptel-log-level 'debug)

  :config
  ;; Follow streamed responses after gptel's internal
  ;; `save-excursion' has restored point.
  (add-hook
   'gptel-post-stream-hook
   #'cipher/gptel-auto-scroll)

  ;; Send and stop generation from every gptel chat buffer.
  (define-key
   gptel-mode-map
   (kbd "C-c C-g")
   #'cipher/gptel-abort)

  (setq cipher/gptel-deepseek-flash
        (gptel-make-openai "DeepSeek V4 Flash - Writing"
          :host "api.deepseek.com"
          :endpoint "/chat/completions"
          :key #'cipher/gptel-deepseek-api-key
          :stream t
          :models '(deepseek-v4-flash)
          :request-params
          '(:thinking (:type "disabled")
            :temperature 0.6
            :top_p 1.0
            :max_tokens 8192)))

  (setq cipher/gptel-deepseek-pro
        (gptel-make-openai "DeepSeek V4 Pro - Coding"
          :host "api.deepseek.com"
          :endpoint "/chat/completions"
          :key #'cipher/gptel-deepseek-api-key
          :stream t
          :models '(deepseek-v4-pro)
          :request-params
          '(:thinking (:type "enabled")
            :reasoning_effort "max"
            :max_tokens 8192)))

  ;; Flash is the default for chats that do not select a backend.
  (setq gptel-backend cipher/gptel-deepseek-flash)
  (setq gptel-model 'deepseek-v4-flash))

(provide 'core-ai)

;;; core-ai.el ends here
