;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


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
(setq doom-theme 'doom-gruvbox)

;; processing mode
(setq processing-location "/home/jacob/Downloads/processing/result/bin/processing-java")
(setq processing-application-dir "/home/jacob/Documents/processing/apps")
(setq processing-sketchbook-dir "/home/jacob/Documents/processing/sketch")
(setq processing-output-dir "/tmp")

;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Jacob Goldman-Wetzler"
      user-mail-address "jacoblevgw@gmail.com")


(after! evil-snipe
  (evil-snipe-mode -1))

;; Make vertical splits open on the right and horizontal splits open below
(setq evil-vsplit-window-right t
      evil-split-window-below t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)

;; cd to home
(defun cd-home ()
  (interactive)
  (cd "/home/jacob/"))

(defun cd-root-dir ()
  (interactive)
  (cd (vc-root-dir)))

(setq gradle-use-gradlew t)

(add-hook! 'markdown-mode-hook (flyspell-mode))
(map! :mode 'common-lisp-mode :n "K" #'sly-documentation)

(require 'lsp)
(use-package! zig-mode
  :hook ((zig-mode . lsp))
  :custom (zig-format-on-save nil)
  :init)

(add-to-list 'lsp-language-id-configuration '(vue-mode . "vue"))
(lsp-register-client
 (make-lsp-client
  :new-connection (lsp-stdio-connection "vls")
  :major-modes '(vue-mode)
  :server-id 'vls))

;; (add-to-list 'lsp-language-id-configuration '(zig-mode . "zig"))
;; (lsp-register-client
;;  (make-lsp-client
;;   :new-connection (lsp-stdio-connection "zls")
;;   :major-modes '(zig-mode)
;;   :server-id 'zls)))

(setq projectile-project-search-path '("~/dev/"))
(setq ivy-use-selectable-prompt t)
(setq company-idle-delay 0.1)
(setq circe-new-day-notifier-format-message "")

(map! :leader :desc "Next Error" :n "e" #'next-error
      :leader :desc "Previous Error" :n "E" #'previous-error
      :leader :desc "Open URL" :n "l" #'browse-url-xdg-open)

(map!
 :n "C-j" #'evil-window-down
 :n "C-k" #'evil-window-up
 :n "C-h" #'evil-window-left
 :n "C-l" #'evil-window-right)

(map!
 :leader :desc "cd VC root" :n "r" #'cd-root-dir)

(map!
 :leader :prefix "c" :desc "LSP Doc Glance" :n "g" #'lsp-ui-doc-glance)


(defun browse-github-issue (repo issue-num)
  (call-process (getenv "BROWSER") nil 0 nil (concat "https://github.com/" repo "/pull/" (number-to-string issue-num))))


(defun browse-github-issue (repo issue-num)
  (call-process (getenv "BROWSER") nil 0 nil (concat "https://github.com/" repo "/pull/" (number-to-string issue-num))))

(defun browse-github-issue-at-point (repo)
  (browse-github-issue repo (thing-at-point 'number t)))

(defun browse-zig-issue () (interactive) (browse-github-issue-at-point "ziglang/zig"))

(defun browse-serenity-issue () (interactive) (browse-github-issue-at-point "serenityos/serenity"))

(defun circe-command-ZNC (what)
  "Send a message to ZNC incorporated by user '*status'."
  (circe-command-MSG "*status" what))
(defun circe-command-JNET (what)
  "Send a message to ZNC incorporated by user '*status'."
  (circe-command-MSG "*status" (concat "JumpNetwork " what)))
(after! circe
    (set-irc-server! "soju"
                     '(:tls nil
                        :host "bruh"
                        :port 6667
                        :nick "g-w1"
                        :pass "bruhmoment")))

(defun lui-autopaste-service-clbin (text)
  "Paste TEXT to clbin.com and return the paste url."
  (let ((url-request-method "POST")
        (url-request-extra-headers
         '(("Content-Type" . "application/x-www-form-urlencoded")))
        (url-request-data (format "clbin=%s" (url-hexify-string text)))
        (url-http-attempt-keepalives nil))
    (let ((buf (url-retrieve-synchronously "https:/clbin.com/")))
      (unwind-protect
          (with-current-buffer buf
            (goto-char (point-min))
            (if (re-search-forward "\n\n" nil t)
                (buffer-substring (point) (point-at-eol))
              (error "Error during pasting to clbin.com")))
        (kill-buffer buf)))))
(setq! lui-autopaste-function #'lui-autopaste-service-clbin)

;; email
;; Each path is relative to `+mu4e-mu4e-mail-path', which is ~/.mail by default
                                        ; (require 'mu4e)
                                        ; (set-email-account! "home"
                                        ;   '((mu4e-sent-folder       . "/home/[Gmail].Sent Mail")
                                        ;     (mu4e-drafts-folder     . "/home/[Gmail].Drafts")
                                        ;     (mu4e-trash-folder      . "/home/[Gmail].Trash")
                                        ;     (mu4e-refile-folder     . "/home/[Gmail].All Mail")
                                        ;     (smtpmail-smtp-user     . "jacoblevgw@gmail.com")
                                        ;     (mu4e-compose-signature . "---\nJacob"))
                                        ;   t)
                                        ; (set-email-account! "school"
                                        ;   '((mu4e-sent-folder       . "/school/[Gmail].Sent Mail")
                                        ;     (mu4e-drafts-folder     . "/school/[Gmail].Drafts")
                                        ;     (mu4e-trash-folder      . "/school/[Gmail].Trash")
                                        ;     (mu4e-refile-folder     . "/school/[Gmail].All Mail")
                                        ;     (smtpmail-smtp-user     . "goldman-wetzlerj24@learn.hohschools.org")
                                        ;     (mu4e-compose-signature . "---\nJacob"))
                                        ;   t)

;; (setq mu4e-bookmarks
;;       '((:name "home-INBOX"
;;          :key ?h
;;          :query "maildir:/home/INBOX")
;;         (:name "school-INBOX"
;;          :key ?s
;;          :query "maildir:/school/INBOX")
;;         (:name "INBOX"
;;          :key ?i
;;          :query "maildir:/school/INBOX OR maildir:/home/INBOX")))

(setq +format-on-save-enabled-modes
      '(not c-mode c++-mode))


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
