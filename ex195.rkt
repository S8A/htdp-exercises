;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname ex195) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp")) #f)))
; A Letter is one of the following 1Strings: 
; – "a"
; – ... 
; – "z"
; or, equivalently, a member? of this list: 
(define LETTERS
  (explode "abcdefghijklmnopqrstuvwxyz"))


(define LOCATION "/usr/share/dict/words")
; A Dictionary is a List-of-strings.
(define AS-LIST (read-lines LOCATION))


; Letter Dictionary -> Number
; counts how many words in the given Dictionary start with the given Letter
(define (starts-with# letter dict)
  (cond
    [(empty? dict) 0]
    [(cons? dict)
     (+ (if (string=? letter (string-ith (first dict) 0)) 1 0)
        (starts-with# letter (rest dict)))]))

(check-expect (starts-with# "x" AS-LIST) 17)

(starts-with# "e" AS-LIST)
(starts-with# "z" AS-LIST)
