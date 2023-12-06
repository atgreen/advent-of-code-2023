;; Part 1
(let* ((input (uiop:read-file-lines "06.input"))
       (times (mapcar #'parse-integer (cdr (remove-if #'uiop:emptyp (uiop:split-string (car input))))))
       (records (mapcar #'parse-integer (cdr (remove-if #'uiop:emptyp (uiop:split-string (cadr input)))))))

  (reduce '* (loop for time in times
                   for record in records
                   collect (loop for x from 1 below time
                                 count (> (* x (- time x)) record)))))

;; Part 2 - don't even bother parsing
(loop for x from 1 below 61709066
      when (> (* x (- 61709066 x)) 643118413621041)
        sum 1)
