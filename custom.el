(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("a63355b90843b228925ce8b96f88c587087c3ee4f428838716505fd01cf741c8" "d3691a8307e87d4289d7e8057eb1a5ac55ef2f009df9c0309c35262c43b1c7b8" default))
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
 '(helm-case-fold-search t)
 '(package-selected-packages
   '(which-key eclipse-theme rust-mode yasnippet-snippets use-package switch-window swiper-helm mixed-pitch lsp-ui intellij-theme highlight-indentation helm-flx git-gutter evil-magit evil-collection drag-stuff diminish company-lsp ace-window)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(fill-column-indicator ((t (:foreground "#e0e0e0" :height 1.3))))
 '(header-line ((t (:inherit mode-line :background "black" :foreground "gray90" :inverse-video t :box nil :underline nil :slant normal :weight normal))))
 '(minibuffer-prompt ((t (:foreground "SkyBlue3" :inverse-video nil :underline nil :slant normal :weight bold))))
 '(mode-line ((t (:background "#ffffff" :foreground "#000000" :inverse-video t :box (:line-width 1 :color "grey75" :style released-button) :underline nil :slant normal :weight normal :family "DeJaVu Sans"))))
 '(mode-line-inactive ((t (:inherit mode-line :background "gray30" :foreground "dark gray" :inverse-video t :box (:line-width 1 :color "grey75" :style released-button) :underline nil :slant normal :weight normal))))
 '(show-paren-match ((t (:background "powder blue"))))
 '(spaceline-highlight-face ((t (:background "white smoke" :foreground "#3E3D31" :inherit 'mode-line)))))
