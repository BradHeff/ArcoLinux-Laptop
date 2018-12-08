;;; evil-latex-textobjects-autoloads.el --- automatically extracted autoloads
;;
;;; Code:


;;;### (autoloads nil "evil-latex-textobjects" "evil-latex-textobjects.el"
;;;;;;  (0 0 0 0))
;;; Generated autoloads from evil-latex-textobjects.el

(autoload 'evil-latex-textobjects-mode "evil-latex-textobjects" "\
Minor mode for latex-specific text objects in evil.

Installs the following additional text objects:
\\<evil-latex-textobjects-outer-map>
  \\[evil-latex-textobjects-a-math]	Display math		\\=\\[ .. \\=\\]
  \\[evil-latex-textobjects-a-dollar]	Inline math		$ .. $
  \\[evil-latex-textobjects-a-macro]	TeX macro		\\foo{..}
  \\[evil-latex-textobjects-an-env]	LaTeX environment	\\begin{foo}..\\end{foo}

\(fn &optional ARG)" t nil)

(autoload 'turn-on-evil-latex-textobjects-mode "evil-latex-textobjects" "\
Enable evil-latex-textobjects-mode in current buffer.

\(fn)" t nil)

(autoload 'turn-off-evil-latex-textobjects-mode "evil-latex-textobjects" "\
Disable evil-latex-textobjects-mode in current buffer.

\(fn)" t nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "evil-latex-textobjects" '("evil-latex-textobjects-")))

;;;***

(provide 'evil-latex-textobjects-autoloads)
;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; evil-latex-textobjects-autoloads.el ends here
