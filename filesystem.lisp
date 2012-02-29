(in-package #:cl-blackjack)

;; cache

(defparameter *cache* (make-hash-table :test #'equal))

(defun cache-cell (id)
  (values (gethash id *cache* nil)))

(defun cached-content (id content date)
  (setf (gethash id *cache*)
        (list date content))
  content)

(defmacro with-pathname-cache (pathname &body body)
  (with-gensyms (cached-origin)
    (once-only (pathname)
      `(if (probe-file ,pathname)
           (let ((write-date (file-write-date ,pathname)))
             (flet ((,cached-origin ()
                      (cached-content ,pathname (progn ,@body) write-date)))
               (aif (cache-cell pathname)
                    (destructuring-bind (cache-date cache-content) it
                      (if (and cache-date (>= cache-date write-date))
                          (values cache-content t)
                          (,cached-origin)))
                    (,cached-origin))))
           (error "File not found: ~a" ,pathname)))))

(defun kill-pathname-cache (pathname)
  (remhash pathname *cache*))

;; I/O

(defun save-into-file (value pathname)
  (ensure-directories-exist pathname)
  (with-open-file (file pathname :direction :output :if-exists :supersede)
    (format file "~s" value))
  nil)

(defmacro define-cached-pathname (name (&rest args) &rest content)
  (with-gensyms (file-content)
    `(defun ,name (pathname &key (cache t) ,@args)
       (flet ((,file-content ()
                ,@content))
         (if cache
             (with-pathname-cache pathname (,file-content))
             (progn (kill-pathname-cache pathname)
                    (,file-content)))))))

;(defun load-from-file (pathname &key (cache t))
;  (when (probe-file pathname)
;    (flet ((file-content ()
;             (with-open-file (file pathname)
;               (read file nil))))
;      (if cache
;          (with-pathname-cache pathname (file-content))
;          (progn (kill-pathname-cache pathname)
;                 (file-content))))))

(define-cached-pathname load-from-file ()
  (when (probe-file pathname)
    (with-open-file (file pathname)
      (read file nil))))

(defun pathname-string+bytes (pathname)
  "Suck up an entire file from PATH into a freshly-allocated string, returning two values: the string and the number of bytes read."
  (with-open-file (s pathname)
    (let* ((len (file-length s))
           (data (make-string len)))
      (values data (read-sequence data s)))))

;(defun pathname-content (pathname &key binary (cache t))
;  "Suck up an entire file from PATH into a freshly-allocated string."
;  (flet ((file-content ()
;           (if binary
;               (let (result)
;                 (with-open-file (file pathname :element-type '(unsigned-byte 8))
;                   (loop for byte = (read-byte file nil)
;                      while byte do (push byte result)))
;                 (reverse result))
;               (clean-unicode (pathname-string+bytes pathname)))))
;    (if cache
;        (with-pathname-cache pathname (file-content))
;        (progn (kill-pathname-cache pathname)
;               (file-content)))))

(define-cached-pathname pathname-content (binary)
  (if binary
      (let (result)
        (with-open-file (file pathname :element-type '(unsigned-byte 8))
          (loop for byte = (read-byte file nil)
             while byte do (push byte result)))
        (reverse result))
      (clean-unicode (pathname-string+bytes pathname))))
