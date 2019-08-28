;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname ex242) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp") (lib "web-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp") (lib "web-io.rkt" "teachpack" "2htdp")) #f)))
; A [Maybe X] is one of: 
; – #false 
; – X


; [Maybe String]
; A Maybe-String is one of:
; - #false
; - String
; interpretation a string of characters or #false


; [Maybe [List-of String]]
; A Maybe-List-of-Strings is one of:
; - #false
; - List-of-Strings
; interpretation a list of strings, or #false


; [List-of [Maybe String]]
; A List-of-Maybe-String is one of:
; - '()
; - (cons Maybe-String List-of-Maybe-String)
; interpretation a list of strings or #false values


; Q: What does the following function signature mean (see occurs, below)
; A: It's a function that takes a string and a list of strings
; and returns a list of strings or a #false value.

; String [List-of String] -> [Maybe [List-of String]]
; returns the remainder of los starting with s 
; #false otherwise 
(define (occurs s los)
  (cond
    [(empty? los) #false]
    [(cons? los)
     (if (string=? s (first los))
         (rest los)
         (occurs s (rest los)))]))

(check-expect (occurs "a" (list "b" "a" "d" "e"))
              (list "d" "e"))
(check-expect (occurs "a" (list "b" "c" "d")) #f)
