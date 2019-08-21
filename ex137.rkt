;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex137) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp")) #f)))
; List-of-names -> Boolean
; determines whether "Flatt" is on a-list-of-names
(define (contains-flatt? alon)
  (cond
    [(empty? alon) ...]
    [(cons? alon)
     (... (first alon) ... (contains-flatt? (rest alon)) ...)]))

; List-of-strings -> Number
; determines how many strings are on alos
(define (how-many alos)
  (cond
    [(empty? alos) ...]
    [(cons? alos)
     (... (first alos) ... (how-many (rest alos)) ...)]))


; Compare the template for contains-flatt? with the one for how-many.
; Ignoring the function name, they are the same. Explain the similarity.

; The fourth step in the function design recipe consists of translating
; the data definition into a template. Since both functions deal with the
; essentially the same data definition, both templates have the same
; structure: one cond clause per data clause (the empty list and the cons),
; selectors in the second clause because it identifies a structure (cons),
; and one natural recursion per self-reference - the rest of the cons in
; both definitions refers to the data definition itself, so the cond clause
; applies the function itself (recursion) to that.


