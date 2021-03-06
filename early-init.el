(setq gc-cons-threshold most-positive-fixnum)

(setq file-name-handler-alist-original file-name-handler-alist)
(setq file-name-handler-alist nil)

(setq load-prefer-newer t
      package-enable-at-startup nil
      package--init-file-ensured t)

(push '(tool-bar-lines . 0) default-frame-alist)
(push '(vertical-scroll-bars) default-frame-alist)
(push '(menu-bar-lines . 0) default-frame-alist)

(setq inhibit-startup-screen t)

(setq evil-want-integration nil)

(add-to-list 'default-frame-alist '(fullscreen . maximized))
