;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Zihao"
      user-mail-address "lzh401770@alibaba-inc.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-solarized-light)
(setq doom-font (font-spec :family "Iosevka" :size 17))

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)


;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;; (define-key evil-normal-state-map (kbd "j") 'evil-next-visual-line)
;; (define-key evil-normal-state-map (kbd "k") 'evil-previous-visual-line)
;; (define-key evil-visual-state-map (kbd "j") 'evil-next-visual-line)
;; (define-key evil-visual-state-map (kbd "k") 'evil-previous-visual-line)
(setq lsp-pyright-python-executable-cmd "python3")
;; ;; to debug with DAP-MODE
;; (setq dap-auto-configure-mode t)
;; (require 'dap-cpptools)

;; Org-mode config
(after! org
  (setq org-directory "~/org/")
  (setq org-agenda-files '("~/org/agenda.org"))
  (setq org-log-done 'time)
  (setq org-hugo-base-dir "~/Documents/blog/")
  )
;; Org mode
(add-hook 'org-mode-hook #'org-modern-mode)
(add-hook 'org-agenda-finalize-hook #'org-modern-agenda)
(setq org-hide-emphasis-markers t)
(add-hook 'org-mode-hook 'org-appear-mode)
;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


(map! :leader
      :n
      :desc "enable auto format"
      "c f" #'format-all-mode)

;; Wezterm
(defun open-in-wezterm () (interactive)
       (let ((workdir (if (projectile-project-root)
                          (projectile-project-root)
                        default-directory)))
         (start-process-shell-command "wezterm" nil
                                      (concat "wezterm start --cwd " workdir))))
(global-set-key (kbd "C-t") #'+vterm/toggle)
(map! :leader
      :n
      :desc "open in wezterm"
      "o T" #'open-in-wezterm)


;; cpp
(c-add-style "work"
             '((c-offsets-alist
                (access-label . -))))

;; Setting this as the default style:
(setq c-default-style "work")


;; Rust
(set-formatter!
  'cargo-fmt
  '("rustfmt" "--edition" "2021")
  :modes '(rustic-mode)
  )
(setq lsp-rust-analyzer-cargo-watch-command "clippy")
(setq rustic-enable-detached-file-support 't)


;; Proxy
(setq url-proxy-services
      '(("no_proxy" . "^\\(localhost\\|10\\..*\\|192\\.168\\..*\\)")
        ("http" . "127.0.0.1:7890")
        ("https" . "127.0.0.1:7890")))

;; Wakatime
(global-wakatime-mode)

;; Tree-sitter
(global-tree-sitter-mode)
(global-ts-fold-mode)

;; Github copilot
(use-package! copilot
  ;; :hook (prog-mode . copilot-mode)
  :bind (("C-TAB" . 'copilot-accept-completion-by-word)
         ("C-<tab>" . 'copilot-accept-completion-by-word)
         :map copilot-completion-map
         ("<tab>" . 'copilot-accept-completion)
         ("TAB" . 'copilot-accept-completion)))

;; Auto complete tuning
(setq company-auto-select-first-candidate nil)

;; fcitx
;; (require 'evil-fcitx)


;; Leetcode Plugin
(setq leetcode-prefer-language "rust")
(setq leetcode-save-solutions t)
(setq leetcode-directory "~/.leetcode")

;; Auto switch dark/light themes
(defun my/apply-theme (appearance)
  "Load theme, taking current system APPEARANCE into consideration."
  (mapc #'disable-theme custom-enabled-themes)
  (pcase appearance
    ('light (load-theme 'doom-solarized-light t))
    ('dark (load-theme 'doom-dark+ t))))

(if (eq system-type 'darwin)
                                        ; something for OS X if true
                                        ; optional something if not
    (progn
      (my/apply-theme ns-system-appearance)
      (add-hook 'ns-system-appearance-change-functions #'my/apply-theme))
  )

(setq frame-resize-pixelwise t)

(set-file-template! ".*\.h(pp)?" :trigger "__new_header.hpp" :mode 'c++-mode)
;; (setq +lsp-company-backends '(company-capf :with company-yasnippet))
(set-company-backend! 'prog-mode '(company-capf :with company-yasnippet company-dabbrev company-dabbrev-code))
;; (setq company-backends '(:seperate company-capf company-yasnippet company-dabbrev company-dabbrev-code))

(defun eshell/mkcd(folder)
  (eshell/mkdir "-p" folder)
  (eshell/cd folder))
(defun eshell/myproxy()
  (eshell/export "HTTP_PROXY=http://localhost:7890")
  (eshell/export "HTTPS_PROXY=http://localhost:7890")
  (eshell/export "ALL_PROXY=http://localhost:7890")
  )
(defun eshell/unproxy()
  (eshell/export "HTTP_PROXY=")
  (eshell/export "HTTPS_PROXY=")
  (eshell/export "ALL_PROXY=")
  )

(add-hook 'before-save-hook 'time-stamp)
(setq time-stamp-pattern (concat "15/.*LastModified:\\\\?[ \t]+%:y-%02m-%02d %02H:%02M:%02S\\\\?$"))

(setq treemacs-follow-after-init t)
(map! :g "s-d" 'evil-multiedit-match-symbol-and-next)
(map! :g "s-D" 'evil-multiedit-match-symbol-and-prev)
(map! :g "s-h" 'centaur-tabs-backward)
(map! :g "s-l" 'centaur-tabs-forward)
(map! :g "s-s" 'save-buffer)
(map! :g "s-w" 'kill-buffer)
(map! :g "s-M-t" 'centaur-tabs-kill-other-buffers-in-current-group)
(map! :g "s-e" (lambda () (interactive) (+treemacs/toggle) (treemacs-follow-mode t)))
(map! :g "C-e" (lambda () (interactive) (+treemacs/toggle) (treemacs-follow-mode t)))
(map! :g "s-t" '+vterm/toggle)
(map! :g "C-t" '+vterm/toggle)

(setq
 org-download-method 'directory
 org-download-image-dir "images"
 )

(add-to-list 'default-frame-alist '(undecorated-round . t))
