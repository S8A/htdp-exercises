;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex281) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp")) #f)))
(define DOT (circle 1 "solid" "red"))
(define MT (empty-scene 200 200))

(define-struct ir [name price])


; Write down a lambda expression that:

; consumes a number and decides whether it is less than 10;
(check-expect ((lambda (x) (<= x 10)) 9) #true)

; multiplies two given numbers and turns the result into a string;
(check-expect ((lambda (x y) (number->string (* x y))) 2 3) "6")

; consumes a natural number and returns 0 for evens and 1 for odds;
(check-expect ((lambda (n) (if (even? n) 0 1)) 7) 1)

; consumes two inventory records and compares them by price; and
(check-expect ((lambda (a b) (> (ir-price a) (ir-price b)))
               (make-ir "JBL MDR-XB450" 10.00)
               (make-ir "AirPods i9s" 25.00))
              #false)

; adds a red dot at a given Posn to a given Image.
(check-expect ((lambda (p im) (place-image DOT (posn-x p) (posn-y p) im))
               (make-posn 42 69) MT)
              (place-image DOT 42 69 MT))
