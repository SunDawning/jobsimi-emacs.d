(defun jobsimi::js-mode-hook ()
  (electric-pair-mode)
  (setf indent-tabs-mode nil)
  )
(with-eval-after-load (quote js)
  (add-hook (quote js-mode-hook) (function jobsimi::js-mode-hook)))
(setf package-archives
      (quote
       (("gnu"   . "http://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")
	("melpa" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/"))))
(setf user-emacs-directory "d:/sxtcProjects/.emacs.d/")
(defun jobsimi:fullscreen()
  (interactive)
  (package-initialize)
  (global-company-mode)
  (global-font-lock-mode))
(global-set-key (kbd "<f11>")(function jobsimi:fullscreen))
(defun jobsimi::emacs-lisp-mode-hook()
  (electric-pair-mode)
  (setf indent-tabs-mode nil))
(with-eval-after-load (quote elisp-mode)
  (add-hook (quote emacs-lisp-mode-hook) (function jobsimi::emacs-lisp-mode-hook)))
