(labels ((solve (xform)
           (loop for line in (mapcar #'uiop:split-string (uiop:read-file-lines "09.input"))
                 sum (labels ((process (nums)
                                (let ((dnums (loop for i from 0 below (1- (length nums))
                                                   collect (- (nth (1+ i) nums) (nth i nums)))))
                                  (if (every #'zerop dnums)
                                      0
                                      (+ (car (last dnums)) (process dnums))))))
                       (let ((nline (mapcar #'parse-integer (funcall xform line))))
                         (+ (car (last nline)) (process nline)))))))
  ;; Part 1
  (print (solve #'identity))
  ;; Part 2
  (print (solve #'reverse)))
