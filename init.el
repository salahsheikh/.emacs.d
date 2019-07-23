(setq gc-cons-threshold most-positive-fixnum)

(setq file-name-handler-alist-original file-name-handler-alist)
(setq file-name-handler-alist nil)

(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

(setq load-prefer-newer t)

;; Prefer splitting vertically for popups
(setq split-width-threshold nil)
(setq split-height-threshold 0)

(setq initial-frame-alist '((width . 90) ; character
        (height . 50) ; lines
        ))

(custom-set-faces
 '(fill-column-indicator ((t (:foreground "#e0e0e0")))))

(add-to-list 'default-frame-alist
             '(font . "DejaVu Sans Mono-9"))

(set-face-attribute 'variable-pitch nil
                    :family "Sans"
                    :height 110
                    :weight 'regular)

(add-hook 'org-mode 'variable-pitch-mode)

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
(add-hook 'prog-mode-hook #'display-line-numbers-mode)
(setq visible-bell nil)
(setq ring-bell-function 'ignore)
;; Newline at end of file
(setq require-final-newline t)

(setq font-lock-maximum-decoration t)
;; Wrap lines at 80 characters
(setq-default fill-column 80)

(setq inhibit-startup-screen t)
(setq inhibit-startup-message t)
(setq create-lockfiles nil)
;; revert buffers automatically when underlying files are changed externally
(global-auto-revert-mode t)
(set-default 'indent-tabs-mode nil)
(setq-default tab-width 4)

(set-language-environment 'utf-8)
(setq locale-coding-system 'utf-8)

;; set the default encoding system
(prefer-coding-system 'utf-8)
(setq default-file-name-coding-system 'utf-8)
;; backwards compatibility as default-buffer-file-coding-system
;; is deprecated in 23.2.
(if (boundp buffer-file-coding-system)
    (setq buffer-file-coding-system 'utf-8)
  (setq default-buffer-file-coding-system 'utf-8))

;; Treat clipboard input as UTF-8 string first; compound text next, etc.
(setq x-select-request-type '(UTF8_STRING COMPOUND_TEXT TEXT STRING))
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

(setq use-package-always-ensure t)

(use-package server
  :init
  (server-mode 1)
  :config
  (unless (server-running-p)
    (server-start)))

(use-package evil
  :init
  (setq evil-want-integration t) 
  (setq evil-want-keybinding nil)
  :config
  (evil-mode 1))

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

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
  (helm-mode 1)
)

;; fuzzier matching for helm
(use-package helm-flx 
  :after helm
  :config
  (helm-flx-mode +1))

(use-package swiper-helm 
  :after helm
  :bind ("C-s" . swiper-helm)
  :config
  (setq swiper-helm-display-function 'helm-default-display-buffer)
  )

;;; built-in packages
(use-package paren 
  :custom-face
  (show-paren-match ((t (:background "powder blue"))))
  :config
  (setq show-paren-delay 0)
  (show-paren-mode t))

(use-package elec-pair 
  :config
  (electric-pair-mode +1))

;; highlight the current line
(use-package hl-line 
  :config
  (global-hl-line-mode +1))

(use-package intellij-theme 
  :init (load-theme 'intellij t))

(use-package diminish)

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
  :diminish drag-stuff-mode
  :bind (("M-<down>" . drag-stuff-down)
         ("M-<up>" . drag-stuff-up))
  :config
  (drag-stuff-global-mode))

(use-package highlight-indentation 
  :diminish highlight-indentation-mode
  :diminish highlight-indentation-current-column-mode
  :config
  (set-face-background 'highlight-indentation-face "#e3e3d3")
  (set-face-background 'highlight-indentation-current-column-face "#c3b3b3")
  (add-hook 'prog-mode-hook #'highlight-indentation-mode))

(use-package avy
  :after evil
  :config
  (define-key evil-motion-state-map "gl" 'evil-avy-goto-line)
  (define-key evil-normal-state-map "gl" 'evil-avy-goto-line)
  (define-key evil-motion-state-map "gc" 'evil-avy-goto-char)
  (define-key evil-normal-state-map "gc" 'evil-avy-goto-char)
  (setq avy-background t))

(use-package git-gutter 
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

(set-fringe-style nil)

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

(add-hook 'rust-mode-hook
        (lambda ()
            (push '("fn"    . ?ƒ) prettify-symbols-alist)
            (push '("::"    . ?∷) prettify-symbols-alist)
            ))

(when (member "Symbola" (font-family-list))
    (setq use-default-font-for-symbols nil)
    (set-fontset-font "fontset-default" 'unicode (font-spec :name "Symbola"))
    (set-fontset-font "fontset-default" 'unicode-bmp (font-spec :name "Symbola")))

(use-package magit 
  :after evil
  :init
  (define-key evil-normal-state-map "gs" 'magit-status)
  :config
  (defun my-magit-mode-hook ()
    "Custom `magit-mode' behaviours."
    (setq left-fringe-width 10
          right-fringe-width 0))

  (add-hook 'magit-mode-hook 'my-magit-mode-hook))

(use-package evil-magit 
  :after magit)

(use-package yasnippet 
  :config
  (yas-global-mode 1))

(use-package yasnippet-snippets 
  :after yasnippet)

(use-package lsp-mode 
  :config
  (add-hook 'python-mode-hook #'lsp-deferred))

(use-package company 
  :config
  (add-to-list 'company-backends 'company-yasnippet)
  (add-to-list 'company-backends 'company-elisp)
  (add-to-list 'company-backends 'company-files)
  (setq company-idle-delay 0.2)
  (setq company-show-numbers t)
  (setq company-minimum-prefix-length 1)
  (global-company-mode))

(use-package company-lsp 
  :after (lsp-mode yasnippet company)
  :config
  (setq company-lsp-enable-snippet t)
  (push 'company-lsp company-backends))

(use-package lsp-ui 
  :after lsp-mode
  :config
  (lsp-ui-doc-enable nil)
  (add-hook 'lsp-mode-hook 'lsp-ui-mode))

(use-package mixed-pitch 
  :hook
  ;; If you want it in all text modes:
  (org-mode . mixed-pitch-mode))

(add-hook 'prog-mode-hook 'display-fill-column-indicator-mode)

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

(global-set-key  [C-backspace]
            'aborn/backward-kill-word)

(use-package spaceline 
  :init
  (remove-hook 'focus-out-hook 'powerline-unset-selected-window)
  (setq powerline-default-separator 'bar)
  (setq evil-normal-state-tag "🅝")
  (setq evil-insert-state-tag "🅘")
  (setq evil-visual-state-tag "🅥")
  :config
  (require 'spaceline-config)
  (powerline-reset)
  (spaceline-spacemacs-theme)
  (spaceline-helm-mode)
  (spaceline-compile))

;; Normal scrolling
(setq scroll-margin 10
      scroll-step 1
      scroll-conservatively 10000
      scroll-preserve-screen-position 1)

(use-package ace-window 
  :after speedbar
  :config
  (define-key speedbar-mode-map [remap evil-window-next] 'ace-window)
  (evil-global-set-key 'normal "\C-w\C-w" 'ace-window))

(use-package sr-speedbar
  :config
  (setq sr-speedbar-width 20)
  (setq sr-speedbar-right-side nil))

(setq-default header-line-format
                    '("" ;; invocation-name
                      (:eval (if (buffer-file-name)
                                 (abbreviate-file-name (buffer-file-name))
                               "%b"))
                      ))

(setq python-python-command "/usr/bin/python3")

(setq custom-file "~/.emacs.d/custom.el")
(load custom-file 'noerror)

(setq gc-cons-threshold 262144)
