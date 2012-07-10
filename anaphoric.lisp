;; (c) Дмитрий Пинский <demetrius@neverblued.info>
;; Допускаю использование и распространение согласно
;; LLGPL -> http://opensource.franz.com/preamble.html

(in-package #:cl-blackjack)

(defmacro awith (it &body body)
  `(let ((it ,it))
     (declare (ignorable it))
     ,@body))

(defmacro aif (test then &optional else)
  `(awith ,test
     (if it ,then ,else)))

(defmacro aunless (test &body forms)
  `(awith ,test
     (unless it ,@forms)))

(defmacro aprogn (it &body side-effects)
  `(awith ,it
     ,@side-effects
     it))

(defmacro awhen (test &body forms)
  `(awith ,test
     (when it ,@forms)))

(defmacro asetf (origin setfable value)
  `(awith ,origin
     (when it
       (setf ,setfable
             (awith ,setfable ,value)))
     it))
