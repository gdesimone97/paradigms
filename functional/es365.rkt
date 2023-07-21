#lang scheme

(define-syntax cons-stream
 (syntax-rules ()
 ( (cons-stream expr1 expr2)
 (cons expr1 (delay expr2)) )))

(define stream-null? null?)
(define stream-car car)
(define (stream-cdr s) (force (cdr s)))
(define (stream-cadr s) (stream-car (stream-cdr s)))
(define (stream-caddr s) (stream-car (stream-cdr (stream-cdr s))))
(define (stream-cddr s) (stream-cdr (stream-cdr s)))
(define (map-stream func s) (cons (func (stream-car s)) (delay (map func s))))

(define (alt n)
  (expt -1 n))

(define (take n stream)
  (if (or (stream-null? stream) (< n 1))
          '()
       (cons (stream-car stream)
       (take (- n 1) (stream-cdr stream)))))

(define (log-series-inner n)
  (cons-stream (* (alt (- n 1)) (/ 1 n)) (log-series-inner (+ n 1) )))

(define log-series
  (log-series-inner 1))

;(time (take 10 log-series))

(define (op s)
  (let ((x2 (stream-caddr s))
        (x1 (stream-cadr s))
        (x (stream-car s)))
    (- x2 (/ (expt (- x2 x1) 2) (- (- x2 x1) (- x1 x))))
    ))

(define (aitken s)
  (define res (op s))
  (cons-stream res (aitken (stream-cdr s))))

(define (fixpoint tollerance s)
  (define a (stream-car s))
  (define b (stream-cadr s))
  (define diff (abs (- a b)))
  (if (< diff tollerance)
      b
      (fixpoint tollerance (stream-cdr s))))

(define (sum-stream s)
  (define (sum-stream-inner s sum)
    (+ sum (stream-car sum)))
  (cons-stream 0 (sum-stream-inner (stream-cdr s) 0)))

(define l (cons-stream 1 '(2 3)))
(sum-stream l)


