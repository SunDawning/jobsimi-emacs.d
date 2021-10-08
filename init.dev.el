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
