;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname ex187) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp")) #f)))
(define-struct gp [name score])
; A GamePlayer is a structure: 
;    (make-gp String Number)
; interpretation (make-gp p s) represents player p who 
; scored a maximum of s points
(define pa3 (make-gp "a" 3))
(define pb2 (make-gp "b" 2))
(define pc1 (make-gp "c" 1))
(define pd12 (make-gp "d" 12))
(define pe20 (make-gp "e" 20))
(define pf5 (make-gp "f" 5))
(define pg6 (make-gp "g" 6))
(define ph4 (make-gp "h" 4))

; A ListOfGamePlayers (LGP) is one of:
; - '()
; - (cons GamePlayer LGP)


; LGP -> LGP
; sorts a list of game players by their score in descending order
(define (sort-players> lgp)
  (cond
    [(empty? lgp) '()]
    [else
     (insert (first lgp) (sort-players> (rest lgp)))]))

(check-expect (sort-players> (list pa3 pb2 pc1))
              (list pa3 pb2 pc1))
(check-expect (sort-players> (list pc1 pb2 pa3))
              (list pa3 pb2 pc1))
(check-expect (sort-players> (list pd12 pe20 pf5))
              (list pe20 pd12 pf5))


; GamePlayer LGP -> LGP
; inserts player p into the sorted list of players
(define (insert p lgp)
  (cond
    [(empty? lgp) (list p)]
    [else
     (if (gp-score>= p (first lgp))
         (cons p lgp)
         (cons (first lgp) (insert p (rest lgp))))]))

(check-expect (insert pf5 '()) (list pf5))
(check-expect (insert pf5 (list pg6)) (list pg6 pf5))
(check-expect (insert pf5 (list ph4)) (list pf5 ph4))
(check-expect (insert pd12 (list pe20 pf5))
              (list pe20 pd12 pf5))


; GamePlayer GamePlayer -> Boolean
; is player A's score greater than or equal to player B's
(define (gp-score>= a b)
  (>= (gp-score a) (gp-score b)))

(check-expect (gp-score>= pf5 pg6) #false)
(check-expect (gp-score>= pe20 pd12) #true)
