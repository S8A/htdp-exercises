;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex149) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp")) #f)))
; N String -> List-of-strings 
; creates a list of n copies of s
(define (copier n s)
  (cond
    [(zero? n) '()]
    [(positive? n) (cons s (copier (sub1 n) s))]))

(check-expect (copier 0 "hello") '())
(check-expect (copier 2 "hello")
              (cons "hello" (cons "hello" '())))


; N String -> List-of-strings 
; creates a list of n copies of s
(define (copier.v2 n s)
  (cond
    [(zero? n) '()]
    [else (cons s (copier.v2 (sub1 n) s))]))

(check-expect (copier.v2 0 "hello") '())
(check-expect (copier.v2 2 "hello")
              (cons "hello" (cons "hello" '())))


; Q: Does copier function properly when you apply it to a natural
; number and a Boolean or an image? Or do you have to design another function?
; A: Yes, it does, because all it does with the s argument is cons it and
; pass it again to the same function but with (sub1 n). There is no type
; check for s.


; Q: How do copier and copier.v2 behave when you apply them to 0.1 and "x"?
; Explain. Use DrRacket’s stepper to confirm your explanation.
; A: With copier, the first cond clause is false and the second is true,
; so the function produces (cons "x" (cons (sub1 0.1) "x")). But (sub1 0.1)
; produces a negative number, so the function will run out of cond clauses
; and signal an error.
; On the other hand, copier.v2 uses a cond clause for (zero? n) and an else
; clause instead of another cond clause. Therefore, after checking that 0.1
; is not zero, it will produce (cons "x" (cons (sub1 0.1) "x")). Again,
; (sub1 0.1) produces a negative number, but this time the function will not
; run out of cond clauses and will keep reducing n by 1 and applying itself
; over and over again indefinitely.
(copier 0.1 "x")
(copier.v2 0.1 "x")
