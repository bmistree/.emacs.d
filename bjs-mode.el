(require 'generic-x)

(define-generic-mode 'bjs-mode                               ;;name of mode to create
  '(("//" . nil) ("/*" . "*/"))  ;;looks like comments
  '("if" "else" "do" "while" "function" "try" "catch" "finally" "||" "&&" "for" "boolean" "break" "case" "continue" "default" "delete" "double" "false" "true" "false" "final" "float" "in" "instanceof" "int" "long" "null" "new" "return" "short" "switch" "this" "throw" "true" "typeof" "var" "void" "with" "undefined");; looks like keywords
  '(("\+" . 'font-lock-variable-name-face) ("->" . 'font-lock-variable-name-face) ("<-" . 'font-lock-variable-name-face) ("/" . 'font-lock-variable-name-face) ("*" . 'font-lock-variable-name-face) ("-" . 'font-lock-variable-name-face))

  '(".keymap\\'" ".map\\'")                                     ;;when this mode should be actie
  nil                                                           ;;other functions to call
  "Major mode for editing emerson file." ;;
  )

  (make-local-variable 'font-lock-defaults)

(provide 'bjs-mode)