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

(define (variable? x) (symbol? x))
(define (variable p) (car p))
(define (term-list p) (stream-cdr p))

(define (make-poly var terms)
  (if (not (variable? var))
      (error "var is not a symbol")
      (cons-stream var terms)))

(define (poly? p)
  (if (and (variable? (variable p))
           (list? (term-list p)))
      #t
      #f))

(define (same-variable? v1 v2)
  ( if (and (variable? v1)
            (variable? v2)
            (eq? v1 v2))
       #t
       #f))

(define p1 (make-poly 'x '(1 4 9)))

(define (integrate s n)0
  (cons-stream (* (/ 1 n) (stream-car s)) (integrate (stream-cdr s) (+ n 1))))
   
(define (integrate-series s1)
  (define s-terms (term-list s1))
  (cons 'c (integrate s-terms 1)))

(integrate-series p1)
(stream-cdr (integrate-series p1))
(stream-cddr (integrate-series p1))
(stream-cddr (stream-cdr (integrate-series p1)))

(define (integrate-series2 s)
  (cons 1 (integrate s 2)))

(display "Exp series:\n")
(define exp-series
  (cons-stream 1 (integrate-series2 exp-series)))
(stream-cdr exp-series)
(stream-cddr exp-series)
(define temp (stream-cddr exp-series))
(stream-cdr temp)

(define (take n stream)
  (if (or (stream-null? stream) (< n 1))
          '()
       (cons (stream-car stream)
       (take (- n 1) (stream-cdr stream)))))
(take 10 exp-series)
