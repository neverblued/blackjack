;; (c) Дмитрий Пинский <demetrius@neverblued.info>
;; Допускаю использование и распространение согласно
;; LLGPL -> http://opensource.franz.com/preamble.html

(in-package #:cl-blackjack)

(defun mkstr (&rest args)
  (with-output-to-string (s)
    (dolist (a args) (princ a s))))

(defun keyword-name (keyword)
  (unless (keywordp keyword)
    (error 'type-error :datum keyword :expected-type 'keyword))
  (string-downcase (symbol-name keyword)))

(defmacro pizdec (&rest huynya)
  `(progn ,@(apply #'append
;  (adjoin 'progn
;          (apply #'append
                   (loop for foo in huynya
                      collect `(awith ',foo
                                 (when (boundp it)
                                   (makunbound it))
                                 (when (fboundp it)
                                   (fmakunbound it))
                                 (unintern it))))))

(defun symb (&rest args)
  (values (intern (apply #'mkstr args))))

(defun symbol-keyword (symbol)
  (intern (symbol-name symbol) :keyword))
