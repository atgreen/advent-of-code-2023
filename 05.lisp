(declaim (optimize (speed 3) (debug 0) (safety 0)))

(time
 (let ((input (uiop:read-file-lines "05.input")))
   (let ((seeds (mapcar #'parse-integer (cdr (uiop:split-string (car input)))))
         (maps nil))
     (setf input (cdddr input))
     (loop until (not input)
           for map = (list)
           do (loop until (uiop:emptyp (car input))
                    do (let ((mline (mapcar #'parse-integer (uiop:split-string (car input)))))
                         (push mline map)
                         (setf input (cdr input)))
                    finally (push (reverse map) maps))
           do (setf input (cddr input))
           finally (setf maps (reverse maps)))
     ;; Part 1
     (print (loop for s in seeds
                  minimize (loop for map in maps
                                 for range = (find-if (lambda (e) (<= 0 (- s (cadr e)) (caddr e))) map)
                                 do (setf s (or (and range
                                                     (+ (car range) (- s (cadr range))))
                                                s))
                                 finally (return s))))
     ;; Part 2
     (print (loop for (start length) on seeds by #'cddr
                  do (format t "> ~A : ~A~%" start (1- (+ start length)))
                  minimize (loop for seed from start upto (1- (+ start length))
                                 for s = seed
                                 minimize (loop for map in maps
                                                for range = (find-if (lambda (e) (<= 0 (- s (cadr e)) (caddr e))) map)
                                                do (setf s (or (and range
                                                                    (+ (car range) (- s (cadr range))))
                                                               s))
                                                finally (return s))))))))
