;; selection-menu.jl -- a sawfish popup menu to allow users to select
;;                      X selections
;;
;; version 0.3
;;
;; $Id: selection-menu.jl,v 1.7 2005/01/09 22:16:27 mario Exp $
;;
;; Copyright (C) 2004, 2005 Mario Domenech Goulart
;;
;; Author: Mario Domenech Goulart <mario@inf.ufrgs.br>
;;
;; This code is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published
;; by the Free Software Foundation; either version 1, or (at your
;; option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program; if not, write to the Free Software
;; Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
;;
;; Commentary:
;;
;; selection-menu.jl provides a menu to allow users select X
;; selections (primary, secondary and clipboard).  Actions to be
;; applyed to selections can be configured through the
;; `selection-actions' variable.  It was inspired by Stephen Farrell's
;; services.jl.
;;
;; IMPORTANT NOTES: 
;;
;; 1. Swapping selections is done by an external process.  You'll need
;;    the xclip program.  You can find it at
;;    http://people.debian.org/~kims/xclip/
;;
;; 2. If pasting selections doesn't seem to work with xterms, take a
;;    look at this thread from the sawfish mailing list:
;;    http://mail.gnome.org/archives/sawfish-list/2004-February/msg00003.html


(require 'menus)
(require 'selection)

(defvar *selection-last-focused-window* nil
  "Focused window before selection-menu is popped-up.")

(defvar selection-actions
  '(
    ;; ("Mozilla"  "mozilla -remote \'openURL(" ",new-tab)\'" selection-fix-url)
    ;; ("Google"  "mozilla -remote \'openURL(http://www.google.com/search?q=" ",new-tab)\'" selection-clean-url-query-escaping)
    ;; ("Emacsclient"  "emacsclient --no-wait" nil selection-shell-quote-argument)
    ;; ("Manual"   "xterm -e man")
    ;; ("Dictionary"  "xterm -e dict")
    ;; ("Swap primary and secondary" (lambda (#!rest args) (selection-swap "primary" "secondary")))
    ;; ("Swap primary and clipboard" (lambda (#!rest args) (selection-swap "primary" "clipboard")))
    ("Paste selection"  (lambda (selection) (selection-dump selection)))
))

(define (selection-menu)
  (let (
        (prim (x-get-selection 'PRIMARY))
        ;(prim (utf8-substring (x-get-selection 'PRIMARY), 0 ))
	(secd (x-get-selection 'SECONDARY))
	(clip (x-get-selection 'CLIPBOARD)))
    (list 
     (list (concat "sssPrimary: " (selection-fix-entry prim))
	   `(selection-popup-action-menu ,prim))
     (list (concat "Secondary: " (selection-fix-entry secd))
	   `(selection-popup-action-menu ,secd))
     (list (concat "Clipboard: " (selection-fix-entry clip))
	   `(selection-popup-action-menu, clip)))))

(define (selection-popup-action-menu selection)
  (setq *selection-last-focused-window* (input-focus))
  (popup-menu
   (mapcar 
    (lambda (item)
      (let ((title (nth 0 item))
	    (command (nth 1 item))
	    (postargs (nth 2 item))
	    (escape-func (nth 3 item)))
	(list 
	 title
	 (if (not (stringp command))
	     `(,command ,selection)
	   (if escape-func
	       `(system 
		 ,(concat command " " 
			  escape-func selection " " 
			  postargs " &"))
	     `(system 
	       ,(concat command " "  selection " " postargs " &")))))))
    selection-actions)))

(define (selection-popup-menu)
  (interactive)
  (popup-menu (selection-menu)))
    
(define (selection-shell-quote-argument argument)
  "Quote an argument for passing as argument to an inferior
  shell. (based on shell-quote-argument from GNU Emacs subr.el)"
  (if (or (equal argument "") (null argument))
      "''"
    ;; Quote everything except POSIX filename characters.
    ;; This should be safe enough even for really weird shells.
    (let ((result "") (start 0) end)
      (while (string-match "[^-0-9a-zA-Z_./]" argument start)
	(setq end (match-start 0)
	      result (concat result (substring argument start end)
			     "\\" (substring argument end (1+ end)))
	      start (1+ end)))
      (concat result (substring argument start)))))

(define (selection-clean-url-query-escaping str)
  "Do URL escaping appropriate for components of a GET query.  Do
not do this with a full url -- if selection is a complete url
then use selection-fix-url (from Stephen Farrell's service.jl --
services-clean-url-query-escaping)"
  ;; Uses some code by "Sen Nagata" <sen@eccosys.com>, which in turn
  ;; was a port of code by url.el from w3 package by "William
  ;; M. Perry" <wmperry@cs.indiana.edu>
  (mapconcat
   (lambda (char)
     (cond ((eq char 32)
	    "+")
	   ((or (and (>= char 65) (<= char 90)) 
		(and (>= char 97) (<= char 122)))
	    make-string 1 char)
	   ((< char 16)
	    (string-upcase (format nil "%%0%x" char)))
	   (t
	    (string-upcase (format nil "%%%x" char)))))
   str ""))

(define (selection-fix-url url)
  (string-replace " " "%20" url))

(define (selection-get-selection str)
  (cond ((string= str "primary")
	 (x-get-selection 'PRIMARY))
	((string= str "secondary")
	 (x-get-selection 'SECONDARY))
	((string= str "clipboard")
	 (x-get-selection 'CLIPBOARD))))

(define (selection-swap from to)
  "Swap the selections FROM and TO, which can be the strings
`primary', `secondary' and `clipboard' (used by xclip)." 
  (let ((backup (selection-get-selection to)))
    (system (concat "xclip -o -selection " from " | xclip -i -selection " to))
    (system (concat "echo -n " backup " | xclip -i -selection " from))))

(define (selection-type-in text window #!optional ret)
  "Based on type-in from Mark Triggs's selection-push.jl."
  (cond ((string= text "") 
	 (when ret (synthesize-event "Return" window)))
        (t (if (string= (substring text 0 1) "\n")
               (synthesize-event "Return" window)
             (synthesize-event (substring text 0 1) window))
           (selection-type-in (substring text 1) window ret))))

(define (selection-dump text)
  "Send the selected selection to the window focused before the
  selection menu was popped-up. Based on dump-selections from
  Mark Triggs's selection-push.jl."
  (selection-type-in text *selection-last-focused-window*))


(define (selection-fix-entry text)
  "Fix TEXT to be displayed correctly in the menu."
  (if (or (equal text "") (null text))
      ""
    (string-replace "_" "__" text)
    (system (concat "echo -n" text "echo -n wangdahai"))
    ))

(provide 'selection-menu)

(string-replace "a" "A" "aabbCC")
;(shell-command-to-string (concat "echo -n" " AAA" " wangdahai"))




