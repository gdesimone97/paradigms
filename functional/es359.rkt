#lang scheme

(define-syntax cons-stream
  (syntax-rules ()
    ( (cons-stream a b)
      (cons a (delay b)))))

(define empty-stream '())

(define stream-null? null?)
(define stream-car car)
(define (stream-cdr s) (force (cdr s)))
(define (stream-cadr s) (stream-car (stream-cdr s)))
(define (stream-cddr s) (stream-cdr (stream-cdr s)))
(define (map-stream func s) (cons (func (stream-car s)) (delay (map func s))))

(define (take n stream)
  (if (or (stream-null? stream) (< n 1))
          '()
       (cons (stream-car stream)
       (take (- n 1) (stream-cdr stream)))))

(define (math-op term n)
  (* (/ 1 n) term))

(define (integrate s n)
  (define curr (stream-car s))
  (cons-stream (math-op curr n) (integrate (stream-cdr s) (+ n 1))))

(define (integrate-series s)
  (integrate s 1))

(define l (cons-stream 1 '(1 2 3 4 5 6 7 8 9 10)))
(integrate-series l)
(take 10 (integrate-series l))

(define exp-series
  (cons-stream 1 (integrate-series exp-series)))

(take 5 exp-series)

(define (inv s n)
  (define curr (stream-car s))
  (cons-stream (* (expt -1 n) curr) (inv (stream-cdr s) (+ n 1))))

(define sin-series
  (cons-stream 0 (integrate-series (inv cosin-series 1))))

(define cosin-series
  (cons-stream 1 (integrate-series (inv sin-series 1))))

(take 6 cosin-series)
(take 6 sin-series)



