
(provide 'keylogger)
(require 'cl) ;;including the common-lisp library so that can use fold function (which is known as reduce in cl)


;;;;;;;;;;;;GLOBAL NAMES;;;;;;;;;;;;;;;;;;;;;

;;global logFileName

;;(setq BFTM_GLOBAL_FILE_NAME "~/.emacs.d/bftm-logging.lg")
(setq BFTM_GLOBAL_FILE_NAME "~/.emacs.d/citadel_logging_emacs.lg")
;;(setq BFTM_GLOBAL_FILE_NAME "~/Desktop/bftm-logging.lg")


(setq BFTM_KEYLOGGER_VERSION 3)
;version history: version 2 will have buffering and I've got to check to make sure that opening and closing files removes filenames from the logging array.
;version 3 added a before things happen logging as well as logged the length of the after-change function

;;checks filename.  if it doesn't exist, return false.  if it's the log file, return false.  otherwise, return true.
(defun bftm-checkfilename-p ()
  (if buffer-file-name
      (let ((filenamer (abbreviate-file-name buffer-file-name)))
        (if (string-equal BFTM_GLOBAL_FILE_NAME filenamer)
          ;;should return false: don't actually log the keystrokes when open up log file in emacs
          (progn
            (message "Please do not modify this file.  I need it to graduate!  (Contact bmistree@stanford.edu for any questions.)")
            nil)
        ;;should return true: log all actions in the file.
          t))
      ;;should return false: no filename
      nil))



(setq BFTM_EMPTY_FIELD                                         "BFTM_EMPTY_FIELD_BFTM")

;;global start tags
(setq BFTM_GLOBAL_START_TAG_BEGIN                              "<BFTM_START_TAG_BFTM>")
(setq BFTM_GLOBAL_START_TAG_END                               "</BFTM_START_TAG_BFTM>")

;;global end tags
(setq BFTM_GLOBAL_END_TAG_BEGIN                                  "<BFTM_END_TAG_BFTM>")
(setq BFTM_GLOBAL_END_TAG_END                                   "</BFTM_END_TAG_BFTM>")

;;global buffer name tags
(setq BFTM_GLOBAL_BUFFER_NAME_TAG_BEGIN                  "<BFTM_BUFFER_NAME_TAG_BFTM>")
(setq BFTM_GLOBAL_BUFFER_NAME_TAG_END                   "</BFTM_BUFFER_NAME_TAG_BFTM>")

;;global command string tags
(setq BFTM_GLOBAL_COMMAND_STRING_TAG_BEGIN            "<BFTM_COMMAND_STRING_TAG_BFTM>")
(setq BFTM_GLOBAL_COMMAND_STRING_TAG_END             "</BFTM_COMMAND_STRING_TAG_BFTM>")

;;global INSERTED string tags
(setq BFTM_GLOBAL_INSERTED_STRING_TAG_BEGIN          "<BFTM_INSERTED_STRING_TAG_BFTM>")
(setq BFTM_GLOBAL_INSERTED_STRING_TAG_END           "</BFTM_INSERTED_STRING_TAG_BFTM>")

;;global line number tags
(setq BFTM_GLOBAL_LINE_NUMBER_TAG_BEGIN                  "<BFTM_LINE_NUMBER_TAG_BFTM>")
(setq BFTM_GLOBAL_LINE_NUMBER_TAG_END                   "</BFTM_LINE_NUMBER_TAG_BFTM>")

;;global time tags
(setq BFTM_GLOBAL_TIME_TAG_BEGIN                                "<BFTM_TIME_TAG_BFTM>")
(setq BFTM_GLOBAL_TIME_TAG_END                                 "</BFTM_TIME_TAG_BFTM>")

;;global point tags
(setq BFTM_GLOBAL_POINT_TAG_BEGIN                              "<BFTM_POINT_TAG_BFTM>")
(setq BFTM_GLOBAL_POINT_TAG_END                               "</BFTM_POINT_TAG_BFTM>")

;;global len tags
(setq BFTM_GLOBAL_LEN_TAG_BEGIN                               "<BFTM_LEN_TAG_BFTM>")
(setq BFTM_GLOBAL_LEN_TAG_END                                "</BFTM_LEN_TAG_BFTM>")


;;global num words tags
(setq BFTM_GLOBAL_NUM_WORDS_TAG_BEGIN                      "<BFTM_NUM_WORDS_TAG_BFTM>")
(setq BFTM_GLOBAL_NUM_WORDS_TAG_END                       "</BFTM_NUM_WORDS_TAG_BFTM>")

;;global original filename arg  
(setq BFTM_GLOBAL_ORIGINAL_FILENAME_TAG_BEGIN      "<BFTM_ORIGINAL_FILENAME_TAG_BFTM>")
(setq BFTM_GLOBAL_ORIGINAL_FILENAME_TAG_END       "</BFTM_ORIGINAL_FILENAME_TAG_BFTM>")

;;global count arg tags
;;new
(setq BFTM_GLOBAL_COUNT_TAG_BEGIN                              "<BFTM_COUNT_TAG_BFTM>")
(setq BFTM_GLOBAL_COUNT_TAG_END                               "</BFTM_COUNT_TAG_BFTM>")

;;global log mover tags
(setq BFTM_GLOBAL_MOVER_TAG_BEGIN                          "<BFTM_LOG_MOVER_TAG_BFTM>")
(setq BFTM_GLOBAL_MOVER_TAG_END                           "</BFTM_LOG_MOVER_TAG_BFTM>")


(setq BFTM_GLOBAL_REGEXP_TAG_BEGIN                            "<BFTM_REGEXP_TAG_BFTM>")
(setq BFTM_GLOBAL_REGEXP_TAG_END                             "</BFTM_REGEXP_TAG_BFTM>")

(setq BFTM_GLOBAL_CREATE_NO_RECURSIVE_TAG_BEGIN  "<BFTM_CREATE_NO_RECURSIVE_TAG_BFTM>")
(setq BFTM_GLOBAL_CREATE_NO_RECURSIVE_TAG_END   "</BFTM_CREATE_NO_RECURSIVE_TAG_BFTM>")


;;
(setq BFTM_GLOBAL_STRING_TAG_BEGIN                            "<BFTM_STRING_TAG_BFTM>")
(setq BFTM_GLOBAL_STRING_TAG_END                             "</BFTM_STRING_TAG_BFTM>")

(setq BFTM_GLOBAL_CREATE_MESSAGE_TAG_BEGIN                   "<BFTM_MESSAGE_TAG_BFTM>")
(setq BFTM_GLOBAL_CREATE_MESSAGE_TAG_END                    "</BFTM_MESSAGE_TAG_BFTM>")


(setq BFTM_COMMAND_ARG_TAG_BEGIN                         "<BFTM_COMMAND_ARG_TAG_BFTM>")
(setq BFTM_COMMAND_ARG_TAG_END                          "</BFTM_COMMAND_ARG_TAG_BFTM>")



 

(setq BFTM_GLOBAL_ARG_TAG_BEGIN                           "<BFTM_GLOBAL_ARG_TAG_BFTM>")
(setq BFTM_GLOBAL_ARG_TAG_END                            "</BFTM_GLOBAL_ARG_TAG_BFTM>")

;;global log entry tags
(setq BFTM_GLOBAL_LOG_ENTRY_TAG_BEGIN                      "<BFTM_LOG_ENTRY_TAG_BFTM>")
(setq BFTM_GLOBAL_LOG_ENTRY_TAG_END                       "</BFTM_LOG_ENTRY_TAG_BFTM>")


;;global version tag so that I can tell which version of logger subjects are using
(setq BFTM_GLOBAL_LOG_VERSION_TAG_BEGIN               "<BFTM_LOGGER_VERSION_TAG_BFTM>")
(setq BFTM_GLOBAL_LOG_VERSION_TAG_END                "</BFTM_LOGGER_VERSION_TAG_BFTM>")




;;;;;;;;;;;;;;;;;;;;;;;;Helper create arg functions;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun bftm-create-start-arg (starter)
  (concat BFTM_GLOBAL_START_TAG_BEGIN                  (number-to-string starter)                BFTM_GLOBAL_START_TAG_END))

(defun bftm-create-end-arg (ender)
  (concat BFTM_GLOBAL_END_TAG_BEGIN                    (number-to-string ender)                    BFTM_GLOBAL_END_TAG_END))

(defun bftm-create-line-number-arg (ln-num)
  (concat BFTM_GLOBAL_LINE_NUMBER_TAG_BEGIN            ln-num                              BFTM_GLOBAL_LINE_NUMBER_TAG_END))

(defun bftm-create-buffer-name (buff-name)
  (concat BFTM_GLOBAL_BUFFER_NAME_TAG_BEGIN            buff-name                           BFTM_GLOBAL_BUFFER_NAME_TAG_END))

(defun bftm-create-command-string (comm-string)
  (concat BFTM_GLOBAL_COMMAND_STRING_TAG_BEGIN         comm-string                      BFTM_GLOBAL_COMMAND_STRING_TAG_END))

(defun bftm-create-inserted-string (inserted-string)
  (concat BFTM_GLOBAL_INSERTED_STRING_TAG_BEGIN        inserted-string                 BFTM_GLOBAL_INSERTED_STRING_TAG_END))

(defun bftm-create-point-arg (pointer)
  (concat BFTM_GLOBAL_POINT_TAG_BEGIN                  (number-to-string pointer)                BFTM_GLOBAL_POINT_TAG_END))

(defun bftm-create-num-words (num-wordser)
  (concat BFTM_GLOBAL_NUM_WORDS_TAG_BEGIN              (number-to-string num-wordser)        BFTM_GLOBAL_NUM_WORDS_TAG_END))

(defun bftm-create-len-arg (lener)
  (concat BFTM_GLOBAL_LEN_TAG_BEGIN                    (number-to-string lener)                    BFTM_GLOBAL_LEN_TAG_END))

;;new
(defun bftm-create-count-arg (count)
  (concat BFTM_GLOBAL_COUNT_TAG_BEGIN                  (number-to-string count)                  BFTM_GLOBAL_COUNT_TAG_END))

(defun bftm-create-mover-arg (mover)
  (concat BFTM_GLOBAL_MOVER_TAG_BEGIN                  mover                                     BFTM_GLOBAL_MOVER_TAG_END))

(defun bftm-create-arg-arg (arg)
  (concat BFTM_GLOBAL_ARG_TAG_BEGIN                    (number-to-string arg)                      BFTM_GLOBAL_ARG_TAG_END))


(defun bftm-create-regexp-p-arg (regexp-p)
  (concat BFTM_GLOBAL_REGEXP_TAG_BEGIN                 regexp-p                                 BFTM_GLOBAL_REGEXP_TAG_END))

(defun bftm-create-no-recursive-edit-arg (no-recursive-edit)
  (concat BFTM_GLOBAL_CREATE_NO_RECURSIVE_TAG_BEGIN    no-recursive-edit           BFTM_GLOBAL_CREATE_NO_RECURSIVE_TAG_END))


(defun bftm-create-string-arg (string)
  (concat BFTM_GLOBAL_STRING_TAG_BEGIN                 string                                   BFTM_GLOBAL_STRING_TAG_END))


(defun bftm-create-message-arg (message)
  (concat BFTM_GLOBAL_CREATE_MESSAGE_TAG_BEGIN         message                          BFTM_GLOBAL_CREATE_MESSAGE_TAG_END))



(defun bftm-create-command-arg (command-arg)
  (concat BFTM_COMMAND_ARG_TAG_BEGIN                   command-arg                                BFTM_COMMAND_ARG_TAG_END))

        
        
;;mostly used when calling save as (in write-file overwrite that I did).
(defun bftm-create-original-filename-arg (filename-original)
  (concat BFTM_GLOBAL_ORIGINAL_FILENAME_TAG_BEGIN    filename-original         BFTM_GLOBAL_ORIGINAL_FILENAME_TAG_END))

;takes care of time stamping
(defun bftm-get-current-time ()
  (concat BFTM_GLOBAL_TIME_TAG_BEGIN                (current-time-string)                   BFTM_GLOBAL_TIME_TAG_END))

(defun bftm-get-log-version ()
  (concat BFTM_GLOBAL_LOG_VERSION_TAG_BEGIN         (number-to-string BFTM_KEYLOGGER_VERSION)                   BFTM_GLOBAL_LOG_VERSION_TAG_END))


;;re-named this from files.el.gz so that won't be spitting out irritating messages about having been added to files.
(defun bftm-append-to-file (start end filename)
  "Append the contents of the region to the end of file FILENAME.
When called from a function, expects three arguments,
START, END and FILENAME.  START and END are buffer positions
saying what text to write."
  (interactive "r")
  (write-region start end filename t))

;;buffer modify here
(setq BFTM_BUFFER_EVENT_STRING "")
(setq BFTM_BUFFER_EVENT_COUNT_SINCE_FLUSH 0)
(setq BFTM_MAX_BUFFER_EVENT_LENGTH 10)


;;lkjs;
;; (defun bftm-flush-event-string()
;;   (interactive)
;;   (if (not (eq BFTM_BUFFER_EVENT_COUNT_SINCE_FLUSH 0))
;;       (with-temp-buffer
;;         (insert BFTM_BUFFER_EVENT_STRING)
;;         (when (file-writable-p BFTM_GLOBAL_FILE_NAME)  ;defaults to writing to global filename: ignores the args that I used to be taking
;;           (bftm-append-to-file (point-min)
;;                                (point-max)
;;                                BFTM_GLOBAL_FILE_NAME)))
;;     (setq BFTM_BUFFER_EVENT_STRING "")
;;     (setq BFTM_BUFFER_EVENT_COUNT_SINCE_FLUSH 0)))


(defun bftm-flush-event-string()
  (interactive)
  (write-region BFTM_BUFFER_EVENT_STRING nil BFTM_GLOBAL_FILE_NAME t)
  (setq BFTM_BUFFER_EVENT_STRING "")
  (setq BFTM_BUFFER_EVENT_COUNT_SINCE_FLUSH 0))
  

  
;;   (with-temp-buffer
;;     (insert BFTM_BUFFER_EVENT_STRING)
;;     (bftm-append-to-file (point-min)
;;                          (point-max)
;;                          BFTM_GLOBAL_FILE_NAME)))

          
;;           (when (file-writable-p BFTM_GLOBAL_FILE_NAME)
;;             (bftm-append-to-file (point-min)
;;                             (point-max)
;;                             BFTM_GLOBAL_FILE_NAME)))))
;;          )))





