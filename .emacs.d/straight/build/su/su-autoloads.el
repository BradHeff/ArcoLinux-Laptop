;;; su-autoloads.el --- automatically extracted autoloads
;;
;;; Code:


;;;### (autoloads nil "su" "su.el" (0 0 0 0))
;;; Generated autoloads from su.el

(autoload 'su "su" "\
Find file as root

\(fn)" t nil)

(autoload 'su-auto-save-mode "su" "\
Automatically save buffer as root

\(fn &optional ARG)" t nil)

(defvar su-mode nil "\
Non-nil if Su mode is enabled.
See the `su-mode' command
for a description of this minor mode.
Setting this variable directly does not take effect;
either customize it (see the info node `Easy Customization')
or call the function `su-mode'.")

(custom-autoload 'su-mode "su" nil)

(autoload 'su-mode "su" "\
Automatically read and write files as users

\(fn &optional ARG)" t nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "su" '("su-")))

;;;***

(provide 'su-autoloads)
;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; su-autoloads.el ends here
