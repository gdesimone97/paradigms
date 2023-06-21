#lang scheme
(define empty-stream '())

(define-syntax cons-stream
 (syntax-rules ()
 ( (cons-stream expr1 expr2)
 (cons expr1 (delay expr2)) )))

(define stream-null? null?)
(define stream-car car)
(define (stream-cdr s) (force (cdr s)))
(define (stream-cadr s) (stream-car (stream-cdr s)))
(define (stream-cddr s) (stream-cdr (stream-cdr s)))

(define square (lambda (x) l(* x x)))
(define l (cons 2 '(2 3 4 5 6)))
(define (map-stream func s) (cons (func (stream-car s)) (delay (map func s))))
(define l2 (map-stream square l))

(define (integers-from n)
 (cons-stream n (integers-from (+ n 1))))