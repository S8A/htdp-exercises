;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex311) (read-case-sensitive #t) (teachpacks ((lib "abstraction.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "abstraction.rkt" "teachpack" "2htdp")) #f)))
(define-struct no-parent [])
(define NP (make-no-parent))
(define-struct child [father mother name date eyes])
; An FT (short for family tree) is one of: 
; – NP
; – (make-child FT FT String N String)

; Oldest Generation:
(define Carl (make-child NP NP "Carl" 1926 "green"))
(define Bettina (make-child NP NP "Bettina" 1926 "green"))
 
; Middle Generation:
(define Adam (make-child Carl Bettina "Adam" 1950 "hazel"))
(define Dave (make-child Carl Bettina "Dave" 1955 "black"))
(define Eva (make-child Carl Bettina "Eva" 1965 "blue"))
(define Fred (make-child NP NP "Fred" 1966 "pink"))
 
; Youngest Generation: 
(define Gustav (make-child Fred Eva "Gustav" 1988 "brown"))



; FT -> Number
; Produces the average age of all people in the given family tree
(define (average-age ft)
  (cond
    [(no-parent? ft) 0]
    [(child? ft) (/ (sum-ages ft) (count-persons ft))]))

(check-expect (average-age Carl) 93)
(check-expect (average-age Gustav) 64.8)



; FT -> N
; Counts the number of people in the given family tree
(define (count-persons ft)
  (cond
    [(no-parent? ft) 0]
    [(child? ft) (+ 1
                    (count-persons (child-father ft))
                    (count-persons (child-mother ft)))]))

(check-expect (count-persons Carl) 1)
(check-expect (count-persons Gustav) 5)


; FT -> Number
; Sums the ages of all people in the given family tree
(define (sum-ages ft)
  (cond
    [(no-parent? ft) 0]
    [(child? ft)
     (+ (current-age (child-date ft))
        (sum-ages (child-father ft))
        (sum-ages (child-mother ft)))]))

(check-expect (sum-ages Carl) (current-age 1926))
(check-expect (sum-ages Gustav) (+ (current-age 1988) (current-age 1966)
                                   (current-age 1965) (current-age 1926)
                                   (current-age 1926)))


; N -> Number
; Calculates the current age of someone born in the given year
(define (current-age year)
  (local ((define CURRENT-YEAR 2019))
    (- CURRENT-YEAR year)))

(check-expect (current-age 1926) 93)
(check-expect (current-age 1988) 31)
