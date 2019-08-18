;; make some symbols look better
(global-prettify-symbols-mode +1)
(setq prettify-symbols-unprettify-at-point 'right-edge)
(setq inhibit-compacting-font-caches t)

(add-hook 'prog-mode-hook
        (lambda ()
            (push '("lambda" . ?λ) prettify-symbols-alist)
            (push '("return" . ?⮱) prettify-symbols-alist)
            (push '("->" . ?🠆) prettify-symbols-alist)
            (push '("=>" . ?⇒) prettify-symbols-alist)
            (push '("!=" . ?≠) prettify-symbols-alist)
            (push '("==" . ?⩵) prettify-symbols-alist)
            (push '("<=" . ?≤) prettify-symbols-alist)
            (push '(">=" . ?≥) prettify-symbols-alist)
            (push '("pi". ?π) prettify-symbols-alist)
            (push '("&&" . ?∧) prettify-symbols-alist)
            (push '("||" . ?∨) prettify-symbols-alist)))

(add-hook 'python-mode-hook
        (lambda ()
            (push '("def"    . ?ƒ) prettify-symbols-alist)
            (push '("sum"    . ?Σ) prettify-symbols-alist)
            (push '("**2"    . ?²) prettify-symbols-alist)
            (push '("**3"    . ?³) prettify-symbols-alist)
            (push '("None"   . ?∅) prettify-symbols-alist)
            (push '("in"     . ?∈) prettify-symbols-alist)
            (push '("not in" . ?∉) prettify-symbols-alist)
            (push '("{}" . (?⦃ (Br . Bl) ?⦄)) prettify-symbols-alist)))

(add-hook 'rust-mode-hook
        (lambda ()
            (push '("fn"    . ?ƒ) prettify-symbols-alist)))

(when (member symbol-font (font-family-list))
    (setq use-default-font-for-symbols nil)
    (set-fontset-font "fontset-default" 'unicode (font-spec :name symbol-font))
    (set-fontset-font "fontset-default" 'unicode-bmp (font-spec :name symbol-font)))

(provide 'better-symbols)
