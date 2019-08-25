;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname ex209) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp") (lib "itunes.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp") (lib "itunes.rkt" "teachpack" "2htdp")) #f)))
; A Word is ...
 
; A List-of-words is ...
 
; Word -> List-of-words
; finds all rearrangements of word
(define (arrangements word)
  (list word))


; List-of-strings -> Boolean
(define (all-words-from-rat? w)
  (and (member? "rat" w) (member? "art" w) (member? "tar" w)))


; String -> List-of-strings
; finds all words that the letters of some given word spell
(define (alternative-words s)
  (in-dictionary
    (words->strings (arrangements (string->word s)))))

;(check-member-of (alternative-words "cat")
;                 (list "act" "cat") (list "cat" "act"))
 
;(check-satisfied (alternative-words "rat") all-words-from-rat?)

 
; List-of-words -> List-of-strings
; turns all Words in low into Strings 
(define (words->strings low) '())


; List-of-strings -> List-of-strings
; picks out all those Strings that occur in the dictionary 
(define (in-dictionary los) '())



; String -> Word
; converts s to the chosen word representation 
(define (string->word s) (explode s))

(check-expect (string->word "") '())
(check-expect (string->word "cat") (list "c" "a" "t"))

 
; Word -> String
; converts w to a string
(define (word->string w) (implode w))

(check-expect (word->string '()) "")
(check-expect (word->string (list "c" "a" "t")) "cat")
