#lang scheme

(define empty-stream '())

(define-syntax cons-stream
  (syntax-rules ()
    ((cons-stream a b)
    (cons a (delay b)))))

(define stream-null? null?)

(define (stream-car s)
  (car s))

(define (stream-cdr s)
  (force (cdr s)))

(define (stream cadr s)
  (stream-car (stream-cdr s)))

(define (partial-sums s)
  (if (stream-null? s)
      0
      (+ (stream-car s) (partial-sums (stream-cdr s)))))

(define s1 (cons-stream 0 '(10 20 30)))
(time (partial-sums s1))