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

; test 1
(define square (lambda (x) l(* x x)))
(define l (cons 1 '(2 3 4 5)))
(define (map-stream func s) (cons (func (stream-car s)) (delay (map func s))))
(define l2 (map-stream square l))

; test 2
(define l3 (cons-stream 0 '(1 2 3 4 5)))

(define (integers-from n)
 (cons-stream n (integers-from (+ n 1))))
(define (integers-cons-from n)
 (cons n (integers-cons-from (+ n 1))))

(define l4 (integers-from 1))

(define (take n stream)
  (if (or (stream-null? stream) (< n 1))
          '()
       (cons (stream-car stream)
       (take (- n 1) (stream-cdr stream)))))

(define (stream-map func n lst) (map func (take n lst)))
;(stream-map square 5 l4)

; filter

(define int-div2 (lambda (n) (= 0 (remainder n 2))))
(define (filter-stream func lst) (cons-stream (car lst) (filter func lst)))
(define lf (filter-stream int-div2 l))
(define (filter-stream-inf func lst)
  (define current (car lst))
  (if (func current)
      (cons current (cdr lst))
      (filter-stream-inf func (stream-cdr lst))))
       
;(define linf (filter-stream-inf int-div2 l4))

(define (take-filter func n stream)
  (define current (car(filter-stream-inf func stream)))
  (if  (< n 1)
       '()
       (cons current (take-filter func (- n 1) (stream-cdr stream)))))

; foldr




