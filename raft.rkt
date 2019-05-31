#lang racket

#|
Please note that this module is a work in progress.

This file implements the Raft protocol.

It creates nodes that have all roles, and are able to come to an agreement
about a single value.

The protocol defines the following messages:
- heartbeat
- proposeleader
- proposevalue
- acceptvalue
|#

;;;;;;;;;;;;;;;;;
;;; Protocol ;;;;
;;;;;;;;;;;;;;;;;

(define (send-heartbeat node)
  (send-to node '(heartbeat)))

(define (send-ack node)
  (send-to node '(ack)))

(define (send-proposeleader node leader-id)
  (send-to node `(proposeleader ,leader-id)))

(define (send-proposevalue node value)
  (send-to node `(proposevalue ,value)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Cluster management ;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;
