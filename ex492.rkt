;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex492) (read-case-sensitive #t) (teachpacks ((lib "abstraction.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "abstraction.rkt" "teachpack" "2htdp")) #f)))
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
(define a-sg '((A (B))
               (B (C))
               (C (E))
               (D (E))
               (E (B))
               (F (F))))

; A Path is a [List-of Node].
; interpretation The list of nodes specifies a sequence
; of immediate neighbors that leads from the first 
; Node on the list to the last one.


; Node Node Graph -> [Maybe Path]
; finds a path from origin to dest in G
; if there is no path, the function produces #false
(define (find-path origin dest G)
  (local (; Node [List-of Node] -> [Maybe Path]
          ; finds a path from o to dest given a list of seen nodes
          (define (find-path/a o seen)
            (cond
              [(symbol=? o dest) (list dest)]
              [(member? o seen) #false]
              [else
               (local ((define next (neighbors o G))
                       (define candidate
                         (find-path/list next (cons o seen))))
                 (cond
                   [(boolean? candidate) #false]
                   [(cons? candidate) (cons o candidate)]))]))
          ; [List-of Node] [List-of Node] -> [Maybe Path]
          ; finds a path from some nodein lo-Os given a lsit of seen nodes
          (define (find-path/list lo-Os seen)
            (cond
              [(empty? lo-Os) #false]
              [else (local ((define candidate (find-path/a (first lo-Os) seen)))
                      (cond
                        [(boolean? candidate)
                         (find-path/list (rest lo-Os) seen)]
                        [else candidate]))])))
    (find-path/a origin '())))

(check-expect (find-path 'C 'D sample-graph1)
              '(C D))
(check-member-of (find-path 'E 'D sample-graph1)
                 '(E F D) '(E C D))
(check-expect (find-path 'C 'G sample-graph1)
              #false)
(check-expect (find-path 'A 'G sample-graph1) '(A B E F G))
(check-expect (find-path 'C 'D a-sg) #false)


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
