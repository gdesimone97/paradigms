#lang scheme

(define (add-term a b)
  (+ a b))

;Poly add
(define (poly-add p1 p2)
  (cond ((null? p1) p2)
        ((null? p2) p1)
        (else
         (cons (add-term (car p1) (car p2)) (poly-add (cdr p1) (cdr p2)))))) 

(define (scale-poly p x)
  (if (null? p)
      '()
      (cons (* (car p) x) (scale-poly (cdr p) x))))

(define (poly-derive p)
  (define (poly-derive-inner p n)
    (if (null? p)
        '()
        (cons (* (car p) n) (poly-derive-inner (cdr p) (+ n 1)))))
  (poly-derive-inner (cdr p) 1))

;Newton
(define tollerance 1e-7)

(define (eval-poly p x)
  (define (eval-poly-inner p n)
    (if (null? p)
        '()
        (cons (* (car p) (expt x n)) (eval-poly-inner (cdr p) (+ n 1)))))
  (foldr + 0 (eval-poly-inner p 0)))

(define (newton p)
  (define dg (poly-derive p))
  (lambda (x)
    (- x
       (/ (eval-poly p x) (eval-poly dg x)))))

(define (close? a b)
  (< (abs (- a b)) tollerance))

(define (fixpoint f start)
  (define next (f start))
  (if (close? start next)
      next
      (fixpoint f next)))

(define (poly-solve p)
  (fixpoint (newton p) 0.1))

;test
(define p1 '(1 -2 1))
(define p2 '(0 1 0 0 -2))
(poly-add p1 p2)

(define p3 '(1 1))
(define p4 '(1 -1))

(define p5 '(3 -2 -1 1))
(poly-derive p5)

(poly-solve '(1 0 -8 1))