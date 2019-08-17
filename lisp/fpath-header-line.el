;; display nice file path in headerline
(setq-default header-line-format '(:eval
                (if (and (not (string-suffix-p "*" (buffer-name))) (not (string-prefix-p "*" (buffer-name))))
                    (if (eq ml-selected-window (selected-window))
                        (propertize (get-buffer-title) 'face 'mode-line)
                      (propertize (get-buffer-title) 'face 'mode-line-inactive)) nil)))

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

(provide 'fpath-header-line)
;; end of header line file display