(defun appendToBufferEventString (stringToAppend)
  (interactive)
  (setq BFTM_BUFFER_EVENT_STRING (concat BFTM_BUFFER_EVENT_STRING stringToAppend))
  (if (> BFTM_BUFFER_EVENT_COUNT_SINCE_FLUSH BFTM_MAX_BUFFER_EVENT_LENGTH)
      (bftm-flush-event-string)))


(defun incrementAppendToBufferEventString()
  (setq BFTM_BUFFER_EVENT_COUNT_SINCE_FLUSH (+ BFTM_BUFFER_EVENT_COUNT_SINCE_FLUSH 1)))
  

  
;;buffer modify here


;;this function writes to a file
;;otherVariables is a list of lists
;;  each elemeent of the list is a list each element of those lists is a string that will be entered
;;  (defun write-string-to-file (command-string string fromFileName logFileName &rest otherVariables) 
;;   (interactive)
;;    (with-temp-buffer
;;      (insert "\n\n")
;;      (insert BFTM_GLOBAL_LOG_ENTRY_TAG_BEGIN)      ;insert begin log tag
;;      (insert "\n")
;;      (insert (bftm-create-command-string command-string))
;;      (insert "\n")
;;      (insert (bftm-create-inserted-string string))
;;      (insert "\n")
;;      (insert (bftm-create-buffer-name fromFileName))
;;      (insert "\n")
;;      (insert (bftm-get-current-time))
;;      (insert "\n")
;;      (insert (bftm-get-log-version))
;;      (insert "\n")
;;      ;;walk additional argument list, and insert them.
;;      (mapcar '(lambda(outer-list-arg)
;;                 (insert outer-list-arg)
;;                 (insert "\n"))
;;              otherVariables)

;;      (insert BFTM_GLOBAL_LOG_ENTRY_TAG_END)  ; insert end log tag
;;      (insert "\n")

;;      (when (file-writable-p logFileName)
;;        (bftm-append-to-file (point-min)
;;                        (point-max)
;;                        logFileName))))


