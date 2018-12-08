;;; helm-flx-historian-autoloads.el --- automatically extracted autoloads
;;
;;; Code:


;;;### (autoloads nil "helm-flx-historian" "helm-flx-historian.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from helm-flx-historian.el

(defvar helm-flx-historian-mode nil "\
Non-nil if Helm-Flx-Historian mode is enabled.
See the `helm-flx-historian-mode' command
for a description of this minor mode.
Setting this variable directly does not take effect;
either customize it (see the info node `Easy Customization')
or call the function `helm-flx-historian-mode'.")

(custom-autoload 'helm-flx-historian-mode "helm-flx-historian" nil)

(autoload 'helm-flx-historian-mode "helm-flx-historian" "\
historian minor mode

\(fn &optional ARG)" t nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "helm-flx-historian" '("helm-flx-historian-")))

;;;***

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

;;;### (autoloads nil "ivy-historian" "ivy-historian.el" (0 0 0 0))
;;; Generated autoloads from ivy-historian.el

(defvar ivy-historian-mode nil "\
Non-nil if Ivy-Historian mode is enabled.
See the `ivy-historian-mode' command
for a description of this minor mode.
Setting this variable directly does not take effect;
either customize it (see the info node `Easy Customization')
or call the function `ivy-historian-mode'.")

(custom-autoload 'ivy-historian-mode "ivy-historian" nil)

(autoload 'ivy-historian-mode "ivy-historian" "\
historian minor mode

\(fn &optional ARG)" t nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "ivy-historian" '("ivy-historian-")))

;;;***

(provide 'helm-flx-historian-autoloads)
;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; helm-flx-historian-autoloads.el ends here
