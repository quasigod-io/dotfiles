;; Removing visual clutter
(setq inhibit-startup-message t)
(scroll-bar-mode -1)
(tool-bar-mode -1)
(tooltip-mode -1)
(set-fringe-mode 10)
(menu-bar-mode -1)

;; Basic visual shits
(set-face-attribute 'default nil :font "JetBrains Mono" :height 125 :weight 'normal)
(global-display-line-numbers-mode 1)
(setq display-line-numbers-type 'relative)

(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

;; Disable line numbers for some modes
(dolist (mode '(org-mode-hook
                term-mode-hook
                shell-mode-hook
                treemacs-mode-hook
                eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

;; Initialize package sources
(require 'package)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))
(package-initialize)

(unless package-archive-contents
 (package-refresh-contents))

;; Initialize use-package on non-Linux platforms
(unless (package-installed-p 'use-package)
   (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

(use-package command-log-mode)

(use-package ivy
  :diminish
  :bind (("C-s" . swiper)
         :map ivy-minibuffer-map
         ("TAB" . ivy-alt-done)
         ("C-l" . ivy-alt-done)
         ("C-j" . ivy-next-line)
         ("C-k" . ivy-previous-line)
         :map ivy-switch-buffer-map
         ("C-k" . ivy-previous-line)
         ("C-l" . ivy-done)
         ("C-d" . ivy-switch-buffer-kill)
         :map ivy-reverse-i-search-map
         ("C-k" . ivy-previous-line)
         ("C-d" . ivy-reverse-i-search-kill))
  :config
  (ivy-mode 1))

(use-package ivy-rich 
  :init
  (ivy-rich-mode 1))

(use-package counsel
  :diminish
  :bind (("C-M-j" . 'counsel-switch-buffer)
         :map minibuffer-local-map
         ("C-r" . 'counsel-minibuffer-history))
  :custom
  (counsel-linux-app-format-function #'counsel-linux-app-format-function-name-only)
  :config
  (counsel-mode 1))

(use-package doom-themes
  :init (load-theme 'doom-one t))

(use-package all-the-icons)

(use-package doom-modeline
  :init (doom-modeline-mode 1)
  :custom ((doom-modeline-height 35)))

(use-package rainbow-delimiters
    :hook (prog-mode . rainbow-delimiters-mode))

(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 0.5))

(use-package helpful
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-key] . helpful-key))

(use-package evil
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-i-jump nil)
  :config
  (evil-mode 1)
  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
  (define-key evil-insert-state-map (kbd "C-h") 'evil-delete-backward-char-and-join)
  (setq evil-undo-system 'undo-redo)

  ;; Use visual line motions even outside of visual-line-mode buffers
  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line)

  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal))

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

(use-package general
  :after evil
  :config
  (general-create-definer quasi/leader-keys
    :keymaps '(normal insert visual emacs)
    :prefix "SPC"
    :global-prefix "C-SPC")

  (quasi/leader-keys
    "." '(counsel-find-file :which-key "find file")
    "," '(counsel-switch-buffer :which-key "switch buffer")
    ;; bookmarks
    "RET" '(:ignore t :which-key "bookmarks")
    "RET l" '(bookmark-bmenu-list :which-key "list bookmarks")
    "RET a" '(bookmark-set :which-key "add bookmark")
    "RET d" '(bookmark-delete :which-key "add bookmark")
    "RET RET" '(counsel-bookmark :Which-key "bookmarks")
    ;; buffers
    "b" '(:ignore t :which-key "buffers")
    "bs" '(save-buffer :which-key "save buffer")
    "bk" '(kill-current-buffer :which-key "kill current buffer")
    "bK" '(kill-buffer :which-key "kill buffer")
    "bw" '(kill-buffer-and-window :which-key "kill buffer and window")
    ;; help
    "h" '(:ignore t :which-key "help")
    "hp" '(describe-package :which-key "describe package")
    "hf" '(describe-function :which-key "describe function")
    "hv" '(describe-variable :which-key "describe variable")
    "hs" '(describe-symbol :which-key "describe symbol")
    "hm" '(describe-mode :which-key "describe mode")
    "hk" '(describe-mode :which-key "describe keymap")
    ;; quit
    "q" '(:ignore t :which-key "quit")
    "qq" '(save-buffers-kill-terminal :which-key "save+quit client")
    "qQ" '(save-buffers-kill-emacs :which-key "save+quit emacs")
    ;; toggle
    "t"  '(:ignore t :which-key "toggles")
    "tt" '(counsel-load-theme :which-key "choose theme")
    "fde" '(lambda () (interactive) (find-file (expand-file-name "~/.emacs.d/Emacs.org")))))

(use-package hydra)

(use-package magit
  :commands magit-status
  :custom
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))


(quasi/leader-keys
  "g" '(:ignore t :which-key "git")
  "gg" '(magit-status :which-key "status")
  "gd" '(magit-diff-unstaged :which-key "diff unstaged")
  "gc" '(magit-branch-or-checkout :which-key "branch or checkout")
  "gl" '(:ignore t :which-key "log")
  "glc" '(magit-log-current :which-key "current log")
  "glf" '(magit-log-buffer-file :which-key "file log")
  "gb" '(magit-branch :which-key "branch")
  "gP" '(magit-push-current :which-key "push")
  "gp" '(magit-pull-branch :which-key "pull branch")
  "gf" '(magit-fetch :which-key "fetch")
  "gF" '(magit-fetch-all :which-key "fetch all")
  "gr" '(magit-rebase :which-key "rebase"))

(defconst jetbrains-ligature-mode--ligatures
   '("-->" "//" "/**" "/*" "*/" "<!--" ":=" "->>" "<<-" "->" "<-"
     "<=>" "==" "!=" "<=" ">=" "=:=" "!==" "&&" "||" "..." ".."
     "|||" "///" "&&&" "===" "++" "--" "=>" "|>" "<|" "||>" "<||"
     "|||>" "<|||" ">>" "<<" "::=" "|]" "[|" "{|" "|}"
     "[<" ">]" ":?>" ":?" "/=" "[||]" "!!" "?:" "?." "::"
     "+++" "??" "###" "##" ":::" "####" ".?" "?=" "=!=" "<|>"
     "<:" ":<" ":>" ">:" "<>" "***" ";;" "/==" ".=" ".-" "__"
     "=/=" "<-<" "<<<" ">>>" "<=<" "<<=" "<==" "<==>" "==>" "=>>"
     ">=>" ">>=" ">>-" ">-" "<~>" "-<" "-<<" "=<<" "---" "<-|"
     "<=|" "/\\" "\\/" "|=>" "|~>" "<~~" "<~" "~~" "~~>" "~>"
     "<$>" "<$" "$>" "<+>" "<+" "+>" "<*>" "<*" "*>" "</>" "</" "/>"
     "<->" "..<" "~=" "~-" "-~" "~@" "^=" "-|" "_|_" "|-" "||-"
     "|=" "||=" "#{" "#[" "]#" "#(" "#?" "#_" "#_(" "#:" "#!" "#="
     "&="))

(sort jetbrains-ligature-mode--ligatures (lambda (x y) (> (length x) (length y))))

(dolist (pat jetbrains-ligature-mode--ligatures)
  (set-char-table-range composition-function-table
                      (aref pat 0)
                      (nconc (char-table-range composition-function-table (aref pat 0))
                             (list (vector (regexp-quote pat)
                                           0
                                    'compose-gstring-for-graphic)))))


(use-package projectile
  :diminish projectile-mode
  :config (projectile-mode)
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :init
  (when (file-directory-p "~/projects")
    (setq projectile-project-search-path '("~/projects")))
  (setq projectile-switch-project-action #'projectile-dired))

(use-package counsel-projectile
  :config (counsel-projectile-mode))

(quasi/leader-keys
  "p" '(:ignore t :which-key "projects")
  "pp" '(counsel-projectile-switch-project :which-key "switch projects")
  "pf" '(counsel-projectile-find-file :which-key "find project file")
  "pd" '(counsel-projectile-find-dir :which-key "find project file")
  "pb" '(counsel-projectile-switch-to-buffer :which-key "switch project buffer")
  "pd" '(project-dired :which-key "dired")
  "pk" '(project-kill-buffers :which-key "kill project buffers")
  "pr" '(counsel-projectile-rg :which-key "search project directory"))

(use-package evil-collection
  :init
  (evil-collection-init))

(setq evil-undo-system 'undo-redo)
