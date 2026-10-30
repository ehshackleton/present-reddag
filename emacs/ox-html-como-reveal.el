;;; ox-html-como-reveal.el --- C-c C-e h h exporta Reveal en esta charla -*- lexical-binding: t; -*-

;; En Presentacion_Soberania_Reveal.org, cualquier export HTML de Org
;; (h h, h o, dispatcher de Doom) se reenvía a ox-reveal y se abre por
;; HTTP, no por file://.

(require 'ox)
(require 'ox-html)
(require 'ox-reveal)

(defconst present-reddag-reveal-org-name "Presentacion_Soberania_Reveal.org")
(defconst present-reddag-reveal-html-name "Presentacion_Soberania_Reveal.html")
(defconst present-reddag-http-port 8765)

(defun present-reddag--root ()
  (or (locate-dominating-file
       (or buffer-file-name default-directory)
       present-reddag-reveal-org-name)
      default-directory))

(defun present-reddag--reveal-org-p ()
  (and buffer-file-name
       (string-equal (file-name-nondirectory buffer-file-name)
                     present-reddag-reveal-org-name)))

(defun present-reddag--reveal-html-path-p (path)
  (and path
       (string-equal (file-name-nondirectory (expand-file-name path))
                     present-reddag-reveal-html-name)))

(defun present-reddag--http-url ()
  (format "http://127.0.0.1:%s/%s"
          present-reddag-http-port
          present-reddag-reveal-html-name))

(defun present-reddag--http-up-p ()
  (let ((proc (ignore-errors
                (make-network-process
                 :name "present-reddag-probe"
                 :host "127.0.0.1"
                 :service present-reddag-http-port
                 :nowait nil))))
    (when proc
      (delete-process proc)
      t)))

(defun present-reddag--ensure-http-server ()
  "Arranca python3 -m http.server en la raíz del proyecto si el puerto está libre."
  (unless (present-reddag--http-up-p)
    (let* ((root (expand-file-name (present-reddag--root)))
           (python (or (executable-find "python3") "python3"))
           (default-directory root))
      (start-process "present-reddag-http" "*present-reddag-http*"
                     python "-m" "http.server"
                     (number-to-string present-reddag-http-port))
      (sit-for 0.4)))
  (present-reddag--http-up-p))

(defun present-reddag-browse-http ()
  "Abre la presentación por HTTP, no por file://."
  (present-reddag--ensure-http-server)
  (unless noninteractive
    (browse-url (present-reddag--http-url)))
  (message "Reveal: %s" (present-reddag--http-url)))

(defun present-reddag--sync-index-html ()
  "Copia el HTML exportado a index.html (raíz de SDF)."
  (let* ((root (expand-file-name (present-reddag--root)))
         (src (expand-file-name present-reddag-reveal-html-name root))
         (dst (expand-file-name "index.html" root)))
    (when (file-readable-p src)
      (copy-file src dst t t))))

(defun present-reddag--export-to-file (orig backend file &rest args)
  "Si este buffer es la charla Reveal, reenvía el backend HTML a ox-reveal."
  (if (and (eq backend 'html) (present-reddag--reveal-org-p))
      (let ((result (apply orig 'reveal file args)))
        (present-reddag--sync-index-html)
        (present-reddag--ensure-http-server)
        (message "Exportado con ox-reveal (no HTML de Org). Abre %s"
                 (present-reddag--http-url))
        (unless noninteractive
          (present-reddag-browse-http))
        result)
    (apply orig backend file args)))

(defun present-reddag--reveal-and-browse (orig &rest args)
  (if (present-reddag--reveal-org-p)
      (progn
        (apply #'org-reveal-export-to-html args)
        (present-reddag--sync-index-html)
        (present-reddag-browse-http)
        (expand-file-name present-reddag-reveal-html-name
                          (present-reddag--root)))
    (apply orig args)))

(defun present-reddag--open-file-http (orig path &rest args)
  (if (present-reddag--reveal-html-path-p path)
      (present-reddag-browse-http)
    (apply orig path args)))

(defun present-reddag-enable-html-as-reveal ()
  "Instala los consejos una sola vez."
  (unless (advice-member-p #'present-reddag--export-to-file
                           'org-export-to-file)
    (advice-add 'org-export-to-file :around
                #'present-reddag--export-to-file))
  (unless (advice-member-p #'present-reddag--reveal-and-browse
                           'org-reveal-export-to-html-and-browse)
    (advice-add 'org-reveal-export-to-html-and-browse :around
                #'present-reddag--reveal-and-browse))
  (unless (advice-member-p #'present-reddag--open-file-http
                           'org-open-file)
    (advice-add 'org-open-file :around
                #'present-reddag--open-file-http)))

(present-reddag-enable-html-as-reveal)

(provide 'present-reddag-ox-html-como-reveal)
;;; ox-html-como-reveal.el ends here
