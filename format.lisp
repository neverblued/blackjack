;; (c) Дмитрий Пинский <demetrius@neverblued.info>
;; Допускаю использование и распространение согласно
;; LLGPL -> http://opensource.franz.com/preamble.html

(in-package #:cl-blackjack)

(defmacro echo (stream form &key label)
  "Pretty print (LABEL || FORM) => <EVALUATED-FORM> and return the value."
  (with-gensyms (form* label*)
    `(let* ((,form* ,form)
            (,label* (or ,label ',form)))
       (format ,stream "~&~a => ~s~%" ,label* ,form*)
       ,form*)))

(defmacro date-formatter ((time &optional time-zone) &body body)
  (let ((data '(second minute hour date month year day-of-week dst-p tz)))
    `(multiple-value-bind ,data
         (decode-universal-time ,time ,time-zone)
       (declare (ignorable ,@data))
       ,@body)))

(defun now-timestamp ()
  (universal-time-to-timestamp (get-universal-time)))

(let* ((js-base (encode-timestamp 1970 1 1))
       (cl-base (encode-timestamp 1900 1 1))
       (offset (time-subtract js-base cl-base)))
  (defun timestamp-js-to-universal (milliseconds)
    (let ((seconds (round (/ milliseconds 1000))))
      (awith (time-add (universal-time-to-timestamp seconds) offset)
        (timestamp-to-universal-time it)))))
