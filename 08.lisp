(time
 (let* ((input (uiop:read-file-lines "08.input"))
        (insns (coerce (car input) 'list))
        (node-map (make-hash-table :test #'equal)))
   (setf (cdr (last insns)) insns) ; make it circular
   (loop for line in (cddr input)
         do (setf (gethash (subseq line 0 3) node-map)
                  (cons (subseq line 7 10) (subseq line 12 15))))

   (flet ((solve (start-node done-test)
            (loop for insn in insns
                  with node = start-node
                  with count = 0
                  until (funcall done-test node)
                  do (let ((fork (gethash node node-map)))
                       (incf count)
                       (setf node (if (char= insn #\L) (car fork) (cdr fork))))
                  finally (return count))))

     ;; Part 1
     (print (solve "AAA" (lambda (n) (string= n "ZZZ"))))

     ;; Part 2
     (let ((nodes ()))
       (loop for start-node being the hash-keys of node-map
             when (char-equal #\A (aref start-node 2))
               do (push start-node nodes))
       (print (reduce #'lcm (mapcar (lambda (s) (solve s (lambda (n) (char= #\Z (aref n 2))))) nodes))))))