;;lkjs;
(defun write-string-to-file (command-string string fromFileName logFileName &rest otherVariables) 
  (interactive)
  (appendToBufferEventString "\n\n")
  (appendToBufferEventString BFTM_GLOBAL_LOG_ENTRY_TAG_BEGIN)
  (appendToBufferEventString "\n")
  (appendToBufferEventString (bftm-create-command-string command-string))
  (appendToBufferEventString "\n")
  (appendToBufferEventString (bftm-create-inserted-string string))
  (appendToBufferEventString "\n")
  (appendToBufferEventString (bftm-create-buffer-name fromFileName))
  (appendToBufferEventString "\n")
  (appendToBufferEventString (bftm-get-current-time))
  (appendToBufferEventString "\n")
  (appendToBufferEventString (bftm-get-log-version))
  (appendToBufferEventString "\n")

  (mapcar '(lambda(outer-list-arg)
             (appendToBufferEventString outer-list-arg)
             (appendToBufferEventString "\n"))
          otherVariables)


  (appendToBufferEventString BFTM_GLOBAL_LOG_ENTRY_TAG_END)  ; insert end log tag
  (appendToBufferEventString "\n")
  (incrementAppendToBufferEventString ))


;;  (defun write-string-to-file (command-string string fromFileName logFileName &rest otherVariables) 
;;   (interactive))




;;;;;;;;;;;;;;;;;;;;;;DOCUMENT LISTENER;;;;;;;;;;;;;;;
(setq DOC_MOD_COMMAND_STRING "BFTM_DOC_MOD_COMMAND_STRING_BFTM")


(defun bftm-after-document-change-function (beg end len)
  (if (bftm-checkfilename-p)
    (let ((texter        (buffer-substring         beg    end))
          (other-args-1  (bftm-create-start-arg           beg))
          (other-args-2  (bftm-create-end-arg             end))
          (other-args-3  (bftm-create-len-arg            len))) ;;texter is the text that actually changed in the documents
      (write-string-to-file DOC_MOD_COMMAND_STRING texter buffer-file-name BFTM_GLOBAL_FILE_NAME other-args-1 other-args-2 other-args-3))
    nil ;;else statement
    ))


(add-hook 'after-change-functions
           'bftm-after-document-change-function)


;;;;;;;add in a before change hook
(setq DOC_MOD_BEFORE_COMMAND_STRING "BFTM_DOC_MOD_BEFORE_COMMAND_STRING_BFTM")


(defun bftm-before-document-change-function (beg end)
  (if (bftm-checkfilename-p)
    (let ((texter        (buffer-substring         beg    end))
          (other-args-1  (bftm-create-start-arg           beg))
          (other-args-2  (bftm-create-end-arg             end))) ;;texter is the text that actually changed in the documents
      (write-string-to-file DOC_MOD_BEFORE_COMMAND_STRING texter buffer-file-name BFTM_GLOBAL_FILE_NAME other-args-1 other-args-2))
    nil ;;else statement
    ))


(add-hook 'before-change-functions
           'bftm-before-document-change-function)





;;;;;;;;;;;;;;;;;;;;;YANKING;;;;;;;;;;;;;;;;;;;;;;;;;
(setq YANK_COMMAND_STRING "BFTM_YANK_COMMAND_STRING_BFTM")

(fset 'prev-yank (symbol-function 'yank))

;;re-define yank
(defun yank ( &optional arg)
  ;(interactive)
  (interactive "*P")
  ;if there is a buffer declared, go ahead and use it.
  (if (bftm-checkfilename-p)
      (let ((yanked-text (car kill-ring-yank-pointer)))
      (write-string-to-file YANK_COMMAND_STRING yanked-text buffer-file-name BFTM_GLOBAL_FILE_NAME))
    ;;else statement
    nil) ;;end if statement (also, I know it's bad form to have this single parentheses on a line by itslef.
  (prev-yank arg))



;;;;;;;;;;;;;;;;;;;;;;KILL_REGION;;;;;;;;;;;;;;;;;
(setq KILL_REGION_COMMAND_STRING "BFTM_KILL_REGION_COMMAND_STRING_BFTM")

(fset 'prev-kill-region (symbol-function 'kill-region))

(defun kill-region (start end &optional yank-handler)
  ;;apparently, the 'r' command is really important
  ;(interactive "r")
  (interactive (list (point) (mark)))
  (if (bftm-checkfilename-p)
      (let ((killed-text   (buffer-substring start end))
            (other-args-1  (bftm-create-start-arg start))
            (other-args-2  (bftm-create-end-arg   end)))
        (write-string-to-file KILL_REGION_COMMAND_STRING killed-text buffer-file-name BFTM_GLOBAL_FILE_NAME other-args-1 other-args-2)))
  (prev-kill-region start end yank-handler))



;;;;;;;;;;;;;;;;;;;;;UNDO;;;;;;;;;;;;;;;;;;;;;;;;
;;See http://www.delorie.com/gnu/docs/elisp-manual-21/elisp_507.html
;;for what undo data actually looks like/means

(setq UNDO_COMMAND_STRING "BFTM_UNDO_COMMAND_STRING_BFTM")

(fset 'prev-undo (symbol-function 'undo))


;;this function returns ever element in the list until:
;;   1) it sees nil
;;   2) it runs out of elements
(defun bftm-collect-undos (lister)
  (if (not lister)
      ;base case.  if list is empty, return empty list
      '()  
    (if (not (car lister))
        ;another base case, if first element of list is nil, return empty list
        '()
      ;recursive step: keep cons-ing together elements
      (cons (car lister) (bftm-collect-undos (cdr lister))))))
  

