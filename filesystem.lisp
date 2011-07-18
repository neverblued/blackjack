(in-package #:cl-blackjack)

;; cache

(defparameter *pathname-content-cache* (make-hash-table :test #'equal))

(defmacro with-pathname-cache (pathname &body body)
  (with-gensyms (cache-cell cached origin)
    (once-only (pathname)
      `(flet ((,cache-cell ()
                (values (gethash ,pathname *pathname-content-cache* nil)))
              (,cached (date content)
                (setf (gethash ,pathname *pathname-content-cache*)
                      (list date content))
                content)
              (,origin ()
                (progn ,@body)))
         (if (probe-file ,pathname)
             (let ((write-date (file-write-date ,pathname)))
               (aif (,cache-cell)
                    (destructuring-bind (cache-date cache-content) it
                      (if (and cache-date (>= cache-date write-date))
                          (values cache-content t)
                          (,cached write-date (,origin))))
                    (,cached write-date (,origin))))
             (error "File not found: ~a" ,pathname))))))

;; I/O

(defun save-into-file (value pathname)
  (ensure-directories-exist pathname)
  (with-open-file (file pathname :direction :output :if-exists :supersede)
    (format file "~s" value))
  nil)

(defun load-from-file (pathname &key (cache t))
  (when (probe-file pathname)
    (flet ((file-content ()
             (with-open-file (file pathname)
               (read file nil))))
      (if cache
          (with-pathname-cache pathname (file-content))
          (file-content)))))

(defun pathname-string+bytes (pathname)
  "Suck up an entire file from PATH into a freshly-allocated string, returning two values: the string and the number of bytes read."
  (with-open-file (s pathname)
    (let* ((len (file-length s))
           (data (make-string len)))
      (values data (read-sequence data s)))))

(defun pathname-content (pathname &key (binary nil) (cache t))
  "Suck up an entire file from PATH into a freshly-allocated string."
  (flet ((file-content ()
           (if binary
               (let (result)
                 (with-open-file (file pathname :element-type '(unsigned-byte 8))
                   (loop for byte = (read-byte file nil)
                      while byte do (push byte result)))
                 (reverse result))
               (values (pathname-string+bytes pathname)))))
    (if cache
        (with-pathname-cache pathname (file-content))
        (file-content))))
