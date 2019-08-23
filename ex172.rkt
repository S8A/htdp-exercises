;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex172) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp")) #f)))
; A List-of-strings (LS) is one of:
; - '()
; - (cons String LS)
(define ex1 (cons "TTT"
                  (cons ""
                        (cons "Put up in a place"
                              (cons "something" '())))))
(define ex2 (cons "TTT"
                  (cons "Put"
                        (cons "up"
                              (cons "in"
                                    (cons "a" '()))))))
(define ttt1 (read-lines "ttt.txt"))
(define ttt2 (read-words "ttt.txt"))

; List-of-list-of-strings (LLS) is one of:
; - '()
; - (cons List-of-strings LLS)
(define ex3 (cons (cons "TTT" '())
                  (cons '()
                        (cons (cons "Put"
                                    (cons "up"
                                          (cons "in" '())))
                              (cons (cons "damn" '()) '())))))
(define ttt3 (read-words/line "ttt.txt"))


(define line0 (cons "hello" (cons "world" '())))
(define line1 '())
 
(define lls0 '())
(define lls1 (cons line0 (cons line1 '())))


; LLS -> String
; converts a list of lines into a string, words separated by blank spaces
; and lines separated by newlines.
(define (collapse lls)
  (cond
    [(empty? lls) "\n"]
    [(cons? lls)
     (string-append (line-string (first lls)) (collapse (rest lls)))]))

(check-expect (collapse lls0) "")
(check-expect (collapse lls1) "hello world\n")
(check-expect (collapse ex3) "TTT\nPut up in\ndamn\n")


; List-of-strings -> String
; converts a line into a string, words separated by blank spaces
(define (line-string los)
  (cond
    [(empty? los) ""]
    [(cons? los)
     (string-append (first los) " " (line-string (rest los)))]))

(check-expect (line-string line0) "hello world")
(check-expect (line-string line1) "")
