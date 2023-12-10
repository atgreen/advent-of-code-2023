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
           (loop for dir in (mapcar #'- (cadr (assoc (aref grid pos) moves)))
                 for next-pipe = (aref grid (+ pos dir))
                 when (and (position dir (cadr (assoc next-pipe moves)))
                           (setf (aref grid pos) #\X))
                   return (+ pos dir))))
    (loop with pos = (+ start-pos 140)
          until (eq pos start-pos)
          do (progn (incf steps)
                    (setf pos (find-next pos))))
    (print (/ steps 2))) ;; Part 1

  ;; Clean out the original grid
  (loop for i from 0 below (length grid)
        unless (eq #\X (aref grid i))
          do (setf (aref ogrid i) #\Space))

  ;; Hack
  (setf (aref ogrid (position #\S ogrid)) #\7)

  ;; Split it back into lines
  (let ((glines (loop for i from 0 below (* 140 140) by 140
                      collect (subseq ogrid i (+ i 140))))
        (count 0))
    (loop for line in glines
          do (let ((crossings 0))
               (loop for c across (cl-ppcre:regex-replace-all
                               "F-*J"
                               (cl-ppcre:regex-replace-all "L-*7" line "|") "|")
                     do (cond ((and (eq c #\Space) (oddp crossings))
                               (incf count))
                              ((eq c #\|) (incf crossings))))))
    count))
