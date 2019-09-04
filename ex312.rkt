;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex312) (read-case-sensitive #t) (teachpacks ((lib "abstraction.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "abstraction.rkt" "teachpack" "2htdp")) #f)))
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



; FT -> [List-of String]
; Produces a list of all eye colors in the given family tree
(define (eye-colors ft)
  (cond
    [(no-parent? ft) '()]
    [(child? ft)
     (cons (child-eyes ft)
           (append (eye-colors (child-father ft))
                   (eye-colors (child-mother ft))))]))

(check-expect (eye-colors Carl) (list (child-eyes Carl)))
(check-expect (eye-colors Gustav) (list (child-eyes Gustav)
                                        (child-eyes Fred)
                                        (child-eyes Eva)
                                        (child-eyes Carl)
                                        (child-eyes Bettina)))
