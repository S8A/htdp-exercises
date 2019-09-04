;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex335) (read-case-sensitive #t) (teachpacks ((lib "abstraction.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "abstraction.rkt" "teachpack" "2htdp")) #f)))
; .: Data definitions :.
(define-struct dir [name dirs files])
; A Dir.v3 is a structure: 
;   (make-dir.v3 String Dir* File*)
 
; A Dir* is one of: 
; – '()
; – (cons Dir.v3 Dir*)
 
; A File* is one of: 
; – '()
; – (cons File.v3 File*)

(define-struct file [name size content])
; A File.v3 is a structure: 
;   (make-file String N String)

(define file-part1 (make-file "part1" 99 ""))
(define file-part2 (make-file "part2" 52 ""))
(define file-part3 (make-file "part3" 17 ""))
(define file-hang (make-file "hang" 8 ""))
(define file-draw (make-file "draw" 2 ""))
(define file-docs-read (make-file "read!" 19 ""))
(define file-ts-read (make-file "read!" 10 ""))
(define dir-text (make-dir "Text" '() (list file-part1 file-part2 file-part3)))
(define dir-code (make-dir "Code" '() (list file-hang file-draw)))
(define dir-docs (make-dir "Docs" '() (list file-docs-read)))
(define dir-libs (make-dir "Libs" (list dir-code dir-docs) '()))
(define dir-ts (make-dir "TS" (list dir-text dir-libs) (list file-ts-read)))
