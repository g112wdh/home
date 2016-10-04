;(load-file  "~/.emacs.d/init.el" )
;; ;;;;set point not mouse yank
(setq mouse-yank-at-point t)
(setq-default x-select-enable-primary t)
;; ;;;new jde small
;; (add-to-list 'load-path (expand-file-name "/usr/local/share/emacs/22.3/site-lisp/cedet/semantic"))
;; (add-to-list 'load-path (expand-file-name "/usr/local/share/emacs/22.3/site-lisp/cedet/speedbar"))
;; (add-to-list 'load-path (expand-file-name "/usr/local/share/emacs/22.3/site-lisp/cedet/eieio"))
;; (add-to-list 'load-path (expand-file-name "/usr/local/share/emacs/22.3/site-lisp/cedet/jde"))
;; (add-to-list 'load-path (expand-file-name "/usr/local/share/emacs/22.3/site-lisp/cedet/elib"))
;; (add-to-list 'load-path (expand-file-name "/usr/local/share/maxima/5.19.2/emacs"))
(add-to-list 'load-path (expand-file-name "~/.emacs.d"))
;; (load-file "/usr/local/share/emacs/22.3/site-lisp/mixal-mode.el")
;; (autoload 'mixvm "mixvm" "mixvm/gud interaction" t)
(add-to-list 'load-path  (expand-file-name "~/.emacs.d/go-mode"))
(require 'go-mode-autoloads)
(add-to-list 'load-path  (expand-file-name "~/.emacs.d/php-mode"))
(require 'php-mode)
;; ;;;
;(add-to-list 'load-path "~/.emacs.d/helm" )
;(require 'helm-config)
;(global-set-key (kbd "M-x") 'helm-M-x)

;; ;;;
;; ;;;;fringe ;;;;;;;;;;
;; (fringe-mode 0)
;; ;;;;;;;;end fringe ;;;;;;
;; ;;;font;
;; (set-keyboard-coding-system 'chinese-iso-8bit)
;; ;;;;;end font

(load-file "~/.emacs.d/xcscope.el")
(require 'xcscope)

;; ;;;run perl;

(defun runperl()
  "runing perl"
  (interactive)
  ;(save-buffer)
  (let ((filename buffer-file-name)
 (cmd "")
 (oldbuf (current-buffer))
 (end (point-max)))
    (if filename
 (save-buffer)
      (save-excursion
 (setq filename (concat (getenv "tmp") "/temp.pl"))
 (set-buffer (create-file-buffer filename))
 (insert-buffer-substring oldbuf 1 end)
 (write-file filename)
 (kill-buffer (current-buffer))))
    (setq cmd (concat "perl -w " filename))
    (message "%s  ..." cmd)
    (shell-command cmd)))
(global-set-key "\M-o" 'runperl) ;bind-key alt+o:runperl

;; ;;;end runperl;
;; ;;;run metapost
;; ;(load "pi-meta")
;; ;(add-hook 'metapost-mode-hook
;; ;         '(lambda nil
;; ;           (define-key meta-mode-map "\t" 'meta-complete-symbol)))

;; ;; (Defun Mpost-Compile()
;; ;;   "Compile the current file"
;; ;;   (interactive)
;; ;;   (save-buffer)
;; ;;   (compile (concat "gv" (file-name-nondirectory buffer-file-name))))
;; ;; (add-hook 'meta-mode-hook
;; ;;           '(lambda nil
;; ;;             (gloabal-set-key  "\C-c\C-p" 'mpost-compile)))






;; ;(require 'metapreview)
;; (load-file "/usr/local/share/emacs/22.3/site-lisp/metapreview.el")
;; (add-hook 'meta-mode-load-hook
;;  '(lambda () (define-key meta-mode-map
;;    (kbd "\C-c C-c") 'meta-preview-fig)))


;; ;;end run metapost
;; ;;;MIT-scheme 
;; (require 'scheme)
;; (load-file "/usr/local/share/emacs/22.3/site-lisp/xscheme.el")
;; ;;;;end of MIT-scheme

;; ;;;;w3m;;
;; (require 'w3m-load)
;; ;;;;;end of w3m
;; ;;;;;;wiki;;;;
;; (load-file "/usr/local/share/emacs/22.3/site-lisp/emacs-wiki.el")
;; (require 'emacs-wiki)
;; ;;;;end of wiki


;; ;(setq semantic-load-turn-useful-things-on t)
;; ;; Load CEDET
;; ;; (require 'cedet)

;; ;; (setq defer-loading-jde t)

;; ;; (if defer-loading-jde t
;; ;;   (progn
;; ;;     (autoload `jde-mode "jde" "JDE mode." t)
;; ;;     (setq auto-mode-alist
;; ;; 	  (append
;; ;; 	   `(("\\.java\\'" .jde-mode))
;; ;; 	   auto-mode-alist)))
;; ;; (require `jde))
;; ;; ;(require `jde)



;; ;(require 'maxima)
;; (autoload 'maxima-mode "maxima" "Maxima mode" t)
;; (autoload 'maxima "maxima" "Maxima interaction" t)
;; (setq auto-mode-alist (cons '("\\.max" . maxima-mode) auto-mode-alist))




;;  (autoload 'octave-mode "octave-mod" nil t)
;;           (setq auto-mode-alist
;;                 (cons '("\\.m$" . octave-mode) auto-mode-alist))

;;  (autoload 'run-octave "octave-inf" nil t)

;; ;;python
;; (autoload 'python-mode "python-mode" "Mode for editing Python source files")
;; (add-to-list 'auto-mode-alist '("\\.py" . python-mode))
;; ;;perl


;; ;(require 'yasnippet-bundle)
;; ;(setq yas/root-directory "~/.emacs.d/snippets")
;; ;(yas/load-directory yas/root-directory)







;; ;;;;;semantic
;; ;; (semantic-load-enable-minimum-features)
;; ;(semantic-load-enable-code-helpers)
;; ;; (semantic-load-enable-guady-code-helpers)
;; ;; (semantic-load-enable-excessive-code-helpers)
;; ;(semantic-load-enable-semantic-debugging-helpers)
;; ;(define-key global-map (kbd "M-n") 'semantic-ia-complete-symbol-menu)





;; ;;;;w3m
;; ;(autoload 'w3m "w3m" "Interface for w3m on Emacs." t)
;; ;(require 'mime-w3m)
;; ;(require 'mew-w3m)
;; ;(setq mew-prog-html '(mew-mime-text/html-w3m nil nil))
;; ;(require 'w3m)
;; ;(require 'octet)
;; ;(octet-mime-setup)
;; ;;;;end w3m;;;



;; ;(setq column-number-mode t)
(show-paren-mode t)
;; (setq show-paren-style 'parentheses)

;; (setq inhibit-startup-messgae t)
;; (setq kill-ring-max 200)
;; (setq default-fill-column 60)
;; (setq default-major-mode 'text-mode)


;; (auto-image-file-mode)
;; ;(globalhl-line-mode)

;; ;;;;at home;;;;
;; (setq display-time-24hr-format t)
;; (display-time-mode)
;; ;;;;;;;;;;;;;;;;;;

;; (defun wy-go-to-char (n char)
;;   (interactive "p\ncGo to char: ")
;;   (search-forward (string char) nil nil n)
;;   (while (char-equal (read-char)
;; 		     char)
;;     (search-forward (string char) nil nil n))
;;   (setq unread-command-events (list last-input-event)))
;; (defun wdh-go-to-char (n char)
;;   (interactive "p\ncGo to char: ")
;;   (search-backward (string char) nil nil n)
;;   (while (char-equal (read-char)
;; 		     char)
;;     (search-backward (string char) nil nil n))
;;   (setq unread-command-events (list last-input-event)))

;; (define-key global-map (kbd "C-c a") 'wy-go-to-char)
;; (global-set-key "`" 'wy-go-to-char)
;; (global-set-key "\M-`" 'wdh-go-to-char)
;; ;;;;;;;;;;;;;;;;;;;;;;
;; (global-set-key "\M-p" "\C-p")
;; (global-set-key "\M-n" "\C-n")
;; (global-set-key [f9] 'compile)
;; (global-set-key "\M-." 'dabbrev-expand)
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; ;;line        
(setq column-number-mode t) 

(global-set-key (kbd "M-g") 'goto-line)
;; ;;(global-set-key (kbd "`") 'next-multiframe-window)
;; ;;(global-set-key [f1] 'switch-to-buffer)
;; ;(global-set-key [f1] 'delete-other-windows)




;; ;; sawfish mode 
;; ;; load the first sawfish.l or sawfish.elc file found in the load-path
;; ;(load-file "~/emacs.d/sawfish.el")
;; (load "sawfish")
;; ;; this tells emacs to automatically activate the sawfish-mode whenever open
;; ;; file with "sawfishrc" or "jl" (John Lisp) suffix
;; (add-to-list 'auto-mode-alist '(".*sawfishrc\\'" . sawfish-mode ))
;; (add-to-list 'auto-mode-alist '(".*\\.jl\\'" . sawfish-mode ))
;; ;; if you're using ECB, tells to use the compilation buffer to show long
;; ;; sawfish messages  
;; (add-to-list 'ecb-compilation-buffer-names '("*sawfish*"))











;; ;;;;;;;;;;;;;;;;;;;;;;;AUCTEX;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; (load "auctex.el" nil t t)
;; (load "sawfish.el" nil t t)

;; (setq TeX-auto-save t)
;; (setq TeX-parse-self t)




;; (load "preview-latex.el" nil t t)

;; ;;;;;;;;;;END;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;






;; ;;;;;;;;;;;;;;;;scorll  no ;;;;;;;;;;
;; ;(set-scroll-bar-mode nil)
;; ;;;;;;;;;;;;;;;;end;;;;;;;;;;;;;;;
;; (load "clisp-coding")
;; (load "clisp-indent")
;; (load "clisp-ffi")
;; (load "clhs"  )
;; (require 'cl)










;; (if first-time
;; (setq auto-mode-alist
;; (append '(("\\.cl$" . common-lisp-mode)
;; ("\\.scm$" . scheme-mode)
;; ) auto-mode-alist)))









;; ;;;;;go-to-char

;; ;; (defun wy-go-to-char (n char)
;; ;;   (interactive "p\ncGo to char: ")
;; ;;   (search-forward (string char) nil nil n)
;; ;;   (while (char-equal (read-char)
;; ;; 		     char)
;; ;;     (search-forward (string char) nil nil n))
;; ;;   (setq unread-command-events (list last-input-event)))

;; ;; (define-key global-map (kbd "C-c a") 'wy-go-to-char)
;; ;; (global-set-key "`" 'wy-go-to-char)





;; ;;;;;recursive-minibuffers
;; (setq enable-recursive-minibuffers t)


;; ;(put 'scroll-left 'disabled nil)

;;ace-jump-mode

(autoload
  'ace-jump-mode
  "ace-jump-mode"
  "Emacs quick move minor mode"
  t)
;; you can select the key you prefer to
(define-key global-map (kbd "C-c SPC") 'ace-jump-mode)

;;end ace-jump-mode

;; sawfish mode settings
;; load the first sawfish.l or sawfish.elc file found in the load-path
(load-file "~/.emacs.d/sawfish.el")
(load "sawfish")
;; this tells emacs to automatically activate the sawfish-mode whenever open
;; file with "sawfishrc" or "jl" (John Lisp) suffix
(add-to-list 'auto-mode-alist '(".*sawfishrc\\'" . sawfish-mode ))
(add-to-list 'auto-mode-alist '(".*\\.jl\\'" . sawfish-mode ))
;; if you're using ECB, tells to use the compilation buffer to show long
;; sawfish messages  
;(add-to-list 'ecb-compilation-buffer-names '("*sawfish*"))



(add-to-list 'load-path (expand-file-name "/opt/emacs_plugins/nginx/"))    
(require 'nginx-mode)  


;;;markdown
(autoload 'markdown-mode "markdown-mode"
	"Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.markdown\\'". markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'". markdown-mode))

;;;end markdown




;;;; org ;;;

;(add-to-list 'load-path "~/.emacs.d/remember")
(require 'remember)
(require 'org-capture)
(require 'org-install)
;(require 'org-publish)
(global-set-key "\C-cc" 'remember)
;(org-capture-insinuate) 
(setq org-directory "~/org")
;; (setq org-capture-templates '(
;; ("t" "Task"  "** TODO %? %t\n %i\n %a" "~/org/inbox.org" "Task")
;; ("b" "BOOK"  "** %? %t\n %i\n %a" "~/org/inbox.org" "Book") 
;; ("j" "Calendar" "** %? %t\n %i\n %a" "~/org/inbox.org" "Calender")

;; ("p" "Project"  "** %? %t\n %i\n %a" "~/org/inbox.org" "Project")))

(setq org-capture-templates
      '(("t" "TODO" entry (file+headline "~/org/mygtd.org")
	 "** TODO %i %? %t\n %i\n %a" )
        ("j" "Journal" entry (file+datetree "~/org/mygtd.org")
	 "* %?\nEntered on %U\n  %i\n  %a")))
(setq org-default-notes-file (concat org-directory "/mygtd.org"))
(setq org-todo-keywords
      (list "TODO(t)" "|" "WAITING(w)" "CANCELED(c)" "DONE(d)"))


(custom-set-variables
'(org-refile-targets 
  (quote 
   (("inbox.org" :level . 1)("canceled.org" :level . 1) ("finished.org":level . 1))
   )))

(global-set-key "\C-cc" 'remember )
(defun gtd()
  (interactive)
  (find-file "~/org/mygtd.org"))

(global-set-key "\C-cz" 'gtd)

(define-key global-map "\C-ca" 'org-agenda-list)
;(define-key global-map "\C-ct" 'org-todo-list)
(define-key global-map "\C-cm" 'org-tags-view)
;; (setq org-agenda-files
;;       (list "~/org/inbox.org"
;; 	    "~/org/work.org"
;; 	    "~/org/learn.org"
;; 	    "~/org/gtd.org"
;; 	    "~/org/someday.org"))
(setq org-agenda-files
      (list "~/org/mygtd.org"))

(org-agenda-list t)
;(require 'init-utils)
;(require 'init-org)

;;;; end org ;;;


;; (require 'yaml-mode)
;;     (add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))

;; (setq indent-tabs-mode nil)
;; (setq default-tab-width 4)
;; (setq tab-width 4)
		
(setq-default c-basic-offset 4)
		
(setq c-default-style "linux"
      c-basic-offset 4)


(require 'cc-mode)


;; Use cperl-mode instead of the default perl-mode
(defalias 'perl-mode 'cperl-mode)

;; just spaces
(setq-default indent-tabs-mode nil)

;; Use 4 space indents via cperl mode
(custom-set-variables
  '(cperl-close-paren-offset -4)
  '(cperl-continued-statement-offset 4)
  '(cperl-indent-level 4)
  '(cperl-indent-parens-as-block t)
  '(cperl-tab-always-indent t)
)




