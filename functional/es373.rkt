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

(define (take n stream)
  (if (or (stream-null? stream) (< n 1))
          '()
       (cons (stream-car stream)
       (take (- n 1) (stream-cdr stream)))))

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

(define (integral integrand init-value dx)
  (define int
    (cons-stream init-value (add-stream (scale-stream integrand dx) int)))
  int)

(define (RC R C dt)
  (lambda (i v0)
    (add-stream (scale-stream (current-stream i) R) (integral (scale-stream (current-stream i) (/ 1 C)) v0 dt))))

(define (current-stream i)
  (cons-stream i (current-stream i)))

(define RC1 (RC 5 1 0.5))
(define i0 1)
(define v0 10)
(define v (RC1 i0 v0))
(take 10 v)


