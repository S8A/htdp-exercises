;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname ex239) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp") (lib "web-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp") (lib "web-io.rkt" "teachpack" "2htdp")) #f)))
; A [List X Y] is a structure: 
;   (cons X (cons Y '()))


; [List Number Number]
; A List-Number-Number is a structure:
;   (cons Number (cons Number '())
(define lnn (list 3 4))

; [List Number 1String]
; A List-Number-1String is a structure:
;   (cons Number (cons 1String '())
(define lnc (list 1 "a"))

; [List String Boolean]
; A List-String-Boolean is a structure:
;   (cons String (cons Boolean '())
(define lsb (list "registered" #true))
