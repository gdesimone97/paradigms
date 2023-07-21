#lang scheme

(define (variable? x) (symbol? x)) ;x è un simbolo?
(define (variable x) (quote x))