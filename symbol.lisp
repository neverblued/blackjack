;; (c) Дмитрий Пинский <demetrius@neverblued.info>
;; Допускаю использование и распространение согласно
;; LLGPL -> http://opensource.franz.com/preamble.html

(in-package #:cl-blackjack)

(defun instance-class-name (instance)
  (class-name (class-of instance)))

(defun keyword-name (keyword)
  (unless (keywordp keyword)
    (error 'type-error :datum keyword :expected-type 'keyword))
  (string-downcase (symbol-name keyword)))

(defun mkstr (&rest args)
  (with-output-to-string (s)
    (dolist (a args) (princ a s))))

(defun name-value (symbol-name)
  (awith (intern (string-upcase symbol-name) *package*)
    (if (boundp it)
        (symbol-value it)
        (error "Symbol ~s is not bound." it))))

(defmacro pizdec (&rest huynya)
  `(progn ,@(loop for foo in huynya
               collect `(awith ',foo
                          (when (boundp it)
                            (makunbound it))
                          (when (fboundp it)
                            (fmakunbound it))
                          (unintern it)))))

(defun symb (&rest args)
  (values (intern (apply #'mkstr args))))

(defun symbol-keyword (symbol)
  (intern (symbol-name symbol) :keyword))
