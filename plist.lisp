;; (c) Дмитрий Пинский <demetrius@neverblued.info>
;; Допускаю использование и распространение согласно
;; LLGPL -> http://opensource.franz.com/preamble.html

(in-package #:cl-blackjack)

(defun plist-unique (plist)
  (let (result)
    (iter (for (key value) in (group plist 2))
          (unless (getf result key)
            (setf (getf result key) value)))
    result))

(defun plist-extend (origin patch)
  (let (result)
    (iter (for (key value) in (group (append origin patch) 2))
          (setf (getf result key) value))
    result))
