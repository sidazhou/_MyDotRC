;; sdMANUAL
;; GNU Emacs 24.3.1
;; http://ergoemacs.org/emacs/emacs_make_modern.html
(add-to-list 'load-path (expand-file-name "~/.emacs.d/sidz"))
(add-to-list 'load-path (expand-file-name "~/.emacs.d/sidz/expand-region"))

(defalias 'yes-or-no-p 'y-or-n-p)

;; (set-face-foreground 'minibuffer-prompt "white")
(set-face-foreground 'minibuffer-prompt "DarkGoldenrod")

(setq case-fold-search t)   ; make searches case insensitive

(defun search-selection (beg end)
  "search for selected text"
  (interactive "r")
  (let (
        (selection (buffer-substring-no-properties beg end))
       )
    (deactivate-mark)
    (isearch-mode t nil nil nil)
    (isearch-yank-string selection)
  )
)
(global-set-key (kbd "C-d") 'search-selection)


(require 'redo+)
(global-set-key (kbd "C-q") 'redo)


;; t means true, nil mean false
(setq line-move-visual nil)

;; stop creating those backup~ files
(setq make-backup-files nil)

;; stop creating those #auto-save# files
(setq auto-save-default nil)

(setq ring-bell-function 'ignore)

;; background?
;; (set-background-color "honeydew")
;; (add-to-list 'default-frame-alist '(background-color . "honeydew2"))

;; make {copy, cut, paste, undo} have {C-c, C-x, C-v, C-z} keys
(cua-mode 1)

;; turn on bracket match highlight
(show-paren-mode 1)

;; https://stackoverflow.com/questions/5710334/how-can-i-get-mouse-selection-to-work-in-emacs-and-iterm2-on-mac
;; Enable mouse support
(unless window-system
  (require 'mouse)
  (xterm-mouse-mode t)
  (global-set-key [mouse-4] (lambda ()
                             (interactive)
                             (scroll-down 1)))
  (global-set-key [mouse-5] (lambda ()
                             (interactive)
                             (scroll-up 1)))
  (defun track-mouse (e))
  (setq mouse-sel-mode t)

  ;; scroll one line at a time (less "jumpy" than defaults)
  (setq mouse-wheel-scroll-amount '(1 ((shift) . 1) ((control) . nil)))
  (setq mouse-wheel-progressive-speed nil) ;; don't accelerate scrolling
  (setq mouse-wheel-follow-mouse 't) ;; scroll window under mouse
  (setq scroll-step 1) ;; keyboard scroll one line at a time
  (setq scroll-conservatively 101)
)


(setq echo-keystrokes -1)


;; auto insert closing bracket
(electric-pair-mode 1)

;; remember cursor position. When file is opened, put cursor at last position
(if (version< emacs-version "25.0")
    (progn
      (require 'saveplace)
      (setq-default save-place t))
  (save-place-mode 1))

;; always show line numbers
(global-linum-mode 1)
(setq linum-format "%3d\u2502 ")

;; The following commands let you move by paragraph in a predictable way, regardless what major mode you are in
(defun xah-forward-block (&optional n)
  "Move cursor beginning of next text block.
A text block is separated by blank lines.
This command similar to `forward-paragraph', but this command's behavior is the same regardless of syntax table.
URL `http://ergoemacs.org/emacs/emacs_move_by_paragraph.html'
Version 2016-06-15"
  (interactive "p")
  (let ((n (if (null n) 1 n)))
    (re-search-forward "\n[\t\n ]*\n+" nil "NOERROR" n)))

(defun xah-backward-block (&optional n)
  "Move cursor to previous text block.
See: `xah-forward-block'
URL `http://ergoemacs.org/emacs/emacs_move_by_paragraph.html'
Version 2016-06-15"
  (interactive "p")
  (let ((n (if (null n) 1 n))
        ($i 1))
    (while (<= $i n)
      (if (re-search-backward "\n[\t\n ]*\n+" nil "NOERROR")
          (progn (skip-chars-backward "\n\t "))
        (progn (goto-char (point-min))
               (setq $i n)))
      (setq $i (1+ $i)))))
(global-unset-key (kbd "<C-up>"))
(global-unset-key (kbd "<C-down>"))
(global-set-key (kbd "<C-up>") 'xah-backward-block)
(global-set-key (kbd "<C-down>") 'xah-forward-block)




(defun xah-select-text-in-quote ()
  "Select text between the nearest left and right delimiters.
Delimiters here includes the following chars: \"<>(){}[]“”‘’‹›«»「」『』【】〖〗《》〈〉〔〕（）
This command select between any bracket chars, not the inner text of a bracket. For example, if text is

 (a(b)c▮)

 the selected char is “c”, not “a(b)c”.

URL `http://ergoemacs.org/emacs/modernization_mark-word.html'
Version 2016-12-18"
  (interactive)
  (let (
        ($skipChars
         (if (boundp 'xah-brackets)
             (concat "^\"" xah-brackets)
           "^\"<>(){}[]“”‘’‹›«»「」『』【】〖〗《》〈〉〔〕（）"))
        $pos
        )
    (skip-chars-backward $skipChars)
    (setq $pos (point))
    (skip-chars-forward $skipChars)
    (set-mark $pos)))

(defun xah-select-line ()
  "Select current line. If region is active, extend selection downward by line.
URL `http://ergoemacs.org/emacs/modernization_mark-word.html'
Version 2017-11-01"
  (interactive)
  (if (region-active-p)
      (progn
        (forward-line 1)
        (end-of-line))
    (progn
      (end-of-line)
      (set-mark (line-beginning-position)))))



(defun xah-select-current-line ()
  "Select current line.
URL `http://ergoemacs.org/emacs/modernization_mark-word.html'
Version 2016-07-22"
  (interactive)
  (end-of-line)
  (set-mark (line-beginning-position)))


(defun xah-select-block ()
  "Select the current/next block of text between blank lines.
If region is active, extend selection downward by block.

URL `http://ergoemacs.org/emacs/modernization_mark-word.html'
Version 2017-11-01"
  (interactive)
  (if (region-active-p)
      (re-search-forward "\n[ \t]*\n" nil "move")
    (progn
      (skip-chars-forward " \n\t")
      (when (re-search-backward "\n[ \t]*\n" nil "move")
        (re-search-forward "\n[ \t]*\n"))
      (push-mark (point) t t)
      (re-search-forward "\n[ \t]*\n" nil "move"))))


(defun xah-select-current-block ()
  "Select the current block of text between blank lines.

URL `http://ergoemacs.org/emacs/modernization_mark-word.html'
Version 2017-07-02"
  (interactive)
  (progn
    (skip-chars-forward " \n\t")
    (when (re-search-backward "\n[ \t]*\n" nil "move")
      (re-search-forward "\n[ \t]*\n"))
    (push-mark (point) t t)
    (re-search-forward "\n[ \t]*\n" nil "move")))

(global-set-key (kbd "C-k") 'xah-select-block)
(global-set-key (kbd "C-l") 'xah-select-line)
;;(global-set-key (kbd "C-o") 'xah-select-text-in-quote)


(require 'expand-region)
(global-set-key (kbd "C-p") 'er/expand-region)
(global-set-key (kbd "C-o") 'er/contract-region)



(defun comment-or-uncomment-region-or-line ()
    "Comments or uncomments the region or the current line if there's no active region."
    (interactive)
    (let (beg end)
        (if (region-active-p)
            (setq beg (region-beginning) end (region-end))
            (setq beg (line-beginning-position) end (line-end-position)))
        (comment-or-uncomment-region beg end)))
(global-unset-key (kbd "C-_"))
(global-set-key (kbd "C-_") 'comment-or-uncomment-region-or-line)




;;(progn
 ;; make emacs use standard keys

  ;; Select All. was move-beginning-of-line
  ;; (global-set-key (kbd "C-a") 'mark-whole-buffer-buffer)

  ;; Find. was forward-char
  ;; (global-set-key (kbd "C-f") 'isearch-forward)

  ;; New. was next-line
  ;;(global-set-key (kbd "C-n") 'xah-new-empty-buffer)

  ;; New Window. was nil
  ;;(global-set-key (kbd "C-S-n") 'make-frame-command)

  ;; Open. was open-line
  ;;(global-set-key (kbd "C-o") 'ido-find-file)

  ;; Save. was isearch-forward
  ;; (global-set-key (kbd "C-s") 'save-buffer)

  ;; Save As. was nil
  ;;(global-set-key (kbd "C-S-s") 'write-file)

  ;; Paste. was scroll-up-command
  ;;(global-set-key (kbd "C-v") 'yank)

  ;; Close. was kill-region
  ;;(global-set-key (kbd "C-w") 'kill-buffer)

  ;; Redo. was yank
  ;;(global-set-key (kbd "C-S-z") 'redo)

  ;; Undo. was suspend-frame
  ;;(global-set-key (kbd "C-z") 'undo)

;;)

