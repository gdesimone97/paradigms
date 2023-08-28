#lang scheme
(define (poly-add p1 p2)
  (cond ((null? p1) p2)
        ((null? p2) p1)
        (else (cons (+ (car p1) (car p2)) (poly-add (cdr p1) (cdr p2))))))

(poly-add '(1 -2 1) '(0 1 0 0 -2)) ;test

(define (poly-scale p v)
  (map (lambda (x) (* x v)) p))

(poly-scale '(1 2 3) 3) ;test

(define (poly-mult p1 p2)
  (cond ((null? p1) '())
        ((null? p2) '())
        (else
         (cons (* (car p1) (car p2)) (poly-add (poly-scale (cdr p2) (car p1))
                                               (poly-mult (cdr p1) p2))))))

(poly-mult '(1 1) '(1 -1)) ;test

(define (poly-derive p)
  (define (poly-derive-inner p index)
    (if (null? p)
        '()
        (cons (* (car p) index) (poly-derive-inner (cdr p) (+ index 1)))))
  (poly-derive-inner (cdr p) 1))

(display "Poly derive: ")
(poly-derive '(3 -2 -1 1)) ;test

(define (eval-poly p v)
  (define (eval-poly-inner p v index start)
    (if (null? p) start
        (let ((new-start (+ start (* (car p) (expt v index)))))
          (eval-poly-inner (cdr p) v (+ index 1) new-start))))
  (eval-poly-inner (cdr p) v 1 (car p)))
  
(eval-poly '(1 1 2) 1)

;Newton
(define tollerance 1e-7)

(define (newton g)
  (define dg (poly-derive g))
  (lambda (x)
    (- x (/ (eval-poly g x) (eval-poly dg x)))))

(define (close? a b)
  (< (abs (- a b)) tollerance))

(define (fixpoint f start)
  (define next (f start))
  (if (close? start next)
      next
      (fixpoint f next)))

(define (poly-solve p)
  (fixpoint (newton p) 0.1))

(poly-solve '(1 0 -8 1))