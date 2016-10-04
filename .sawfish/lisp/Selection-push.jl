;; selection-push.jl -- Store multiple selections for later retrieval
;;
;; Description: Often I'll want to copy a bunch of links/text from a page, and
;; have traditionally resorted to copying and pasting each bit individually.
;; This hack will hopefully streamline things a bit, providing a key to push
;; the current contents of the clipboard onto a list, and another to retrieve
;; the list.
;;
;; Author: Mark Triggs <mst@dishevelled.net>
;;

(require 'sawfish.wm.util.selection)

(defvar *select-list* nil "The currently stored selections")

(defun type-in (str wind #!optional ret)
  (cond ((string= str "") (when ret (synthesize-event "Return" wind)))
        (t (if (string= (substring str 0 1) "\n")
               (synthesize-event "Return" wind)
             (synthesize-event (substring str 0 1) wind))
           (type-in (substring str 1) wind ret))))

(defun push-current-selection ()
  (setq *select-list* (cons (or (x-get-selection 'CLIPBOARD)
                                (x-get-selection 'PRIMARY)) *select-list*)))

(defun dump-selections ()
  "Send the stored selections to the current window"
  (type-in (mapconcat identity (reverse *select-list*) " ") (input-focus)))

;; not at all mnemonic, but easy to reach. I need more meta keys.
;(bind-keys global-keymap (meta+ "z") '(push-current-selection))
(bind-keys global-keymap "Super-k" '(push-current-selection))

                                        ;(bind-keys global-keymap "Super-P" '(dump-selections))
(bind-keys global-keymap "Super-p" '(display-message *select-list*))
;(bind-keys global-keymap (meta+ "BS") '(setq *select-list* nil))

(provide 'selection-push)


*select-list*

(mapc display-message  *select-list* )









(display-message (x-get-selection 'PRIMARY))
