(setq file-name-handler-alist-original file-name-handler-alist)
(setq file-name-handler-alist nil)

(setq backup-directory-alist `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms `((".*" ,temporary-file-directory t)))

(setq create-lockfiles nil)

(eval-when-compile
    (require 'package)
    (setq package-enable-at-startup nil)
    (add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
    (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/"))
    (package-initialize)

    (unless (package-installed-p 'use-package)
    (package-refresh-contents)
    (package-install 'use-package))

    (setq use-package-always-ensure t)

    (require 'use-package)
    (require 'diminish))

(eval-after-load "subword" '(diminish 'subword-mode))
(eval-after-load "undo-tree" '(diminish 'undo-tree-mode))
(eval-after-load "whitespace" '(diminish 'whitespace-mode))
(eval-after-load "eldoc" '(diminish 'eldoc-mode))
(add-hook 'emacs-lisp-mode-hook 
  (lambda()
    (setq mode-name "elisp"))) 

;; necessary packages
(use-package evil
  :hook (after-init . evil-mode)
  :init
  (setq evil-want-integration t) 
  (setq evil-want-keybinding nil)
  :config
  (dolist (k
    '([mouse-1] [down-mouse-1] [drag-mouse-1] [double-mouse-1] [triple-mouse-1]  
      [mouse-2] [down-mouse-2] [drag-mouse-2] [double-mouse-2] [triple-mouse-2]
      [mouse-3] [down-mouse-3] [drag-mouse-3] [double-mouse-3] [triple-mouse-3]
      [mouse-4] [down-mouse-4] [drag-mouse-4] [double-mouse-4] [triple-mouse-4]
      [mouse-5] [down-mouse-5] [drag-mouse-5] [double-mouse-5] [triple-mouse-5]))
  (define-key evil-normal-state-map k 'ignore)))

(use-package evil-collection :defer 2
  :after evil
  :config
  (evil-collection-init))

(use-package magit :defer 4
  :after (evil git-gutter)
  :init
  (define-key evil-normal-state-map "gs" 'magit-status)
  :config
  (defun my-magit-mode-hook ()
    "Custom `magit-mode' behaviours."
    (setq left-fringe-width 10
          right-fringe-width 0))
  (add-hook 'magit-post-refresh-hook
            #'git-gutter:update-all-windows)
  (add-hook 'magit-mode-hook 'my-magit-mode-hook))

(use-package evil-magit 
  :after magit)

(use-package avy
  :after (evil evil-collection)
  :config
  (define-key evil-motion-state-map "gl" 'evil-avy-goto-line)
  (define-key evil-normal-state-map "gl" 'evil-avy-goto-line)
  (define-key evil-motion-state-map "gc" 'evil-avy-goto-char)
  (define-key evil-normal-state-map "gc" 'evil-avy-goto-char)
  (setq avy-background t))

(use-package ace-window :defer 2
  :after evil
  :custom-face
  (aw-leading-char-face ((t (:inherit font-lock-builtin-face :bold t :height 2.0))))
  :config
  (evil-global-set-key 'normal "\C-w\C-w" 'ace-window))

(use-package switch-window
  :after evil)

(use-package git-gutter :defer 1
  :config
  ;; Ignore git status icons. Colors are enough.
  (custom-set-variables
   '(git-gutter:modified-sign " ") 
   '(git-gutter:added-sign " ")   
   '(git-gutter:deleted-sign " "))
  (custom-set-variables
   '(git-gutter:update-interval 0.2)
   '(git-gutter:hide-gutter t)
   )
  (progn
    (set-face-background 'git-gutter:deleted "#f2bfb6")
    (set-face-background 'git-gutter:modified "#c3d6e8")
    (set-face-background 'git-gutter:added "#c9dec1"))
  (global-git-gutter-mode))

(use-package helm 
  :diminish helm-mode
  :init
  (setq helm-M-x-fuzzy-match t
	helm-mode-fuzzy-match t
	helm-buffers-fuzzy-matching t
	helm-recentf-fuzzy-match t
	helm-locate-fuzzy-match t
	helm-semantic-fuzzy-match t
	helm-imenu-fuzzy-match t
	helm-completion-in-region-fuzzy-match t
    helm-follow-mode-persistent t
    helm-quick-update t
	helm-candidate-number-list 150
	helm-split-window-in-side-p t
	helm-move-to-line-cycle-in-source t
	helm-echo-input-in-header-line t
	helm-ff-skip-boring-files t
	helm-autoresize-max-height 0
	helm-autoresize-min-height 20)
  :config
  (defun helm-dashboard()
    "Author: MikeTheTall"
    (if (< (length command-line-args) 2)
    (let ((helm-full-frame-orig helm-full-frame) (helm-mini-default-sources-orig helm-mini-default-sources))
        (setq helm-full-frame t)
        ;; (setq helm-mini-default-sources `(helm-source-bookmarks helm-source-recentf))
        ;; (helm-mini)
        ;; (setq helm-mini-default-sources helm-mini-default-sources-orig)
        (helm-mini)
        (setq helm-full-frame helm-full-frame-orig))))
  (add-hook 'window-setup-hook (lambda () (helm-dashboard)))
  (setq helm-candidate-number-limit 100)
  (global-set-key (kbd "M-x") #'helm-M-x)
  (global-set-key (kbd "C-x C-f") #'helm-find-files)
  (global-set-key (kbd "C-x C-b") #'helm-buffers-list)

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

  (helm-autoresize-mode 1)
  (helm-adaptive-mode 1)
  (helm-mode 1))

;; fuzzier matching for helm
(use-package helm-flx :defer 1
  :after helm
  :config
  (helm-flx-mode +1))

(use-package swiper-helm :defer 1
  :after helm
  :bind ("C-s" . swiper-helm)
  :config
  (setq swiper-helm-display-function 'helm-default-display-buffer))

(use-package helm-ag
  :after (helm))

(use-package projectile :defer 2
  :config
  (projectile-mode +1))

(use-package helm-projectile
  :after (helm))

;; Moves selected region around.
(use-package drag-stuff 
  :diminish drag-stuff-mode
  :bind (("M-<down>" . drag-stuff-down)
         ("M-<up>" . drag-stuff-up))
  :config
  (drag-stuff-global-mode))

(use-package yasnippet :defer 4
  :diminish yas-minor-mode
  :config
  (use-package yasnippet-snippets)
  (yas-global-mode 1))

(use-package lsp-mode :defer 2
  :config
  (setq lsp-prefer-flymake nil)
  (add-hook 'python-mode-hook #'lsp-deferred))

(use-package company :defer 6
  :diminish company-mode
  :config
  (add-to-list 'company-backends 'company-yasnippet)
  (add-to-list 'company-backends 'company-elisp)
  (add-to-list 'company-backends 'company-files)
  (setq company-idle-delay 0.2)
  (setq company-show-numbers t)
  (setq company-minimum-prefix-length 1)
  (global-company-mode))

(use-package company-flx
  :after (company)
  :config
  (company-flx-mode +1))

(use-package company-lsp 
  :after (lsp-mode yasnippet company)
  :config
  (setq company-lsp-enable-snippet t)
  (push 'company-lsp company-backends))

(use-package flycheck)

(use-package helm-flycheck
  :init
  (defvar helm-source-flycheck
    '((name . "Flycheck")
      (init . helm-flycheck-init)
      (candidates . helm-flycheck-candidates)
      (action-transformer helm-flycheck-action-transformer)
      (action . (("Go to" . helm-flycheck-action-goto-error)))
      (follow . 1))))

(use-package lsp-ui 
  :after (lsp-mode flycheck)
  :config
  (setq lsp-ui-doc-enable t
        lsp-ui-flycheck-enable t)
  (add-hook 'lsp-mode-hook 'lsp-ui-mode))

(use-package rust-mode)

(use-package which-key :defer 8
  :config
  (which-key-mode))

;; end of necessary packages

;; ui customization

(setq frame-resize-pixelwise t)

;;; built-in packages
;(add-to-list 'default-frame-alist '(font . "DejaVu Sans Mono-10"))

(set-default 'indent-tabs-mode nil)
(setq-default tab-width 4)

(setq initial-frame-alist '((width . 90) (height . 50)))

(setq split-width-threshold nil)
(setq split-height-threshold 0)

(set-default 'truncate-lines nil)
(add-hook 'prog-mode-hook #'toggle-truncate-lines)
(add-hook 'prog-mode-hook #'display-line-numbers-mode)

(use-package autorevert :defer 8
  :config
  (global-auto-revert-mode t))

(fset 'yes-or-no-p 'y-or-n-p)

(setq visible-bell t)
(setq ring-bell-function 'ignore)

(use-package paren 
  :custom-face
  (show-paren-match ((t (:background "powder blue"))))
  :config
  (setq show-paren-delay 0)
  (show-paren-mode t))

(use-package elec-pair :defer 1
  :config
  (electric-pair-mode +1))

;; highlight the current line
(use-package hl-line :defer 1
  :config
  (global-hl-line-mode +1))

(use-package highlight-indent-guides
  :config
  (setq highlight-indent-guides-method 'column)
  (add-hook 'prog-mode-hook 'highlight-indent-guides-mode))

(use-package intellij-theme :init (load-theme 'intellij t))

(when (member "DeJaVu Sans" (font-family-list))
  (with-current-buffer (get-buffer " *Echo Area 0*")
    (setq-local face-remapping-alist
                '((default (:family "DeJaVu Sans") variable-pitch)))))

;; display nice file path in headerline
(setq-default header-line-format '(:eval
                (if (and (not (string-suffix-p "*" (buffer-name))) (not (string-prefix-p "*" (buffer-name))))
                    (if (eq ml-selected-window (selected-window))
                        (propertize (get-buffer-title) 'face 'mode-line)
                      (propertize (get-buffer-title) 'face 'mode-line-inactive))
                  nil)))

(defun get-buffer-title ()
  (if (buffer-file-name)
      (abbreviate-file-name (buffer-file-name))
    (abbreviate-file-name (buffer-name))))

(defvar ml-selected-window nil)

(defun ml-record-selected-window ()
  (setq ml-selected-window (selected-window)))

(defun ml-update-all ()
  (if (derived-mode-p 'prog-mode)
      (setq left-fringe-width 0)
    (setq left-fringe-width 5))
  (force-mode-line-update t))

(add-hook 'post-command-hook 'ml-record-selected-window)

(add-hook 'buffer-list-update-hook 'ml-update-all)

;; if mouse is clicked on something, leave active minibuffer
(defun stop-using-minibuffer ()
  "kill the minibuffer"
  (when (and (>= (recursion-depth) 1) (active-minibuffer-window))
    (abort-recursive-edit)))

(add-hook 'mouse-leave-buffer-hook 'stop-using-minibuffer)

;; custom ctrl+backspace behavior
(use-package s)
(defun aborn/backward-kill-word ()
  "Customize/Smart backward-kill-word. Author: Aborn Jiang"
  (interactive)
  (let* ((cp (point))
         (backword)
         (end)
         (space-pos)
         (backword-char (if (bobp)
                            ""           ;; cursor in begin of buffer
                          (buffer-substring cp (- cp 1)))))
    (if (equal (length backword-char) (string-width backword-char))
        (progn
          (save-excursion
            (setq backword (buffer-substring (point) (progn (forward-word -1) (point)))))
          (setq ab/debug backword)
          (save-excursion
            (when (and backword          ;; when backword contains space
                       (s-contains? " " backword))
              (setq space-pos (ignore-errors (search-backward " ")))))
          (save-excursion
            (let* ((pos (ignore-errors (search-backward-regexp "\n")))
                   (substr (when pos (buffer-substring pos cp))))
              (when (or (and substr (s-blank? (s-trim substr)))
                        (s-contains? "\n" backword))
                (setq end pos))))
          (if end
              (kill-region cp end)
            (if space-pos
                (kill-region cp space-pos)
              (backward-kill-word 1))))
      (kill-region cp (- cp 1)))         ;; word is non-english word
    ))

(global-set-key  [C-backspace] 'aborn/backward-kill-word)

;; Normal scrolling
(setq scroll-margin 10
      scroll-step 1
      scroll-conservatively 10000
      scroll-preserve-screen-position 1)

;; set the default encoding system
(set-language-environment 'utf-8)
(setq locale-coding-system 'utf-8)
(prefer-coding-system 'utf-8)

;; Treat clipboard input as UTF-8 string first; compound text next, etc.
(setq x-select-request-type '(UTF8_STRING COMPOUND_TEXT TEXT STRING))
(setq-default buffer-file-coding-system 'utf-8-auto-unix)

;; make some symbols look better
(add-hook 'prog-mode-hook #'prettify-symbols-mode)
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
            (push '("fn"    . ?ƒ) prettify-symbols-alist)
            (push '("::"    . ?∷) prettify-symbols-alist)))

(when (member "Symbola" (font-family-list))
    (setq use-default-font-for-symbols nil)
    (set-fontset-font "fontset-default" 'unicode (font-spec :name "Symbola"))
    (set-fontset-font "fontset-default" 'unicode-bmp (font-spec :name "Symbola")))


;; Wrap lines at 80 characters
(setq-default fill-column 79)
(custom-set-faces
 '(fill-column-indicator ((t (:foreground "#e0e0e0" :height 1.3 )))))
(add-hook 'prog-mode-hook 'display-fill-column-indicator-mode)

;; org mode customization
(set-face-attribute 'variable-pitch nil
                    :family "Sans"
                    :height 110
                    :weight 'regular)

(add-hook 'org-mode 'variable-pitch-mode)

(use-package mixed-pitch 
  :hook
  ;; If you want it in all text modes:
  (org-mode . mixed-pitch-mode))

(setq org-hide-emphasis-markers t)

(use-package spaceline :defer 2
  :init
  (remove-hook 'focus-out-hook 'powerline-unset-selected-window)
  (setq powerline-default-separator 'bar)
  (setq evil-normal-state-tag "🅝")
  (setq evil-insert-state-tag "🅘")
  (setq evil-visual-state-tag "🅥")
  :config
  (require 'spaceline-config)
  (spaceline-spacemacs-theme)
  (spaceline-toggle-buffer-id-off)
  (spaceline-helm-mode))

(when (member "DeJaVu Sans" (font-family-list))
  (with-current-buffer (get-buffer " *Echo Area 0*")
    (setq-local face-remapping-alist '((default (:family "DeJaVu Sans" :height 0.9) variable-pitch)))))

(setq auto-window-vscroll nil) 

;; disablemouse interaction
(dolist (k mwheel-installed-bindings)
  (global-set-key k 'ignore))
;; end of ui customization

(setq custom-file "~/.emacs.d/custom.el")
(load custom-file 'noerror)

(setq gc-cons-threshold 262144)

(setq-default inhibit-message nil)

(setq inhibit-startup-screen t)
(setq inhibit-startup-echo-area-message t)
(setq initial-scratch-message nil)

(message (emacs-init-time))
