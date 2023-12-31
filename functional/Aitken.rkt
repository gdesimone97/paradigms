#lang scheme

(define empty-stream '())

(define-syntax cons-stream
 (syntax-rules ()
 ( (cons-stream expr1 expr2)
 (cons expr1 (delay expr2)) )))

(define (within tollerance s)
  (define current (stream-car s))
  (define next (stream-cadr s))
  (define diff (abs (- current next)))
  (if (<= diff tollerance)
      current
      (within tollerance (stream-cdr s))))

(define (add-streams s1 s2)
 ; assume the streams are infinite
 (cons-stream (+ (stream-car s1) (stream-car s2))
 (add-streams (stream-cdr s1) (stream-cdr s2))))

(define (integral f a b)
 ; return a stream of increasingly better approximations
 (define midpoint (/ (+ a b) 2))
 (cons-stream (* (f midpoint) (- b a))
 (add-streams (integral f a midpoint)
 (integral f midpoint b))))

(define (f x) (/ 4 (+ 1 (* x x))))

(define stream-null? null?)
(define stream-car car)
(define (stream-cdr s) (force (cdr s)))
(define (stream-cadr s) (stream-car (stream-cdr s)))
(define (stream-cddr s) (stream-cdr (stream-cdr s)))

(define (improve s)
  (define (square x) (* x x))
  (define xn (stream-car s))
  (define xn1 (stream-cadr s))
  (define xn2 (stream-car (stream-cddr s)))
  (define an (- xn2 (/ (square (- xn2 xn1)) (- (- xn2 xn1) (- xn1 xn)))))
  (cons-stream an (improve (stream-cdr s))))

