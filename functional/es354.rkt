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

(define (mul-streams s1 s2)
  (if (or (stream-null? s1) (stream-null? s2))
      '()
      ( let (
             (current1 (stream-car s1))
             (current2 (stream-car s2))
             (next1 (stream-cdr s1))
             (next2 (stream-cdr s2)))
         (cons (* current1 current2) (mul-streams next1 next2)))))

(define (add-streams s1 s2)
  (if (or (stream-null? s1) (stream-null? s2))
      '()
      ( let (
             (current1 (stream-car s1))
             (current2 (stream-car s2))
             (next1 (stream-cdr s1))
             (next2 (stream-cdr s2)))
         (cons (+ current1 current2) (add-streams next1 next2)))))

(define s1 (cons-stream 0 '(1 2 3)))
(define s2 (cons-stream 0 '(1 2 3)))
(mul-streams s1 s2)
(add-streams s1 s2)