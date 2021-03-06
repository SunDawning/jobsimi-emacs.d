(load-file "./before-init.el")
(setf gc-cons-threshold (* 1024 1024 1024))
(defun jobsimi::js-mode-hook ()
  (electric-pair-mode)
  )
(with-eval-after-load (quote js)
  (add-hook (quote js-mode-hook) (function jobsimi::js-mode-hook)))
(setf package-archives
      (quote
       (("gnu"   . "http://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")
        ("melpa" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/"))))
(defun jobsimi::package-initialize()
  (unless (and (boundp (quote package--initialized))
               package--initialized)
    (package-initialize)))
(defun jobsimi::unless-package-install (function package)
    (jobsimi::package-initialize)
  (unless (functionp function)
    (package-install package)))
(defun jobsimi:fullscreen()
  (interactive)
  (global-auto-revert-mode)
  (show-paren-mode)
  (jobsimi::unless-package-install (function global-company-mode) (quote company))
  (global-company-mode)
  (global-font-lock-mode)
  (when (functionp (function jobsimi::beautify-window))
    (jobsimi::beautify-window))
  (unless custom-enabled-themes
    (dolist (theme custom-enabled-themes)
      (disable-theme theme))
    (load-theme (quote manoj-dark)))
  (let ((format "(%Y-%m-%d %a %H:%M)"))
    (unless (boundp 'display-time-format) (require 'time))
    (when (boundp 'display-time-format)
      (unless (equal display-time-format format)
        (setf display-time-format format)
        (display-time-mode)
        (display-battery-mode)
        (custom-set-variables
         '(mode-line-format
           '("%e" mode-line-front-space mode-line-mule-info mode-line-client mode-line-modified mode-line-remote mode-line-frame-identification mode-line-buffer-identification "   " mode-line-position
             (vc-mode vc-mode)
             "  " mode-line-misc-info mode-line-end-spaces))))))
  (when (display-graphic-p)
    (jobsimi::unless-package-install (function default-text-scale-increase) (quote default-text-scale))
    (unless (functionp (function default-text-scale-increment))
      (require (quote default-text-scale)))
    (when (functionp (function default-text-scale-increment))
      (let ((size 140)
            (height (face-attribute 'default :height)))
        (when (>= (abs (- size height)) 10)
          (default-text-scale-increment (- size height)))))
    (when (eq system-type 'windows-nt)
      (let ((family "Lucida Console"))
        (unless (functionp (function cl-member))
          (require 'cl-seq))
        (when (and (eq system-type 'windows-nt)
                   (functionp (function cl-member))
                   (cl-member "Lucida Console"
                              (font-family-list)
                              :test (function string-equal)))
          (let ((font (format "-outline-Lucida Console-normal-normal-normal-mono-%d-*-*-*-c-*-iso10646-1"
                              (line-pixel-height))))
            (unless (string-equal (frame-parameter nil 'font)
                                  font)
              (set-frame-font font)
              family))))))
  (global-set-key (kbd "M-p") (function jobsimi:symbol-overlay-jump-prev))
  (global-set-key (kbd "M-n") (function jobsimi:symbol-overlay-jump-next))
  (global-set-key (kbd "M-i") (function jobsimi:symbol-overlay-put))
  (jobsimi::unless-package-install (function undo-tree-mode) (quote undo-tree))
  (global-undo-tree-mode)
  (jobsimi::unless-package-install (function separedit) (quote separedit))
  (jobsimi::unless-package-install (function aggressive-indent-mode)(quote aggressive-indent))
  (global-aggressive-indent-mode))
(global-set-key (kbd "<f11>")(function jobsimi:fullscreen))
(defun jobsimi::emacs-lisp-mode-hook()
  (electric-pair-mode))
(with-eval-after-load (quote elisp-mode)
  (add-hook (quote emacs-lisp-mode-hook) (function jobsimi::emacs-lisp-mode-hook)))
(defun jobsimi::install-counsel()
  (jobsimi::unless-package-install (function counsel-M-x) (quote counsel))
  (jobsimi::unless-package-install (function ivy-mode) (quote ivy))
  (jobsimi::unless-package-install (function smex) (quote smex)))
(defun jobsimi:execute-extended-command()
  (interactive)
  (jobsimi::install-counsel)
  (call-interactively (function counsel-M-x)))
(global-set-key (kbd "M-x") (function jobsimi:execute-extended-command))
(defun jobsimi:switch-to-buffer()
  (interactive)
  (jobsimi::install-counsel)
  (call-interactively (function counsel-switch-buffer)))
(global-set-key (kbd "C-x b") (function jobsimi:switch-to-buffer))
(defun jobsimi:find-file()
  (interactive)
  (jobsimi::install-counsel)
  (call-interactively (function counsel-find-file)))
(global-set-key (kbd "C-x C-f") (function jobsimi:find-file))
(defun jobsimi:dired()
  (interactive)
  (jobsimi::install-counsel)
  (call-interactively (function counsel-dired)))
(global-set-key (kbd "C-x d") (function jobsimi:dired))
(with-eval-after-load (quote ivy)
  (unless ivy-use-virtual-buffers
    (ivy-mode)
    (setq-default ivy-use-virtual-buffers t
                  ivy-count-format ""
                  projectile-completion-system 'ivy)
    (define-key ivy-minibuffer-map (kbd "RET") (function ivy-alt-done))))
(defun jobsimi::beautify-window ()
  (if (display-graphic-p)
      (when menu-bar-mode (menu-bar-mode 0))
    (when (= (frame-parameter (car (frame-list))
                              (quote menu-bar-lines))
             1)
      (menu-bar-mode 0)))
  (when (and (fboundp 'tool-bar-mode) tool-bar-mode)
    (tool-bar-mode 0))
  (when (and (display-graphic-p) scroll-bar-mode)
    (scroll-bar-mode 0)
    (unless (when fringe-mode (zerop fringe-mode))
      (fringe-mode 5)))
  (dotimes (i 3)
    (toggle-frame-fullscreen))
  ;; Emacs ???????????? - Emacs-general - Emacs China: https://emacs-china.org/t/topic/2405/16
  (let ((value 70)
        (frame nil)
        (parameter (quote alpha)))
    (unless (and (frame-parameter frame parameter)
                 (= (frame-parameter frame parameter)
                    value))
      (set-frame-parameter nil parameter value))))
(defun jobsimi::coding-system ()
  "???????????????????????????"
  (let ((coding-system (quote utf-8)))
    (setf default-buffer-file-coding-system coding-system
          selection-coding-system coding-system)
    (prefer-coding-system coding-system)
    (when (eq system-type (quote windows-nt))
      (let ((coding-system (quote utf-16-le)))
        (set-next-selection-coding-system coding-system)
        (set-selection-coding-system coding-system))
      (unless (cl-member 'cp65001 coding-system-list)
        (define-coding-system-alias 'cp65001 coding-system))))
  (when (functionp (function w32-list-locales))
    (setf system-time-locale "ENU")))
(jobsimi::coding-system)
(defun jobsimi:avy-goto-char()
  (interactive)
  (jobsimi::unless-package-install (function avy-goto-char) (quote avy))
  (call-interactively (function avy-goto-char)))
(global-set-key (kbd "C-c ;") (function jobsimi:avy-goto-char))
(with-eval-after-load (quote magit)
  (jobsimi::unless-package-install (function diff-hl-mode) (quote diff-hl))
  (global-diff-hl-mode)
  (add-hook (quote magit-pre-refresh-hook) (quote diff-hl-magit-pre-refresh))
  (add-hook (quote magit-post-refresh-hook) (quote diff-hl-magit-post-refresh))
  )
(setf (symbol-function (quote yes-or-no-p)) (symbol-function (quote y-or-n-p)))
(defun jobsimi:symbol-overlay-jump-prev()
  (interactive)
  (jobsimi::unless-package-install (function symbol-overlay-jump-prev) (quote symbol-overlay))
  (call-interactively (function symbol-overlay-jump-prev)))
(defun jobsimi:symbol-overlay-jump-next()
  (interactive)
  (jobsimi::unless-package-install (function symbol-overlay-jump-next) (quote symbol-overlay))
  (call-interactively (function symbol-overlay-jump-next)))
(defun jobsimi:symbol-overlay-put()
  (interactive)
  (jobsimi::unless-package-install (function symbol-overlay-put) (quote symbol-overlay))
  (call-interactively (function symbol-overlay-put)))
(defun jobsimi::mhtml-mode-hook ()
  (electric-pair-mode)
  )
(with-eval-after-load (quote mhtml)
  (add-hook (quote mhtml-mode-hook) (function jobsimi::mhtml-mode-hook)))
(defun jobsimi:close-emacs-and-logoff-logout-the-computer (&optional arg)
  (interactive "P")
  (unless (and (called-interactively-p)
               (not (y-or-n-p "??????????????????????????????")))
    (if arg
        (run-with-timer
         (string-to-number
          (read-string "Close Emacs After Seconds: "))
         nil
         (lambda ()
           (when (functionp (function jobsimi:close-emacs-and-logoff-logout-the-computer))
             (jobsimi:close-emacs-and-logoff-logout-the-computer))))
      (when (functionp (function jobsimi::close-emacs))
        (jobsimi::close-emacs
         (lambda ()
           (when (functionp (function jobsimi::shutdown))
             (jobsimi::shutdown (quote logoff)))))))))
(defun jobsimi:close-emacs-and-shut-down-poweroff-the-computer (&optional arg)
  "Restart emacs from within emacs - Emacs Stack Exchange: https://emacs.stackexchange.com/questions/5428/restart-emacs-from-within-emacs"
  (interactive "P")
  (unless (and (called-interactively-p)
               (not (y-or-n-p "??????????????????????????????")))
    (if arg
        (run-with-timer
         (string-to-number
          (read-string "Close Emacs After Seconds: "))
         nil
         (lambda ()
           (when (functionp (function jobsimi:close-emacs-and-shut-down-poweroff-the-computer))
             (jobsimi:close-emacs-and-shut-down-poweroff-the-computer))))
      (when (functionp (function jobsimi::close-emacs))
        (jobsimi::close-emacs
         (lambda ()
           (when (functionp (function jobsimi::shutdown))
             (jobsimi::shutdown 'poweroff))))))))
(defun jobsimi:close-emacs-and-restart-reboot-computer (&optional arg)
  (interactive "P")
  (unless (and (called-interactively-p)
               (not (y-or-n-p "??????????????????????????????")))
    (if arg
        (run-with-timer
         (string-to-number
          (read-string "Close Emacs After Seconds: "))
         nil
         (lambda ()
           (when (functionp (function jobsimi:close-emacs-and-restart-reboot-computer))
             (jobsimi:close-emacs-and-restart-reboot-computer))))
      (when (functionp (function jobsimi::close-emacs))
        (jobsimi::close-emacs
         (lambda ()
           (when (functionp (function jobsimi::shutdown))
             (jobsimi::shutdown 'reboot))))))))
(defun jobsimi::close-emacs (function)
  (let ((kill-emacs-hook
         (append kill-emacs-hook
                 (list function)))
        (message '("
         .----.
      _.'__    `.
  .--(#)(##)---/#\\
.' @          /###\\
:         ,   #####
 `-..__.-' _.-\\###/
       `;_:    `\"'
     .'\"\"\"\"\"`.
    /,  GOD  ,\\
   // Bless U. \\\\
   `-._______.-'
   ___`. | .'___
  (______|______)" "
 ??? ???^????????? /?????????_,_
??? |  ??? ???7??? (???r???7/
??? ????????? ??????_/??????_???
???/???????????????????????? {
_?????????????????????????????????
_??????????????????????? ??? ???
??? `???????????????????????????
????????? /??? ??? ?????????
?????? ???????????????????????? ??????}" "
       ??? ????????????
       ???  GOD  |
       ??? Bless |
       ???   U   |
       ???????????????
  ???__??? ???
 \(`???????? ???
 \ ??? ???
  ???--???" "
 ??? \\???  /
???????????????\\ /???????????????
???????????????????????????????????????
??????   GOD   ??????
?????? Bless U ??????
???????????????????????????????????????
???????????????????????????????????????" "
{\____/}
\(????????????)
/????????????B???????????????")))
    (switch-to-buffer "*close-emacs*")
    (erase-buffer)
    (insert (nth (random (length message)) message))
    (kill-emacs)))
(defun jobsimi::shutdown (type)
  (unless (fboundp (quote cl-case))
    (require (quote cl-macs)))
  (when (fboundp (quote cl-case))
    (cl-case type
      (reboot
       (cond ((executable-find "/sbin/shutdown")
              (call-process "sh" nil nil nil "-c" "/sbin/shutdown --reboot 0"))
             ((executable-find "shutdown.exe")
              (shell-command
               (format
                "%s -r -f -t 0"
                (executable-find "shutdown.exe"))))))
      (logoff
       (cond ((executable-find "shutdown.exe")
              (shell-command
               (format
                "%s -l -f"
                (executable-find "shutdown.exe"))))))
      (poweroff
       (cond ((executable-find "/sbin/shutdown")
              (call-process "sh" nil nil nil "-c" "/sbin/shutdown --poweroff 0"))
             ((executable-find "shutdown.exe")
              (shell-command
               (format
                "%s -s -f -t 0"
                (executable-find "shutdown.exe")))))))))
(let ((symbol (quote jobsimi::*task-file*)))
  (when (boundp symbol)
    (with-eval-after-load (quote org)
      (let ((file (expand-file-name (symbol-value symbol))))
        (when (file-exists-p file)
          (setf org-default-notes-file file
                org-capture-templates
                `(("t" "todo" entry (file "")  ; "" => `org-default-notes-file'
                   "* TODO %?\nSCHEDULED: %T\n" :clock-resume t))
                ;; M-x org-agenda-list
                org-agenda-span (quote day))
          (add-to-list (quote org-agenda-files)
                       file))))))
(defun jobsimi:http-server-browse-url-of-file()
  "????????????node???http-server???????????????????????????????????????"
  (interactive)
  (let ((symbol (quote jobsimi::*http-server-root*)))
    (when (boundp symbol)
      (let ((root (symbol-value symbol))
            (file (buffer-file-name))
            (newtext jobsimi::*http-server-root-replace*))
        (when (string-match root file)
          (browse-url
           (replace-match newtext nil nil file)))))))
(defun jobsimi:yank ()
  "??????"
  (interactive)
  (when (use-region-p)
    (delete-region
     (region-beginning)
     (region-end)))
  (if (eq major-mode (quote org-mode))
      (org-yank)
    (yank)))
(defun jobsimi::global-set-key (keys function)
  (when (commandp function)
    (global-set-key (kbd keys) function)))
(when (functionp (function jobsimi:yank))
  (jobsimi::global-set-key "C-y" (function jobsimi:yank)))
(defun jobsimi::js2-mode()
  (jobsimi::unless-package-install (function js2-mode) (quote js2-mode))
  (js2-mode))
(add-to-list (quote auto-mode-alist)
             (cons "\\.js$" (function jobsimi::js2-mode)))
(setf auto-save-default nil)
(setf make-backup-files nil)
(defun jobsimi::before-save-hook ()
  (setf indent-tabs-mode nil)
  (untabify (point-min) (point-max))
  (whitespace-cleanup))
(add-hook (quote before-save-hook) (function jobsimi::before-save-hook))
