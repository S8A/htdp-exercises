;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex285) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; Constants :.

(define USD-PER-EURO 1.06) ; on April 13th, 2017


; Data definitions :.

; A EuroAmount is a PositiveNumber.
; A DollarAmount is a PositiveNumber.
; An FTemperature is a Number.
; A CTemperature is a Number.
; A Pair is a (list Number Number)


; Functions :.

; [List-of EuroAmount] -> [List-of DollarAmount]
; Converts a list of USD amounts into a list of euro amounts.
(define (convert-euro l)
  (map (lambda (amount) (/ amount USD-PER-EURO)) l))

(check-expect (convert-euro '()) '())
(check-expect (convert-euro '(106 3.18 74.2)) '(100 3 70))


; [List-of FTemperature] -> [List-of CTemperature]
; Converts a list of Fahrenheit measurements to a list of Celsius measurements.
(define (convertFC l)
  (map (lambda (ftemp) (* 5/9 (- ftemp 32))) l))

(check-expect (convertFC '()) '())
(check-expect (convertFC '(32 100.4)) '(0 38))


; [List-of Posn] -> [List-of Pair]
; Converts a list of Posns into a list of Pairs.
(define (translate l)
  (map (lambda (p) (list (posn-x p) (posn-y p))) l))

(check-expect (translate '()) '())
(check-expect (translate (list (make-posn 47 54)
                               (make-posn 0 60)
                               (make-posn 50 50)))
              (list '(47 54) '(0 60) '(50 50)))
