(setq gc-cons-threshold most-positive-fixnum)

(setq file-name-handler-alist-original file-name-handler-alist)
(setq file-name-handler-alist nil)

(setq package-enable-at-startup nil)
(setq load-prefer-newer noninteractive)

(unless (or (daemonp) noninteractive)
  (setq-default inhibit-redisplay t
                inhibit-message t)
  (add-hook 'window-setup-hook
            (lambda ()
              (setq-default inhibit-redisplay nil
                            inhibit-message nil)
              (redisplay)))

  (define-advice load-file (:override (file) silence)
    (load file nil 'nomessage))

  (define-advice startup--load-user-init-file (:before (&rest _) init)
    (advice-remove #'load-file #'load-file@silence)))

(set-language-environment "UTF-8")
(setq default-input-method nil)

(setq frame-background-mode 'dark)
(setq default-frame-alist '((background-color . "#181818")
                            (foreground-color . "ivory")
                            (height . 48)
                            (width . 130)
			                (font . "Go Mono-9")))

(push '(vertical-scroll-bars) default-frame-alist)
(push '(tool-bar-lines . 0) default-frame-alist)
(push '(menu-bar-lines . 0) default-frame-alist)
