;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex325) (read-case-sensitive #t) (teachpacks ((lib "abstraction.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "abstraction.rkt" "teachpack" "2htdp")) #f)))
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


; BT -> [List-of Number]
; Produces the sequence of all the ssn numbers in the tree as they
; show up from left to right
(define (inorder bt)
  (cond
    [(no-info? bt) '()]
    [(node? bt)
     (append (inorder (node-left bt))
             (list (node-ssn bt))
             (inorder (node-right bt)))]))

(check-expect (inorder bt1) '(15 24))
(check-expect (inorder bt2) '(87 15))
(check-expect (inorder bta) '(10 15 24 29 63 77 89 95 99))
(check-expect (inorder btb) '(87 15 24 29 63 33 89 95 99))


; Number BST -> [Maybe Symbol]
; if the tree contains a node whose ssn field is n, produce its name;
; otherwise produces #false
(define (search-bst n bst)
  (cond
    [(no-info? bst) #false]
    [(node? bst)
     (cond
       [(= n (node-ssn bst)) (node-name bst)]
       [(< n (node-ssn bst)) (search-bst n (node-left bst))]
       [(> n (node-ssn bst)) (search-bst n (node-right bst))])]))

(check-expect (search-bst 15 bt1) 'd)
(check-expect (search-bst 15 bta) 'd)
(check-expect (search-bst 95 bt1) #false)
(check-expect (search-bst 95 bta) 'f)
