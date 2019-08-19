(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(git-gutter:added-sign " ")
 '(git-gutter:deleted-sign " ")
 '(git-gutter:hide-gutter t)
 '(git-gutter:modified-sign " ")
 '(git-gutter:update-interval 0.01)
 '(package-selected-packages
   '(dired-ranger hide-mode-line ranger helm-projectile projectile lsp-java rust-mode mixed-pitch which-key org-bullets company-lsp java-snippets yasnippet-snippets lsp-ui helm-flycheck flycheck company-flx company lsp-mode yasnippet s highlight-indent-guides drag-stuff ace-window swiper-helm helm-flx helm avy evil-magit git-gutter magit evil-collection evil use-package diminish))
 '(safe-local-variable-values
   '((projectile-project-run-cmd . "mkdir -p build; cd build; cmake ..; make run")
     (projectile-project-compilation-cmd . "mkdir -p build; cd build; cmake ..; make"))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(aw-leading-char-face ((t (:inherit font-lock-builtin-face :bold t :height 2.0))))
 '(fill-column-indicator ((t (:foreground "gray30" :family "Symbola" :height 1.6)))))
