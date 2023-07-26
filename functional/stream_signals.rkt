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

(define (stream-map proc . argstreams)
  (if (stream-null? (car argstreams))
      empty-stream
      (cons-stream
        (apply proc (map stream-car argstreams))
        (apply stream-map 
               (cons proc (map stream-cdr argstreams))))))

(define (scale-stream s fact)
  (stream-map (lambda (x) (* fact x)) s))

(define (add-stream s1 s2)
  (stream-map + s1 s2))

(define (take n stream)
  (if (or (stream-null? stream) (< n 1))
          '()
       (cons (stream-car stream)
       (take (- n 1) (stream-cdr stream)))))

(define (integral integrand int-value dt)
  (define int
    (cons-stream int-value
                 (add-stream (scale-stream integrand dt) int)))
  int)

(define l '(1 2 3))
(take 10 (integral l 0 0.001))

