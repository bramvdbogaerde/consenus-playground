#lang racket

(provide (all-defined-out))

#|
   A simulation of the IP protocol.
|#

;;; An IPv4 packet
(struct ip-packet 
        (src dst payload))

;;; An IPv4 (4 bytes) address
(struct ip
        (b1 b2 b3 b4))

;;; Send an ip packet
;;; @param Node a node to send the packet to
;;; @param Ip src the source ip
;;; @param Ip dst the destination ip
;;; @param any payload the contents of the ip packet
(define (send-to-ip node src dst payload)
  (ip-packet src dst payload))

