(setq file-name-handler-alist-original file-name-handler-alist)
(setq file-name-handler-alist nil)

(setq backup-directory-alist `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms `((".*" ,temporary-file-directory t)))

(setq create-lockfiles nil)
(setq custom-file "~/.emacs.d/custom.el")
(load custom-file 'noerror)

(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))

(defvar mono-font "Monaco-13" "Default font for programming.")
(defvar sans-font "DeJaVu Sans-13" "Default font for normal text.")
(defvar symbol-font "Symbola" "Default font for special symbols.")

;; packages
(eval-when-compile
  (require 'package)
  (setq package-enable-at-startup nil)
  (setq package-archives
        '(("GNU ELPA"     . "https://elpa.gnu.org/packages/")
          ("MELPA Stable" . "https://stable.melpa.org/packages/")
          ("MELPA"        . "https://melpa.org/packages/"))
        package-archive-priorities
        '(("GNU ELPA"     . 10)
          ("MELPA Stable" . 5)
          ("MELPA"        . 0)))
  (package-initialize)

  (unless (package-installed-p 'use-package)
    (package-refresh-contents)
    (package-install 'use-package))

  (setq use-package-always-ensure t)

  (require 'use-package)
  (use-package diminish
    :config
    (eval-after-load "subword" '(diminish 'subword-mode))
    (eval-after-load "abbrev" '(diminish 'abbrev-mode))
    (eval-after-load "undo-tree" '(diminish 'undo-tree-mode))
    (eval-after-load "whitespace" '(diminish 'whitespace-mode))
    (eval-after-load "eldoc" '(diminish 'eldoc-mode))))
;; end of packages

;; core packages

