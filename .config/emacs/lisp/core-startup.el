;;; core-startup.el --- Startup reporting -*- lexical-binding: t; -*-

;;; Commentary:
;; Report Emacs startup time in normal and daemon sessions.

;;; Code:

(use-package server
  :ensure nil

  :preface
  (defun cipher/report-startup-time ()
    "Report how long Emacs took to start."
    (message
     "Emacs started in %.2f seconds"
     (float-time
      (time-subtract after-init-time
                     before-init-time))))

  (defun cipher/report-normal-startup-time ()
    "Report startup time in a normal Emacs session."
    (unless (daemonp)
      (cipher/report-startup-time)))

  (defun cipher/report-daemon-startup-time ()
    "Report startup time in the first daemon client frame."
    (when (daemonp)
      (remove-hook
       'server-after-make-frame-hook
       #'cipher/report-daemon-startup-time)

      (cipher/report-startup-time)))

  :custom
  ;; Disable client-frame instructions only in daemon mode.
  (server-client-instructions (not (daemonp)))

  :hook
  ((emacs-startup
    . cipher/report-normal-startup-time)

   (server-after-make-frame
    . cipher/report-daemon-startup-time)))

(provide 'core-startup)
;;; core-startup.el ends here
