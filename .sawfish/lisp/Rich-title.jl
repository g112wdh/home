;; -*- lisp -*-

;; rich-title -- Show clock, mail arrival, etc. on the title bar.
;; $Id: rich-title.jl,v 1.16 2006/07/02 10:42:59 hira Exp $	

;; Copyright (c) 2001, 2002, 2003, 2006
;; by HIRAOKA Kazuyuki <khi@users.sourceforge.jp>
;;
;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 1, or (at your option)
;; any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; The GNU General Public License is available by anonymouse ftp from
;; prep.ai.mit.edu in pub/gnu/COPYING.  Alternately, you can write to
;; the Free Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139,
;; USA.

;;;=============================================================
;;; INSTALL
;;;=============================================================

;; (0) Check the latest version at
;;       http://www.me.ics.saitama-u.ac.jp/~hira/rich-title/
;; (1) Put this file on your load-path.
;;     In order to confirm your load-path, type 'sawfish-client -' 
;;     on a console and then type 'load-path'.
;; (2) Write
;;       (load "rich-title")
;;     in your ~/.sawfishrc
;; (3) Restart sawfish.

;; [Note]
;; If an error occures, write
;;   (require 'rep.io.timers)
;; before (2).

;; [Bug]
;; - Does not work for some frame styles.
;;     (OK) absolute-e, Aqua-Graphite, brushed-metal, CleanVine, gradient, gtk, mono, simple, smaker, winXP
;;     (NG) Crux, MacOS, microGUI, twm-traditional

;;;=============================================================
;;; CUSTOMIZE
;;;=============================================================

;;; --------- basic -----------------------

;; Simply change these variables for basic customize.
;; e.g. put the below in ~/.sawfishrc.
;;   (setq rttl-title-interval 10)

;; update interval (seconds):
(defvar rttl-title-interval 60)

;; By default, the title is updated when the focus is changed.
;; If you have troubles on this behavior, put the below in ~/.sawfishrc
;; *before* loading this file.
;;   (setq rttl-title-interval 1)    ;; update every second
;;   (setq rttl-update-on-focus nil) ;; not update on focus change
(defvar rttl-update-on-focus t)

;; shell
(defvar rttl-shell-default-wait-sec 0)  ;; not work??
(defvar rttl-shell-default-wait-millisec 1000)  ;; not work??
(defvar rttl-shell-sh (list "/bin/sh" "-c"))

;;; --------- format -----------------------

;; Write 'rttl-set-format' in your ~/.sawfishrc, like the below.
;; You can put any strings and 'items' in it.
;; 
;; (load "rich-title")
;; (setq rttl-title-interval 1) ;; update every second
;; (rttl-set-format
;;  ;; window name
;;  (rttl-name-item)
;;  "   "
;;  ;; date & time. As for format string, see 'man strftime'.
;;  (rttl-time-item "%m/%d(%a)[%I:%M:%S]")
;;  " "
;;  ;; check /var/spool/mail/xxxx and show "mail!" or "mail-" accordingly
;;  (rttl-biff-item "/var/spool/mail/xxxx" "mail!" "mail-")
;;  " "
;;  ;; twirling baton :-)
;;  (rttl-animation-item '("|" "/" "-" "\\"))
;;  " {"
;;  ;; invoke a shell command at every 1200 seconds
;;  (rttl-timer (rttl-shell-item "df -h | tail +2 | tr -s ' ' | cut -d' ' -f4 | tr '\n' ' '")
;; 	     1200)
;;  "} >"
;;  ;; run a shell command on background and watch its output.
;;  ;; keep the previous output if no new output is obtained.
;;  (rttl-hold (rttl-background-shell-item "tail -f /var/log/messages"))
;;  )

;;; --------- What is 'item'? -----------------------

;; 'Item' is simply a function which receives no input and returns a string.
;; Each 'rttl-xxxx-item' in this file returns an item.
;; See 'ITEM' section below to check available rttl-xxxx-item.
;; 
;; There are several (higher-order) functions which returns a modified item
;; from the original item.
;; 'rttl-timer' and 'rttl-hold' are typical modifiers.
;; See 'ITEM MODIFIER' section below to check available modifiers.

;;;=============================================================
;;; CHANGE LOG
;;;=============================================================

;; [2006-07-02] email address is updated.
;; [2003-05-02] v0.5:
;;     syntax updates for sawfish-1.3,
;;     hook on change of window name (e.g. picture viewer)
;;     -- thanks to michael(@diaspora.gen.nz)
;; [2003-05-02] v0.4.4:
;;     new modifiers (rotate, only-new, only-new*, newest, form, if)
;;     debug (rttl-background-shell-item)
;; [2001-12-21] v0.4.3: debug (comments: (load '...') ==> (load "..."))
;; [2001-12-20] v0.4.2: debug (rttl-background-shell-item)
;; [2001-12-19] v0.4: refined. not compatible with previous version.
;; [2001-12-18] v0.3.1: new item (uptime)
;; [2001-12-18] v0.3: new items (df, tail), debug (chomp)
;; [2001-12-17] v0.2: new items (biff, shell)
;; [2001-12-16] v0.1: Clean up my old dtitle.jl.

;;;=============================================================
;;; UTILITIES
;;;=============================================================

(defun rttl-read (file-name)
  (let* ((f (open-file file-name 'read))
	 (s (read-line f)))
    (close-file f)
    s))
(defun rttl-grep-stream (r s)
  (let ((line (read-line s)))
    (cond ((null line) nil)
	  ((string-match r line) t)
	  (t (rttl-grep-stream r s)))))
(defun rttl-grep (r f)
  (let* ((s (open-file f 'read)))
    (prog1
	(rttl-grep-stream r s)
      (close-file s))))

(defun rttl-string-match-ignorecase (regexp str)
  (string-match regexp str nil t))
(defun rttl-matched-substring (str n)
  (substring str (match-start n) (match-end n)))

(defun rttl-current-second ()
  (let ((c (current-time)))
    (+ (* (car c) 24 60) (cdr c))))

(defun rttl-round (x) (inexact->exact (round x)))
(defun rttl-floor (x) (inexact->exact (floor x)))
(defun rttl-string->number (s) (read-from-string s))
(defun rttl-number->string (x) (format nil "%s" x))

(defun rttl-string-if (pred str) (if pred str ""))

(defun rttl-string-remove-last (str)
  (substring str 0 (1- (length str))))
(defun rttl-chomp (str)
  (if (equal str "")
      str
    (let ((last-char (elt str (1- (length str)))))
      (if (= last-char ?\n)
	  (rttl-string-remove-last str)
	str))))

;; I dare to use *symbol* instead of *value* to enable easy change
;; of the interval.
(defun rttl-make-timer (f interval-symbol)
  (make-timer (lambda (m) (f) (set-timer m (eval interval-symbol))) 1))

(defun rttl-shell (command-string #!rest args)
  ((apply rttl-shell-item `(,command-string ,@args))))

;;;=============================================================
;;; ITEM
;;;=============================================================

;; ------ expected to work on every platform -------

(defun rttl-name-item ()
  (lambda () (window-name (input-focus))))

(defun rttl-time-item (#!optional time-format)
  (let ((time-form (or time-format "%m/%d(%a)[%I:%M]")))
    (lambda () (current-time-string nil time-form))))

(defun rttl-biff-item (watched-file #!optional on-string off-string)
  (let ((on-str (or on-string "mail!"))
	(off-str (or off-string "mail-")))
    (lambda ()
      (if (and (file-exists-p watched-file)
	       (> (file-size watched-file) 0))
	  on-str
	off-str))))

(defun rttl-animation-item (str-list)
  (apply rttl-rotate (mapcar rttl-make-item-function str-list)))

; (defun rttl-animation-item (str-list)
;   (apply rttl-rotate str-list))

(defun rttl-background-shell-item (command-string)
  (let* ((s (make-string-output-stream))
	 (p (make-process s)))
    (letrec ((self
	      (lambda (#!rest msg)
		(let ((com (cond ((null msg) nil)
				 (t (car msg)))))
		  (cond ((null com) (self 'output))
			((eq com 'output) (rttl-chomp
					   (get-output-stream-string s)))
			((eq com 'set-command) (setq command-string
						     (cadr msg)))
			((eq com 'process) p) ;; for debug
			((eq com 'start) (if (not (process-running-p p))
					     (apply start-process
						    `(,p
						      ,@rttl-shell-sh
						      ,command-string))))
 			((eq com 'kill) (if (process-running-p p)
 					    (kill-process p)))
			((eq com 'restart) (progn
					     (self 'kill)
					     (sleep-for 1) ;; work???
					     (self 'start))))))))
	    (self 'start)
	    self)))

(defun rttl-shell-item (command-string #!optional wait-sec wait-millisec)
  (lambda ()
    (let ((s (or wait-sec rttl-shell-default-wait-sec))
	  (ms (or wait-millisec rttl-shell-default-wait-millisec))
	  (sh (rttl-background-shell-item command-string)))
	(accept-process-output s ms) ;; not work?? [2002/01/03]
	(sh 'kill)
	(sh))))

; (defun rttl-timer-background-shell-item (command-string interval-seconds)
;   ;; restart periodically
;   (let ((sh (lambda arg "")) ;; dummy initial object
; 	(tm (rttl-timer (lambda ()
; 			  (sh 'kill)
; 			  (setq sh (rttl-background-shell-item command-string)))
; 			interval-seconds)))
;     (lambda () (sh))))

; (defun rttl-shell-item (command-string #!rest args)
;   (let ((input-string "")
; 	(wait-sec nil)
; 	(wait-millisec nil))
;     (cond
;      ;; obsolete style
;      ((numberp (car args)) (setq wait-sec (car args)
; 				 wait-millisec (cadr args)))
;      ;; new style
;      ((stringp (car args)) (setq input-string (car args)
; 				 wait-sec (cadr args)
; 				 wait-millisec (caddr args))))
;     (lambda ()
;       (let ((s (or wait-sec rttl-shell-default-wait-sec))
; 	    (ms (or wait-millisec rttl-shell-default-wait-millisec))
; 	    (sh (rttl-background-shell-item command-string)))
; 	(sh 'write input-string)
; 	(accept-process-output s ms)
; 	(sh 'kill)
; 	(sh)))))

;; ------ for Linux 2.2.x -------

;; load average
(defun rttl-loadavg-item ()
  (lambda () (substring (rttl-read "/proc/loadavg") 0 4)))

;; uptime (days)
(defun rttl-uptime-item ()
  (lambda ()
    (let* ((raw (rttl-read "/proc/uptime"))
	   (sec-str (progn
		      (string-match "^[0-9.]*" raw)
		      (substring raw (match-start) (match-end))))
	   (sec (rttl-string->number sec-str)))
      (rttl-number->string (rttl-floor (/ sec 60 60 24))))))

;; battery information
(defun rttl-apm-item (#!optional ac-format battery-format)
  (let ((ac-form (or ac-format "%s%%"))
	(battery-form (or battery-format "v%s%%(%smin)")))
    (lambda ()
      (let* ((s (rttl-read "/proc/apm"))
	     (dummy (string-match "^(\\S+) (\\S+) (\\S+) (\\S+) (\\S+) (\\S+) (\\S+)% (\\S+) (\\S+)\n"
				  s))
	     (driver-version   (rttl-matched-substring s 1))
	     (apm-bios-version (rttl-matched-substring s 2))
	     (apm-bios-flags   (rttl-matched-substring s 3))
	     (ac-line-status   (rttl-matched-substring s 4))
	     (battery-status   (rttl-matched-substring s 5))
	     (battery-flag     (rttl-matched-substring s 6))
	     (percentage       (rttl-string->number (rttl-matched-substring s 7)))
	     (time-units       (rttl-string->number (rttl-matched-substring s 8)))
	     (units            (rttl-matched-substring s 9)))
	(cond ((string= ac-line-status "0x00")
	       (format nil battery-form percentage
		       (cond ((rttl-string-match-ignorecase "^m" units)
			      time-units)
			     ((rttl-string-match-ignorecase "^h" units)
			      (* time-units 60))
			     ((rttl-string-match-ignorecase "^s" units)
			      (rttl-round (/ time-units 60)))
			     (t (- time-units)))))
	      ;;((string= battery-status "0x03") "not implemented")
	      (t
	       (format nil ac-form percentage)))))))

;;;=============================================================
;;; ITEM MODIFIER
;;;=============================================================

;; If (item) is empty, keep the previous value.
(defun rttl-hold (item #!optional post-processor)
  (let ((prev "")
	(ppr (or post-processor (lambda (x) x))))
    (lambda ()
      (let ((r (item)))
	(cond ((= (length r) 0) prev)
	      (t (setq prev (ppr r)) prev))))))

;; (rttl-pipe i f1 f2 f3) ==> (lambda () (f3 (f2 (f1 (i)))))
(defun rttl-pipe (item #!rest funcs)
  (cond ((null funcs) item)
	(t (apply rttl-pipe
		  `(,(lambda () ((car funcs) (item)))
		    ,@(cdr funcs))))))

;; update periodically
(defun rttl-timer (item interval-seconds)
  (let ((prev ""))
    (make-timer (lambda (tm)
		  (setq prev (item))
		  (set-timer tm interval-seconds))
		1)
    (lambda () prev)))

;; (rttl-rotate i1 i2 i3) ==> show (i1), (i2), (i3) cyclically
(defun rttl-rotate (#!rest item-list)
  (let ((n -1)
	(len (length item-list)))
    (lambda ()
      (setq n (mod (1+ n) len))
      (let ((item (nth n item-list)))
	(item)))))

;; Return "" if (item) is unchanged.
(defun rttl-only-new (item)
  (let ((prev ""))
    (lambda ()
      (let ((now (item)))
	(cond ((string= now prev) "")
	      (t (setq prev now) now))))))

;; Same as rttl-only-new, except that empty string is considered as unchanged.
(defun rttl-only-new* (item)
  (rttl-only-new (rttl-hold item)))

;; (rttl-newest i1 i2 i3) ==> Same as (rttl-rotate i1 i2 i3), except that
;; unchanged items are skipped.
(defun rttl-newest (#!rest item-list)
  (rttl-hold (apply rttl-rotate (mapcar (lambda (i) (rttl-only-new* i))
					item-list))))

;; Apply format string if (item) is not empty.
;; See 'format' in documents on librep.
(defun rttl-form (format-str item)
  (lambda ()
    (let ((r (item)))
      (if (> (length r) 0)
	  (format nil format-str r)
	r))))

;; (then-item) or (else-item) according to (pred)
(defun rttl-if (pred then-item #!optional else-item)
  (let ((el (or else-item (rttl-make-item-function ""))))
    (lambda ()
      (if (pred)
	  (then-item)
	(el)))))

;;;=============================================================
;;; MAIN
;;;=============================================================

;;; ----------- format ------------------

(defvar rttl-default-format
  (list
   (rttl-name-item)
   "   "
;   (rttl-time-item "%m/%d(%a)[%I:%M]")
   (rttl-time-item "%m/%d[%I:%M]")
   ))

(defun rttl-make-item-function (item)
  (cond ((stringp item) (lambda () item))
	((functionp item) item)
	((null item) (lambda () ""))))

(defvar rttl-title-generators nil)
(defun rttl-set-format (#!rest items)
  (rttl-set-format-original
   (if (and (= (length items) 1) (listp (car items)))
       (car items) ;; obsolete style
     items)))
(defun rttl-set-format-original (form)
  (setq rttl-title-generators
	(mapcar (lambda (item) (rttl-make-item-function item))
		form)))
(apply rttl-set-format rttl-default-format)

;;; ----------- main ------------------

(defun rttl-title ()
  (apply concat (mapcar (lambda (item-function) (item-function))
			rttl-title-generators)))

(defun rttl-set-title-frame (frame-part text)
  (if (eq (cdr (assoc 'class frame-part)) 'title)
      (mapcar (lambda (p)
		(if (eq (car p) 'text)
		    (cons 'text text)
		  p))
	      frame-part)
    frame-part))

(defun rttl-set-title (w title)
  (let ((f (window-frame w)))
    (when f
      (set-window-frame w
			(mapcar (lambda (z) (rttl-set-title-frame z title)) f)))))

(defun rttl-reset-title (w)
  (rttl-set-title w (window-name w)))

(defun rttl-update-title ()
  (let ((w (input-focus)))
    (when w
      (rttl-set-title w (rttl-title)))))

(defvar rttl-title-timer (rttl-make-timer rttl-update-title 'rttl-title-interval))

(when rttl-update-on-focus
  (defvar focus-in-hook nil)
  (defvar focus-out-hook nil)
  (add-hook 'focus-in-hook rttl-update-title)
  (add-hook 'property-notify-hook
    (lambda (w at type)
      (if (and (eq w (input-focus)) (eq at 'WM_NAME))
	  (rttl-update-title))))
  (add-hook 'focus-out-hook rttl-reset-title))
