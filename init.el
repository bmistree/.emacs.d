;#####################################################################
; .emacs
;
; Emacs configuration file
; Original by Jerry Talton (jtalton@cs.stanford.edu)
; Modified by Ewen Cheslack-Postava (ewencp@cs.stanford.edu)
; Modified by Behram Mistree (bmistree@stanford.edu)
; Sets up a nice configuration for coding and writing -- C, C++, Ruby,
; Python, LaTeX, and so on.  Note that personal information is stored
; in personality.el to isolate modifications necessary to personalize
; a copy of this setup.
;
;#####################################################################


;;; Copied from https://melpa.org/#/
(require 'package)
(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
                    (not (gnutls-available-p))))
       (proto (if no-ssl "http" "https")))
  (when no-ssl
    (warn "\
Your version of Emacs does not support SSL connections,
which is unsafe because it allows man-in-the-middle attacks.
There are two things you can do about this warning:
1. Install an Emacs version that does support SSL and be safe.
2. Remove this warning from your init file so you won't see it again."))
  ;; Comment/uncomment these two lines to enable/disable MELPA and MELPA Stable as desired
  (add-to-list 'package-archives (cons "melpa" (concat proto "://melpa.org/packages/")) t)
  ;;(add-to-list 'package-archives (cons "melpa-stable" (concat proto "://stable.melpa.org/packages/")) t)
  (when (< emacs-major-version 24)
    ;; For important compatibility libraries like cl-lib
    (add-to-list 'package-archives (cons "gnu" (concat proto "://elpa.gnu.org/packages/")))))
(package-initialize)

;;; Packages manually installed:
;;;;; M-x package-install json-mode

;; Additional commands

; Don't wait for the window manager if it takes a long time
(modify-frame-parameters nil '((wait-for-wm . nil)))

; Disable the splash screen, which hides the document opened and is
; useless anyway
(setq inhibit-splash-screen t)

; Use .emacs.d for .el files
(add-to-list 'load-path "~/.emacs.d/load-path/")


; Personality stuff
(require 'personality)
(require 'todo-mode)
(require 'cursors)
(require 'cc-mode)
(require 'mouse-drag)
(require 'helper)

(require 'protobuf-mode)
  (defconst my-protobuf-style
    '((c-basic-offset . 4)
      (indent-tabs-mode . nil)))

(add-hook 'protobuf-mode-hook
          (lambda () (c-add-style "my-style" my-protobuf-style t)))


(setq load-path (cons (expand-file-name "~/.emacs.d/load-path")
                      load-path))
(autoload 'bantlr-mode "bantlr-mode" "to edit antlr files." t)
(autoload 'bjs-mode "bjs-mode" "to edit antlr files." t)
(autoload 'ruby-mode "ruby-mode" "Ruby editing mode." t)
(autoload 'caml-mode "caml" "Major mode for editing Caml code." t)
(autoload 'run-caml "inf-caml" "Run an inferior Caml process." t)
(autoload 'glsl-mode "glsl-mode" nil t)
(autoload 'ansi-color-for-comint-mode-on "ansi-color" nil t)
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)
(autoload 'csharp-mode "csharp-mode" "Major mode for editing C# code." t)
(autoload 'cmake-mode "cmake-mode" "Major mode for editing CMake build scripts." t)
(autoload 'js2-mode "js2" nil t)
(autoload 'espresso-mode "espresso-mode" nil t)


; Set default mode for new buffers to text
(setq default-major-mode 'text-mode)

; Put temp files somewhere they won't bother me, and delete old ones
(setq make-backup-files t)
(setq version-control t)
(setq backup-directory-alist (quote ((".*" . "~/.emacs_backups/"))))
(setq delete-old-versions t)
(setq delete-auto-save-files t)

; Make executabe after saving if #! is in the first line
(add-hook 'after-save-hook 'executable-make-buffer-file-executable-if-script-p)

; Always show me column numbers
(setq column-number-mode t)

; Make searches case-INsensitive
(set-default 'case-fold-search t)

; Stop forcing me to type "yes"
(fset 'yes-or-no-p 'y-or-n-p)

; Highlight matching braces
(load-library "paren")
(show-paren-mode t)

; Use the Command key for meta on Macs
(defvar macosx-p (string-match "darwin" (symbol-name system-type))
(if macosx-p (progn (setq mac-command-key-is-meta nil))))

(autoload 'cycle-buffer "cycle-buffer" "Cycle forward." t)
(autoload 'cycle-buffer-backward "cycle-buffer" "Cycle backward." t)

;;Comment region
(global-unset-key (kbd "C-x C-i"))
(global-set-key (kbd "C-x C-i") 'comment-region)
(global-unset-key (kbd "C-x C-u"))
(global-set-key (kbd "C-x C-u") 'uncomment-region)

;; Cycle buffers
(global-unset-key (kbd "C-x C-n"))
(global-set-key (kbd "C-x C-n") 'cycle-buffer)

(global-unset-key (kbd "C-x C-m"))
(global-set-key (kbd "C-x C-m") 'cycle-buffer-backward)

;; Indentation
(global-unset-key (kbd "C-x C-l"))
(global-set-key (kbd "C-x C-l") 'shift-indent-right)

(global-unset-key (kbd "C-x C-j"))
(global-set-key (kbd "C-x C-j") 'shift-indent-left)

;; Change behavior of splitting windows to match tmux
(global-set-key (kbd "C-x h") 'split-window-horizontally)
(global-set-key (kbd "C-x v") 'split-window-vertically)

;; Etc.
(global-unset-key (kbd "C-u"))
(global-set-key (kbd "C-u") 'backward-kill-word)



(global-set-key [down-mouse-2] 'mouse-drag-drag)

; Global color and fonts
(setq default-frame-alist
      '(
        (font             .  "Monospace-14")
        (width            .     156 )
        (height           .     50 )
        (mouse-color      . "White")
        (cursor-color     . "White")
        (foreground-color . "gray95")
))
        ;; (background-color . "#212121")))

; Turn on highlighting with CTRL-X w h and CTRL-X w r
(if (functionp 'global-hi-lock-mode)
    (global-hi-lock-mode 1)
  (hi-lock-mode 1))

; Make the modeline a little more inconspicuous...
;; (set-face-background 'modeline "#202020")
;; (set-face-foreground 'modeline "#C0C0C0")

; Make emacs stop bugging me about symlinks
(setq vc-follow-symlinks t)

; Make all tabs spaces by default
(setq-default indent-tabs-mode nil)

; Set up the mode-specific font locking
;;bftm commented out when upgraded to 11.04
;; (global-font-lock-mode t nil)
(setq font-lock-maximum-decoration t)

(setq auto-mode-alist
      (append
       (list
        '("\\.C$"         . c++-mode)
        '("\\.h$"         . c++-mode)
        '("\\.c\\+\\+$"   . c++-mode)
        '("\\.H$"         . c++-mode)
        '("\\.cu$"        . c++-mode)
        '("\\.rb$"        . ruby-mode)
        '("\\.el$"        . emacs-lisp-mode)
        '("emacs$"        . emacs-lisp-mode)
        '("\\.tar$"       . tar-mode)
        '("make\\.log\\~" . compilation-mode)
        '("Makefile$"     . makefile-mode)
        '("Makefile.*"    . makefile-mode)
        '("\\.vert\\'"    . glsl-mode)
        '("\\.frag\\'"    . glsl-mode)
        '("\\.py\\'"      . python-mode)
        '("SConscript"    . python-mode)
        '("\\.ml[iylp]?$" . caml-mode)
        '("\\.php$"       . php-mode)
        '("\\.cs$"        . csharp-mode)
        '("CMakeLists\\.txt\\'" . cmake-mode)
        '("\\.wld$"   . c++-mode)
        '("\\.rph$"   . c++-mode)
        '("\\.x$"   . c++-mode)
        '("\\.cmake\\'"   . cmake-mode)
        ;'("\\.doc\\'"     . c++-mode) ; Doxygen docs use C++ comments
        '("\\.js\\'"      . js2-mode)
        '("\\.json\\'"    . js2-mode)
        '("\\.em\\'"      . js2-mode)
        '("\\.g\\'"      . bantlr-mode)
        '("\\.proto\\'"    . protobuf-mode)
        '("\\.go\\'"    . go-mode)
        '("\\.m\\'"    . matlab-mode)
        )
       auto-mode-alist))



(make-face            'nick-url-face)
(set-face-foreground  'nick-url-face "Blue")
(set-face-underline-p 'nick-url-face t)

; Remove those pesky scrollbars - they just take up space
(if (fboundp 'scroll-bar-mode)
    (scroll-bar-mode nil)
  )

; Remove stupid toolbar
(if (fboundp 'tool-bar-mode)
    (tool-bar-mode nil)
  )

; In case of extra buttons
(global-set-key [mouse-4] 'scroll-down)
(global-set-key [mouse-5] 'scroll-up)

; Quick access to files and tags
(setq speedbar-use-imenu-flag 't)

; Hooks, hooks, and more hooks
(defconst text-mode-hook
  '(lambda ()
     (defconst fill-column 70)
     (defconst tab-stop-list
       (list 8 12 16 20 24 28 32 36 40 44 48 52 56 60 64 68 72 76 80))
     (auto-fill-mode 1)
     (transient-mark-mode 1)))

(defconst shell-mode-hook
  '(lambda ()
     (defconst comint-scroll-show-maximum-output 't)
     (defconst comint-scroll-to-bottom-on-input 't)
     (defconst comint-scroll-show-maximum-output 't)
     (defconst comint-output-filter-functions
       '(comint-postoutput-scroll-to-bottom comint-strip-ctrl-m))))

(defconst ediff-startup-hook
  '(lambda ()
     (ediff-toggle-split)))

;;bftm
(defconst makefile-mode-hook
  '(lambda ()
     (run-hooks 'text-mode-hook)
     (auto-fill-mode)
     ))

(defconst btodo-mode-hook
    '(lambda ()
     (defconst fill-column nil)
     ))

(defconst bjs-mode-hook
    '(lambda ()
     (defconst fill-column nil)
     (setq-default indent-tabs-mode nil)
     (setq-default tab-width 4)
     (setq indent-line-function 'insert-tab)
     ))

(defconst latex-mode-hook
  '(lambda ()
     (run-hooks 'text-mode-hook)
     (defconst fill-column 70) ; Every other time
     (auto-fill-mode 1)))


(defconst html-mode-hook
  '(lambda ()
     (defconst fill-column 80) ; Every other time
     (auto-fill-mode 1)))


(defconst js2-mode-hook
  '(lambda ()
     (defconst fill-column 400) ; Every other time
     (auto-fill-mode 1)))
;; end bftm


; tex stuff
(setq tex-dvi-view-command "xdvi")

;;bftm commented out when upgraded to 11.04
;; (global-font-lock-mode t nil)
(setq-default font-lock-maximum-decoration t)
(setq scroll-preserve-screen-position nil)

;#####################################################################
; Style stuff
;####################################################################
;(setq font-lock-support-mode 'lazy-lock-mode)


;;quoted text in c++
(set-face-foreground  'font-lock-string-face "HotPink1")

;;comments in c++
;;(set-face-foreground  'font-lock-comment-face "#94AFE6")
(set-face-foreground  'font-lock-comment-face "DarkOrange")
(set-face-foreground  'font-lock-warning-face "#FC0B0C")

;;bftm
;;class name in class::
(set-face-foreground  'font-lock-function-name-face "MediumOrchid1")
;;namespace in c++
(set-face-foreground  'font-lock-keyword-face "cyan2")

(set-face-foreground  'font-lock-constant-face "#F09E9F")

;;iterator in c++  currently yellowish
(set-face-foreground  'font-lock-type-face "#FFDC78")

;;variable names in c++
(set-face-foreground  'font-lock-variable-name-face "gray95")

;;brackets and -> in c++
(set-face-foreground  'font-lock-operators-face "#F7B683")

;;includes and #defines in c++
(set-face-foreground  'font-lock-preprocessor-face "#FC0B0C")

;; (set-face-background  'show-paren-match-face "SlateBlue3")
(set-face-background  'region "#502020")



; Setup C++ style
(defconst c-mode-hook
  '(lambda ()
     (c-set-style "jerry")
     (run-hooks 'text-mode-hook)
     (auto-fill-mode t)
     (defconst fill-column 80)
     (setq truncate-lines nil)
     (line-number-mode 1)
     (c-toggle-hungry-state 1)
     (imenu-add-menubar-index)))

(defconst c++-mode-hook
  '(lambda ()
     (run-hooks 'c-mode-hook)))

(defconst csharp-mode-hook
  '(lambda ()
     (run-hooks 'c-mode-hook)))

(defconst asm-mode-set-comment-hook
  '(lambda ()
     (setq asm-comment-char ?\#)))

; Javascript stuff

; sourced from mihai.bazon.net/projects/editing-javascript-with-emacs-js2-mode
(defun js2-indent-function ()
  (interactive)
  (save-restriction
    (widen)
    (let* ((inhibit-point-motion-hooks t)
           (parse-status (save-excursion (syntax-ppss (point-at-bol))))
           (offset (- (current-column) (current-indentation)))
           (indentation (espresso--proper-indentation parse-status))
           node)

      (save-excursion

        ;; I like to indent case and labels to half of the tab width
        (back-to-indentation)
        (if (looking-at "case\\s-")
            (setq indentation (+ indentation (/ espresso-indent-level 2))))

        ;; consecutive declarations in a var statement are nice if
        ;; properly aligned, i.e:
        ;;
        ;; var foo = "bar",
        ;;     bar = "foo";
        (setq node (js2-node-at-point))
        (when (and node
                   (= js2-NAME (js2-node-type node))
                   (= js2-VAR (js2-node-type (js2-node-parent node))))
          (setq indentation (+ 4 indentation))))

      (indent-line-to indentation)
      (when (> offset 0) (forward-char offset)))))

(defun js2-mode-hook ()
  (require 'espresso)
  (auto-fill-mode t)
  (defconst fill-column 80)
  (setq espresso-indent-level 8
        indent-tabs-mode nil
        c-basic-offset 8)
  (c-toggle-auto-state 0)
  (c-toggle-hungry-state 1)
  (set (make-local-variable 'indent-line-function) 'my-js2-indent-function)
  (define-key js2-mode-map [(meta control |)] 'cperl-lineup)
  (define-key js2-mode-map [(meta control \;)]
    '(lambda()
       (interactive)
       (insert "/* -----[ ")
       (save-excursion
         (insert " ]----- */"))
       ))
  (define-key js2-mode-map [(return)] 'newline-and-indent)
  (define-key js2-mode-map [(backspace)] 'c-electric-backspace)
  (define-key js2-mode-map [(control d)] 'c-electric-delete-forward)
  (if (featurep 'js2-highlight-vars)
    (js2-highlight-vars-mode))
  (message "My JS2 hook"))
(add-hook 'js2-mode-hook 'my-js2-mode-hook)

;#####################################################################
; extra binds
;#####################################################################
(global-set-key (kbd "M-o") 'header-flip)
(global-set-key (kbd "M-[ d") 'backward-word)
(global-set-key (kbd "M-[ c") 'forward-word)
(global-set-key (kbd "M-<f12>") 'eval-current-buffer)
(global-set-key (kbd "M-g") 'goto-line)



(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(column-number-mode t)
 '(load-home-init-file t t)
 '(package-selected-packages (quote (json-mode)))
 '(show-paren-mode t))


;;bftm added named window
(setq frame-title-format (concat  "%b - emacs@" system-name))
(add-to-list 'default-frame-alist '(foreground-color . "green"))




;;;;;;;;;;;Beginning of experimentation;;;;;;;;;;;;;;;;;;;;
;(require 'keylogger)

;;This way, don't have dumb formatting:
;; public void function (
;;                       int arg1,
;;                       int arg2)
;;{}
(defun my-indent-setup ()
  (c-set-offset 'arglist-intro '+))
(add-hook 'java-mode-hook 'my-indent-setup)

;; this way, don't have dumb formatting:
;; if ()
;;   {
;;       something;
;;   }
;;
(setq c-default-style "bsd"
      c-basic-offset 4)


;; (add-hook 'go-mode-hook
;;   (lambda ()
;;     (setq-default)
;;     (setq tab-width 4)
;;     (setq standard-indent 2)
;;     (setq indent-tabs-mode nil)))

; make it so that underscores are treated as delimiters (ie, ctrl-d on
; hello_this will leave hello)
(add-hook 'go-mode-hook
          (lambda () (modify-syntax-entry ?_ "-")))

;; Goal: when use ctrl-j (newline-and-indent), remove trailing
;; whitespace at end of line just returned from (or all lines in
;; document).  (Previously, had added a save hook, which would remove
;; all trailing whitespaces.  This was not good though because I
;; frequently save after adding a whitespace, and I kept adding a
;; space, saving, and removing the space I just added.)
(defconst old-newline-and-indent
  (symbol-function 'newline-and-indent))
(defun newline-and-indent
  (&rest args) (interactive)
  (delete-trailing-whitespace)
  (apply old-newline-and-indent args))

;; When kill word (eg., using meta-d), will kill each hump of
;; camel-case separately.  Ie., before this, if entered the word
;; "toDelete", and then meta-d at beginning of line would get blank
;; line.  With this change, will delete "to" and leave "Delete".
(global-subword-mode t)
