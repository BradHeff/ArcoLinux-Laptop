;;; framemove-autoloads.el --- automatically extracted autoloads
;;
;;; Code:


;;;### (autoloads nil "framemove" "framemove.el" (0 0 0 0))
;;; Generated autoloads from framemove.el

(autoload 'fm-down-frame "framemove" "\


\(fn)" t nil)

(autoload 'fm-up-frame "framemove" "\


\(fn)" t nil)

(autoload 'fm-left-frame "framemove" "\


\(fn)" t nil)

(autoload 'fm-right-frame "framemove" "\


\(fn)" t nil)

(autoload 'framemove-default-keybindings "framemove" "\
Set up keybindings for `framemove'.
Keybindings are of the form MODIFIER-{left,right,up,down}.
Default MODIFIER is 'meta.

\(fn &optional MODIFIER)" t nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "framemove" '("framemove-hook-into-windmove" "fm-")))

;;;***

(provide 'framemove-autoloads)
;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; framemove-autoloads.el ends here
