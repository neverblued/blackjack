;; (c) Дмитрий Пинский <demetrius@neverblued.info>
;; Допускаю использование и распространение согласно
;; LLGPL -> http://opensource.franz.com/preamble.html

(defpackage #:blackjack-system
  (:use #:common-lisp #:asdf))

(in-package #:blackjack-system)

(defsystem "blackjack"
  :description "Common Lisp Blackjack"
  :version "0.3"
  :author "Дмитрий Пинский <demetrius@neverblued.info>"
  :depends-on (#:alexandria
               #:babel
               #:cl-ppcre
               #:ironclad
               #:iterate)
  :serial t
  :components ((:file "package")
               (:file "anaphoric")
               (:file "symbol")
               (:file "function")
               (:file "pattern")
               (:file "count")
               (:file "list")
               (:file "plist")
               (:file "string")
               (:file "format")
               (:file "filesystem")
               (:file "asdf")
               (:file "data")
               (:file "shell")))
