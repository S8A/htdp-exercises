;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex313) (read-case-sensitive #t) (teachpacks ((lib "abstraction.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "abstraction.rkt" "teachpack" "2htdp")) #f)))
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


; Q: Explain why this function fails one of its tests.
; A: Because at no point does the function actually check if
; an ancestor's eyes are blue, it just recursively calls itself
; until inevitably reaching the base case of NP and producing #false.

; Q: What is the result of (blue-eyed-ancestor? A) no matter which A you choose?
; A: #false, as explained above.

; FT -> Boolean
; Does the given child have an ancestor with blue eyes
(define (blue-eyed-ancestor.f? ft)
  (cond
    [(no-parent? ft) #false]
    [(child? ft)
     (or (blue-eyed-ancestor.f? (child-father ft))
         (blue-eyed-ancestor.f? (child-mother ft)))]))

(check-expect (blue-eyed-ancestor.f? Eva) #false)
;(check-expect (blue-eyed-ancestor.f? Gustav) #true) ; failed


; Q: Can you fix your friend’s solution?
; A: Yes.

; FT -> Boolean
; Does the given child have an ancestor with blue eyes
(define (blue-eyed-ancestor? c)
  (cond
    [(and (no-parent? (child-father c)) (no-parent? (child-mother c))) #false]
    [(no-parent? (child-father c))
     (or (string=? (child-eyes (child-mother c)) "blue")
         (blue-eyed-ancestor? (child-mother c)))]
    [(no-parent? (child-mother c))
     (or (string=? (child-eyes (child-father c)) "blue")
         (blue-eyed-ancestor? (child-father c)))]
    [else
     (or (string=? (child-eyes (child-mother c)) "blue")
         (string=? (child-eyes (child-father c)) "blue")
         (blue-eyed-ancestor? (child-father c))
         (blue-eyed-ancestor? (child-father c)))]))

(check-expect (blue-eyed-ancestor? Eva) #false)
(check-expect (blue-eyed-ancestor? Gustav) #true)
