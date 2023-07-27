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

(define (integers-from n)
  (cons-stream n (integers-from (+ n 1))))

(define (inv-intergers-from n)
  (stream-map (lambda (x)
                (/ 1 x))
              (integers-from n)))

(define (cauchy  s1 s2)
  (cons-stream (* (stream-car s1) (stream-car s2))
               (add-stream (add-stream
                            (scale-stream (stream-cdr s1)
                                          (stream-car s2))
                            (scale-stream (stream-cdr s2)
                                          (stream-car s1)))
                           (cons-stream 0 (cauchy (stream-cdr s1) (stream-cdr s2))))))

(define (factorial n)
  (define (factorial-inner n res)
  (if (or (= n 1) (= n 0))
      res
      (factorial-inner (- n 1) (* n res))))
  (factorial-inner n 1))

(define exp 
  (cons-stream 1 (stream-map (lambda (x)
                               (/ 1 (factorial x)))
                             (integers-from 1))))

(define (mult-stream s1 s2)
  (stream-map * s1 s2))

(define (integrate-series s)
  (mult-stream s (inv-intergers-from 1)))

(take 6 exp)
(take 6 (integrate-series exp))

(define exp-series
  (cons-stream 1 (integrate-series exp-series)))

(take 6 exp-series)

(define cosine-series
  (cons-stream 1 (stream-map (lambda (x)
                               (* -1 x))
                             (integrate-series sine-series))))

(define sine-series
  (cons-stream 0 (integrate-series cosine-series)))

(display "cosine: ")
(take 6 cosine-series)
(display "sine: ")
(take 6 sine-series)

(define ones
  (cons-stream 1 ones))

; ex 3.61

(define (inv-series s)
  (cons-stream 1
               (scale-stream (cauchy (stream-cdr s) (inv-series s)) -1 )))

(take 6 (inv-series exp))

(define (div-series n d)
  (cauchy n (inv-series d)))

(display "tan: ")
(take 8 (div-series sine-series cosine-series))

(define (within tollerance s)
  (define curr (stream-car s))
  (define next (stream-cadr s))
  (if (< (abs (- curr next)) tollerance)
      next
      (within tollerance (stream-cdr s))))

(define (sum-series s)
  (cons-stream (stream-car s) (add-stream (stream-cdr s) (sum-series s))))

(take 10 (sum-series exp))
(exact->inexact (within 1e-3 (sum-series exp)))