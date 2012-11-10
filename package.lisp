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
        #:iterate
        #:simple-date)
  (:shadowing-import-from #:ironclad #:null)
  (:export
                                        ; anaphoric
   #:it #:aif #:aprogn #:asetf #:aunless #:awhen #:awith
                                        ; asdf
   #:system-directory
                                        ; data
   #:define-data-factory #:define-fetch-list #:define-fetch-item
                                        ; function
   #:compost #:mutate #:pipemap
                                        ; pattern
   #:append-case #:careful-apply #:hamster #:maphash-collect #:pick-up #:prognil
                                        ; count
   #:compare #:true? #:round-time-to-minute
                                        ; filesystem
   #:pathname-content #:save-into-file #:load-from-file
                                        ; format
   #:echo #:date-formatter #:timestamp-js-to-universal
                                        ; list
   #:average-length #:badjoin #:find-assoc #:group #:make-revolver-magazine
                                        ; plist
   #:plist-unique #:plist-extend
                                        ; shell
   #:shell-run-output
                                        ; string
   #:join #:join-by #:join-rec #:split-once
   #:name-keyword #:checksum
   #:trim-left #:trim-right #:regex-cut
   #:begins-with? #:string-null
   #:clean-unicode #:capitalize-1st
   #:safely-read-from-string
                                        ; symbol
   #:instance-class-name #:keyword-name #:mkstr #:pizdec #:symb #:symbol-keyword #:with-gensyms
                                        ; .
   ))
