(add-to-list 'load-path "~/.emacs.d")

(setq backup-by-copying t)
(setq backup-by-copying-when-mismatch t)
(setq backup-by-copying-when-linked t)
(setq version-control t)
(setq backup-directory-alist '(("" . "~/.emacs.d/emacs-backup")))
(setq kept-old-versions 20)
(setq kept-new-versions 20)
(setq-default delete-old-versions t)

;;(setq delete-auto-save-files nil)

(setq x-select-enable-clipboard t)
(setq interprogram-paste-function 'x-cut-buffer-or-selection-value)

(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)

(display-time)

(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)

(global-font-lock-mode t)
(setq font-lock-maximum-decoration t)

(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(auto-compression-mode t nil (jka-compr))
 '(blink-cursor-mode nil)
 '(case-fold-search t)
 '(column-number-mode t)
 '(frame-background-mode nil)
 '(icicle-reminder-prompt-flag 6)
 '(show-paren-mode t nil (paren))
 '(tool-bar-mode nil))

(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 )

(defvar nuke-trailing-whitespace-p 'ask)

(defun nuke-trailing-whitespace ()
  "Nuke all trailing whitespace in the buffer.
Whitespace in this case is just spaces or tabs.
This is a useful function to put on write-file-hooks.

If the variable `nuke-trailing-whitespace-p' is `nil', this function is
disabled.  If `t', unreservedly strip trailing whitespace.
If not `nil' and not `t', query for each instance."
  (interactive)
  (and nuke-trailing-whitespace-p
       (save-match-data
         (save-excursion
           (save-restriction
             (widen)
             (goto-char (point-min))
             (cond ((eq nuke-trailing-whitespace-p t)
                    (while (re-search-forward "[ \t]+$" (point-max) t)
                      (delete-region (match-beginning 0) (match-end 0))))
                   (t
                    (query-replace-regexp "[ \t]+$" "")))))))
  ;; always return nil, in case this is on write-file-hooks.
  nil)

(defun untabify-buffer()
  (interactive)
  "untabifies the current buffer
    has to always return nil, if added
    to write-file-hooks"
  (save-excursion
    (goto-char (point-min))
    (while (re-search-forward "[ \t]+$" nil t)
      (delete-region (match-beginning 0) (match-end 0)))
    (goto-char (point-min))
    (if (search-forward "\t" nil t)
        (untabify (1- (point)) (point-max))))
  nil)

(defun do-on-write-file()
  (untabify-buffer)
  (setq nuke-trailing-whitespace-p t)
  (nuke-trailing-whitespace))

(add-hook 'java-mode-hook
            '(lambda ()
               (make-local-variable 'write-contents-hooks)
               (add-hook 'write-contents-hooks 'do-on-write-file)))

(setq auto-mode-alist
      (cons '("\\.py$" . python-mode) auto-mode-alist))
(setq interpreter-mode-alist
      (cons '("python" . python-mode)
            interpreter-mode-alist))

(autoload 'python-mode "python-mode" "Python editing mode." t)

(setq archive-zip-use-pkzip nil)
(setq archive-zip-expunge     '("zip" "-d" "-q")
   archive-zip-extract     '("unzip" "-qq" "-c")
   archive-zip-update      '("zip" "-q")
   archive-zip-update-case '("zip" "-q" "-k"))

(iswitchb-mode)

;; use bash as the default shell
(setq exec-path (cons "C:/cygwin/bin" exec-path))
(setq shell-file-name "bash")
(setenv "SHELL" shell-file-name)
(setenv "PATH" (concat (getenv "PATH") ";C:\\cygwin\\bin"))
(setq explicit-shell-file-name shell-file-name)
(setq explicit-shell-args '("--login" "-i"))
(setq shell-command-switch "-ic")
(setq w32-quote-process-args t)
(defun bash ()
  (interactive)
  (let ((binary-process-input t)
        (binary-process-output nil))
    (shell)))

(setq process-coding-system-alist (cons '("bash" . (raw-text-dos . raw-text-unix))
                    process-coding-system-alist))

;(autoload 'javascript-mode "javascript-mode" "JavaScript mode" t)
;(setq auto-mode-alist (append '(("\\.js$" . javascript-mode))
;                              auto-mode-alist))

;; make #! scripts executable after saving them
(add-hook 'after-save-hook 'executable-make-buffer-file-executable-if-script-p)

;(require 'gnuserv)
;(gnuserv-start)
(server-start)

;; Load CEDET
;(load-file "~/.emacs.d/cedet-1.0pre3/common/cedet.el")

;; Enabling various SEMANTIC minor modes.  See semantic/INSTALL for more ideas.
;; Select one of the following
;(semantic-load-enable-code-helpers)
;; (semantic-load-enable-guady-code-helpers)
;; (semantic-load-enable-excessive-code-helpers)

;; Enable this if you develop in semantic, or develop grammars
;; (semantic-load-enable-semantic-debugging-helpers)

;(setq load-path (cons "~/.emacs.d/ecb-2.32" load-path))
;(require 'ecb-autoloads)

(defun try-complete-abbrev (old)
  (if (expand-abbrev) t nil))

(setq hippie-expand-try-functions-list
      '(try-complete-abbrev
        try-complete-file-name
        try-expand-dabbrev))

(defun indent-or-expand (arg)
  "Either indent according to mode, or expand the word preceding point."
  (interactive "*P")
  (if (and
       (or (bobp) (= ?w (char-syntax (char-before))))
       (or (eobp) (not (= ?w (char-syntax (char-after))))))
      (dabbrev-expand arg)
    (indent-according-to-mode)))

(defun my-tab-fix ()
  (local-set-key [tab] 'indent-or-expand))

(add-hook 'c-mode-hook          'my-tab-fix)
(add-hook 'sh-mode-hook         'my-tab-fix)
(add-hook 'emacs-lisp-mode-hook 'my-tab-fix)
(add-hook 'ruby-mode-hook       'my-tab-fix)


(setq load-path (cons "~/.emacs.d/emacs-rails" load-path))
(require 'rails)

(setq load-path (cons "~/.emacs.d/rinari" load-path))
(setq load-path (cons "~/.emacs.d/rinari/rhtml" load-path))
(require 'rinari)

(defun my-ruby-mode-hook ()
  (ruby-electric-mode))
(add-hook 'ruby-mode-hook 'my-ruby-mode-hook)


;(require 'speedbar)

;; (defconst my-speedbar-buffer-name "SPEEDBAR")
;; ; (defconst my-speedbar-buffer-name " SPEEDBAR") ; try this if you get "Wrong type argument: stringp, nil"

;; (defun my-speedbar-no-separate-frame ()
;;   (interactive)
;;   (when (not (buffer-live-p speedbar-buffer))
;;     (setq speedbar-buffer (get-buffer-create my-speedbar-buffer-name)
;;           speedbar-frame (selected-frame)
;;           dframe-attached-frame (selected-frame)
;;           speedbar-select-frame-method 'attached
;;           speedbar-verbosity-level 0
;;           speedbar-last-selected-file nil)
;;     (set-buffer speedbar-buffer)
;;     (speedbar-mode)
;;     (speedbar-reconfigure-keymaps)
;;     (speedbar-update-contents)
;;     (speedbar-set-timer 1)
;;     (make-local-hook 'kill-buffer-hook)
;;     (add-hook 'kill-buffer-hook
;;               (lambda () (when (eq (current-buffer) speedbar-buffer)
;;                            (setq speedbar-frame nil
;;                                  dframe-attached-frame nil
;;                                  speedbar-buffer nil)
;;                            (speedbar-set-timer nil)))))
;;   (set-window-buffer (selected-window)
;;                      (get-buffer my-speedbar-buffer-name)))


; icicles - keep this near the end
;(setq load-path (cons "~/.emacs.d/icicles" load-path))
;(require 'icicles) ; Load this library.
;(icicle-mode 1)    ; Turn on Icicle mode.

(eval-after-load
       "filecache"
       '(progn
        (message "Loading file cache...")
        ;(file-cache-add-directory-list load-path)
        ;(file-cache-add-directory "~/")
        ;(file-cache-add-file-list (list "~/foo/bar" "~/baz/bar"))
       ))
(require 'filecache)

(defun file-cache-iswitchb-file ()
  "Using iswitchb, interactively open file from file cache'.
First select a file, matched using iswitchb against the contents
in `file-cache-alist'. If the file exist in more than one
directory, select directory. Lastly the file is opened."
  (interactive)
  (let* ((file (file-cache-iswitchb-read "File: "
                                   (mapcar
                                    (lambda (x)
                                      (car x))
                                    file-cache-alist)))
         (record (assoc file file-cache-alist)))
    (find-file
     (concat
      (if (= (length record) 2)
          (car (cdr record))
        (file-cache-iswitchb-read
         (format "Find %s in dir: " file) (cdr record))) file))))

(defun file-cache-iswitchb-read (prompt choices)
  (let ((iswitchb-make-buflist-hook
     (lambda ()
       (setq iswitchb-temp-buflist choices))))
    (iswitchb-read-buffer prompt)))

(global-set-key "\C-cf" 'file-cache-iswitchb-file)
