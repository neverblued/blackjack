;; (c) Дмитрий Пинский <demetrius@neverblued.info>
;; Допускаю использование и распространение согласно
;; LLGPL -> http://opensource.franz.com/preamble.html

(in-package #:cl-blackjack)

(defmacro define-data-factory ((name &optional (item name)) list)
  `(progn

     (defmethod ,(symb "CREATE-" name) ((this ,item))
       (push this ,list)
       this)

     (defmethod ,(symb "DELETE-" name) ((this ,item))
       (setf ,list
             (remove this ,list
                     :test #'equal))
       this)))

(defmacro define-fetch-list ((&rest signature) name)
  (declare (type symbol name))
  (macrolet ((map-signature (key &body body)
               `(iter (for ,key in signature)
                      (collect (progn ,@body)))))
    (labels ((? (key)
               (symb key "?"))
             (fetcher-signature ()
               (map-signature key `(,key nil ,(? key)))))
      (with-gensyms (source)
        `(progn
           (let ((,source #',name))

             (defgeneric ,name (&key))

             (defmethod ,name (&key ,@(fetcher-signature) &allow-other-keys)
               (declare (ignorable ,@(mapcar #'? signature)))
               (let ((list (funcall ,source)))
                 (iter (for item in list)
                       (when (and ,@(map-signature key
                                      `(if ,(? key)
                                           (equal ,key (,key item))
                                           t)))
                         (collect item)))))))))))

(defmacro define-fetch-item (item list &key sort-predicate sort-key grab)
  (declare (type symbol item list))
  `(progn

     (defgeneric ,item (&rest filter))

     (defmethod ,item (&rest filter)
       (macrolet ((result ()
                    `(values (,',(or grab 'first) it)
                             (length it))))
         (awith (apply #',list filter)
           ,(aif sort-predicate
                 `(awith (sort it ,it :key ,sort-key)
                    (result))
                 '(result)))))))