;;this function runs through the buffer-undo-list, taking out
;;the most recent changes examples:
;;
;;buffer-undo-list      returns
;;nil a b c d nil ----> a b c d
;;
;;nil a           ----> a
;;
;;nil             ----> nil
(defun bftm-get-latest-undo ()
  (let ((lister buffer-undo-list))
    (if lister
        (if (not (car lister))
            (bftm-collect-undos (cdr lister))
          (bftm-collect-undos lister))
      '())))


;;re-define undo function
(defun undo ()
  (interactive)
  (if (bftm-checkfilename-p);;if there is a buffer declared, go ahead and use it.
      (let ((undone-action (pp-to-string (bftm-get-latest-undo))))
        (write-string-to-file UNDO_COMMAND_STRING undone-action buffer-file-name BFTM_GLOBAL_FILE_NAME))
    nil ;;else statement
    )   ;;end if statement
  ;;issue the over-written command
  (prev-undo))




;;;;;;;;;;;;;;;;;;;;;;beginning of line;;;;;;;;;;;;
;; (setq BEGINNING_OF_LINE_COMMAND_STRING "BFTM_BEGINNING_OF_LINE_COMMAND_STRING_BFTM")

;; (fset 'prev-beginning-of-line (symbol-function 'beginning-of-line))

;; ;;re-define beginning-of-line
;; (defun beginning-of-line ()
;;   (interactive)
;;   (if buffer-file-name  ;if there is a buffer declared, go ahead and use it.
;;       (let ((other-args-1 (bftm-create-line-number-arg (what-line))))
;;         (write-string-to-file BEGINNING_OF_LINE_COMMAND_STRING BFTM_EMPTY_FIELD buffer-file-name BFTM_GLOBAL_FILE_NAME other-args-1))
;;     nil ;;else statement
;;     ) ;;end if statement (also, I know it's bad form to have this single parentheses on a line by itslef.
;;   (prev-beginning-of-line))



;;;;;;;;;;;;;;;;;;;;;upcase region;;;;;;;;;;;;;;;;;
(setq UPCASE_REGION_COMMAND_STRING "BFTM_UPCASE_REGION_COMMAND_STRING_BFTM")

(fset 'prev-upcase-region (symbol-function 'upcase-region))


;;re-define upcase-region function
(defun upcase-region (start end)
  (interactive)
  (prev-upcase-region start end)
  (if (bftm-checkfilename-p);;if there is a buffer declared, go ahead and use it.
      (let ((upper-text (buffer-substring start end))
            (other-args-1  (bftm-create-start-arg start))
            (other-args-2  (bftm-create-end-arg   end)))
        (write-string-to-file UPCASE_REGION_COMMAND_STRING upper-text buffer-file-name BFTM_GLOBAL_FILE_NAME other-args-1 other-args-2))
    nil ;;else statement
    )) ;;end if statement




;;;;;;;;;;;;;;;;;;;;;downcase region;;;;;;;;;;;;;;;;;
(setq DOWNCASE_REGION_COMMAND_STRING "BFTM_DOWNCASE_REGION_COMMAND_STRING_BFTM")

(fset 'prev-downcase-region (symbol-function 'downcase-region))


;;re-define downcase-region function
(defun downcase-region (start end)
  (interactive)
  (prev-downcase-region start end)
  (if (bftm-checkfilename-p);;if there is a buffer declared, go ahead and use it.
      (let ((downer-text (buffer-substring start end))
            (other-args-1  (bftm-create-start-arg start))
            (other-args-2  (bftm-create-end-arg   end)))
        (write-string-to-file DOWNCASE_REGION_COMMAND_STRING downer-text buffer-file-name BFTM_GLOBAL_FILE_NAME other-args-1 other-args-2))
    nil ;;else statement
    )) ;;end if statement





;; ;;;;;;;;;;;;;;;;;;;;;upcase word;;;;;;;;;;;;;;;;;
(setq UPCASE_WORD_COMMAND_STRING "BFTM_UPCASE_WORD_COMMAND_STRING_BFTM")

(fset 'prev-upcase-word (symbol-function 'upcase-word))


;;re-define upcase-word function
(defun upcase-word (number-words)
  (interactive)
  (prev-upcase-word number-words)
  (if (bftm-checkfilename-p);;if there is a buffer declared, go ahead and use it.
      (let ((other-args-1  (bftm-create-point-arg (point)))
            (other-args-2  (bftm-create-num-words number-words)))
        (write-string-to-file UPCASE_WORD_COMMAND_STRING BFTM_EMPTY_FIELD buffer-file-name BFTM_GLOBAL_FILE_NAME other-args-1 other-args-2))
    nil ;;else statement
    )) ;;end if statement



;; ;;;;;;;;;;;;;;;;;;;;;downcase word;;;;;;;;;;;;;;;;;
(setq DOWNCASE_WORD_COMMAND_STRING "BFTM_DOWNCASE_WORD_COMMAND_STRING_BFTM")

(fset 'prev-downcase-word (symbol-function 'downcase-word))


;;re-define downcase-word function
(defun downcase-word (number-words)
  (interactive)
  (prev-downcase-word number-words)
  (if (bftm-checkfilename-p);;if there is a buffer declared, go ahead and use it.
      (let ((other-args-1  (bftm-create-point-arg (point)))
            (other-args-2  (bftm-create-num-words number-words)))
        (write-string-to-file DOWNCASE_WORD_COMMAND_STRING BFTM_EMPTY_FIELD buffer-file-name BFTM_GLOBAL_FILE_NAME other-args-1 other-args-2))
    nil ;;else statement
    )) ;;end if statement




;;;;;;;;;;;;;;;;;;;;Manage checkpointed files;;;;;;;;;;;;;;;;;;;;

