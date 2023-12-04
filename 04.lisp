;; Part 1

(loop for line in (mapcar (lambda (line)
                            (uiop:split-string line :separator '(#\| #\:)))
                          (uiop:read-file-lines "04.input"))
      for winners = (mapcar #'parse-integer (remove-if #'uiop:emptyp (uiop:split-string (cadr line))))
      for numbers = (mapcar #'parse-integer (remove-if #'uiop:emptyp (uiop:split-string (caddr line))))
      sum (let ((i (intersection numbers winners)))
            (if i (expt 2 (1- (length i))) 0)))

;; Part 2

(let ((dupes (make-hash-table)))
  (loop for line in (mapcar (lambda (line)
                              (uiop:split-string line :separator '(#\| #\:)))
                            (uiop:read-file-lines "04.input"))
        with count = 0
        for number from 1 to 1000
        for winners = (mapcar #'parse-integer (remove-if #'uiop:emptyp (uiop:split-string (cadr line))))
        for numbers = (mapcar #'parse-integer (remove-if #'uiop:emptyp (uiop:split-string (caddr line))))
        do (let ((i (intersection numbers winners)))
             (incf count) ;; for the original card
             (dotimes (d (1+ (length (gethash number dupes))))
               (dotimes (x (length i))
                 (incf count)
                 (push t (gethash (+ number (1+ x)) dupes)))))
        finally (print count)))
