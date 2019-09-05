;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex338) (read-case-sensitive #t) (teachpacks ((lib "abstraction.rkt" "teachpack" "2htdp") (lib "dir.rkt" "teachpack" "htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "abstraction.rkt" "teachpack" "2htdp") (lib "dir.rkt" "teachpack" "htdp")) #f)))
; Dir -> N
; how many files are in the given directory
(define (how-many dir)
  (foldr + (length (dir-files dir)) (map how-many (dir-dirs dir))))

; As of September 4th, 2019
(define documents (create-dir "/home/s8a/Documents/"))
(define umc (create-dir "/home/s8a/Documents/Umc/"))
(check-expect (how-many documents) 240)
(check-expect (how-many umc) 197)
