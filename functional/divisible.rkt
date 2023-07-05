#lang scheme

(define (filter-stream func n lst)
  (define current (car lst))
  (if (func current)
      (cons current (filter-stream-inf func (- n 1) (stream-cdr lst)))
      (filter-stream-inf func (- n 1) (stream-cdr lst))))


(define (divisible? a b)
  ( = (remainder a b) 0 ))

(define (not-divisible? a b)
  (not (divisible? a b)))

(define (sieve stream)
  (define first (stream-car stream))
  (cons-stream first
               (sieve
               (filter-stream (lambda (n) (not-divisible? n first)
                                (stream-cdr stream))))))

(define primes (sieve (integers-from 2)))

(define (add-streams a b)
  (cons-stream (+ (stream-car a) (stream-car b))
               (add-streams (stream-cdr a) (stream-cdr b))))

(define (integral f a b)
  (define m (/ (+ a b) 2))
  (cons-stream (* (f m) (- a b))
               (add-streams (integral f a m)
                            (integral f m b))))

; (time (within 1e-6 (integral (f 0.0 1.0)))) ; Valuta la complessità computazionale