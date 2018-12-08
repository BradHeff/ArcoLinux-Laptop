;;; historian-autoloads.el --- automatically extracted autoloads
;;
;;; Code:


;;;### (autoloads nil "historian" "historian.el" (0 0 0 0))
;;; Generated autoloads from historian.el

(autoload 'historian-save "historian" "\
Save the historian history to `historian-save-file'.

\(fn)" t nil)

(autoload 'historian-load "historian" "\


\(fn)" t nil)

(autoload 'historian-clear "historian" "\


\(fn)" t nil)

(defvar historian-mode nil "\
Non-nil if Historian mode is enabled.
See the `historian-mode' command
for a description of this minor mode.
Setting this variable directly does not take effect;
either customize it (see the info node `Easy Customization')
or call the function `historian-mode'.")

(custom-autoload 'historian-mode "historian" nil)

(autoload 'historian-mode "historian" "\
historian minor mode

\(fn &optional ARG)" t nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "historian" '("historian-")))

;;;***

(provide 'historian-autoloads)
;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; historian-autoloads.el ends here
