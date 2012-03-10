;; (c) Дмитрий Пинский <demetrius@neverblued.info>
;; Допускаю использование и распространение согласно
;; LLGPL -> http://opensource.franz.com/preamble.html

(in-package #:cl-blackjack)

(defmacro append-case (source-list &rest clause-appendix-plist)
  "Append list according to cases logic."
  (unless (evenp (length clause-appendix-plist))
    (error 'data-error "The list of clauses and appendixes ~a should have an even length." clause-appendix-plist))
  (with-gensyms (source)
    `(let ((,source ,source-list))
       ,@(mapcar (lambda (case-form)
                   `(when ,(first case-form)
                      (setf ,source (append ,source ,(second case-form)))))
                 (group clause-appendix-plist 2))
       ,source)))

(defmacro careful-apply (func params &optional (default nil))
  (with-gensyms (f p)
    `(let ((,f ,func)
           (,p ,params))
       (if (functionp ,f)
           (apply ,f ,p)
           (or (values ,default t) ,p)))))

(defmacro hamster (&body journey)
  "Evaluate JOURNEY with casual (PICK-UP 'GRAIN) events and return the resulting pouch contents."
  (with-gensyms (pouch)
    `(let (,pouch)
       (macrolet ((pick-up (grain)
                    `(push ,grain ,',pouch)))
         ,@journey)
       (reverse ,pouch))))

(defmacro maphash-collect ((hash-key hash-value) hash-table &body collector-body)
  `(loop for ,hash-key being the hash-keys of ,hash-table using (hash-value ,hash-value)
      collect (progn ,@collector-body)))

(defmacro prognil (&body body)
  `(progn ,@body nil))
