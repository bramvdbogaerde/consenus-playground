#lang racket

(require "./protocol.rkt")
(require "../node.rkt")

(provide (all-defined-out))

#| 
   This module provides a router.
   A router is a special kind of 
   node that accepts pure IP packets.

   It has connections through ports
   with other nodes. And will forward
   packets to their correct destination.

   In this implementation we implement the link state routing protocol.
   In the link state protocol, each router periodically broadcasts its neighbouring routers (each router has its own ip address). These packets contribute to the construction of a graph. Then each router indepentely calculates a path to all the other nodes. (ie. with the Dijkstra shortest path algorithm)

   Currently, the neighbours of a router are determined statically, however we plan to make it dynamic.
|#
 
(struct link-state-message
        (origin neighbours))


;;; Create a new router
;;; @param Ip ip the ip of the router
(define (make-router ip)
  (define neighbours '())

  (define (process-neighbours origin neighbours)
    'todo)

  (define (process-ip-packet src dst payload)
    'todo)

  (define (receive sender msg)
    (match msg
      [(link-state-message origin neighbours)
       (for-each (λ (node) (send-to node msg))
                 (remove sender neighbours))
       (process-neighbours origin neighbours)]
      [(ip-packet src dst payload)
       (process-ip-packet src dst payload)]))

  (define (start-broadcast)
    'todo)
               
  (define (start-node)
   (make-node (message-loop receive)))

  (define (add-neighbour neighbour)
    (set! neighbours (cons neighbour neighbours)))

  (define (router-dispatch msg . vars)
    (apply 
      (case msg
            [(add-neighbour) add-neighbour]
            [(start-node) start-node]
            [else (error "Message not understood (Router)")])
      vars))

   router-dispatch)


(define (add-neighbour router other)
  (router 'add-neighbour other))

(define (start-router router)
  (router 'start-node))