(setq bftm-global-list-checkpointed-files '())

;;mostly for debugging
(defun print-file-names ()
  (interactive)
  (message (pp-to-string bftm-global-list-checkpointed-files)))


(defun bftm-add-checkpointed-files (filenamer)
  (setq bftm-global-list-checkpointed-files (cons filenamer bftm-global-list-checkpointed-files)))


(defun remove-element-from-list (val lister)
  (if (not lister)
      ;;base-case: empty list, return nothing
      '()
    (if (string-equal (car lister) val)
        ;;front of list matches: remove the value
      (remove-element-from-list val (cdr lister))
      ;;front of list doesn't match: continue
      (cons (car lister) (remove-element-from-list val (cdr lister))))))


(defun bftm-remove-checkpointed-files (filenamer)
  (setq bftm-global-list-checkpointed-files (remove-element-from-list filenamer bftm-global-list-checkpointed-files)))


(defun search-through-list (val lister)
  (if (not lister)
      ;;base case
      '()
    ;;recursive step
    (if (string-equal (car lister) val)
        ;;two equal: return true
        t
      (search-through-list val (cdr lister)))))


;;checks through bftm-global-list-checkpointed-files
;;if have filenamer in there, then return true
;;otherwise, return false
(defun bftm-file-checkpointed (filenamer)
  (search-through-list filenamer bftm-global-list-checkpointed-files))

;;going to add a hook to remove files from the global checkpointed list
(defun bftm-killed-buffer-hooker ()
  (interactive)
  (bftm-flush-event-string)
  (if (bftm-checkfilename-p)
      (bftm-remove-checkpointed-files buffer-file-name)))

(add-hook 'kill-buffer-hook
          'bftm-killed-buffer-hooker)
          


;;;;;;;;;;;;;;;;;;;;After find file;;;;;;;;;;;;;;;;;;;;;;
(setq AFTER_FIND_FILE_COMMAND_STRING "BFTM_AFTER_FIND_FILE_COMMAND_STRING_BFTM")

(fset 'prev-after-find-file (symbol-function 'after-find-file))


;;helper function: checks if we already have a copy of this file checkpointed
;;if we do not, then we check-point it.
;;if we do, then we do nothing..
(defun bftm-after-find-file-helper ()
  (interactive)
  (if (bftm-checkfilename-p);; if there is a buffer declared, go ahead and use it.
      (if (not (bftm-file-checkpointed buffer-file-name))
          ;;means that we don't already have a check-pointed version of this file
          ;;must checkpoint
          (let ((file-text (buffer-substring (point-min) (point-max))))
            (write-string-to-file AFTER_FIND_FILE_COMMAND_STRING file-text buffer-file-name BFTM_GLOBAL_FILE_NAME)
            (bftm-add-checkpointed-files buffer-file-name)
            nil)
        ;;else statement: we already had a checkpointed version
        nil)
    ;;else statement: we don't have a buffer name
    nil))



;;re-define after-find-file function
(defun after-find-file (&optional error warn noauto after-find-file-from-revert-buffer nomodes)
  (interactive)
  (if (and warn (bftm-checkfilename-p))
      ;;means that there is a more-recent version of the file.  should go ahead and remove the file from the files I'm keeping track of.
      (bftm-remove-checkpointed-files buffer-file-name))
  ;;call real function
  (prev-after-find-file error warn noauto after-find-file-from-revert-buffer nomodes)
  ;;call helper: if don't have a copy of this file, then go ahead and copy it
  (bftm-after-find-file-helper))





;;re-defining the original find-file function.
(setq FIND_FILE_REREAD_COMMAND_STRING "BFTM_FIND_FILE_REREAD_COMMAND_STRING_BFTM")

;;;;;
;  removes and adds the found file;
(defun bftm-find-file-helper-read-from-disk (filename)
  (interactive)
  (bftm-flush-event-string)
  (bftm-remove-checkpointed-files filename)
  (bftm-add-checkpointed-files filename)
  (let ((file-text (buffer-substring (point-min) (point-max))))
    (write-string-to-file FIND_FILE_REREAD_COMMAND_STRING file-text buffer-file-name BFTM_GLOBAL_FILE_NAME)))
  


;; ;;bftm
;; ;;copied verbatim from files.el.gz
;; ;;then added a little snippet of code that adds a helper logging function in case file has been modified on disk
(defun find-file-noselect (filename &optional nowarn rawfile wildcards)
  "Read file FILENAME into a buffer and return the buffer.
If a buffer exists visiting FILENAME, return that one, but
verify that the file has not changed since visited or saved.
The buffer is not selected, just returned to the caller.
Optional second arg NOWARN non-nil means suppress any warning messages.
Optional third arg RAWFILE non-nil means the file is read literally.
Optional fourth arg WILDCARDS non-nil means do wildcard processing
and visit all the matching files.  When wildcards are actually
used and expanded, return a list of buffers that are visiting
the various files."
  (setq filename
	(abbreviate-file-name
	 (expand-file-name filename)))
  (if (file-directory-p filename)
      (or (and find-file-run-dired
	       (run-hook-with-args-until-success
		'find-directory-functions
		(if find-file-visit-truename
		    (abbreviate-file-name (file-truename filename))
		  filename)))
	  (error "%s is a directory" filename))
    (if (and wildcards
	     find-file-wildcards
	     (not (string-match "\\`/:" filename))
	     (string-match "[[*?]" filename))
	(let ((files (condition-case nil
			 (file-expand-wildcards filename t)
		       (error (list filename))))
	      (find-file-wildcards nil))
	  (if (null files)
	      (find-file-noselect filename)
	    (mapcar #'find-file-noselect files)))
      (let* ((buf (get-file-buffer filename))
	     (truename (abbreviate-file-name (file-truename filename)))
	     (attributes (file-attributes truename))
	     (number (nthcdr 10 attributes))
	     ;; Find any buffer for a file which has same truename.
	     (other (and (not buf) (find-buffer-visiting filename))))
	;; Let user know if there is a buffer with the same truename.
	(if other
	    (progn
	      (or nowarn
		  find-file-suppress-same-file-warnings
		  (string-equal filename (buffer-file-name other))
		  (message "%s and %s are the same file"
			   filename (buffer-file-name other)))
	      ;; Optionally also find that buffer.
	      (if (or find-file-existing-other-name find-file-visit-truename)
		  (setq buf other))))
	;; Check to see if the file looks uncommonly large.
	(when (and large-file-warning-threshold (nth 7 attributes)
		   ;; Don't ask again if we already have the file or
		   ;; if we're asked to be quiet.
		   (not (or buf nowarn))
		   (> (nth 7 attributes) large-file-warning-threshold)
		   (not (y-or-n-p
			 (format "File %s is large (%dMB), really open? "
				 (file-name-nondirectory filename)
				   (/ (nth 7 attributes) 1048576)))))
	  (error "Aborted"))
	(if buf
	    ;; We are using an existing buffer.
	    (let (nonexistent)
	      (or nowarn
		  (verify-visited-file-modtime buf)
		  (cond ((not (file-exists-p filename))
			 (setq nonexistent t)
			 (message "File %s no longer exists!" filename))
			;; Certain files should be reverted automatically
			;; if they have changed on disk and not in the buffer.
			((and (not (buffer-modified-p buf))
			      (let ((tail revert-without-query)
				    (found nil))
				(while tail
				  (if (string-match (car tail) filename)
				      (setq found t))
				  (setq tail (cdr tail)))
				found))
			 (with-current-buffer buf
			   (message "Reverting file %s..." filename)
			   (revert-buffer t t)
          ;bftm oringal	   (message "Reverting file %s...done" filename)))
                           (message "Reverting file %s...done" filename)
                           (bftm-find-file-helper-read-from-disk filename)))
          ;bftm end change
			((yes-or-no-p
			  (if (string= (file-name-nondirectory filename)
				       (buffer-name buf))
			      (format
			       (if (buffer-modified-p buf)
				   "File %s changed on disk.  Discard your edits? "
				 "File %s changed on disk.  Reread from disk? ")
			       (file-name-nondirectory filename))
			    (format
			     (if (buffer-modified-p buf)
				 "File %s changed on disk.  Discard your edits in %s? "
			       "File %s changed on disk.  Reread from disk into %s? ")
			     (file-name-nondirectory filename)
			     (buffer-name buf))))
                         (with-current-buffer buf
        ;bftm original	   (revert-buffer t t)))))
                           (revert-buffer t t)
                           (bftm-find-file-helper-read-from-disk filename)))))
        ;bftm end change
	      (with-current-buffer buf

		;; Check if a formerly read-only file has become
		;; writable and vice versa, but if the buffer agrees
		;; with the new state of the file, that is ok too.
		(let ((read-only (not (file-writable-p buffer-file-name))))
		  (unless (or nonexistent
			      (eq read-only buffer-file-read-only)
			      (eq read-only buffer-read-only))
		    (when (or nowarn
			      (let ((question
				     (format "File %s is %s on disk.  Change buffer mode? "
					     buffer-file-name
					     (if read-only "read-only" "writable"))))
				(y-or-n-p question)))
		      (setq buffer-read-only read-only)))
		  (setq buffer-file-read-only read-only))

		(when (and (not (eq (not (null rawfile))
				    (not (null find-file-literally))))
			   (not nonexistent)
			   ;; It is confusing to ask whether to visit
			   ;; non-literally if they have the file in
			   ;; hexl-mode.
			   (not (eq major-mode 'hexl-mode)))
		  (if (buffer-modified-p)
		      (if (y-or-n-p
			   (format
			    (if rawfile
				"The file %s is already visited normally,
and you have edited the buffer.  Now you have asked to visit it literally,
meaning no coding system handling, format conversion, or local variables.
Emacs can only visit a file in one way at a time.

Do you want to save the file, and visit it literally instead? "
				"The file %s is already visited literally,
meaning no coding system handling, format conversion, or local variables.
You have edited the buffer.  Now you have asked to visit the file normally,
but Emacs can only visit a file in one way at a time.

Do you want to save the file, and visit it normally instead? ")
			    (file-name-nondirectory filename)))
			  (progn
			    (save-buffer)
			    (find-file-noselect-1 buf filename nowarn
						  rawfile truename number))
			(if (y-or-n-p
			     (format
			      (if rawfile
				  "\
Do you want to discard your changes, and visit the file literally now? "
				"\
Do you want to discard your changes, and visit the file normally now? ")))
			    (find-file-noselect-1 buf filename nowarn
						  rawfile truename number)
			  (error (if rawfile "File already visited non-literally"
				   "File already visited literally"))))
		    (if (y-or-n-p
			 (format
			  (if rawfile
			      "The file %s is already visited normally.
You have asked to visit it literally,
meaning no coding system decoding, format conversion, or local variables.
But Emacs can only visit a file in one way at a time.

Do you want to revisit the file literally now? "
			    "The file %s is already visited literally,
meaning no coding system decoding, format conversion, or local variables.
You have asked to visit it normally,
but Emacs can only visit a file in one way at a time.

Do you want to revisit the file normally now? ")
			  (file-name-nondirectory filename)))
			(find-file-noselect-1 buf filename nowarn
					      rawfile truename number)
		      (error (if rawfile "File already visited non-literally"
			       "File already visited literally"))))))
	      ;; Return the buffer we are using.
	      buf)
	  ;; Create a new buffer.
	  (setq buf (create-file-buffer filename))
	  ;; find-file-noselect-1 may use a different buffer.
	  (find-file-noselect-1 buf filename nowarn
				rawfile truename number))))))






;;;;;;;;;;;;;;;;;;;;AFTER SAVE HOOK;;;;;;;;;;;;;;;;;;;;;;

(setq AFTER_SAVE_HOOK_COMMAND_STRING "BFTM_AFTER_SAVE_HOOK_COMMAND_STRING_BFTM")

;just going to hook into it
(defun bftm-hooked-after-save ()
  (interactive)
  (bftm-flush-event-string)
  (if (bftm-checkfilename-p);; if there is a buffer declared, go ahead and use it.
      ;;write that there was a save event
      (write-string-to-file AFTER_SAVE_HOOK_COMMAND_STRING BFTM_EMPTY_FIELD buffer-file-name BFTM_GLOBAL_FILE_NAME)
    nil))


(add-hook 'after-save-hook
           'bftm-hooked-after-save)




;;;;;;;;;;;;;;;;;;WRITE-FILE HOOK: (save as);;;;;;;;;;;;;;;
;;write file is like save as.  whenever we get this function,
;;we need to 

(setq SAVE_AS_COMMAND_STRING "BFTM_SAVE_AS_COMMAND_STRING_BFTM")

(fset 'prev-write-file (symbol-function 'write-file))



;;this function logs the initial contents of the file saved to filename-new
;;it adds filename-new to the list of filenames we're monitoring.
;;it does not remove filename-original from the list of filenames we're monitoring.  (we still have copies of it.)
;;
(defun bftm-helper-write-file (filename-new filename-original)
  (interactive)
  (bftm-flush-event-string)
  (let ((file-text    (buffer-substring (point-min) (point-max)))
        (other-args-1 (bftm-create-original-filename-arg filename-original)))
    (write-string-to-file SAVE_AS_COMMAND_STRING file-text filename-new BFTM_GLOBAL_FILE_NAME other-args-1)))



;;bftm
;;copied verbatim from files.el.gz
;;then added a little snippet of code that adds a helper logging function, noted in the text of the function.
(defun write-file (filename &optional confirm)
  "Write current buffer into file FILENAME.
This makes the buffer visit that file, and marks it as not modified.

If you specify just a directory name as FILENAME, that means to use
the default file name but in that directory.  You can also yank
the default file name into the minibuffer to edit it, using \\<minibuffer-local-map>\\[next-history-element].

If the buffer is not already visiting a file, the default file name
for the output file is the buffer name.

If optional second arg CONFIRM is non-nil, this function
asks for confirmation before overwriting an existing file.
Interactively, confirmation is required unless you supply a prefix argument."
;;  (interactive "FWrite file: ")
  (interactive
   (list (if buffer-file-name
	     (read-file-name "Write file: "
			     nil nil nil nil)
	   (read-file-name "Write file: " default-directory
			   (expand-file-name
			    (file-name-nondirectory (buffer-name))
			    default-directory)
			   nil nil))
	 (not current-prefix-arg)))
  (or (null filename) (string-equal filename "")
      (progn
	;; If arg is just a directory,
	;; use the default file name, but in that directory.
	(if (file-directory-p filename)
	    (setq filename (concat (file-name-as-directory filename)
				   (file-name-nondirectory
				    (or buffer-file-name (buffer-name))))))
	(and confirm
	     (file-exists-p filename)
	     (or (y-or-n-p (format "File `%s' exists; overwrite? " filename))
		 (error "Canceled")))
	(set-visited-file-name filename (not confirm))))
  (set-buffer-modified-p t)

  ;;bftm changes
  (if (not (string-equal filename buffer-file-name))
        ;;means that we're saving this file to a new place, we need more of a full account of it.
      (bftm-helper-write-file filename buffer-file-name))
  ;;end bftm changes
  ;; Make buffer writable if file is writable.
  (and buffer-file-name
       (file-writable-p buffer-file-name)
       (setq buffer-read-only nil))
  (save-buffer)
  ;; It's likely that the VC status at the new location is different from
  ;; the one at the old location.
  (vc-find-file-hook))





;;;;;;;;;;;;;;;;;DELETE-REGION;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq DELETE_REGION_COMMAND_STRING "BFTM_DELETE_REGION_COMMAND_STRING_BFTM")

(fset 'prev-delete-region (symbol-function 'delete-region))

(defun delete-region (&optional start end)
  ;;apparently, the 'r' command is really important
  (interactive "r")
  (if (bftm-checkfilename-p)
      (let ((deleted-text  (buffer-substring start end))
            (other-args-1  (bftm-create-start-arg start))
            (other-args-2  (bftm-create-end-arg   end)))
        (write-string-to-file DELETE_REGION_COMMAND_STRING deleted-text buffer-file-name BFTM_GLOBAL_FILE_NAME other-args-1 other-args-2)))
  (prev-delete-region start end))



;; ;;;;;;;;;;;ISEARCH-PROCESS-SEARCH-STRING;;;;;;;;;;;;;;;
(setq ISEARCH_PROCESS_SEARCH_STRING_COMMAND_STRING "BFTM_ISEARCH_PROCESS_SEARCH_COMMAND_STRING_BFTM")

(fset 'prev-isearch-process-search-string (symbol-function 'isearch-process-search-string))

