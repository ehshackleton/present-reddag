;;; Directory Local Variables
;;; For more information see (info "(emacs) Directory Variables")

((nil . ((eval . (let ((el (expand-file-name
                            "emacs/ox-html-como-reveal.el"
                            (locate-dominating-file default-directory
                                                    ".dir-locals.el"))))
                   (when (file-exists-p el)
                     (load el nil t)))))))
