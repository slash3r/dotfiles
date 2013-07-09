(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes (quote (misterioso)))
 '(ecb-layout-name "left9")
 '(ecb-source-path (quote (("d:" "d:"))))
 '(ecb-tag-jump-sets-mark nil)
 '(inhibit-startup-screen t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(bm-fringe-persistent-face ((t (:background "DarkOrange1" :foreground "black")))))

; Add marmalade repo
(require 'package)
(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/"))
(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/"))
(package-initialize)

; Change font
(set-face-attribute 'default nil :font "Terminus-10")

; ECB
(require 'ecb)
(setq ecb-tip-of-the-day nil)

; Activate semantic
(semantic-mode 1)

; Add eshell shortcut
(global-set-key [f1] 'eshell)

; Delete selection on key press
(delete-selection-mode 1)

; Set the default cursor the a vertical bar
(setq-default cursor-type 'box)

; Enable smooth scrolling
(setq mouse-wheel-scroll-amount '(1 ((shift) . 1)))  ;; one line at a time
(setq mouse-wheel-progressive-speed nil)             ;; don't accelerate scrolling
(setq mouse-wheel-follow-mouse 't)                   ;; scroll window under mouse
(setq scroll-step 1)                                 ;; keyboard scroll one line at a time

; Disable some stuff
(scroll-bar-mode -1)
(tool-bar-mode -1)
(menu-bar-mode -1)

; Save session on exit and restore it back on startup
(desktop-save-mode 1)

; Display line numbers everywhere
(global-linum-mode 1)
(setq linum-format "%4d \u2502 ")

; Start Autopair
(require 'autopair)
(autopair-global-mode)

; Enable the show paren mode
(show-paren-mode 1)

; Start Tabbar
(require 'tabbar)
(tabbar-mode t)

; Start EPC
(require 'epc)

; Start auto-complete
(require 'auto-complete)
(global-auto-complete-mode t)

; Setup jedi
(add-hook 'python-mode-hook 'jedi:setup)
(setq jedi:setup-keys t)
(setq jedi:complete-on-dot t)

; Auto load ido mode
(require 'ido)
(ido-mode t)

; Start Visual Bookmarks
(require 'bm)
(setq bm-highlight-style 'bm-highlight-only-fringe)
;(setq bm-marker 'bm-marker-left)

(global-set-key (kbd "<C-f2>") 'bm-toggle)
(global-set-key (kbd "<f2>")   'bm-next)
(global-set-key (kbd "<S-f2>") 'bm-previous)
(global-set-key (kbd "<M-f9>") 'bm-show-all)

;; make bookmarks persistent as default
(setq-default bm-buffer-persistence t)
 
;; Loading the repository from file when on start up.
(add-hook' after-init-hook 'bm-repository-load)
 
;; Restoring bookmarks when on file find.
(add-hook 'find-file-hooks 'bm-buffer-restore)
 
;; Saving bookmark data on killing a buffer
(add-hook 'kill-buffer-hook 'bm-buffer-save)
 
;; Saving the repository to file when on exit.
;; kill-buffer-hook is not called when emacs is killed, so we
;; must save all bookmarks first.
(add-hook 'kill-emacs-hook '(lambda nil
                              (bm-buffer-save-all)
                              (bm-repository-save)))

; Override the kill buffer shortcut
(global-set-key (kbd "C-x b") 'ibuffer)
(setq ibuffer-default-sorting-mode 'major-mode)

; Hide custom files
(require 'ibuf-ext)
(add-to-list 'ibuffer-never-show-predicates "^\\*")

(setq-default truncate-lines -1)

; Some emacs ergonomics
(global-set-key (kbd "C-o") 'find-file)
(global-set-key (kbd "C-w") 'kill-this-buffer)
(global-set-key (kbd "C-S-s") 'occur)
(global-set-key (kbd "<f5>") 'save-buffer)
(global-set-key (kbd "C-z") 'undo)
(global-set-key (kbd "C-l") 'goto-line)

(global-set-key (kbd "M-s") 'other-window)          ; cursor to other pane
(global-set-key (kbd "M-0") 'delete-window)         ; close current pane

(put 'erase-buffer 'disabled nil)

;; Use human readable Size column instead of original one
(define-ibuffer-column size-h
  (:name "Size" :inline t)
  (cond
   ((> (buffer-size) 1024) (format "%7.1fk" (/ (buffer-size) 1024.0)))
   ((> (buffer-size) 1048576) (format "%7.1fM" (/ (buffer-size) 1048576.0)))
   (t (format "%8d" (buffer-size)))))

;; Modify the default ibuffer-formats
(setq ibuffer-formats
      '((mark modified read-only " "
              (name 18 18 :left :elide)
              " "
              (size-h 9 -1 :right)
              " "
              (mode 16 16 :left :elide)
              " "
              filename-and-process)))

;; Compile on save
(defun byte-compile-current-buffer ()
  (interactive)
  (when (eq major-mode 'emacs-lisp-mode)
    (byte-compile-file buffer-file-name)
    (eval-buffer)))

(add-hook 'after-save-hook 'byte-compile-current-buffer)

;; Smart HOME function
(defun smart-beginning-of-line ()
  (interactive)
  (let ((oldpos (point)))
    (back-to-indentation)
    (and (= oldpos (point))
         (beginning-of-line))))

(global-set-key [home] 'smart-beginning-of-line)

