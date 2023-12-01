;; Part 1

(loop for line in (uiop:read-file-lines "01.input")
      for nline = (remove-if #'alpha-char-p line)
      sum (parse-integer (format nil "~A~A" (uiop:first-char nline) (uiop:last-char nline))))

;; Part 2

(asdf:load-system :str)

(loop for line in (uiop:read-file-lines "01.input")
      for nline = (remove-if #'alpha-char-p
                             (reduce (lambda (a b)
                                       (concatenate 'string a b))
                                     (loop while (not (equal line ""))
                                           collect (or (loop for n in '(("one" . "1") ("two" . "2") ("three" . "3")
                                                                        ("four" . "4") ("five" . "5") ("six" . "6")
                                                                        ("seven" . "7") ("eight" . "8") ("nine" . "9"))
                                                             when (str:starts-with? (car n) line)
                                                               return (and (setf line (subseq line 1)) (cdr n)))
                                                       (and (let ((c (subseq line 0 1))) (setf line (subseq line 1)) c))))))
      do (print nline)
      sum (parse-integer (format nil "~A~A" (uiop:first-char nline) (uiop:last-char nline))))
