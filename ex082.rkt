;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex082) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp")) #f)))
; A LLorF is one of:
; - 1String "a" through "z"
; - #false
; interpretation a lowercase letter or the boolean false value


(define-struct 3word [first second third])
; A 3Word is a structure:
;   (make-3word LLorF LLorF LLorF)
; interpretation (make-3word f s t) is a three-letter word
; "fst" where each character is a lowercase letter or the
; boolean false value
(define ex1 (make-3word "c" "a" "t"))
(define ex2 (make-3word "b" "a" "t"))
(define ex3 (make-3word #false "e" "t"))

; LLorF LLorF -> LLorF
; if the letters l1 and l2 are the same, returns the letter;
; otherwise, returns #false
(define (compare-llorf l1 l2)
  (if (equal? l1 l2) l1 #false))

(check-expect (compare-llorf "a" "a") "a")
(check-expect (compare-llorf #false #false) #false)
(check-expect (compare-llorf "x" "y") #false)


; 3Word 3Word -> 3Word
; produces a word that indicates where the given ones
; agree (keep the letter) or disagree (replaces it with #false)
(define (compare-word w1 w2)
  (make-3word (compare-llorf (3word-first w1) (3word-first w2))
              (compare-llorf (3word-second w1) (3word-second w2))
              (compare-llorf (3word-third w1) (3word-third w2))))

(check-expect (compare-word ex1 ex2) (make-3word #false "a" "t"))
(check-expect (compare-word ex3 ex3) ex3)