(defun isearch-process-search-string (string message)
  (interactive)
  (if (bftm-checkfilename-p)
      (let ((other-args-1  (bftm-create-string-arg string))
            (other-args-2  (bftm-create-message-arg   message)))
        (write-string-to-file ISEARCH_PROCESS_SEARCH_STRING_COMMAND_STRING  BFTM_EMPTY_FIELD buffer-file-name BFTM_GLOBAL_FILE_NAME other-args-1 other-args-2)))
  (prev-isearch-process-search-string string message))


;; ;;;;;;;;;;;;;;;;;ISEARCH-BACKWARD;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq ISEARCH_BACKWARD_COMMAND_STRING "BFTM_ISEARCH_BACKWARD_COMMAND_STRING_BFTM")

(fset 'prev-isearch-backward (symbol-function 'isearch-backward))

(defun isearch-backward (&optional regexp-p no-recursive-edit)
  (interactive)
  (if buffer-file-name
      (let ((other-args-1 (bftm-create-regexp-p-arg regexp-p))
            (other-args-2 (bftm-create-point-arg (point)))
            (other-args-3 (bftm-create-no-recursive-edit-arg no-recursive-edit)))
      (write-string-to-file ISEARCH_BACKWARD_COMMAND_STRING BFTM_EMPTY_FIELD buffer-file-name BFTM_GLOBAL_FILE_NAME other-args-1 other-args-2 other-args-3)))
  (prev-isearch-backward regexp-p no-recursive-edit))


