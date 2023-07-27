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

(define s1 (cons-stream 1 '(2 3 4)))

(define (even? x)
  (= (remainder x 2) 0))

(define(multiply-streams s1 s2)
  (stream-map * s1 s2))

(define (integers-from n)
  (cons-stream n
               (integers-from (+ n 1.0))))

(define ln2
  (stream-map (lambda (x)
                (if (even? x)
                    (* (/ 1 x) -1)
                    (/ 1 x)))
              (integers-from 1)))

(define s-ln2
  (cons-stream (stream-car ln2)
               (add-stream (stream-cdr ln2)
                           s-ln2)))


  