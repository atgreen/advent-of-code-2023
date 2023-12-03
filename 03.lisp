(asdf:load-system :cl-ppcre)

(let ((grid (format nil "~V{~A~:*~}~{.~A.~}~V{~A~:*~}"
                    142 '(#\.) (uiop:read-file-lines "03.input") 142 '(#\.)))
      (gears (make-hash-table)))
  (print (loop for (start end) on (cl-ppcre:all-matches "(\\d+)" grid) by #'cddr
               for value = (parse-integer (subseq grid start) :junk-allowed t)
               sum (if (not (every (lambda (i)
                                     (every (lambda (j)
                                              (let ((c (aref grid (+ i j))))
                                                (when (eq c #\*) (push value (gethash (+ i j) gears)))
                                                (or (eq c #\.) (digit-char-p c))))
                                            '(-143 -142 -141 -1 1 141 142 143)))
                                   (loop for i from start to (1- end) collect i)))
                       value 0)))
  (print (loop for value being the hash-values of gears
               sum (if (eq (length value) 2) (apply #'* value) 0))))
