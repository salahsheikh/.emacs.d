(setq custom-file (concat user-emacs-directory "custom.el"))
(load custom-file 'noerror)

(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))

(eval-when-compile
  (require 'package)
  (setq package-enable-at-startup nil)
  (setq package-archives
        '(("GNU ELPA"     . "https://elpa.gnu.org/packages/")
          ("MELPA Stable" . "https://stable.melpa.org/packages/")
          ("MELPA"        . "https://melpa.org/packages/"))
        package-archive-priorities
        '(("GNU ELPA"     . 15)
          ("MELPA"        . 10)
          ("MELPA Stable" . 5)))
  (package-initialize)

  (unless (package-installed-p 'use-package)
    (package-refresh-contents)
    (package-install 'use-package))

  (setq use-package-always-ensure t)

  (require 'use-package))

(setq auto-mode-case-fold nil)

(fset 'yes-or-no-p 'y-or-n-p)

(mouse-avoidance-mode 'animate)

(setq x-underline-at-descent-line t)

(window-divider-mode)

(set-default 'indent-tabs-mode nil)
(setq-default tab-width 4)

(add-hook 'prog-mode-hook 'display-line-numbers-mode)
(setq-default display-fill-column-indicator-column 120)
(add-hook 'prog-mode-hook 'display-fill-column-indicator-mode)
(add-hook 'markdown-mode-hook #'display-line-numbers-mode)

(delete-selection-mode t)

(setq scroll-margin 0
      scroll-preserve-screen-position t
      next-screen-context-lines 2)

(defun flash-mode-line ()
  (invert-face 'mode-line)
  (run-with-timer 0.1 nil #'invert-face 'mode-line))
(setq visible-bell nil
      ring-bell-function 'flash-mode-line)

(setq make-backup-files nil)
(setq auto-save-default nil)
(setq create-lockfiles nil)

(setq sentence-end-double-space t
      set-mark-command-repeat-pop t

      view-read-only t
      view-inhibit-help-message t

      inhibit-compacting-font-caches t)

(setq window-resize-pixelwise t
      frame-resize-pixelwise t)

(setq x-select-enable-clipboard t)

(setq use-dialog-box nil)

(use-package paren
  :ensure t
  :config
  (setq show-paren-delay 0)
  (set-face-attribute 'show-paren-match nil :weight 'extra-bold)
  (set-face-attribute 'show-paren-mismatch nil :weight 'extra-bold)  
  (show-paren-mode t))

(use-package shackle
  :config
  (shackle-mode))

(use-package helm
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
        helm-candidate-number-list 20
        helm-candidate-number-limit 20
        helm-split-window-in-side-p t
        helm-move-to-line-cycle-in-source t
        helm-echo-input-in-header-line t
        helm-ff-skip-boring-files t
        helm-autoresize-max-height 20)
  :config
  (defun helm-dashboard()
    (when (display-graphic-p)
      (let ((helm-full-frame-orig helm-full-frame)
            (helm-mini-default-sources-orig helm-mini-default-sources))
        (setq helm-full-frame t)
        (setq helm-mini-default-sources `(helm-source-bookmarks
                                          helm-source-recentf))
        (helm-mini)
        (setq helm-mini-default-sources helm-mini-default-sources-orig)
        (setq helm-full-frame helm-full-frame-orig))))
  (add-hook 'emacs-startup-hook #'helm-dashboard)

  (global-set-key (kbd "M-x") #'helm-M-x)
  (global-set-key (kbd "C-x C-f") #'helm-find-files)
  (global-set-key (kbd "C-x C-b") #'helm-buffers-list)

  (defun helm-skip-dots (old-func &rest args)
    "Skip . and .. initially in helm-find-files. First call OLD-FUNC with ARGS."
    (apply old-func args)
    (let ((sel (helm-get-selection)))
      (if (and (stringp sel) (string-match "/\\.$" sel))
          (helm-next-line 2)))
    (let ((sel (helm-get-selection))) ; if we reached .. move back
      (if (and (stringp sel) (string-match "/\\.\\.$" sel))
          (helm-previous-line 1))))

  (advice-add #'helm-preselect :around #'helm-skip-dots)
  (advice-add #'helm-ff-move-to-first-real-candidate :around #'helm-skip-dots)
  (define-key helm-map [escape] 'helm-keyboard-quit)

  (helm-autoresize-mode 1)
  (helm-adaptive-mode 1)

  (helm-mode))

(use-package helm-flx
  :after helm
  :config
  (helm-flx-mode +1))

(use-package swiper-helm
  :after helm
  :bind ("C-s" . swiper-helm)
  :config
  (setq swiper-helm-display-function 'helm-default-display-buffer))

(use-package projectile
  :ensure t
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :config
  (setq projectile-project-search-path '("~"))
  (setq projectile-indexing-method 'native)
  (setq projectile-enable-caching t)
  (projectile-global-mode))

(use-package helm-projectile
  :after projectile)

(use-package hl-line
  :hook ((prog-mode . hl-line-mode)
         (dired-mode . hl-line-mode))
  :config
  (setq hl-line-sticky-flag nil))

(use-package magit)

(require 'tramp)

(put 'erase-buffer 'disabled nil)

(require 'fpath-header-line)

(set-face-foreground 'font-lock-constant-face "Aquamarine3")
(set-face-foreground 'font-lock-keyword-face "SteelBlue3")
(set-face-foreground 'font-lock-type-face "PaleGreen3")

(use-package clang-format
  :config
  (setq-default clang-format-style "file")
  (defun clang-format-save-hook-for-this-buffer ()
    "Create a buffer local save hook."
    (add-hook 'before-save-hook
              (lambda ()
                (when (locate-dominating-file "." ".clang-format")
                  (clang-format-buffer))
                nil)
              nil
              t))

  (add-hook 'c++-mode-hook (lambda () (clang-format-save-hook-for-this-buffer))))

(use-package subword
  :init (global-subword-mode +1))

(setq-default bidi-display-reordering 'left-to-right
              bidi-paragraph-direction 'left-to-right)
(setq bidi-inhibit-bpa t)

(setq-default cursor-in-non-selected-windows nil)
(setq-default highlight-nonselected-windows nil)

(setq fast-but-imprecise-scrolling t)

(setq-default indicate-empty-lines t)

(setq font-lock-maximum-decoration t
      color-theme-is-global t
      truncate-partial-width-windows nil)

(setq redisplay-dont-pause t)

(when window-system
  (setq frame-title-format '(buffer-file-name "%f" ("%b")))
  (when (bound-and-true-p tooltip-mode)
    (tooltip-mode -1))  
  (blink-cursor-mode -1))

(setq enable-recursive-minibuffers t)
(setq echo-keystrokes 0.02)

(setq ansi-color-for-comint-mode t)

(setq-default display-line-numbers-width 3)
(setq-default display-line-numbers-widen t)

(setq frame-inhibit-implied-resize t)
(setq inhibit-x-resources nil)

(setq split-width-threshold 160
      split-height-threshold nil)

(setq inhibit-startup-screen t
      inhibit-startup-echo-area-message t
      initial-scratch-message nil
      inhibit-default-init t
      initial-major-mode 'fundamental-mode)

(setq idle-update-delay 1.0)

(setq inhibit-compacting-font-caches t)

(setq redisplay-skip-fontification-on-input t)

(setq hscroll-margin 2
      hscroll-step 1
      ;; Emacs spends too much effort recentering the screen if you scroll the
      ;; cursor more than N lines past window edges (where N is the settings of
      ;; `scroll-conservatively'). This is especially slow in larger files
      ;; during large-scale scrolling commands. If kept over 100, the window is
      ;; never automatically recentered.
      scroll-conservatively 101
      scroll-margin 0
      scroll-preserve-screen-position t
      ;; Reduce cursor lag by a tiny bit by not auto-adjusting `window-vscroll'
      ;; for tall lines.
      auto-window-vscroll nil
      ;; mouse
      mouse-wheel-scroll-amount '(2 ((shift) . hscroll))
      mouse-wheel-scroll-amount-horizontal 2)

(use-package diff-hl
  :after magit
  :config
  (global-diff-hl-mode t))

(use-package ace-window
  :ensure t
  :init
  (ace-window-display-mode t)
  (setq aw-display-mode-overlay nil)

  (defvar ss/cursor-type-holder)
  
  (defun ss/hide-frills (orig-fun &rest args)
    (show-paren-mode -1)
    (hl-line-mode -1)
    (let ((original-cursor-type (symbol-value 'cursor-type)))
      (setq ss/cursor-type-holder original-cursor-type)
      ;; (setq cursor-type nil)
      (message (prin1-to-string original-cursor-type))
      (apply orig-fun args)
      (show-paren-mode t)
      (hl-line-mode t)
      ;; (setq cursor-type original-cursor-type)
      ))

  (advice-add 'ace-window :around #'ss/hide-frills)

  (defun ss/restore-frills ()
    (when (eq major-mode 'ace-window-mode)
      (setq cursor-type ss/cursor-type-holder)))

  (add-hook 'change-major-mode-hook #'ss/restore-frills)  
  
  (progn (global-set-key (kbd "C-x o") 'ace-window)))

(setq-default indent-tabs-mode nil)
(setq-default tab-width 2)
(setq indent-line-function 'insert-tab)