(use-package evil
  :hook (after-init . evil-mode)
  :init
  (setq evil-want-keybinding nil)
  :config
  (setq evil-normal-state-tag "🅝")
  (setq evil-insert-state-tag "🅘")
  (setq evil-visual-state-tag "🅥")
  (defun clear-shell()
    "docstring"
    (interactive)
    (if (equal major-mode 'eshell-mode)
        (progn
          (let ((inhibit-read-only t))
            (erase-buffer)
            (eshell-send-input)))
      (progn
        (comint-clear-buffer)))
    )
  (evil-ex-define-cmd "clear" #'clear-shell)
  (add-hook 'org-capture-mode-hook 'evil-insert-state)
  (dolist (k
           '([mouse-1] [down-mouse-1] [drag-mouse-1] [double-mouse-1] [triple-mouse-1]
             [mouse-2] [down-mouse-2] [drag-mouse-2] [double-mouse-2] [triple-mouse-2]
             [mouse-3] [down-mouse-3] [drag-mouse-3] [double-mouse-3] [triple-mouse-3]
             [mouse-4] [down-mouse-4] [drag-mouse-4] [double-mouse-4] [triple-mouse-4]
             [mouse-5] [down-mouse-5] [drag-mouse-5] [double-mouse-5] [triple-mouse-5]))
    (define-key evil-normal-state-map k 'ignore)))

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

(use-package git-gutter
  :diminish git-gutter-mode
  :config
  ;; Ignore git status icons. Colors are enough.
  (setq git-gutter:added-sign " ")
  (setq git-gutter:deleted-sign " ")
  (setq git-gutter:modified-sign " ")
  (setq git-gutter:hide-gutter t)
  (add-hook 'after-save-hook #'git-gutter:update-all-windows)
  (progn
    (set-face-background 'git-gutter:deleted "dark red")
    (set-face-background 'git-gutter:modified "steel blue")
    (set-face-background 'git-gutter:added "dark green"))
  (global-git-gutter-mode))

(use-package magit :defer t
  :after (evil git-gutter)
  :init
  (define-key evil-normal-state-map "gs" 'magit-status)
  :config
  (add-hook 'with-editor-mode-hook 'evil-insert-state)
  (add-hook 'magit-post-refresh-hook #'git-gutter:update-all-windows))

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
        (let ((helm-full-frame-orig helm-full-frame)
              (helm-mini-default-sources-orig helm-mini-default-sources))
          (setq helm-full-frame t)
          (setq helm-mini-default-sources `(helm-source-bookmarks
                                            helm-source-recentf
                                            helm-source-projectile-projects))
          (helm-mini)
          (setq helm-mini-default-sources helm-mini-default-sources-orig)
          (setq helm-full-frame helm-full-frame-orig))))
  (add-hook 'after-init-hook #'helm-dashboard)
  (setq helm-candidate-number-limit 100)
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

  ;; hide helm modeline
  ;;(defun helm-display-mode-line (source &optional force)
  ;; (setq mode-line-format " "))
  (helm-mode 1))

;; fuzzier matching for helm
(use-package helm-flx
  :after helm
  :config
  (helm-flx-mode +1))

(use-package swiper-helm
  :after helm
  :bind ("C-s" . swiper-helm)
  :config
  (setq swiper-helm-display-function 'helm-default-display-buffer))

(use-package switch-window
  :after evil
  :config
  (define-advice switch-window (:around (fun &rest r) cursor-stuff)
    (progn
      (let ((cursor-in-non-selected-windows nil))
        (apply fun r))))
  (setq switch-window-shortcut-style 'qwerty)
  (setq switch-window-multiple-frames t)
  (evil-global-set-key 'normal "\C-w\C-w" 'switch-window))

(use-package drag-stuff
  :diminish drag-stuff-mode
  :bind (("M-<down>" . drag-stuff-down)
         ("M-<up>" . drag-stuff-up)
         ("M-<left>" . drag-stuff-left)
         ("M-<right>" . drag-stuff-right))
  :config
  (drag-stuff-global-mode))

(require 'completion)

(use-package autorevert
  :config
  (global-auto-revert-mode t))

(use-package elec-pair
  :config
  (electric-pair-mode +1))

(use-package which-key
  :diminish which-key-mode
  :config
  (which-key-mode))

(use-package projectile
  :config
  (setq projectile-indexing-method 'alien)
  (setq projectile-enable-caching t)
  (projectile-global-mode))

(use-package helm-projectile
  :after helm)

(use-package neotree :defer t)

(use-package hide-mode-line
  :config
  (add-hook 'neotree-mode-hook #'hide-mode-line-mode))

(use-package expand-region
  :after evil
  :config
  (evil-global-set-key 'normal "ze" 'er/expand-region))

(if (not (equal module-file-suffix nil))
    (use-package vterm
      :after evil
      :load-path "~/emacs-libvterm"
      :config
      (add-hook 'vterm-mode-hook
                (lambda ()
                  (setq-local evil-insert-state-cursor 'box)
                  (evil-insert-state)))

      (define-key vterm-mode-map [return]                      #'vterm-send-return)

      (setq vterm-keymap-exceptions nil)
      (evil-define-key 'insert vterm-mode-map (kbd "C-e")      #'vterm--self-insert)
      (evil-define-key 'insert vterm-mode-map (kbd "C-f")      #'vterm--self-insert)
      (evil-define-key 'insert vterm-mode-map (kbd "C-a")      #'vterm--self-insert)
      (evil-define-key 'insert vterm-mode-map (kbd "C-v")      #'vterm--self-insert)
      (evil-define-key 'insert vterm-mode-map (kbd "C-b")      #'vterm--self-insert)
      (evil-define-key 'insert vterm-mode-map (kbd "C-w")      #'vterm--self-insert)
      (evil-define-key 'insert vterm-mode-map (kbd "C-u")      #'vterm--self-insert)
      (evil-define-key 'insert vterm-mode-map (kbd "C-d")      #'vterm--self-insert)
      (evil-define-key 'insert vterm-mode-map (kbd "C-n")      #'vterm--self-insert)
      (evil-define-key 'insert vterm-mode-map (kbd "C-m")      #'vterm--self-insert)
      (evil-define-key 'insert vterm-mode-map (kbd "C-p")      #'vterm--self-insert)
      (evil-define-key 'insert vterm-mode-map (kbd "C-j")      #'vterm--self-insert)
      (evil-define-key 'insert vterm-mode-map (kbd "C-k")      #'vterm--self-insert)
      (evil-define-key 'insert vterm-mode-map (kbd "C-r")      #'vterm--self-insert)
      (evil-define-key 'insert vterm-mode-map (kbd "C-t")      #'vterm--self-insert)
      (evil-define-key 'insert vterm-mode-map (kbd "C-g")      #'vterm--self-insert)
      (evil-define-key 'insert vterm-mode-map (kbd "C-c")      #'vterm--self-insert)
      (evil-define-key 'insert vterm-mode-map (kbd "C-SPC")    #'vterm--self-insert)
      (define-key vterm-mode-map (kbd "C-<backspace>") 'vterm-send-meta-backspace)
      (evil-define-key 'normal vterm-mode-map (kbd "C-<backspace>")    #'vterm-send-meta-backspace)
      (evil-define-key 'normal vterm-mode-map (kbd "C-d")      #'vterm--self-insert)
      (evil-define-key 'normal vterm-mode-map (kbd ",c")       #'multi-libvterm)
      (evil-define-key 'normal vterm-mode-map (kbd ",n")       #'multi-libvterm-next)
      (evil-define-key 'normal vterm-mode-map (kbd ",p")       #'multi-libvterm-prev)
      (evil-define-key 'normal vterm-mode-map (kbd "i")        #'evil-insert-resume)
      (evil-define-key 'normal vterm-mode-map (kbd "o")        #'evil-insert-resume)
      (evil-define-key 'normal vterm-mode-map (kbd "<return>") #'evil-insert-resume)))

;; end of core packages

;; ui customization
(set-face-attribute 'default nil :font mono-font)
(set-foreground-color "white")
(set-background-color "black")

(setq c-default-style "linux"
      c-basic-offset 4)

(setq default-frame-alist '((width . 90) (height . 50)))

;; highlight the current line
(use-package hl-line 
  :hook (prog-mode . hl-line-mode))

(blink-cursor-mode 0)

;; prefer vertical splits
(setq split-width-threshold nil)
(setq split-height-threshold 0)

(fset 'yes-or-no-p 'y-or-n-p)

(setq visible-bell t)
(setq ring-bell-function 'ignore)

(use-package paren
  :config
  (setq show-paren-delay 0)
  (show-paren-mode t))

(use-package highlight-indent-guides
  :diminish highlight-indent-guides-mode
  :config
  (defun my-highlighter (level response display)
    (if (> 1 level)
        nil
      (highlight-indent-guides--highlighter-default level response display)))

  (setq highlight-indent-guides-highlighter-function 'my-highlighter)

  (setq highlight-indent-guides-method 'column)
  (add-hook 'prog-mode-hook 'highlight-indent-guides-mode))

;; Normal scrolling
(setq scroll-margin 10
      scroll-step 1
      scroll-conservatively 10000
      scroll-preserve-screen-position 1)

(defun spacemacs//hide-cursor-in-helm-buffer ()
  "Hide the cursor in helm buffers."
  (with-helm-buffer
    (setq cursor-in-non-selected-windows nil)))
(add-hook 'helm-after-initialize-hook
          'spacemacs//hide-cursor-in-helm-buffer)

(setq fast-but-imprecise-scrolling t)

(add-hook 'emacs-lisp-mode-hook
          (lambda()
            (setq mode-name "elisp")))

(add-hook 'python-mode-hook
          (lambda()
            (setq mode-name "py")))

(setq frame-resize-pixelwise t)

(set-default 'truncate-lines t)
(add-hook 'after-init-hook #'toggle-truncate-lines)
(add-hook 'prog-mode-hook #'display-line-numbers-mode)
(add-hook 'markdown-mode-hook #'display-line-numbers-mode)

(set-default 'indent-tabs-mode nil)
(setq-default tab-width 4)

;; if mouse is clicked on something, leave active minibuffer
(defun stop-using-minibuffer ()
  "kill the minibuffer"
  (when (and (>= (recursion-depth) 1) (active-minibuffer-window))
    (abort-recursive-edit)))

(add-hook 'mouse-leave-buffer-hook 'stop-using-minibuffer)

(require 'fpath-header-line)
(require 'c-backspace)
;(require 'better-symbols)

;; Wrap lines at 80 characters
(setq-default fill-column 79)
(custom-set-faces
 `(fill-column-indicator ((t (:foreground "gray30" :family ,symbol-font :height 1.6)))))
(add-hook 'prog-mode-hook 'display-fill-column-indicator-mode)

(set-face-attribute 'mode-line nil :font sans-font)

(window-divider-mode)


(when (member sans-font (font-family-list))
  (with-current-buffer (get-buffer " *Echo Area 0*")
    (setq-local face-remapping-alist '((default (:family sans-font) variable-pitch)))))

(setq auto-window-vscroll nil)

(set-face-attribute 'variable-pitch nil :font sans-font)

(use-package symon
  :config
  (symon-mode))

(setq-default
 mode-line-mule-info nil
 mode-line-front-space nil
 mode-line-modified nil
 mode-line-remote nil)

(setq whitespace-display-mappings
       ;; all numbers are Unicode codepoint in decimal. try (insert-char 182 ) to see it
      '((tab-mark 9 [8677 9] [92 9]) ; 9 TAB, 9655 WHITE RIGHT-POINTING TRIANGLE 「▷」
        ))

(setq show-trailing-whitespace t)
;; end of ui customization

;; utf-8 options
(set-language-environment 'utf-8)
(setq locale-coding-system 'utf-8)
(prefer-coding-system 'utf-8)

;; Treat clipboard input as UTF-8 string first; compound text next, etc.
(setq x-select-request-type '(UTF8_STRING COMPOUND_TEXT TEXT STRING))
(setq-default buffer-file-coding-system 'utf-8-auto-unix)

;; end of utf-8 options

(require 'custom-org)
;; end of config

(setq inhibit-startup-screen t)
(setq inhibit-startup-echo-area-message t)
(setq initial-scratch-message nil)

(setq gc-cons-threshold 262144)
