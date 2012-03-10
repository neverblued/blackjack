;; (c) Дмитрий Пинский <demetrius@neverblued.info>
;; Допускаю использование и распространение согласно
;; LLGPL -> http://opensource.franz.com/preamble.html

(in-package #:cl-blackjack)

(defmacro echo (stream form &key label)
  "Pretty print FORM => <EVALUATED-FORM> and return the value. LABEL is just for overweight source forms."
  (with-gensyms (form* label*)
    `(let* ((,form* ,form)
            (,label* (or ,label ',form)))
       (format ,stream "~&~a => ~s~%" ,label* ,form*)
       ,form*)))
