(asdf:load-system :fset)

(defun max-multiplicity (bag)
  (let ((max-count 0))
    (fset:do-bag-pairs (element count bag)
      (when (> count max-count)
        (setf max-count count)))
    max-count))

(defun xform (p &optional (low-jack nil))
  (let ((s (car p))
        (v (cadr p))
        (card-map (if low-jack
                      '((#\T . #\B) (#\J . #\1) (#\Q . #\D) (#\K . #\E) (#\A . #\F))
                      '((#\T . #\B) (#\J . #\C) (#\Q . #\D) (#\K . #\E) (#\A . #\F)))))
    (dolist (m card-map)
      (setf s (substitute (cdr m) (car m) s)))
    (let ((bag (fset:convert 'fset:bag (coerce s 'list))))
      (cons
       (format nil "~A~A~A" (max-multiplicity bag) (- 5 (fset:set-size bag)) s)
       v))))

;; Part 1
(print (loop for hand in (sort (mapcar #'xform
                                       (mapcar #'uiop:split-string (uiop:read-file-lines "07.input")))
                               (lambda (a b) (string< (car a) (car b))))
             with i = 0
             sum (* (incf i) (parse-integer (cdr hand)))))

;; Part 2
(print (loop for hand in (sort (mapcar (lambda (hand)
                                         (let ((cards (car hand)))
                                           (let ((best (car (sort (loop for c in '(#\2 #\3 #\4 #\5 #\6 #\7 #\8 #\9 #\T #\Q #\K #\A)
                                                                        collect (xform (list (substitute c #\J cards) hand)))
                                                                  (lambda (a b) (string> (car a) (car b)))))))
                                             (cons (format nil "~A~A" (subseq (car best) 0 2) (subseq (car (xform (list (car hand) (cadr hand)) t)) 2)) (cddr best)))))
                                       (mapcar #'uiop:split-string (uiop:read-file-lines "07.input")))
                               (lambda (a b) (string< (car a) (car b))))
             with i = 0
             sum (* (incf i) (parse-integer (cadr hand)))))
