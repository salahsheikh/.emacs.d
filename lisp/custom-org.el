(setq org-directory "~/org")
(setq org-default-notes-file "~/org/notes.org")

(setq org-agenda-files '("~/org"))

(global-set-key (kbd "C-c c") 'org-capture)

(use-package org-bullets
  :config
  (add-hook 'org-mode-hook (lambda() (org-bullets-mode 1))))

(setq org-todo-keywords
      (quote ((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d)")
              (sequence "WAITING(w@/!)" "HOLD(h@/!)" "|" "CANCELLED(c@/!)" "PHONE" "MEETING"))))

(setq org-todo-keyword-faces
      (quote (("TODO" :foreground "red" :weight bold)
              ("NEXT" :foreground "blue" :weight bold)
              ("DONE" :foreground "forest green" :weight bold)
              ("WAITING" :foreground "orange" :weight bold)
              ("HOLD" :foreground "magenta" :weight bold)
              ("CANCELLED" :foreground "forest green" :weight bold)
              ("MEETING" :foreground "forest green" :weight bold)
              ("PHONE" :foreground "forest green" :weight bold))))

(setq org-todo-state-tags-triggers
      (quote (("CANCELLED" ("CANCELLED" . t))
              ("WAITING" ("WAITING" . t))
              ("HOLD" ("WAITING") ("HOLD" . t))
              (done ("WAITING") ("HOLD"))
              ("TODO" ("WAITING") ("CANCELLED") ("HOLD"))
              ("NEXT" ("WAITING") ("CANCELLED") ("HOLD"))
              ("DONE" ("WAITING") ("CANCELLED") ("HOLD")))))

(setq org-capture-templates
      '(("t" "Todo" entry (file+headline "~/org/todo.org" "Tasks")
         "* TODO %?\n %i")
        ("m" "Meeting" entry (file+headline "~/org/todo.org" "Meetings")
         "* MEETING WITH %?\n%i\nSCHEDULED: %^T")))

(use-package mixed-pitch 
  :hook
  ;; If you want it in all text modes:
  (org-mode . mixed-pitch-mode))

(setq org-hide-emphasis-markers t)

(provide 'custom-org)
