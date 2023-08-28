#lang scheme
;######################### Utils
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

(define (stream-map proc . argstreams)
  (if (stream-null? (car argstreams))
      empty-stream
      (cons-stream
        (apply proc (map stream-car argstreams))
        (apply stream-map 
               (cons proc (map stream-cdr argstreams))))))

(define (take n stream)
  (if (or (stream-null? stream) (< n 1))
          '()
       (cons (stream-car stream)
       (take (- n 1) (stream-cdr stream)))))
;#########################

;Test streams:
(define s1 (cons-stream 1 '(2 3 4)))

;Test add-stream:
(define (add-streams s1 s2)
  (stream-map + s1 s2))

(take 10 (add-streams s1 s1))

;Test mul-stream:
(define (mul-streams s1 s2)
  (stream-map * s1 s2))

(take 10 (mul-streams s1 s1))

;Integers
(define (integers-from n)
  (cons-stream n (integers-from (+ n 1))))

(define integers
  (integers-from 1))

;Test factorials
(define factorials
  (cons-stream 1 (mul-streams (integers-from 2) factorials)))

(take 10 factorials)
      
  