;;;;;;;;;;;;;;;ISEARCH-BACKWARD-REGEXP;;;;;;
(setq ISEARCH_BACKWARD_REGEXP_COMMAND_STRING "BFTM_ISEARCH_BACKWARD_REGEXP_COMMAND_STRING_BFTM")

(fset 'prev-isearch-backward-regexp (symbol-function 'isearch-backward-regexp))

(defun isearch-backward-regexp (&optional regexp-p no-recursive-edit)
  (interactive)
  (if buffer-file-name
      (let ((other-args-1 (bftm-create-regexp-p-arg regexp-p))
            (other-args-2 (bftm-create-point-arg (point)))
            (other-args-3 (bftm-create-no-recursive-edit-arg no-recursive-edit)))
      (write-string-to-file ISEARCH_BACKWARD_REGEXP_COMMAND_STRING BFTM_EMPTY_FIELD buffer-file-name BFTM_GLOBAL_FILE_NAME other-args-1 other-args-2 other-args-3)))
  (prev-isearch-backward-regexp regexp-p no-recursive-edit))





;; ;;;;;;;;;;;;;;;;;SEARCH-BACKWARD;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (setq SEARCH_BACKWARD_COMMAND_STRING "BFTM_SEARCH_BACKWARD_COMMAND_STRING_BFTM")

;; (fset 'prev-search-backward (symbol-function 'search-backward))

;; (defun search-backward (search-for)
;;   (interactive)
;;   (if buffer-file-name
;;       (let ((other-args-1 (bftm-create-search-string search-for))
;;             (other-args-2 (bftm-create-point-arg (point))))
;;       (write-string-to-file SEARCH_BACKWARD_COMMAND_STRING BFTM_EMPTY_FIELD buffer-file-name BFTM_GLOBAL_FILE_NAME other-args-1 other-args-2)))
;;   (prev-search-backward search-for))


;; ;;;;;;;;;;;;;;;;;ISEARCH-FORWARD;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq ISEARCH_FORWARD_COMMAND_STRING "BFTM_ISEARCH_FORWARD_COMMAND_STRING_BFTM")

(fset 'prev-isearch-forward (symbol-function 'isearch-forward))


(defun isearch-forward (&optional regexp-p no-recursive-edit)
  (interactive)
  (if buffer-file-name
      (let ((other-args-1 (bftm-create-regexp-p-arg regexp-p))
            (other-args-2 (bftm-create-point-arg (point)))
            (other-args-3 (bftm-create-no-recursive-edit-arg no-recursive-edit)))
        (write-string-to-file ISEARCH_FORWARD_COMMAND_STRING BFTM_EMPTY_FIELD buffer-file-name BFTM_GLOBAL_FILE_NAME other-args-1 other-args-2 other-args-3)))
  (prev-isearch-forward regexp-p no-recursive-edit))


;;;;;;;;;;;;;;;ISEARCH-FORWARD-REGEXP;;;;;;
(setq ISEARCH_FORWARD_REGEXP_COMMAND_STRING "BFTM_ISEARCH_FORWARD_REGEXP_COMMAND_STRING_BFTM")

(fset 'prev-isearch-forward-regexp (symbol-function 'isearch-forward-regexp))

(defun isearch-forward-regexp (&optional regexp-p no-recursive-edit)
  (interactive)
  (if buffer-file-name
      (let ((other-args-1 (bftm-create-regexp-p-arg regexp-p))
            (other-args-2 (bftm-create-point-arg (point)))
            (other-args-3 (bftm-create-no-recursive-edit-arg no-recursive-edit)))
      (write-string-to-file ISEARCH_FORWARD_REGEXP_COMMAND_STRING BFTM_EMPTY_FIELD buffer-file-name BFTM_GLOBAL_FILE_NAME other-args-1 other-args-2 other-args-3)))
  (prev-isearch-forward-regexp regexp-p no-recursive-edit))




;;;;;;;;;;;;;;;;;SEARCH-FORWARD;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (setq SEARCH_FORWARD_COMMAND_STRING "BFTM_SEARCH_FORWARD_COMMAND_STRING_BFTM")

;; (fset 'prev-search-forward (symbol-function 'search-forward))



;; (defun oof-search-forward (&optional search-for  limit-of-search what-to-do-if-search-fails repeat-count)
;;   (interactive "p")
;;   (if buffer-file-name
;;       (let ((other-args-1 "oof") ;;(bftm-create-string-arg search-for))
;;             (other-args-2 (bftm-create-point-arg (point))))
;;       (write-string-to-file SEARCH_FORWARD_COMMAND_STRING BFTM_EMPTY_FIELD buffer-file-name BFTM_GLOBAL_FILE_NAME other-args-1 other-args-2)))
;;   (prev-search-forward search-for limit-of-search what-to-do-if-search-fails repeat-count))





;;;;;;;;;;;;;;;;;Comment region;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq COMMENT_REGION_COMMAND_STRING "BFTM_COMMENT_REGION_COMMAND_STRING_BFTM")


;;re-define comment region


;;copied verbatim from newcomment.el.gz
;;then added a little snippet of code 
(defun comment-region (beg end &optional arg)
  "Comment or uncomment each line in the region.
With just \\[universal-argument] prefix arg, uncomment each line in region BEG .. END.
Numeric prefix ARG means use ARG comment characters.
If ARG is negative, delete that many comment characters instead.
By default, comments start at the left margin, are terminated on each line,
even for syntax in which newline does not end the comment and blank lines
do not get comments.  This can be changed with `comment-style'.

The strings used as comment starts are built from
`comment-start' without trailing spaces and `comment-padding'."
  (interactive "*r\nP")
  (comment-normalize-vars)

;;bftm modified
  (if (bftm-checkfilename-p)
      (let ((other-args-1     (bftm-create-start-arg beg))
            (other-args-2     (bftm-create-end-arg   end)))
        (write-string-to-file COMMENT_REGION_COMMAND_STRING BFTM_EMPTY_FIELD buffer-file-name BFTM_GLOBAL_FILE_NAME other-args-1 other-args-2)))
;;end bftm modified
  
  (if (> beg end) (let (mid) (setq mid beg beg end end mid)))
  (save-excursion
    ;; FIXME: maybe we should call uncomment depending on ARG.
    (funcall comment-region-function beg end arg)))

;;end re-define comment region





;;;;;;;;;;;;;;;;;Uncomment region;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq UNCOMMENT_REGION_COMMAND_STRING "BFTM_UNCOMMENT_REGION_COMMAND_STRING_BFTM")

;; (fset 'prev-uncomment-region (symbol-function 'uncomment-region))

;; (defun uncomment-regioner (start end &optional arg)
;;   ;;apparently, the 'r' command is really important
;;   (interactive "r")
;;   (if (bftm-checkfilename-p)
;;       (let ((other-args-1       (bftm-create-start-arg start))
;;             (other-args-2       (bftm-create-end-arg   end)))
;;         (write-string-to-file UNCOMMENT_REGION_COMMAND_STRING BFTM_EMPTY_FIELD buffer-file-name BFTM_GLOBAL_FILE_NAME other-args-1 other-args-2)))
;;   (prev-uncomment-region start end arg))

;;copied verbatim from newcomment.el.gz
;;then added a little snippet of code 

