(setq file-name-handler-alist-original file-name-handler-alist)
(setq file-name-handler-alist nil)

(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

(setq load-prefer-newer t)

(setq initial-frame-alist '((width . 90) ; character
        (height . 50) ; lines
        ))

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

(set-default 'truncate-lines nil)
(add-hook 'prog-mode-hook #'toggle-truncate-lines)

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

(use-package evil :ensure t
  :init
  (setq evil-want-integration t) 
  (setq evil-want-keybinding nil)
  :config
  (evil-mode 1))

(use-package evil-collection
  :after evil
  :requires evil
  :ensure t
  :config
  (evil-collection-init))

(use-package helm :ensure t :defer 2
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
(use-package helm-flx :ensure t
  :after helm
  :config
  (helm-flx-mode +1))

(use-package swiper-helm :ensure t :defer 2
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
  (custom-set-faces
  '(show-paren-match ((t (:background "#497FAB" :foreground "white smoke"))))
  '(show-paren-match-expression ((t (:background "#497FAB")))))

  (setq show-paren-delay 0)
  (setq show-paren-priority -50)
  (show-paren-mode +1))

(use-package elec-pair
  :config
  (electric-pair-mode +1))

;; highlight the current line
(use-package hl-line
  :config
  (global-hl-line-mode +1))

(use-package spacemacs-theme
  :defer t
  :init (load-theme 'spacemacs-light t))

(use-package diminish :ensure t :defer 2)

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
(use-package drag-stuff :ensure t :defer 2
  :diminish drag-stuff-mode
  :bind (("M-<down>" . drag-stuff-down)
         ("M-<up>" . drag-stuff-up))
  :config
  (drag-stuff-global-mode))

(use-package highlight-indentation :ensure t :defer 2
  :diminish highlight-indentation-mode
  :diminish highlight-indentation-current-column-mode
  :config
  (set-face-background 'highlight-indentation-face "#e3e3d3")
  (set-face-background 'highlight-indentation-current-column-face "#c3b3b3")
  (add-hook 'prog-mode-hook #'highlight-indentation-mode))

(use-package avy :ensure t :defer 4
  :requires evil
  :config
  (define-key evil-motion-state-map "gl" 'evil-avy-goto-line)
  (define-key evil-normal-state-map "gl" 'evil-avy-goto-line)
  (define-key evil-motion-state-map "gc" 'evil-avy-goto-char)
  (define-key evil-normal-state-map "gc" 'evil-avy-goto-char)
  (setq avy-background t))

(use-package git-gutter :ensure t :defer 8
  :diminish git-gutter-mode
  :config (global-git-gutter-mode)
  :config
  ;; Ignore git status icons. Colors are enough.
  (custom-set-variables
   '(git-gutter:modified-sign " ") 
   '(git-gutter:added-sign " ")   
   '(git-gutter:deleted-sign " "))
  (custom-set-variables
   '(git-gutter:update-interval 0.2))
  (progn
    (set-face-background 'git-gutter:deleted "#f2bfb6")
    (set-face-background 'git-gutter:modified "#c3d6e8")
    (set-face-background 'git-gutter:added "#c9dec1")))

(use-package company :ensure t :defer 8
  :config
  (add-to-list 'company-backends 'company-yasnippet)
  (setq company-idle-delay 0.2)
  (setq company-show-numbers t)
  (setq company-minimum-prefix-length 1)
  (global-company-mode))

(global-prettify-symbols-mode)
(setq prettify-symbols-unprettify-at-point 'right-edge)
(setq inhibit-compacting-font-caches t)
(add-hook 'prog-mode-hook
        (lambda ()
            (push '("lambda" . ?λ) prettify-symbols-alist)
            (push '("->" . ?→) prettify-symbols-alist)
            (push '("=>" . ?⇒) prettify-symbols-alist)
            (push '("!=" . ?≠) prettify-symbols-alist)
            (push '("==" . ?≡) prettify-symbols-alist)
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
            (push '("{}" . (?⦃ (Br . Bl) ?⦄)) prettify-symbols-alist)
            ))

(use-package magit :ensure t :defer 8
  :init
  (define-key evil-normal-state-map "gs" 'magit-status))

(use-package evil-magit :ensure t :defer 8
  :after magit)

(use-package yasnippet :ensure t 
  :config
  (yas-global-mode 1))

(use-package yasnippet-snippets :ensure t
  :after yasnippet)

(use-package lsp-mode :ensure t
  :requires yasnippet
  :config
  (add-hook 'python-mode-hook #'lsp-deferred))

(use-package company-lsp :ensure t
  :after lsp-mode
  :config
  (setq company-lsp-enable-snippet t)
  (push 'company-lsp company-backends))

(use-package lsp-ui :ensure t
  :after lsp-mode
  :config
  (add-hook 'lsp-mode-hook 'lsp-ui-mode))

(setq custom-file "~/.emacs.d/custom.el")
(load custom-file 'noerror)
