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

(define (stream-filter cond s)
  (define curr (stream-car s))
  (if (cond curr)
      (cons-stream curr (stream-filter cond (stream-cdr s)))
      (stream-filter cond (stream-cdr s))))

(define (take n s)
  (if (or (stream-null? s)
          (eq? n 0))
      '()
      (cons (stream-car s) (take (- n 1) (stream-cdr s)))))

(define (interleave s1 s2)
  (if (stream-null? s1)
      s2
      (cons-stream (stream-car s1) (interleave s2 (stream-cdr s1)))))

(define (integers-inner n)
  (cons-stream n (integers-inner (+ n 1))))

(define integers
  (integers-inner 1))

(define (pairs s t)
  (cons-stream
   (list (stream-car s) (stream-car t))
  (interleave 
   (stream-map
    (lambda (x) (list (stream-car s) x))
    (stream-cdr t))
   (pairs (stream-cdr s) (stream-cdr t)))))

(define (triple s1 s2 s3)
  (cons-stream
   (list
    (stream-car s1) (stream-car s2) (stream-car s3))
   (interleave
   (stream-map (lambda (x) (cons (stream-car s1) x))
               (stream-cdr (pairs s2 s3)))
   (triple (stream-cdr s1) (stream-cdr s2) (stream-cdr s3)))))

(define test (triple integers integers integers))
(take 10 test)

(define (condition s)
  (let ( (i (car s))
         (  j (cadr s))
         (  k (caddr s)))
    (and (= (expt k 2) (+ (expt i 2) (expt j 2)))
    (<= i j))))

(define (test-cond s)
  (stream-filter condition s))

(take 6 (test-cond test))
