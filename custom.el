;;; Uncomment the modules you'd like to use and restart Prelude afterwards

;; (require 'prelude-ido) ;; Super charges Emacs completion for C-x C-f and more
(require 'prelude-ivy) ;; A mighty modern alternative to ido
(require 'prelude-helm) ;; Interface for narrowing and search
(require 'prelude-helm-everywhere) ;; Enable Helm everywhere
;; (require 'prelude-company)
(require 'prelude-emacs-lisp)
(require 'prelude-go)
(require 'prelude-js)
(require 'prelude-latex)
(require 'prelude-org) ;; Org-mode helps you keep TODO lists, notes and more
(require 'prelude-python)
(require 'prelude-shell)
(require 'prelude-scss)
(require 'prelude-ts)
(require 'prelude-web) ;; Emacs mode for web templates
(require 'prelude-xml)
(require 'prelude-yaml)


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(multiple-cursors dockerfile-mode exec-path-from-shell zop-to-char zenburn-theme which-key volatile-highlights undo-tree super-save smartrep smartparens operate-on-number move-text magit projectile imenu-anywhere hl-todo guru-mode gitignore-mode gitconfig-mode git-timemachine gist flycheck expand-region epl editorconfig easy-kill diminish diff-hl discover-my-major crux browse-kill-ring beacon anzu ace-window))
 '(safe-local-variable-values '((flycheck-disabled-checkers emacs-lisp-checkdoc))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )


;; (setq prelude-theme 'zenburn)
(setq prelude-whitespace nil)

;; blinky box cursor
(setq-default cursor-type 'box)
(blink-cursor-mode)
(blink-cursor-mode)
(menu-bar-mode -1)
;; Multiple cursors
(require 'multiple-cursors)
(global-set-key (kbd "C-S-; C-S-;") 'mc/edit-lines)
(global-set-key (kbd "C-c ;") 'mc/mark-next-like-this)
(global-set-key (kbd "C-c :") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c '") 'mc/mark-all-like-this)
(global-set-key (kbd "C-S-k") 'kill-whole-line)

(defadvice kill-region (before slick-cut activate compile)
  "When called interactively with no active region, kill a single line instead."
  (interactive
   (if mark-active
       (list (region-beginning) (region-end))
     (list (line-beginning-position) (line-beginning-position 2)))))

(defadvice kill-ring-save (before slick-copy activate compile)
  "When called interactively with no active region, copy a single line instead."
  (interactive
   (if mark-active
       (list (region-beginning) (region-end))
     (message "Copied line")
     (list (line-beginning-position) (line-beginning-position 2)))))