(defun uncomment-region (beg end &optional arg)
  "Uncomment each line in the BEG .. END region.
The numeric prefix ARG can specify a number of chars to remove from the
comment markers."
  (interactive "*r\nP")
  (comment-normalize-vars)

;;bftm-modified
  (if (bftm-checkfilename-p)
      (let ((other-args-1       (bftm-create-start-arg beg))
            (other-args-2       (bftm-create-end-arg   end)))
        (write-string-to-file UNCOMMENT_REGION_COMMAND_STRING BFTM_EMPTY_FIELD buffer-file-name BFTM_GLOBAL_FILE_NAME other-args-1 other-args-2)))
;;end bftm-modified
  
  (when (> beg end) (setq beg (prog1 end (setq end beg))))
  ;; Bind `comment-use-global-state' to nil.  While uncommenting a region
  ;; (which works a line at a time), a comment can appear to be
  ;; included in a mult-line string, but it is actually not.
  (let ((comment-use-global-state nil))
    (save-excursion
      (funcall uncomment-region-function beg end arg))))
;;end re-define uncomment region


;;;;;;;;;;;;;;;;;;INDENT FOR TAB COMMAND;;;;;;;;;;;;;
(setq INDENT_FOR_TAB_COMMAND_STRING "BFTM_INDENT_FOR_TAB_COMMAND_STRING_BFTM")

;;(fset 'prev-indent-for-tab-command (symbol-function 'indent-for-tab-command))


;;copied from indent.el.gz with bftm changes noted
(defun indent-for-tab-command (&optional arg)
  "Indent line in proper way for current major mode or insert a tab.
Depending on `tab-always-indent', either insert a tab or indent.
If initial point was within line's indentation, position after
the indentation.  Else stay at same point in text.
The function actually called to indent is determined by the value of
`indent-line-function'."
  (interactive "P")
  (cond
   ((or ;; indent-to-left-margin is only meant for indenting,
	;; so we force it to always insert a tab here.
	(eq indent-line-function 'indent-to-left-margin)
	(and (not tab-always-indent)
	     (or (> (current-column) (current-indentation))
		 (eq this-command last-command))))
;;original bftm    (insert-tab arg))
    (progn
      (if (bftm-checkfilename-p)
          (let ((other-args-1        (bftm-create-point-arg (point)))
                (other-args-2        (bftm-create-command-arg "insert-tab-command")))
            (write-string-to-file INDENT_FOR_TAB_COMMAND_STRING BFTM_EMPTY_FIELD buffer-file-name BFTM_GLOBAL_FILE_NAME other-args-1 other-args-2)))
      (insert-tab arg)))
    ;;end bftm mod
    
   ;; Those functions are meant specifically for tabbing and not for
   ;; indenting, so we can't pass them to indent-according-to-mode.
   ((memq indent-line-function '(indent-relative indent-relative-maybe))
;;original bftm    (funcall indent-line-function))
    (progn
      (if (bftm-checkfilename-p)
          (let ((other-args-1        (bftm-create-point-arg (point)))
                (other-args-2        (bftm-create-command-arg "indent-line-function")))
            (write-string-to-file INDENT_FOR_TAB_COMMAND_STRING BFTM_EMPTY_FIELD buffer-file-name BFTM_GLOBAL_FILE_NAME other-args-1 other-args-2)))
      (funcall indent-line-function)))
   ;;end bftm mod

    
   (t ;; The normal case.
;;original bftm    (indent-according-to-mode))))
    (progn
      (if (bftm-checkfilename-p)
          (let ((other-args-1        (bftm-create-point-arg (point)))
                (other-args-2        (bftm-create-command-arg "indent-according-to-mode")))
            (write-string-to-file INDENT_FOR_TAB_COMMAND_STRING BFTM_EMPTY_FIELD buffer-file-name BFTM_GLOBAL_FILE_NAME other-args-1 other-args-2)))
      (indent-according-to-mode)))))
;;end bftm mod



;;;;;;;;;;;;;;;;;;insert tab;;;;;;;;;;
(setq INSERT_TAB_COMMAND_STRING "BFTM_INDENT_REGION_COMMAND_STRING_BFTM")

(fset 'prev-insert-tab (symbol-function 'insert-tab))

(defun insert-tab (&optional arg)
  (if (bftm-checkfilename-p)
      (let ((other-args-1        (bftm-create-point-arg (point))))
        (write-string-to-file INSERT_TAB_COMMAND_STRING BFTM_EMPTY_FIELD buffer-file-name BFTM_GLOBAL_FILE_NAME other-args-1)))
  (prev-insert-tab arg))

;;;;;;;;
  


;;;;;;;;;;;;;;;;;;INDENT REGION;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq INDENT_REGION_COMMAND_STRING "BFTM_INDENT_REGION_COMMAND_STRING_BFTM")

(fset 'prev-indent-region (symbol-function 'indent-region))

(defun indent-region (start end &optional column)
  ;;apparently, the 'r' command is really important
  (interactive "r")
  (if (bftm-checkfilename-p)
      (let ((other-args-1        (bftm-create-start-arg start))
            (other-args-2        (bftm-create-end-arg   end)))
        (write-string-to-file INDENT_REGION_COMMAND_STRING BFTM_EMPTY_FIELD buffer-file-name BFTM_GLOBAL_FILE_NAME other-args-1 other-args-2)))
  (prev-indent-region start end column))


;;newly added

;;;;;;;;;;;;;;;;;;DELETE CHAR;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq DELETE_CHAR_COMMAND_STRING "BFTM_DELETE_CHAR_COMMAND_STRING_BFTM")

(fset 'prev-delete-char (symbol-function 'delete-char))


(defun  delete-char (count &optional killp)
  ;;apparently, the "*p\nP" command is really important
  (interactive "*p\nP")
  (if (bftm-checkfilename-p)
      (let ((other-args-1        (bftm-create-count-arg count))
            (other-args-2        (bftm-create-point-arg (point))))
        (write-string-to-file DELETE_CHAR_COMMAND_STRING BFTM_EMPTY_FIELD buffer-file-name BFTM_GLOBAL_FILE_NAME other-args-1 other-args-2)))
  (prev-delete-char count killp))


;;;;;;;;;;;;;;;;;;delete backward char;;;;;;;;;;;;;;;;;;;;;;;
(setq DELETE_BACKWARD_CHAR_COMMAND_STRING "BFTM_DELETE_BACKWARD_CHAR_COMMAND_STRING_BFTM")

(fset 'prev-delete-backward-char (symbol-function 'delete-backward-char))


(defun  delete-backward-char (count &optional killp)
  ;;apparently, the "*p\nP" command is really important
  (interactive "*p\nP")
  (if (bftm-checkfilename-p)
      (let ((other-args-1        (bftm-create-count-arg count))
            (other-args-2        (bftm-create-point-arg (point))))
        (write-string-to-file DELETE_BACKWARD_CHAR_COMMAND_STRING BFTM_EMPTY_FIELD buffer-file-name BFTM_GLOBAL_FILE_NAME other-args-1 other-args-2)))
  (prev-delete-backward-char count killp))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;transpose subr;;;;;;;;;;;;;;;;;
(setq TRANSPOSE_SUBR_COMMAND_STRING "BFTM_TRANSPOSE_SUBR_COMMAND_STRING_BFTM")

(fset 'prev-transpose-subr (symbol-function 'transpose-subr))

(defun transpose-subr (mover arg &optional special)
  ;;apparently, the "*p\nP" command is really important
  (if (bftm-checkfilename-p)
      (let ((other-args-1     (bftm-create-arg-arg arg)))
        (write-string-to-file TRANSPOSE_SUBR_COMMAND_STRING BFTM_EMPTY_FIELD buffer-file-name BFTM_GLOBAL_FILE_NAME other-args-1)))
  (prev-transpose-subr mover arg special))


