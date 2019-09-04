;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex322) (read-case-sensitive #t) (teachpacks ((lib "abstraction.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "abstraction.rkt" "teachpack" "2htdp")) #f)))
(define-struct no-info [])
(define NONE (make-no-info))
 
(define-struct node [ssn name left right])
; A BT (short for BinaryTree) is one of:
; – NONE
; – (make-node Number Symbol BT BT)

(define bt1 (make-node 15 'd NONE (make-node 24 'i NONE NONE)))
(define bt2 (make-node 15 'd (make-node 87 'h NONE NONE) NONE))


; Number BT -> Boolean
; is n an ssn in the given binary tree
(define (contains-bt? n bt)
  (cond
    [(no-info? bt) #false]
    [(node? bt)
     (or (= n (node-ssn bt))
         (contains-bt? n (node-left bt))
         (contains-bt? n (node-right bt)))]))

(check-expect (contains-bt? 15 NONE) #false)
(check-expect (contains-bt? 15 bt1) #true)
(check-expect (contains-bt? 15 bt2) #true)
(check-expect (contains-bt? 24 bt1) #true)
(check-expect (contains-bt? 24 bt2) #false)
