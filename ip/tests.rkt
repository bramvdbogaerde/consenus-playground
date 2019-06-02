#lang racket

(require "./router.rkt")
(require "./protocol.rkt")

(define r1 (make-router 
             (ip 192 0 0 1)))

(define r2 (make-router
             (ip 192 0 1 1)))

(define r3 (make-router
             (ip 192 0 2 1)))

(add-neighbour r1 r2)
(add-neighbour r2 r3)
