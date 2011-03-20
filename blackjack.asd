(defpackage #:blackjack-system
  (:use #:common-lisp #:asdf))

(in-package #:blackjack-system)

(defsystem "blackjack"
  :description "Common Lisp Blackjack"
  :version "0.2"
  :author "Demetrius Conde <condemetrius@gmail.com>"
  :depends-on (#:cl-ppcre #:alexandria #:ironclad)
  :serial t
  :components ((:file "package")
               (:file "sugar")
               (:file "string")
               (:file "filesystem")))
