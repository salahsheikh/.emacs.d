(set-face-attribute 'default nil
                    :family "DeJaVu Sans Mono"
                    :height 90
                    :weight 'normal
                    :width 'normal)
(set-face-attribute 'variable-pitch nil :family "Sans" :height 140 :weight 'regular)

(tooltip-mode -1)
(mouse-wheel-mode t)
(scroll-bar-mode -1)
(menu-bar-mode -1)
(when (fboundp 'tool-bar-mode)
  (tool-bar-mode -1))
(blink-cursor-mode -1)
(line-number-mode t)
(column-number-mode t)
(size-indication-mode t)
(setq frame-resize-pixelwise t)
;; enable y/n answers
(fset 'yes-or-no-p 'y-or-n-p)
(global-display-line-numbers-mode)
(setq visible-bell nil)
(setq ring-bell-function 'ignore)
;; Newline at end of file
(setq require-final-newline t)

(setq font-lock-maximum-decoration t)
;; Wrap lines at 80 characters
(setq-default fill-column 80)

(setq inhibit-startup-screen t)
(setq create-lockfiles nil)
;; revert buffers automatically when underlying files are changed externally
(global-auto-revert-mode t)
(set-default 'indent-tabs-mode nil)
(setq-default tab-width 4)
(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(setq-default buffer-file-coding-system 'utf-8-auto-unix)

(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/"))
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))

(use-package evil
:ensure t
:config
(evil-mode 1))

(use-package helm
  :ensure t
  :init
  (setq helm-M-x-fuzzy-match t
	helm-mode-fuzzy-match t
	helm-buffers-fuzzy-matching t
	helm-recentf-fuzzy-match t
	helm-locate-fuzzy-match t
	helm-semantic-fuzzy-match t
	helm-imenu-fuzzy-match t
	helm-completion-in-region-fuzzy-match t
	helm-candidate-number-list 150
	helm-split-window-in-side-p t
	helm-move-to-line-cycle-in-source t
	helm-echo-input-in-header-line t
	helm-ff-skip-boring-files t
	helm-autoresize-max-height 0
	helm-autoresize-min-height 20)
  :config
  (setq helm-candidate-number-limit 100)
  (global-set-key (kbd "M-x") #'helm-M-x)
  (global-set-key (kbd "C-x C-f") #'helm-find-files)
  (global-set-key (kbd "C-x C-b") #'helm-buffers-list)
  (helm-autoresize-mode 1)
  (helm-adaptive-mode 1)
  (helm-mode 1)
)

;; fuzzier matching for helm
(use-package helm-flx
  :ensure t
  :after helm
  :config
  (helm-flx-mode +1))



(use-package swiper-helm
  :ensure t
  :bind ("C-s" . swiper-helm)
  :config
  (setq swiper-helm-display-function 'helm-default-display-buffer)
  )

(defun helm-skip-dots (old-func &rest args)
  "Skip . and .. initially in helm-find-files.  First call OLD-FUNC with ARGS."
  (apply old-func args)
  (let ((sel (helm-get-selection)))
    (if (and (stringp sel) (string-match "/\\.$" sel))
	(helm-next-line 2)))
  (let ((sel (helm-get-selection))) ; if we reached .. move back
    (if (and (stringp sel) (string-match "/\\.\\.$" sel))
	(helm-previous-line 1))))

(advice-add #'helm-preselect :around #'helm-skip-dots)
(advice-add #'helm-ff-move-to-first-real-candidate :around #'helm-skip-dots)

;;; built-in packages
(use-package paren
  :config
  (show-paren-mode +1))

(use-package elec-pair
  :config
  (electric-pair-mode +1))

;; highlight the current line
(use-package hl-line
  :config
(global-hl-line-mode +1))

(use-package intellij-theme
  :ensure t
  :config
  (load-theme 'intellij t))

(use-package diminish
  :ensure t)
(eval-after-load "helm" '(diminish 'helm-mode))
(eval-after-load "company" '(diminish 'company-mode))
(eval-after-load "subword" '(diminish 'subword-mode))
(eval-after-load "flycheck" '(diminish 'flycheck-mode))
(eval-after-load "undo-tree" '(diminish 'undo-tree-mode))
(eval-after-load "whitespace" '(diminish 'whitespace-mode))
(eval-after-load "eldoc" '(diminish 'eldoc-mode))
(add-hook 'emacs-lisp-mode-hook 
  (lambda()
    (setq mode-name "el"))) 

;; Moves selected region around.
(use-package drag-stuff
  :ensure t
  :diminish drag-stuff-mode
  :bind (("M-<down>" . drag-stuff-down)
         ("M-<up>" . drag-stuff-up))
  :config
  (drag-stuff-global-mode))

(use-package vi-tilde-fringe
  :init (global-vi-tilde-fringe-mode t)
:ensure t)

(use-package highlight-indentation
  :diminish highlight-indentation-mode
  :diminish highlight-indentation-current-column-mode
  :init (require 'highlight-indentation)
  :config
  (set-face-background 'highlight-indentation-face "#e3e3d3")
  (set-face-background 'highlight-indentation-current-column-face "#c3b3b3")
  :ensure t)
(add-hook 'prog-mode-hook #'highlight-indentation-mode)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(highlight-indentation-blank-lines t)
 '(package-selected-packages (quote (helm use-package evil))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
