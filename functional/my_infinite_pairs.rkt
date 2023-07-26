#lang scheme

(define-syntax cons-stream
  (syntax-rules ()
    ((cons-stream a b)
     (cons a (delay b)))))

(define stream-null? null?)
(define (stream-car s) (car s))
(define (stream-cdr s) (force (cdr s)))
(define (stream-cddr s) (stream-cdr (stream-cdr s)))

(define (stream-map func s)
  (if (stream-null? s)
      '()
      (cons-stream (func (stream-car s)) (stream-map func (stream-cdr s)))))

(define (take n s)
  (if (or (stream-null? s)
          (eq? n 0))
      '()
      (cons (stream-car s) (take (- n 1) (stream-cdr s)))))
      
(define (interval s1 s2)
  (if (stream-null? s1)
      s2 
      (cons-stream (stream-car s1) (interval s2 (stream-cdr s1)))))

(define (pairs s t)
  (cons-stream
   (list (stream-car s) (stream-car t))
  (interval 
   (stream-map
    (lambda (x) (list (stream-car s) x))
    (stream-cdr t))
   (pairs (stream-cdr s) (stream-cdr t)))))

(define (integers-inner n)
  (cons-stream n (integers-inner (+ n 1))))

(define integers
  (integers-inner 1))

(define test (pairs integers integers))
(take 10 test)