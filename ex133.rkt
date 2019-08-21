;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex133) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp")) #f)))
;(or (string=? (first alon) "Flatt")
;    (contains-flatt? (rest alon)))

; If the first expression is true (the first item is "Flatt"),
; the whole (or ...) is replaced with #true (short-circuited evaluation).
; Otherwise, the result of the (or ...) will be determined by the
; result of the second expression.

;(cond
;  [(string=? (first alon) "Flatt") #true]
;  [else (contains-flatt? (rest alon))])

; Likewise, if the first clause's condition is true, then the whole
; (cond ...) is replaced with #true and the rest is discarded.
; Otherwise (else), the result will be the result of the
; second expression.

; The first version is clearer because someone searching for "Flatt" in a list
; basically thinks that either it's the first element of the list, or
; they have to keep looking.
