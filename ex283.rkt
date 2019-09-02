;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex283) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp")) #f)))
(define th 20)
(define-struct ir [name price])

(check-expect ((lambda (ir) (<= (ir-price ir) th)) (make-ir "bear" 10))
              #true)

(check-expect (map (lambda (x) (* 10 x)) '(1 2 3))
              '(10 20 30))
 
(check-expect (foldl (lambda (name rst) (string-append name ", " rst))
                     "etc."
                     '("Matthew" "Robby"))
              "Robby, Matthew, etc.")
 
(check-expect (filter (lambda (ir) (<= (ir-price ir) th))
                      (list (make-ir "bear" 10) (make-ir "doll" 33)))
              (list (make-ir "bear" 10)))
