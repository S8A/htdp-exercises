;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex475) (read-case-sensitive #t) (teachpacks ((lib "abstraction.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "abstraction.rkt" "teachpack" "2htdp")) #f)))
; A Node is a Symbol.

; A Graph is a [List-of [List Node [List-of Node]]]
(define sample-graph1 '((A (B E))
                        (B (E F))
                        (C (D))
                        (D ())
                        (E (C F))
                        (F (D G))
                        (G ())))
(define sample-graph2 '((A (B C))
                        (B (D))
                        (C (D))
                        (D ())))
(define sample-graph3 '((A (B)) (B (A))))

(define cyclic-graph '((A (B E))
                       (B (E F))
                       (C (B D))
                       (D ())
                       (E (C F))
                       (F (D G))
                       (G ())))

; A Path is a [List-of Node].
; interpretation The list of nodes specifies a sequence
; of immediate neighbors that leads from the first 
; Node on the list to the last one.


; Graph -> Boolean
; determines whether there is a path between any pair of nodes
(define (test-on-all-nodes g)
  (andmap (lambda (pair) (cons? (find-path (first pair) (second pair) g)))
          (all-pairs g)))

(check-expect (test-on-all-nodes sample-graph1) #false)
(check-expect (test-on-all-nodes sample-graph2) #false)
(check-expect (test-on-all-nodes sample-graph3) #true)
;(check-expect (test-on-all-nodes cyclic-graph) #false) ; never ends


; Graph -> [List-of [List Node Node]]
; produces all possible pairs of nodes from a given graph
(define (all-pairs g)
  (local ((define all-nodes (map first g)))
    (for*/list ([n1 all-nodes] [n2 all-nodes]) (list n1 n2))))

(check-expect (all-pairs sample-graph3) '((A A) (A B) (B A) (B B)))


; Node Node Graph -> [Maybe Path]
; finds a path from origination to destination in G
; if there is no path, the function produces #false
(define (find-path origination destination G)
  (cond
    [(symbol=? origination destination)
     (list destination)]
    [else
     (local (; [List-of Node] Node Graph -> [Maybe Path]
             ; finds a path from some node on lo-Os to destination
             ; if there is no path, the function produces #false
             (define (find-path/list lo-Os)
               (foldr (lambda (candidate others)
                        (if (boolean? candidate) others candidate))
                      #false
                      (map (lambda (origin) (find-path origin destination G))
                           lo-Os)))
             (define next (neighbors origination G))
             (define candidate (find-path/list next)))
       (cond
         [(boolean? candidate) #false]
         [(cons? candidate) (cons origination candidate)]))]))

(check-expect (find-path 'C 'D sample-graph1)
              '(C D))
(check-member-of (find-path 'E 'D sample-graph1)
                 '(E F D) '(E C D))
(check-expect (find-path 'C 'G sample-graph1)
              #false)
(check-expect (find-path 'A 'G sample-graph1) '(A B E F G))
(check-expect (find-path 'B 'C cyclic-graph) '(B E C))


; Node Graph -> [List-of Node]
; produces the list of immediate neighbors of n in g
(define (neighbors n g)
  (cond
    [(empty? g) (error 'neighbors n " not found")]
    [(cons? g)
     (local ((define fst (first g)))
       (if (symbol=? (first fst) n)
           (first (rest fst))
           (neighbors n (rest g))))]))

(check-expect (neighbors 'A sample-graph1) '(B E))
(check-expect (neighbors 'D sample-graph1) '())
(check-expect (neighbors 'F sample-graph1) '(D G))
(check-error (neighbors 'Z sample-graph1))
