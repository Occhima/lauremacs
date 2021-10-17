(require 'window-purpose)

;;;###autoload
(defun lauremacs-pop-shell (shell-fn &rest shell-args)
	"Pop a shell in a bottom window.
SHELL-FN is the shell to be used, e.g. `shell', `ansi-term' etc.
SHELL-ARGS are the args passed to the SHELL-FN, e.g. \"/bin/zsh\"."
	(lexical-let ((shell-fn shell-fn) (shell-args shell-args))
		(lambda ()
			(interactive)
			(display-buffer-in-side-window
			 (save-window-excursion
				 (apply shell-fn shell-args)
				 (current-buffer))
			 '((side . bottom)))
			(select-window (purpose-get-bottom-window)))))

;;;###autoload
(defun lauremacs-pop-shell-cmd (cmd buff-name)
	"Pop a shell with some cmd executed.
CMD some shell command, e.g \"lein repl\".
BUFF-NAME the name of the buffer the where shell will be executed."
	(lexical-let ((cmd cmd) (buff-name buff-name))
		(lambda ()
			(interactive)
			(let ((buff (get-buffer-create buff-name)))
				(display-buffer-in-side-window buff '((side . bottom)))
				(projectile-with-default-dir (or (projectile-project-root) ".")
					(async-shell-command cmd buff-name (concat "error-" buff-name)))
				(set-window-dedicated-p (get-buffer-window buff) t)
				(select-window (purpose-get-bottom-window))))))

;;
;; eshell config
;;

(setq eshell-history-size         10000
      eshell-buffer-maximum-lines 10000
      eshell-hist-ignoredups t
      eshell-scroll-to-bottom-on-input t)

(use-package eshell-git-prompt
  :after eshell)

(use-package eshell
  :config
  (with-eval-after-load 'esh-opt
    (setq eshell-destroy-buffer-when-process-dies t)
    (setq eshell-visual-commands '("htop" "zsh" "vim")))
  (eshell-git-prompt-use-theme 'multiline)
	:init
	 ;; Save command history when commands are entered
  (add-hook 'eshell-pre-command-hook 'eshell-save-some-history))

;;
;; binds
;;

(lauremacs-leader
  "as" '(nil :which-key "shell")
	;; pop shell
  "ass" (list (lauremacs-pop-shell 'shell) :which-key "shell")
  "ase" (list (lauremacs-pop-shell 'eshell) :which-key "eshell")
	"ast" (list (lauremacs-pop-shell 'ansi-term "/bin/zsh") :which-key "ansi-term")
	"asi" (list (lauremacs-pop-shell 'ielm) :which-key "ielm")
	"ash" (list (lauremacs-pop-shell-cmd "ghci" "haskell-ghci") :which-key "haskell ghci")
	"asH" (list (lauremacs-pop-shell-cmd "stack ghci" "haskell-stack-ghci") :which-key "haskell stack ghci")
	"asn" (list (lauremacs-pop-shell-cmd "npx ts-node" "ts-node") :which-key "ts node")
	"asN" (list (lauremacs-pop-shell-cmd "node" "node") :which-key "node")
	"asc" (list (lauremacs-pop-shell-cmd "lein repl" "clojure-lein-repl") :which-key "clojure lein repl")
	;; full buffer shell
	"asf" '(nil :which-key "full buffer shell")
	"asfs" 'shell
  "asfe" 'eshell
	"asft" (list (fp/const-fn-interactive 'ansi-term "/bin/zsh") :which-key "ansi-term")
	"asfi" 'ielm)



