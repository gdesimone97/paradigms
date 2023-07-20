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

(define l1 (cons-stream 1 '(1 2 3 4)))
(define l2 (cons-stream 1 '(1 2 3 4)))

(add-series l1 l2)
(take 2 (add-series l1 l2))

(define (mul-coeff coeff1 coeff2)
  (* coeff1 coeff2))

(define rev-series '())

(define (get-head s)
  (cons-stream (stream-car s) (get-head (stream-cdr s))))

(define (get-tail s)
  (cons-stream (stream-car rev-series) (get-tail (stream-cdr rev-series))))

(define (mult-series-single s1 s2)
  (if (or (null? s2) (null? s1))
      (* 1 0)
      (+ (mul-coeff (stream-car s1) (stream-car s2)) (mult-series-single (stream-cdr s1) (stream-cdr s2)))))

(define (mult-series s1 s2)
  (define element (stream-car s2))
  (if (stream-null? rev-series)
        (set! rev-series (list element))
        (set! rev-series (cons element rev-series)))
  (define res (mult-series-single s1 rev-series))
  (cons-stream res (mult-series s1 (stream-cdr s2))))

;;(mult-series l1 l2)
l1
l2
(take 4 (mult-series l1 l2))