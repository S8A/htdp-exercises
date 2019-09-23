;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex490) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; [List-of Number] -> [List-of Number]
; converts a list of relative to absolute distances
; the first number represents the distance to the origin
(define (relative->absolute l)
  (cond
    [(empty? l) '()]
    [else (local ((define rest-of-l
                    (relative->absolute (rest l)))
                  (define adjusted
                    (add-to-each (first l) rest-of-l)))
            (cons (first l) adjusted))]))

(check-expect (relative->absolute '(50 40 70 30 30))
              '(50 90 160 190 220))


; Number [List-of Number] -> [List-of Number]
; adds n to each number on l
(define (add-to-each n l)
  (map (lambda (i) (+ n i)) l))
 
(check-expect (cons 50 (add-to-each 50 '(40 110 140 170)))
              '(50 90 160 190 220))


; For a list of size n, relative->absolute needs n recursions of itself
; and n recursions of add-to-each, so its abstract running time is O(n²):
(relative->absolute (build-list 1 add1)) ; a2e: 1; r2a: 1
(relative->absolute '(1))
(cons 1 (add-to-each 1 (relative->absolute '())))
(cons 1 '())

(relative->absolute (build-list 2 add1)) ; a2e: 2; r2a: 2
(relative->absolute '(1 2))
(cons 1 (add-to-each 1 (relative->absolute '(2))))
(cons 1 (add-to-each 1 (cons 2 (add-to-each 2 (relative->absolute '())))))
(cons 1 (add-to-each 1 (cons 2 '())))
(cons 1 (cons 3 '()))

(relative->absolute (build-list 3 add1)) ; a2e: 3, r2a: 3
(relative->absolute '(1 2 3))
(cons 1 (add-to-each 1 (relative->absolute '(2 3))))
(cons 1 (add-to-each 1 (cons 2 (add-to-each 2 (relative->absolute '(3))))))
(cons 1 (add-to-each 1 (cons 2 (add-to-each 2 (cons 3 (add-to-each 3 (relative->absolute '())))))))
(cons 1 (add-to-each 1 (cons 2 (add-to-each 2 (cons 3 '())))))
(cons 1 (add-to-each 1 (cons 2 (cons 5 '()))))
(cons 1 (cons 3 (cons 6 '())))
