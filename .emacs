(global-set-key (kbd "M-g") 'goto-line)
(add-to-list 'load-path "~/.emacs.d/")
(require 'sr-speedbar)
(require 'auto-complete-config)
(require 'json-mode)
(ac-config-default)
(require 'go-autocomplete)
(add-hook 'go-mode-hook 'go-eldoc-setup)
(define-key ac-mode-map (kbd "M-TAB") 'auto-complete)
(add-hook
 'go-mode-hook
 '(lambda ()

    ;; Imenu & Speedbar

    (setq imenu-generic-expression
          '(("type" "^type *\\([^ \t\n\r\f]*\\)" 1)
            ("func" "^func *\\(.*\\) {" 1)))
    (imenu-add-to-menubar "Index")

    ;; Outline mode

    (make-local-variable 'outline-regexp)
    (setq outline-regexp "//\\.\\|//[^\r\n\f][^\r\n\f]\\|pack\\|func\\|impo\\|cons\\|var.\\|type\\|\t\t*....")
    (outline-minor-mode 1)
    (local-set-key "\M-a" 'outline-previous-visible-heading)
    (local-set-key "\M-e" 'outline-next-visible-heading)

    ;; Menu bar

    (require 'easymenu)
    (defconst go-hooked-menu
      '("Go tools"
        ["Go run buffer" go t]
        ["Go build buffer" go-build t]
        ["Go build directory" go-build-dir t]
        ["Go reformat buffer" go-fmt-buffer t]
        ["Go check buffer" go-fix-buffer t]))
    (easy-menu-define
      go-added-menu
      (current-local-map)
      "Go tools"
      go-hooked-menu)

    ;; Other

    (setq tab-width 4)
    (setq show-trailing-whitespace t)

    ))

;; helper function
(defun go ()
  "run current buffer"
  (interactive)
  (compile (concat "go run " (buffer-file-name))))

;; helper function
(defun go-build ()
  "build current buffer"
  (interactive)
  (compile (concat "go build " (buffer-file-name))))

;; helper function
(defun go-build-dir ()
  "build current directory"
  (interactive)
  (compile "go build ."))

;; helper function
(defun go-fmt-buffer ()
  "run gofmt on current buffer"
  (interactive)
  (if buffer-read-only
    (progn
      (ding)
      (message "Buffer is read only"))
    (let ((p (line-number-at-pos))
	    (filename (buffer-file-name))
	      (old-max-mini-window-height max-mini-window-height))
      (show-all)
      (if (get-buffer "*Go Reformat Errors*")
	    (progn
	          (delete-windows-on "*Go Reformat Errors*")
		      (kill-buffer "*Go Reformat Errors*")))
      (setq max-mini-window-height 1)
      (if (= 0 (shell-command-on-region (point-min) (point-max) "gofmt" "*Go Reformat Output*" nil "*Go Reformat Errors*" t))
	    (progn
	          (erase-buffer)
		      (insert-buffer-substring "*Go Reformat Output*")
		          (goto-char (point-min))
			      (forward-line (1- p)))
	(with-current-buffer "*Go Reformat Errors*"
	    (progn
	          (goto-char (point-min))
		      (while (re-search-forward "<standard input>" nil t)
			      (replace-match filename))
		          (goto-char (point-min))
			      (compilation-mode))))
      (setq max-mini-window-height old-max-mini-window-height)
      (delete-windows-on "*Go Reformat Output*")
      (kill-buffer "*Go Reformat Output*"))))

;; helper function
(defun go-fix-buffer ()
  "run gofix on current buffer"
  (interactive)
  (show-all)
  (shell-command-on-region (point-min) (point-max) "go tool fix -diff"))
(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(speedbar-supported-extension-expressions (quote (".[ch]\\(\\+\\+\\|pp\\|c\\|h\\|xx\\)?" ".tex\\(i\\(nfo\\)?\\)?" ".el" ".emacs" ".l" ".lsp" ".p" ".java" ".js" ".f\\(90\\|77\\|or\\)?" ".ada" ".p[lm]" ".tcl" ".m" ".scm" ".pm" ".py" ".g" ".s?html" ".ma?k" "[Mm]akefile\\(\\.in\\)?" ".go"))))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 )
