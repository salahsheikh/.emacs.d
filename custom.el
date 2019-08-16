(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector
   ["#0a0814" "#f2241f" "#67b11d" "#b1951d" "#4f97d7" "#a31db1" "#28def0" "#b2b2b2"])
 '(company-flx-mode t)
 '(company-idle-delay 0.01)
 '(company-minimum-prefix-length 1)
 '(company-require-match nil)
 '(company-show-numbers t)
 '(company-transformers '(company-flx-transformer))
 '(custom-safe-themes
   '("fa2b58bb98b62c3b8cf3b6f02f058ef7827a8e497125de0254f56e373abee088" "bffa9739ce0752a37d9b1eee78fc00ba159748f50dc328af4be661484848e476" "b8929cff63ffc759e436b0f0575d15a8ad7658932f4b2c99415f3dde09b32e97" "a22f40b63f9bc0a69ebc8ba4fbc6b452a4e3f84b80590ba0a92b4ff599e53ad0" "06f0b439b62164c6f8f84fdda32b62fb50b6d00e8b01c2208e55543a6337433a" "36282815a2eaab9ba67d7653cf23b1a4e230e4907c7f110eebf3cdf1445d8370" "b3bcf1b12ef2a7606c7697d71b934ca0bdd495d52f901e73ce008c4c9825a3aa" "a63355b90843b228925ce8b96f88c587087c3ee4f428838716505fd01cf741c8" "d3691a8307e87d4289d7e8057eb1a5ac55ef2f009df9c0309c35262c43b1c7b8" default))
 '(ensime-sem-high-faces
   '((var :foreground "#000000" :underline
          (:style wave :color "yellow"))
     (val :foreground "#000000")
     (varField :foreground "#600e7a" :slant italic)
     (valField :foreground "#600e7a" :slant italic)
     (functionCall :foreground "#000000" :slant italic)
     (implicitConversion :underline
                         (:color "#c0c0c0"))
     (implicitParams :underline
                     (:color "#c0c0c0"))
     (operator :foreground "#000080")
     (param :foreground "#000000")
     (class :foreground "#20999d")
     (trait :foreground "#20999d" :slant italic)
     (object :foreground "#5974ab" :slant italic)
     (package :foreground "#000000")
     (deprecated :strike-through "#000000")))
 '(git-gutter:added-sign " ")
 '(git-gutter:deleted-sign " ")
 '(git-gutter:hide-gutter t)
 '(git-gutter:modified-sign " ")
 '(git-gutter:update-interval 0.2)
 '(global-company-mode t)
 '(helm-case-fold-search t)
 '(hl-todo-keyword-faces
   '(("TODO" . "#dc752f")
     ("NEXT" . "#dc752f")
     ("THEM" . "#2d9574")
     ("PROG" . "#4f97d7")
     ("OKAY" . "#4f97d7")
     ("DONT" . "#f2241f")
     ("FAIL" . "#f2241f")
     ("DONE" . "#86dc2f")
     ("NOTE" . "#b1951d")
     ("KLUDGE" . "#b1951d")
     ("HACK" . "#b1951d")
     ("TEMP" . "#b1951d")
     ("FIXME" . "#dc752f")
     ("XXX+" . "#dc752f")
     ("\\?\\?\\?+" . "#dc752f")))
 '(package-selected-packages
   '(erlang java-snippets yasnippet-java-mode gruvbox-theme restclient notmuch base16-theme which-key eclipse-theme rust-mode yasnippet-snippets use-package switch-window swiper-helm mixed-pitch lsp-ui intellij-theme highlight-indentation helm-flx git-gutter evil-magit evil-collection drag-stuff diminish company-lsp ace-window))
 '(pdf-view-midnight-colors '("#b2b2b2" . "#292b2e")))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(aw-leading-char-face ((t (:inherit font-lock-builtin-face :bold t :height 3.0))))
 '(company-tooltip ((t (:inherit 'mode-line :family "DeJaVu Sans Mono"))))
 '(company-tooltip-annotation ((t (:inherit 'mode-line :family "DeJaVu Sans Mono"))))
 '(fill-column-indicator ((t (:foreground "#e0e0e0" :height 1.3))))
 '(header-line ((t (:inherit mode-line :background "black" :foreground "gray90" :inverse-video t :box nil :underline nil :slant normal :weight normal))))
 '(minibuffer-prompt ((t (:foreground "SkyBlue3" :inverse-video nil :underline nil :slant normal :weight bold))))
 '(mode-line ((t (:background "#ffffff" :foreground "#000000" :inverse-video t :box nil :underline nil :slant normal :weight normal :family "DeJaVu Sans"))))
 '(mode-line-inactive ((t (:inherit mode-line :background "gray30" :foreground "dark gray" :inverse-video t :underline nil :slant normal :weight normal))))
 '(show-paren-match ((t (:background "powder blue"))))
 '(spaceline-highlight-face ((t (:background "white smoke" :foreground "#3E3D31" :inherit 'mode-line)))))
