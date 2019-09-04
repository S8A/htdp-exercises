;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex332) (read-case-sensitive #t) (teachpacks ((lib "abstraction.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "abstraction.rkt" "teachpack" "2htdp")) #f)))
; .: Data definitions :.
(define-struct dir [name content])
; A Dir.v2 is a structure: 
;   (make-dir String LOFD)
 
; An LOFD (short for list of files and directories) is one of:
; – '()
; – (cons File.v2 LOFD)
; – (cons Dir.v2 LOFD)
 
; A File.v2 is a String.

(define dir-text (make-dir "Text" (list "part1" "part2" "part3")))
(define dir-code (make-dir "Code" (list "hang" "draw")))
(define dir-docs (make-dir "Docs" (list "read!")))
(define dir-libs (make-dir "Libs" (list dir-code dir-docs)))
(define dir-ts (make-dir "TS" (list dir-text "read!" dir-libs)))
