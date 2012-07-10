;; (c) Дмитрий Пинский <demetrius@neverblued.info>
;; Допускаю использование и распространение согласно
;; LLGPL -> http://opensource.franz.com/preamble.html

(defpackage #:cl-blackjack
  (:nicknames #:blackjack #:bj)
  (:use #:common-lisp
        #:alexandria
        #:babel
        #:cl-ppcre
        #:ironclad
        #:iterate)
  (:shadowing-import-from #:ironclad #:null)
  (:export
                                        ; anaphoric
   #:it #:aif #:aprogn #:asetf #:aunless #:awhen #:awith
                                        ; symbol
   #:instance-class-name #:keyword-name #:mkstr #:pizdec #:symb #:symbol-keyword #:with-gensyms
                                        ; function
   #:compost #:mutate #:pipemap
                                        ; pattern
   #:append-case #:careful-apply #:hamster #:maphash-collect #:pick-up #:prognil
                                        ; count
   #:compare #:true?
                                        ; list
   #:average-length #:find-assoc #:group #:make-revolver-magazine
                                        ; plist
   #:plist-unique #:plist-extend
                                        ; string
   #:join #:join-by #:join-rec #:split-once
   #:name-keyword #:checksum
   #:trim-left #:trim-right #:regex-cut
   #:begins-with?
   #:clean-unicode
   #:safely-read-from-string
                                        ; format
   #:echo
                                        ; filesystem
   #:pathname-content #:save-into-file #:load-from-file
                                        ; asdf
   #:system-directory
                                        ; shell
   #:shell-run-output
                                        ; data
   #:define-data-factory #:define-fetch-list #:define-fetch-item
                                        ; .
   ))
