;;
;; @author Laura Viglioni
;; 2021
;; GNU Public License 3.0
;;

;;
;; Always display candidates at bottom window
;;

(defvar spacemacs-helm-display-help-buffer-regexp '("\\*.*Helm.*Help.*\\*"))
(defvar spacemacs-helm-display-buffer-regexp `("\\*.*helm.*\\*"
                                               (display-buffer-in-side-window)
                                               (inhibit-same-window . nil)
                                               (side . bottom)
                                               (window-width . 0.6)
                                               (window-height . 0.4)))

(defun display-helm-at-bottom (buffer &optional _resume)
  (let ((display-buffer-alist (list spacemacs-helm-display-help-buffer-regexp
                                    spacemacs-helm-display-buffer-regexp)))
    (display-buffer buffer)))



;;
;; configs related to projectile, helm and neotree
;;

(use-package helm
  :bind (("M-x" . 'helm-M-x))
  :init
	(helm-mode 1)
	;; bindings
  (lauremacs-leader "<f19>" '(helm-M-x :which-key "M-x"))
	(general-define-key
	 :prefix "C-x"
	 "C-f" '(helm-find-files :which-key "find files")
	 "C-b" '(helm-buffers-list :which-key "list buffers"))
	(general-define-key
	 :prefix "C-h"
	 "a" '(helm-apropos :which-key "apropos")))

(use-package helm-swoop
  :init
  (lauremacs-leader
    "ss" '(helm-swoop :which-key "swoop")))

(use-package helm-descbinds
	:after helm
	:init (helm-descbinds-mode))

(use-package helm-flx
	:after helm
	:init (helm-flx-mode 1))

(use-package projectile
  :custom
	(projectile-sort-order 'recentf)
  (projectile-indexing-method 'native)
  (projectile-globally-ignored-directories
   '(
		 ".cache"
		 ".cask"
     ".eldev"
     ".git"
     ".log"
     ".next"
     ".nyc_output"
     ".pub-cache"
     ".rush"
     ".svn"
     ".vscode"
     "android"
     "bundle*"
     "coverage"
     "dist"
     "dist-*"
     "ios"
     "node_modules"
     "out"
     "repl"
     "rush"
     "target"
     "temp"
     "venv"
     "webnext/common"))
  (projectile-globally-ignored-files
   '(
     "*-lock.json"
     "*.chunk.*"
     "*.gz"
     "*.jar"
     "*.log"
     "*.png"
     "*.pyc"
     "*.tar.gz"
     "*.tgz"
     "*.zip"
     ".DS_Store"
     ".lein-repl-history"
     ".packages"
		 "*~"
     ))
  (projectile-project-search-path
   '("~/Loft/" "~/Personal/"))

  :init
  (projectile-mode 1)
	
  (lauremacs-leader
    "p" '(:keymap projectile-command-map
		  :package projectile
		  :which-key "projectile"))
	
	(projectile-register-project-type
	 'typescript '("tsconfig.json")
	 :project-file "package.json"
	 :src-dir "src"
	 :test-dir "test"
	 :test-suffix ".spec")
	
	(projectile-register-project-type
	 'typescript-react '("tsconfig.json" "__tests__")
	 :project-file "package.json"
	 :src-dir "src"
	 :test-dir "__tests__"
	 :test-suffix ".spec"))

(use-package helm-projectile
  :after (projectile helm)
  :init
  (lauremacs-leader
    "pp" '(helm-projectile-switch-project :which-key "switch project")
    "pf" '(helm-projectile-find-file :which-key "find file")))

(use-package helm-ag
  :after (helm-projectile)
  :init
  (lauremacs-leader "/" '(helm-projectile-grep :which-key "search in project")))

(use-package neotree
  :after (projectile)
  :init
  (lauremacs-leader
    "pt" '(neotree-toggle-project-dir :which-key "neotree toggle"))
  :custom
  (neo-theme (if (display-graphic-p) 'icons 'arrow))
  (neo-show-hidden-files t))
