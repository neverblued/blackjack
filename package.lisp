(defpackage #:cl-blackjack
  (:nicknames #:blackjack #:bj)
  (:use #:common-lisp #:cl-ppcre #:alexandria #:ironclad #:babel)
  (:shadowing-import-from #:ironclad #:null)
  (:export
                                        ; sugar
   #:true? #:alter #:altered #:mutate #:prognil #:pipemap #:hamster #:pick-up #:append-case ; patterns
   #:mkstr #:symb #:with-gensyms #:pizdec #:symbol-keyword #:keyword-name #:compare ; symbol
   #:it #:awith #:awhen #:aunless #:aif ; anaphoric
   #:group #:find-assoc #:make-revolver-magazine ; list
   #:maphash-collect ; hash-table
   #:careful-apply #:compost ; function
   #:shell-run-output ; shell
   #:echo ; debug
                                        ; string
   #:join #:join-by #:join-rec #:split-once
   #:name-keyword #:checksum
   #:trim-left #:trim-right #:regex-cut
   #:begins-with?
   #:clean-unicode
   #:safely-read-from-string
                                        ; filesystem
   #:pathname-content #:save-into-file #:load-from-file
   ))
