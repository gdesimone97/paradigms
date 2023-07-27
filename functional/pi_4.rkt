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

(define (integers-from n)
  (cons-stream n (integers-from (+ n 1))))

(define (even? n)
  (= (remainder n 2) 0))

(define (alt-inner n)
  (cons-stream (expt -1 n) (alt-inner (+ n 1))))

(define alt
  (alt-inner 0))

(define (integers-even-from n)
  (if (even? n)
      (integers-even-from (+ n 1))
      (cons-stream n (integers-even-from (+ n 1)))))
      

(define (fraction-from n)
  (stream-map (lambda (x)
                (/ 1 x))
              (integers-from n)))

(define pi-4
  (stream-map (lambda (x)
                (/ 1 x))
              (multiply-streams alt (integers-even-from 1.0))))
  
(take 4 (fraction-from 1))
(take 8 pi-4)

(define pi-sum
  (cons-stream (stream-car pi-4) (add-stream (stream-cdr pi-4) pi-sum)))

(take 1000 pi-sum)


     