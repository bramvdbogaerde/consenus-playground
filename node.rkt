#lang racket

(require data/queue)

(provide (all-defined-out))


;;; A link layer packet, it has a source, which is a node
;;; and it has a destination which is a node.
(struct packet
        (src dst payload))

;; a node is a thread that executes one function `fn`
;; it is able to send and receive message
(define (make-node fn)
  (define current-thread '())
  (define lock (make-semaphore 1))
  (define queue (make-queue))
  (define lag 0)
  (define random-drop 1)

  (define (send-msg msg)
    (thread (λ ()
      (sleep lag)
      (semaphore-wait lock)
      (enqueue! queue msg)
      (semaphore-post lock)
      (thread-resume current-thread))))

  (define (receive-msg)
    (let loop ()
      (semaphore-wait lock)
      (if (queue-empty? queue)
          (begin 
            (semaphore-post lock)
            ;; as another thread could enqueue! at this time
            ;; it is possible the thread goes to sleep without ever being able to wake up
            ;; which leads to a lack of progress
            (thread-suspend current-thread)
            (loop))
          (let ((el (dequeue! queue)))
            (semaphore-post lock)
            (if (> (random) random-drop)
                (loop)
               el)))))
          
  (define (node-dispatch msg . args)
    (case msg
      [(shutdown) (kill-thread current-thread)]
      [(restart) (start-thread)]
      [(lag) (set! lag (car args))]
      [(random-drop) (set! random-drop (car args))]
      [(send) (send-msg (car args))]
      [(receive) (receive-msg)]))

  (define (start-thread)
    (unless (null? current-thread)
      (kill-thread current-thread))
    (semaphore-wait lock)
    (set! current-thread (thread (λ () (fn node-dispatch))))
    (set! queue (make-queue))
    (semaphore-post lock))

  (start-thread)

  node-dispatch)

;;; Send a message to a node
;;; @param node the node to send the message to
;;; @param msg the message to send
(define (send-to node msg)
  (node 'send msg))

;;; Receive a message for a given node
;;; this call is blocking until we get a message
(define (receive node)
  (node 'receive))

;;; Shut a node down
;;; @param node the node to shut down
(define (shutdown node)
  (node 'shutdown))

;;; Restart a node
;;; @param node the node to restart
(define (restart node)
  (node 'restart))

;;; Introduce a delay in the message sending <-> receiving
;;; This can be used to simulate network latency
;;; @param node the node to lag
;;; @param seconds the number of seconds to lag the node with
(define (lag node seconds)
  (node 'lag seconds))

;;; Set or unset the random drop flag of the node
;;; When set the node will drop messages randomly
;;; simulating an unreliable network
(define (random-drop node enabled)
  (node 'random-drop enabled))

;;; A simple implementation of a link layer packet 
;;; receiving node, which forwards the packets to the given
;;; function.
(define (message-loop fn)
  (λ (self)
     (let loop
       ((msg (receive self)))

       (fn (packet-src msg)
           (packet-payload msg))
       (loop (receive self)))))
   
