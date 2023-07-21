#lang scheme

(define (flatten l)
  (if (null? l)
      '()
      (let ((e (car l))
            (next (cdr l)))
        (foldr cons (flatten next) e))))
        
(define l '((12) (a b c) () (z)))
l
(flatten l)