(defun get-modified-buffer-background-property (active)
  (defconst modified-background "yellow green")
  (defconst unmodified-background "olive drab")
  (defconst inactive-darken-percentage 20)

  (if active      
      (if (buffer-modified-p) modified-background unmodified-background)
    (if (buffer-modified-p) (color-darken-name modified-background inactive-darken-percentage)
      (color-darken-name unmodified-background (+ 15 inactive-darken-percentage)))))

(defun get-window-number()
  (window-parameter
   (selected-window)
   'ace-window-path))

(defun get-buffer-title ()
  (if (buffer-file-name)
      (abbreviate-file-name (buffer-file-name))
    (abbreviate-file-name (buffer-name))))

(defun get-space-padded-title (title)
  (let ((window-number-width (if (featurep 'ace-window) (string-width (get-window-number)) 0)))
    (concat "   " title (make-string (- (window-total-width) (string-width title) window-number-width) ? ))))

(defvar ml-selected-window nil)

(defun ml-record-selected-window ()
  (setq ml-selected-window (selected-window)))

(defun ml-update-all ()
  (when (buffer-file-name)
    (setq
     header-line-format
     '(
       :eval 
       (concat
        (when (featurep 'ace-window)
          (propertize (get-window-number)
                      'face '(:inherit mode-line :background "cadet blue")))
        (if (eq ml-selected-window (selected-window))
            (propertize (get-space-padded-title (get-buffer-title)) 'face
                        `(:inherit mode-line :background ,(get-modified-buffer-background-property t)))
          (propertize (get-space-padded-title (get-buffer-title)) 'face
                      `(:inherit mode-line-inactive :background ,(get-modified-buffer-background-property nil))))))))

  (force-mode-line-update t))

(add-hook 'post-command-hook 'ml-record-selected-window)

(add-hook 'buffer-list-update-hook 'ml-update-all)

(provide 'fpath-header-line)
