;; (use-package yasnippet
;;   :diminish yas-minor-mode
;;   :config
;;   (use-package yasnippet-snippets)
;;   (use-package java-snippets)
;;   (yas-global-mode 1))

(use-package lsp-mode 
  :after (evil lsp-java lsp-python-ms)
  :config
  (setq lsp-prefer-flymake nil)
  (define-key evil-motion-state-map "gd" 'lsp-find-definition)
  (add-hook 'python-mode-hook #'lsp-deferred)
  (add-hook 'java-mode-hook #'lsp-deferred))

(use-package company 
  ;; :after yasnippet
  :diminish company-mode
  :config
  (use-package company-lsp 
    ;; :config
    ;; (setq company-lsp-enable-snippet t)
    ;; (setq lsp-enable-snippet t)
    )

  (setq-default company-backends '((company-capf)
                                   (company-abbrev company-dabbrev)
                                   (company-keywords)
                                   (company-elisp)
                                   (company-files)
                                   (company-lsp)))

  ;; ;; yasnippet specific code
  ;; (push '(company-lsp) company-backends)

  ;; (defun user/enable-yas-for-backend (backend)
  ;;   "Add yasnippet support for specified BACKEND."
  ;;   (if (and (listp backend) (member 'company-yasnippet backend))
  ;;       backend
  ;;     (append (if (consp backend) backend (list backend))
  ;;             '(:with company-yasnippet))))

  ;; ;; Enable for all company backends. Add to hook to prevent missed backends.
  ;; (add-hook 'yas-minor-mode-hook
  ;;           (lambda()
  ;;             (setq company-backends
  ;;                   (mapcar #'user/enable-yas-for-backend company-backends))))

  (setq company-lsp-cache-candidates nil)
  (setq company-idle-delay 0.01)
  (setq company-show-numbers t)
  (setq company-minimum-prefix-length 1)
  (setq company-tooltip-limit 5)
  (global-company-mode))

(use-package flycheck)

(use-package helm-flycheck
  :after (flycheck)
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
  (setq lsp-ui-doc-enable nil
        lsp-ui-sideline-enable nil
        lsp-ui-flycheck-enable t)
  (add-hook 'lsp-mode-hook 'lsp-ui-mode))

;; start of programming language specific packages
(use-package rust-mode)
(use-package lsp-java)
(use-package lsp-python-ms)
;; end of programming language specific packages

(provide 'completion)
