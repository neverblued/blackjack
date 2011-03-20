(defpackage #:cl-blackjack-system
  (:use #:common-lisp #:asdf))

(in-package #:cl-blackjack-system)

(defsystem "cl-blackjack"
  :description "Common Lisp Blackjack"
  :version "0.1"
  :author "Demetrius Conde <condemetrius@gmail.com>"
  :licence "Public Domain"
  :depends-on (#:cl-ppcre #:alexandria #:ironclad)
  :serial t
  :components ((:file "package")
               (:file "sugar")
               (:file "string")
               (:file "filesystem")))
