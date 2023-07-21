#lang scheme

(define dx 1e-5)
(define tollerance 1e-7)

(define (derv f)
  (lambda (x) (/ (- (f (+ x dx)) (f x)) dx)))

(define (newton g)
  (define dg (derv g))
  (lambda (x)
    (- x (/ (g x) (dg x)))))

(define (close? a b)
  (< (abs (- a b)) tollerance))

(define (fixpoint f start)
  (define next (f start))
  (if (close? start next)
      next
      (fixpoint f next)))

(define (g x) (+ (sin x) (cos x) -1.2))
(define solution (fixpoint (newton g) 0))