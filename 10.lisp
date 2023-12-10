(let* ((grid (format nil "~{~A~}" (uiop:read-file-lines "10.input")))
       (ogrid (copy-seq grid))
       (start-pos (+ 140 (position #\S grid))) ;; Assumption!
       (steps 1)
       (moves '((#\| (-140 140))
                (#\- (-1 1))
                (#\L (140 -1))
                (#\J (140 1))
                (#\7 (1 -140))
                (#\F (-1 -140))
                (#\S (-1 1 -140 140)))))
  (flet ((find-next (pos)
           (format t "Finding next: ~A ~A~%" pos (aref grid pos))
           (loop for dir in (mapcar #'- (cadr (assoc (aref grid pos) moves)))
                 for next-pipe = (aref grid (+ pos dir))
                 do (format t "   checking ~A to ~A~%" dir next-pipe)
                 when (and (position dir (cadr (assoc next-pipe moves)))
                           (setf (aref grid pos) #\X))
                   return (+ pos dir))))
    (loop with pos = (+ start-pos 140)
          until (eq pos start-pos)
          do (progn (incf steps)
                    (format t "~A: ~A~%" pos (aref grid pos))
                    (setf pos (find-next pos))))
    (print (/ steps 2)))) ;; Part 1

#|  PART 2 NOT WORKING :(
(let ((count 0))
    (loop for i from 0 below 140
          do (setf inout 0)
          do (loop for j from 0 below 140
                   do (let ((pipe (aref ogrid (+ (* 140 i) j)))
                            (seen (aref grid (+ (* 140 i) j))))
                        (if (not (eq #\X seen))
                            (when (> (mod inout 2) 0)
                              (progn
                                (setf (aref grid (+ (* 140 i) j)) #\*)
                                (incf count)))
                            (progn
                              (print pipe)
                              (cond
                                ((eq pipe #\|) (incf inout))
                                ((or (eq pipe #\J) (eq pipe #\F)) (incf inout 0.5))
                                ((or (eq pipe #\L) (eq pipe #\S) (eq pipe #\7)) (incf inout -0.5))))))))
    (loop for i from 0 below 140
          do (progn
               (format t "~A~%" (subseq grid 0 140))
               (setf grid (subseq grid 140))))
    (print count)))
#|
