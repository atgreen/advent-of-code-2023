(asdf:load-system :parseq)

(parseq:defrule num () (rep (1 3) digit) (:string) (:function #'parse-integer))
(parseq:defrule red () "red" (:constant 12))
(parseq:defrule green () "green" (:constant 13))
(parseq:defrule blue () "blue" (:constant 14))
(parseq:defrule color () (or red green blue))

;; Part 1

(parseq:defrule num-cubes () (and " " num " " color (? ",")) (:choose 1 3) (:lambda (num max) (<= num max)))
(parseq:defrule draw () (and (rep (1 nil) num-cubes) (? ";")) (:choose 0) (:lambda (&rest r) (every #'identity r)))
(parseq:defrule line () (and "Game " num ":" (rep (1 nil) draw))
  (:choose 1 3)
  (:lambda (game results) (if (every #'identity results) game 0)))
(loop for line in (uiop:read-file-lines "02.input")
      sum (parseq:parseq 'line line))

;; Part 2

(parseq:defrule min-colour () (and " " num " " color (? ",")) (:choose 1 3)
  (:lambda (num max) (setf (gethash max *colour*)
                           (max num (gethash max *colour*)))))
(parseq:defrule draw-2 () (and (rep (1 nil) min-colour) (? ";")) (:constant t))
(parseq:defrule power () (and "Game " num ":" (rep (1 nil) draw-2))
  (:lambda (a b c d) (reduce #'* (loop for value being the hash-values of *colour* collect value) :initial-value 1)))
(loop for line in (uiop:read-file-lines "02.input")
      sum (progn (setf *colour* (make-hash-table))
                 (dolist (c '(12 13 14)) (setf (gethash c *colour*) 0))
                 (parseq:parseq 'power line)))
