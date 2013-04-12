;; (c) Дмитрий Пинский <demetrius@neverblued.info>
;; Допускаю использование и распространение согласно
;; LLGPL -> http://opensource.franz.com/preamble.html

(in-package #:cl-blackjack)

(defun average-length (&rest sequences)
  (aif sequences
       (/ (apply #'+ (mapcar #'length it))
          (length it))
       0))

(defun any (&rest items)
  (random-elt items))

(defun badjoin (item list &key key (test #'eql))
  (reverse (adjoin item (reverse list) :key key :test test)))

(defun find-assoc (needle assoc-pairs &key (test #'eql) (fetch #'second))
  (funcall fetch
           (find needle
                 assoc-pairs
                 :test test
                 :key #'first)))

(defun group (source n)
  (if (zerop n) (error "Zero length."))
  (labels ((rec (source acc)
             (let ((rest (nthcdr n source)))
               (if (consp rest)
                   (rec rest (cons
                               (subseq source 0 n)
                               acc))
                   (nreverse
                     (cons source acc))))))
    (if source (rec source nil) nil)))

(defmacro make-revolver-magazine (source)
  (let ((g-source (gensym)))
    `(let ((,g-source ,source))
       (lambda ()
         (let ((item (first ,g-source)))
           (setf ,g-source (append (rest ,g-source) (list item)))
           item)))))
