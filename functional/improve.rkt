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

(define (add-streams s1 s2)
  ; assume the streams are infinite
  (cons-stream (+ (stream-car s1) (stream-car s2))
               (add-streams (stream-cdr s1) (stream-cdr s2))))

(define (integral f a b)
  ; return a stream of increasingly better approximations
  (define midpoint (/ (+ a b) 2))
  (cons-stream (* (f midpoint) (- b a))
               (add-streams (integral f a midpoint)
                            (integral f midpoint b))))

(define (square x)
  (* x x))

(define (fixpoint f init)
  (cons-stream init (fixpoint f (f init))))

(define (within tolerance stream)
  (define first (stream-car stream))
  (define second (stream-cadr stream))
  (if (< (abs (- first second)) tolerance)
      second
      (within tolerance (stream-cdr stream))))

(define (improve stream)
  ; Aitken's acceleration technique
  (define xn (stream-car stream))
  (define xn+1 (stream-cadr stream))
  (define xn+2 (stream-car (stream-cddr stream)))
  (define delta-n (- xn+1 xn))
  (define delta-n+1 (- xn+2 xn+1))
  (define next (- xn+2 (/ (square delta-n+1)
                          (- delta-n+1 delta-n))))
  (cons-stream next (improve (stream-cdr stream))))

(define (f x) (/ 4 (+ 1 (* x x))))
;(within 1e-4 (integral f 0.0 1.0))
(within 1e-7 (improve (integral f 0.0 1.0))) 