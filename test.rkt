#lang racket

(require "./node.rkt")

(define n1 
  (make-node
    (λ (self)
       (let loop  ()
         (displayln (receive self))
         (loop)))))

(random-drop n1 0.8)

(let loop ((i 0))
   (send-to n1 `(msg ,i))
   (sleep 0.1)
   (loop (+ i 1)))


