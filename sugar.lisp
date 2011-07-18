(in-package #:cl-blackjack)

(defmacro awith (it &body body)
  `(let ((it ,it))
     ,@body))

(defmacro aif (test then &optional else)
  `(let ((it ,test))
     (if it ,then ,else)))

(defmacro awhen (test &body forms)
  `(let ((it ,test))
     (when it ,@forms)))

(defmacro aunless (test &body forms)
  `(let ((it ,test))
     (unless it ,@forms)))

(defmacro alter (source &rest side-effects)
  "Evaluate SIDE-EFFECTS on SOURCE (evaluated and dynamically rebound to ALTERED) and return it's final value."
  `(let ((altered ,source))
     (declare (ignorable altered))
     ,@side-effects
     altered))

(defmacro append-case (source-list &rest clause-appendix-plist)
  "Append list according to cases logic."
  (unless (evenp (length clause-appendix-plist))
    (error "The list of clauses and appendixes should have an even length."))
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

(defun compare (x y &key key (test #'eql))
  (macrolet ((a (z)
               `(if (functionp key)
                    (funcall key ,z)
                    ,z)))
    (funcall test (a x) (a y))))

(defmacro compost (&rest functions)
  (with-gensyms (x)
    `(lambda (,x)
       (mutate ,x ,@functions))))

(defmacro echo (form &key label)
  "Pretty print FORM => <EVALUATED-FORM> and return the value. LABEL is just for overweight source forms."
  (with-gensyms (form* label*)
    `(let* ((,form* ,form)
            (,label* (or ,label ',form)))
       (format t "~&~a => ~s~%" ,label* ,form*)
       ,form*)))

(defun find-assoc (needle assoc-pairs &key (test #'eql))
  (second (find needle
                assoc-pairs
                :test test
                :key #'first)))

(defun group (source n)
  (if (zerop n) (error "Zero length."))
  (labels ((rec (source acc)
             (let ((rest (nthcdr n source)))
               (if (consp rest)
                   (rec rest (cons
                               (subseq source 0 n)
                               acc))
                   (nreverse
                     (cons source acc))))))
    (if source (rec source nil) nil)))

(defmacro hamster (&body journey)
  "Evaluate the JOURNEY with casual (PICK-UP 'GRAIN) events and return the resulting pouch contents."
  (with-gensyms (pouch)
    `(let (,pouch)
       (macrolet ((pick-up (grain)
                    `(push ,grain ,',pouch)))
         ,@journey)
       (reverse ,pouch))))

(defmacro make-revolver-magazine (source)
  (let ((g-source (gensym)))
    `(let ((,g-source ,source))
       (lambda ()
         (let ((item (first ,g-source)))
           (setf ,g-source (append (rest ,g-source) (list item)))
           item)))))

(defmacro maphash-collect ((hash-key hash-value) hash-table &body collector-body)
  `(loop for ,hash-key being the hash-keys of ,hash-table using (hash-value ,hash-value)
      collect (progn ,@collector-body)))

(defun mkstr (&rest args)
  (with-output-to-string (s)
    (dolist (a args) (princ a s))))

(defun mutate (value &rest mutations)
  "Process the VALUE through each of the one-argument MUTATIONS lambdas."
  (dolist (mutation mutations value)
    (setf value (funcall mutation value))))

(defun pipemap (list &rest mutations)
  "Map the LIST through each of the one-argument MUTATIONS lambdas."
  (mapcar (lambda (value)
            (apply #'mutate value mutations))
          (typecase list
            (list list)
            (t (list list)))))

(defmacro pizdec (&rest huynya)
  (adjoin 'progn
          (apply #'append
                 (loop for foo in huynya collect `((when (boundp ',foo)
                                                     (makunbound ',foo))
                                                   (when (fboundp ',foo)
                                                     (fmakunbound ',foo))
                                                   (unintern ',foo))))))

(defmacro prognil (&body body)
  `(progn ,@body nil))

(defun symb (&rest args)
  (values (intern (apply #'mkstr args))))

(defun true? (thing)
  "Evaluate the THING to T or NIL."
  (when thing t))

(defun shell-run-output (program &optional (args nil))
  (let ((shell-output (make-string-output-stream)))
    (sb-ext::run-program program args :output shell-output :search t :wait t)
    (get-output-stream-string shell-output)))

(defun symbol-keyword (symbol)
  (intern (symbol-name symbol) :keyword))

(defun keyword-name (keyword)
  (unless (keywordp keyword)
    (error 'type-error :datum keyword :expected-type 'keyword))
  (string-downcase (symbol-name keyword)))
