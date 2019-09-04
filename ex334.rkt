;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex334) (read-case-sensitive #t) (teachpacks ((lib "abstraction.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "abstraction.rkt" "teachpack" "2htdp")) #f)))
; .: Data definitions :.
(define-struct dir [name size readability content])
; A Dir.v2 is a structure: 
;   (make-dir String N Boolean LOFD)
 
; An LOFD (short for list of files and directories) is one of:
; – '()
; – (cons File.v2 LOFD)
; – (cons Dir.v2 LOFD)
 
; A File.v2 is a String.

(define dir-text (make-dir "Text" 1 #t (list "part1" "part2" "part3")))
(define dir-code (make-dir "Code" 1 #f (list "hang" "draw")))
(define dir-docs (make-dir "Docs" 1 #f (list "read!")))
(define dir-libs (make-dir "Libs" 1 #f (list dir-code dir-docs)))
(define dir-ts (make-dir "TS" 1 #f (list dir-text "read!" dir-libs)))



; Dir.v2 -> N
; how many files are in the given directory
(define (how-many dir)
  (foldr + 0 (map (lambda (item) (if (string? item) 1 (how-many item)))
                  (dir-content dir))))

(check-expect (how-many dir-text) 3)
(check-expect (how-many dir-code) 2)
(check-expect (how-many dir-docs) 1)
(check-expect (how-many dir-libs) 3)
(check-expect (how-many dir-ts) 7)
