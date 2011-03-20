(in-package #:cl-blackjack)

(defun save-into-file (value pathname)
  (ensure-directories-exist pathname)
  (with-open-file (file pathname :direction :output :if-exists :supersede)
    (format file "~s" value))
  nil)

(defun load-from-file (pathname)
  (when (probe-file pathname)
    (with-open-file (file pathname)
      (read file nil))))

(defun pathname-string+bytes (pathname)
  "Suck up an entire file from PATH into a freshly-allocated string, returning two values: the string and the number of bytes read."
  (with-open-file (s pathname)
    (let* ((len (file-length s))
           (data (make-string len)))
      (values data (read-sequence data s)))))

(defparameter *pathname-content-cache* (make-hash-table :test #'equal))

(defun pathname-content (pathname &key (binary nil) (cache t))
  "Suck up an entire file from PATH into a freshly-allocated string."
  (flet ((file-content ()
           (if binary
               (let (result)
                 (with-open-file (file pathname :element-type '(unsigned-byte 8))
                   (loop for byte = (read-byte file nil)
                      while byte do (push byte result)))
                 (reverse result))
               (values (pathname-string+bytes pathname))))
         (get-cache-cell ()
           (values (gethash pathname *pathname-content-cache* nil)))
         (cached (date content)
           (setf (gethash pathname *pathname-content-cache*)
                 (list date content))
           content))
    (if cache
        (let ((write-date (file-write-date pathname)))
          (aif (get-cache-cell)
               (destructuring-bind (cache-date cache-content) it
                 (if (>= cache-date write-date)
                     cache-content
                     (cached write-date (file-content))))
               (cached write-date (file-content))))
        (file-content))))
