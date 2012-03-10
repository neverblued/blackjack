;; (c) Дмитрий Пинский <demetrius@neverblued.info>
;; Допускаю использование и распространение согласно
;; LLGPL -> http://opensource.franz.com/preamble.html

(in-package #:cl-blackjack)

(defun compare (x y &key key (test #'eql))
  (macrolet ((a (z)
               `(if (functionp key)
                    (funcall key ,z)
                    ,z)))
    (funcall test (a x) (a y))))

(defun true? (thing)
  "Evaluate the THING to T or NIL."
  (when thing t))
