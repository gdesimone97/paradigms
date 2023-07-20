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

(define (add-series s1 s2)
  (define c1 (stream-car s1))
  (define c2 (stream-car s2))
  (define res (+ c1 c2))
  (cons-stream res (add-series (stream-cdr s1) (stream-cdr s2))))

(define l1 (cons-stream 1 '(1 2 3 4 5 6 7 8 9 10)))
(define l2 (cons-stream 1 '(1 2 3 4 5 6 7 8 9 10)))

(add-series l1 l2)
(take 6 (add-series l1 l2))

(define (mul-coeff coeff1 coeff2)
  (* coeff1 coeff2))

(define rev-series '())

(define (get-head s)
  (cons-stream (stream-car s) (get-head (stream-cdr s))))

(define (get-tail s)
  (cons-stream (stream-car rev-series) (get-tail (stream-cdr rev-series))))

(define (mult-series-single s1 s2)
  (if (null? s2)
      0
      (let (a (stream-car s1))
           (b (car s2))
           (res (mul-coeff a b))
        (+ (res (mult-series a 
  

(define (mult-series s1 s2)
  (define element (stream-car s2))
  (if (stream-null? rev-series)
        (set! rev-series (list element))
        (set! rev-series (cons element rev-series)))
  (define a (stream-car s1))
  (define b (stream-car rev-series))
  (define res (mul-coeff a b))
  (cons-stream res (mult-series (stream-cdr s1) (stream-cdr s2))))

(mult-series l1 l2)
(take 6 (mult-series l1 l2))