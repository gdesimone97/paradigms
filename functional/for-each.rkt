#lang scheme

(define stream-null? null?)
(define (stream-cdr stream) (force (cdr stream)))
(define (stream-car stream) (car stream))
(define (display-line x) (newline) (display x))
(define-syntax cons-stream
  (syntax-rules ()
   ( (cons-stream expr1 expr2)
   (cons expr1 (delay expr2)))))

(define (stream-for-each proc s)
  (if (stream-null? s)
    'done
    (begin (proc (stream-car s))
           (stream-for-each proc (stream-cdr s)))))

(define (display-stream s)
  (stream-for-each display-line s))

(define s (cons-stream 0 '(1 2 3)))
(display-stream s)