(require 'generic-x)

(define-generic-mode 'bantlr-mode                               ;;name of mode to create
  '(("//" . nil) ("/*" . "*/"))  ;;looks like comments
  '("todo" "toDo" "idea" "Idea");; looks like keywords
;;  '(("\\^" . 'font-lock-variable-name-face) ("[(){}:|?*+]" . 'font-lock-variable-name-face) ("(.*)?\\s" . 'font-lock-variable-name-face)) ;;operators
  '(("\\^" . 'font-lock-variable-name-face) ("[(){}:|?*+]" . 'font-lock-variable-name-face)) ;;operators
  '(".keymap\\'" ".map\\'")                                     ;;when this mode should be actie
  nil                                                           ;;other functions to call
  "Major mode for editing toDoList.txt." ;;
  )

  (make-local-variable 'font-lock-defaults)

(provide 'bantlr-mode)