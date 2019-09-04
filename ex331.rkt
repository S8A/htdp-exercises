;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex331) (read-case-sensitive #t) (teachpacks ((lib "abstraction.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "abstraction.rkt" "teachpack" "2htdp")) #f)))
; .: Data definitions :.
; A Dir.v1 (short for directory) is one of: 
; – '()
; – (cons File.v1 Dir.v1)
; – (cons Dir.v1 Dir.v1)
 
; A File.v1 is a String.

(define dir-empty '())
(define dir-text (list "part1" "part2" "part3"))
(define dir-code (list "hang" "draw"))
(define dir-docs (list "read!"))
(define dir-libs (list dir-code dir-docs))
(define dir-ts (list dir-text "read!" dir-libs))


; Dir.v1 -> N
; how many files are in the given directory
(define (how-many dir)
  (foldr + 0 (map (lambda (item) (if (string? item) 1 (how-many item)))
                  dir)))

(check-expect (how-many dir-empty) 0)
(check-expect (how-many dir-text) 3)
(check-expect (how-many dir-code) 2)
(check-expect (how-many dir-docs) 1)
(check-expect (how-many dir-libs) 3)
(check-expect (how-many dir-ts) 7)
