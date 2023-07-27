#lang scheme

(define-syntax cons-stream
 (syntax-rules ()
 ( (cons-stream expr1 expr2)
 (cons expr1 (delay expr2)) )))

(define stream-null? null?)
(define stream-car car)
(define (stream-cdr s) (force (cdr s)))
(define (stream-cadr s) (stream-car (stream-cdr s)))
(define (stream-cddr s) (stream-cdr (stream-cdr s)))

(define (take n stream)
  (if (or (stream-null? stream) (< n 1))
          '()
       (cons (stream-car stream)
       (take (- n 1) (stream-cdr stream)))))

(define (stream-map proc . argstreams)
  (if (stream-null? (car argstreams))
      '()
      (cons-stream
        (apply proc (map stream-car argstreams))
        (apply stream-map 
               (cons proc (map stream-cdr argstreams))))))

(define (scale-stream s fact)
  (stream-map (lambda (x) (* fact x)) s))

(define (add-stream s1 s2)
  (stream-map + s1 s2))

(define(multiply-streams s1 s2)
  (stream-map * s1 s2))

(define (cauchy  s1 s2)
  (cons-stream (* (stream-car s1) (stream-car s2))
               (add-stream (add-stream
                            (scale-stream (stream-cdr s1)
                                          (stream-car s2))
                            (scale-stream (stream-cdr s2)
                                          (stream-car s1)))
                           (cons-stream 0 (cauchy (stream-cdr s1) (stream-cdr s2))))))

(define (sum s)
  (cons-stream (stream-car s) (add-stream (stream-cdr s) (sum s))))

(define l (cons-stream 1 '(2 3 4 5)))
(take 4 (cauchy l l))
(take 4 (sum (cauchy l l)))