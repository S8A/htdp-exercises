;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex326) (read-case-sensitive #t) (teachpacks ((lib "abstraction.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "abstraction.rkt" "teachpack" "2htdp")) #f)))
(define-struct no-info [])
(define NONE (make-no-info))
 
(define-struct node [ssn name left right])
; A BT (short for BinaryTree) is one of:
; – NONE
; – (make-node Number Symbol BT BT)

(define bt1 (make-node 15 'd NONE (make-node 24 'i NONE NONE)))
(define bt2 (make-node 15 'd (make-node 87 'h NONE NONE) NONE))
(define bta (make-node 63 'a
                       (make-node 29 'b
                                  (make-node 15 'd
                                             (make-node 10 'g NONE NONE)
                                             (make-node 24 'h NONE NONE))
                                  NONE)
                       (make-node 89 'c
                                  (make-node 77 'e NONE NONE)
                                  (make-node 95 'f
                                             NONE
                                             (make-node 99 'i NONE NONE)))))
(define btb (make-node 63 'a
                       (make-node 29 'b
                                  (make-node 15 'd
                                             (make-node 87 'g NONE NONE)
                                             (make-node 24 'h NONE NONE))
                                  NONE)
                       (make-node 89 'c
                                  (make-node 33 'e NONE NONE)
                                  (make-node 95 'f
                                             NONE
                                             (make-node 99 'i NONE NONE)))))


; A BST (short for binary search tree) is a BT according to
; the following conditions:
; - NONE is always a BST.
; - (make-node ssn0 name0 L R) is a BST if
;   - L is a BST,
;   - R is a BST,
;   - all ssn fields in L are smaller than ssn0,
;   - all ssn fields in R are larger than ssn0.


; BST Number Symbol -> BST
; produces a copy of the given BST that in place of one NONE subtree
; contains the node structure (make-node n s NONE NONE)
(define (create-bst bst n s)
  (cond
    [(no-info? bst) (make-node n s NONE NONE)]
    [(node? bst)
     (cond
       [(< n (node-ssn bst))
        (make-node (node-ssn bst) (node-name bst)
                   (create-bst (node-left bst) n s)
                   (node-right bst))]
       [(> n (node-ssn bst))
        (make-node (node-ssn bst) (node-name bst)
                   (node-left bst)
                   (create-bst (node-right bst) n s))]
       [else bst])]))

(check-expect (create-bst bt1 15 'a) bt1)
(check-expect (create-bst bt1 10 'a)
              (make-node 15 'd
                         (make-node 10 'a NONE NONE)
                         (make-node 24 'i NONE NONE)))
(check-expect (create-bst bt1 17 'a)
              (make-node 15 'd NONE
                         (make-node 24 'i
                                    (make-node 17 'a NONE NONE)
                                    NONE)))
