;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex163) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp")) #f)))
; ListOfFTemps is one of:
; - '()
; - (cons Number ListOfFTemps)
; interpretation a list of temperature measurements in
; Fahrenheit

; ListOfCTemps is one of:
; - '()
; - (cons Number ListOfCTemps)
; interpretation a list of temperature measurements in
; Celsius


; ListOfFTemps -> ListOfCTemps
; Converts a list of temperature measurments from Fahrenheit to Celsius.
(define (convertFC list)
  (cond
    [(empty? list) '()]
    [(cons? list)
     (cons (* 5/9 (- (first list) 32)) (convertFC (rest list)))]))

(check-expect (convertFC '()) '())
(check-expect (convertFC (cons 32 (cons 100.4 '())))
              (cons 0 (cons 38 '())))
