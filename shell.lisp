;; (c) Дмитрий Пинский <demetrius@neverblued.info>
;; Допускаю использование и распространение согласно
;; LLGPL -> http://opensource.franz.com/preamble.html

(in-package #:cl-blackjack)

(defun shell-run-output (program &optional (args nil))
  (let ((shell-output (make-string-output-stream)))
    (sb-ext::run-program program args :output shell-output :search t :wait t)
    (get-output-stream-string shell-output)))
