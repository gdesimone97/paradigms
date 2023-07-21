#lang scheme

(define current-continuation
  (lambda ()
    (call/cc (lambda (cc)
               ;; `cc` will be the value of `k` in `amb`.
               (cc cc)))))

(define fail-stack '())                 ; list of continuations

(define (fail)
  (define test fail-stack)
  (define test2 (car fail-stack))
  (if (not (pair? fail-stack))
      (error "back-tracking stack exhausted!")
      (begin
        (let ((back-track-point (car fail-stack)))
          (set! fail-stack (cdr fail-stack))
          (back-track-point back-track-point)))))

(define amb
  (lambda (choices)
    ((lambda (k)
       (if (null? choices)
           (fail)
           ((lambda (choice remaining-choices)
              (set! choices remaining-choices)
              (set! fail-stack (cons k fail-stack))
              choice)
            (car choices)
            (cdr choices))))
     (current-continuation))))

(define (assert condition)
  (if (not condition)
      (fail)
      #t))  

; The following prints (4 3 5)
(let ((a (amb (list 1 2 3 4 5 6 7)))
      (b (amb (list 1 2 3 4 5 6 7)))
      (c (amb (list 1 2 3 4 5 6 7))))

  ; We're looking for dimensions of a legal right
  ; triangle using the Pythagorean theorem:
  (assert (= (* c c) (+ (* a a) (* b b))))

  (display (list a b c))
  (newline)

  ; And, we want the second side to be the shorter one:
  (assert (< b a))

  ; Print out the answer:
  (display (list a b c))
  (newline))