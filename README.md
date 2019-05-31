A playground for testing consensus algorithms
===============================================

This repository aims to provide a simulation of a distributed network of nodes.

The network is simulated in a single process with multiple threads. Each thread simulates one node. Message sending and receiving is implemented using a shared queue, similar to a "mailbox". We simulate unreliable networks by introducing two things:

* A delivery delay: a message can be delivered with a certain delay, in order to simulate congestion in a network
* Packet drop: by default all packets are devivered to the nodes, a packet drop rate can be set which ensures that some packets will drop randomly

## Example

```
(define node1 
   (make-node (λ (self)
      ;; self is a reference to node we are defining
      ;; receive is a blocking call
      (let loop ()
         (displayln (receive self))
         (loop)))))

;;; intuitively this random-drop means that 90% of the message
;; are delivered successfully
(random-drop node1 0.90)

(let loop (i 1)
   (send-to node1 `(msg ,i))
   (sleep 0.1)
   (loop (+ i 1)))
```
