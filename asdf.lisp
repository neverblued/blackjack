;; (c) Дмитрий Пинский <demetrius@neverblued.info>
;; Допускаю использование и распространение согласно
;; LLGPL -> http://opensource.franz.com/preamble.html

(in-package #:cl-blackjack)

(defun system-directory (asdf-system)
  (let ((pathname (pathname-directory
                   (asdf:system-definition-pathname
                    (asdf:find-system asdf-system)))))
    (join "/" (apply #'join-by "/" (rest pathname)))))
