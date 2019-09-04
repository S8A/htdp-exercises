;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex315) (read-case-sensitive #t) (teachpacks ((lib "abstraction.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "abstraction.rkt" "teachpack" "2htdp")) #f)))
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


; An FF (short for family forest) is a [List-of FT]
; interpretation a family forest represents several
; families (say, a town) and their ancestor trees

(define ff1 (list Carl Bettina))
(define ff2 (list Fred Eva))
(define ff3 (list Fred Eva Carl))



; [List-of FT] N -> Number
; Produces the "average" age of all people in the family forest
(define (average-age ff current-year)
  (local ((define sum-of-all-ages
            (foldr + 0
                   (map (lambda (ft) (sum-ages ft current-year)) ff)))
          (define number-of-people
            (foldr + 0 (map count-persons ff))))
    (if (zero? number-of-people)
        0
        (/ sum-of-all-ages number-of-people))))

(check-expect (average-age ff1 2019) 93)
(check-expect (average-age ff2 2019) 73.25)
(check-expect (average-age ff3 2019) 77.2) ; tree overlap



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


; FT N > Number
; Sums the ages of all people in the given family tree
(define (sum-ages ft current-year)
  (cond
    [(no-parent? ft) 0]
    [(child? ft)
     (+ (- current-year (child-date ft))
        (sum-ages (child-father ft) current-year)
        (sum-ages (child-mother ft) current-year))]))

(check-expect (sum-ages Carl 2019) 93)
(check-expect (sum-ages Gustav 2019) 324)
