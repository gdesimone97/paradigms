#lang scheme

(define fail 
  (lambda () 
    (error "Amb tree exhausted"))) 
  
(define-syntax amb
  (syntax-rules ()
    ((_) (fail))
    ((_ a) a)
    ((_ a b ...)
     (let ((fail0 fail))
       (call/cc
    (lambda (cc)
      (set! fail
        (lambda ()
          (set! fail fail0)
          (cc (amb b ...))))
      (cc a)))))))      

(define (require condition) 
  (if (not condition) 
      (fail)
      (display "")))

(let ((a (amb 1 2)) 
      (b (amb 2 3 4))) 
  (require (= a (+ a b)))
  (list a b))