(in-package #:cl-blackjack)

(defun begins-with? (whole beginning)
  (let ((beginning-length (length beginning))
        (whole-length (length whole)))
    (if (> beginning-length whole-length)
        nil
        (equal beginning (subseq whole 0 beginning-length)))))

(defun join (&rest strings)
  (format nil "~{~a~}" strings))

(defun join-by (separator &rest strings)
  (format nil (format nil "~~{~~a~~^~a~~}" separator) strings))

(defun join-rec (&rest strings-or-lists)
  (apply #'join (mapcar (lambda (item)
                          (if (listp item)
                              (apply #'join-rec item)
                              item))
                        strings-or-lists)))

(defun name-keyword (string)
  (intern (string-upcase string) (find-package :keyword)))

(defun split-once (regex source)
  (split regex source :limit 2))

(defun trim-left (cut source)
  (regex-replace (create-scanner `(:sequence
                                   :start-anchor
                                   ,cut
                                   (:sequence (:register (:greedy-repetition 0 nil :everything)) :end-anchor)
                                   ))
                 source "\\1"))

(defun trim-right (cut source)
  (regex-replace (create-scanner `(:sequence
                                   (:sequence (:register (:greedy-repetition 0 nil :everything)) :end-anchor)
                                   ,cut
                                   :end-anchor
                                   ))
                 source "\\1"))

(defun regex-cut (regex source)
  (regex-replace-all regex source ""))

(defun checksum (secret)
  (ironclad:byte-array-to-hex-string (ironclad:digest-sequence :sha256 (ironclad:ascii-string-to-byte-array secret))))
