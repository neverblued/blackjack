;; (c) Дмитрий Пинский <demetrius@neverblued.info>
;; Допускаю использование и распространение согласно
;; LLGPL -> http://opensource.franz.com/preamble.html

(in-package #:cl-blackjack)

(defun mutate (value &rest mutations)
  "Process the VALUE through each of the one-argument MUTATIONS lambdas."
  (dolist (mutation mutations value)
    (setf value (funcall mutation value))))

(defmacro compost (&rest functions)
  (with-gensyms (x)
    `(lambda (,x)
       (mutate ,x ,@functions))))

(defun pipemap (list &rest mutations)
  "Map the LIST through each of the one-argument MUTATIONS lambdas."
  (mapcar (lambda (value)
            (apply #'mutate value mutations))
          (typecase list
            (list list)
            (t (list list)))))
