;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex164) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp")) #f)))
; ListOfDollars is one of:
; - '()
; - (cons PositiveNumber ListOfDollars)

; ListOfEuros is one of:
; - '()
; - (cons PositiveNumber ListOfDollars)


; ListOfDollars -> ListOfEuros
; Converts a list of USD amounts to euro amounts.
(define (convert-euro list)
  (cond
    [(empty? list) '()]
    [(cons? list)
     (cons (* 0.90 (first list)) (convert-euro (rest list)))]))

(check-expect (convert-euro '()) '())
(check-expect (convert-euro (cons 10 (cons 3.5 '())))
              (cons 9 (cons 3.15 '())))


; ListOfDollars -> ListOfEuros
; Converts a list of USD amounts to euro amounts using exchange rate exr.
(define (convert-euro* exr list)
  (cond
    [(empty? list) '()]
    [(cons? list)
     (cons (* exr (first list)) (convert-euro* exr (rest list)))]))

(check-expect (convert-euro* 0.90 '()) '())
(check-expect (convert-euro* 0.90 (cons 10 (cons 3.5 '())))
              (cons 9 (cons 3.15 '())))
