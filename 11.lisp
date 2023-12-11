(asdf:load-system :alexandria)
(asdf:load-system :cl-ppcre)

(flet ((solve (expansion)
         (let ((galaxies-by-column (make-hash-table))
               (max-column 0))
           (loop for line in (uiop:read-file-lines "11.input")
                 for row from 0 upto 1000
                 with y-expansion = 0
                 do (let ((hashes (cl-ppcre:all-matches "#" line)))
                      (if hashes
                          (loop for (x y) on hashes by #'cddr
                                do (progn
                                     (setf max-column (max max-column x))
                                     (push (+ row y-expansion) (gethash x galaxies-by-column))))
                          (incf y-expansion expansion))))
           (let ((galaxies ())
                 (total-distance 0))
             (loop for x from 0 upto max-column
                   with x-expansion = 0
                   do (let ((glist (gethash x galaxies-by-column)))
                        (if glist
                            (dolist (y glist)
                              (push (cons (+ x x-expansion) y) galaxies))
                            (incf x-expansion expansion))))
             (alexandria:map-combinations
              (lambda (gpair)
                (incf total-distance ;; Manhattan distance
                      (+ (abs (- (car (car gpair)) (car (cadr gpair))))
                         (abs (- (cdr (car gpair)) (cdr (cadr gpair)))))))
              galaxies :length 2)
              total-distance))))
  (print (solve 1)) ;; Part 1
  (print (solve 999999))) ;; Part 2
