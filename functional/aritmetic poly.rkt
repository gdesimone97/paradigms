#lang scheme
(define (variable? x) (symbol? x))
(define (variable p) (car p))
(define (term-list p) (cdr p))

(define (make-poly var terms)
  (if (not (variable? var))
      (error "var is not a symbol")
      (cons var terms)))

(define (same-variable? v1 v2)
  ( if (and (variable? v1)
            (variable? v2)
            (eq? v1 v2))
       #t
       #f))

(define (add-terms t1 t2)
  (map + t1 t2))
      
;Test add-terms
(define t1 (cons 1 '(1 2 3)))
(define t2 (cons 1 '(1 2 3)))
(add-terms t1 t2)

(define (add-poly p1 p2)
  (define v1 (variable p1))
  (define v2 (variable p2))
  (if (same-variable? v1 v2)
      (let ((var v1)
            (sum-terms (add-terms (term-list p1) (term-list p2))))
        (make-poly var sum-terms))
      (display "polies don't have same variable")))

;Test adding
(define p1 (make-poly 'x '(1 2 3)))
(define p2 (make-poly 'x '(1 2 3)))
(define py (make-poly 'y '(1 2 3)))
(add-poly p1 p2)
(add-poly p1 py)