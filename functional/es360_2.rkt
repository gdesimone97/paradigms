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

(define (scale-stream s v)
  (stream-map (lambda (x) (* x v)) s))

(define (add-streams s1 s2)
  (stream-map + s1 s2))

(define (mul-series s1 s2)
  (cons-stream (* (stream-car s1) (stream-car s2)) (add-stream
                                                    (scale-stream s1 (stream-cdr s2))
                                                    (scale-stream s2 (stream-cdr s1)))))