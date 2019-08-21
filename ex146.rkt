;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex146) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp")) #f)))
; An NEList-of-temperatures is one of: 
; – (cons CTemperature '())
; – (cons CTemperature NEList-of-temperatures)
; interpretation non-empty lists of Celsius temperatures


; NEList-of-temperatures -> Number
; computes the average of a non-empty list of temperatures
(define (average alot)
  (/ (sum alot) (how-many alot)))

(check-expect (average (cons 1 (cons 2 (cons 3 '())))) 2)
(check-expect (average (cons 2 '())) 2)
(check-expect (average (cons 1 (cons 2 '()))) 1.5)
(check-expect (average (cons 3 (cons 2 '()))) 2.5)
(check-expect (average (cons 0 (cons 3 (cons 2 '())))) 5/3)


; List-of-temperatures -> Number 
; adds up the temperatures on the given list 
(define (sum ne-l)
  (cond
    [(empty? (rest ne-l)) (first ne-l)]
    [else (+ (first ne-l) (sum (rest ne-l)))]))

(check-expect (sum (cons 1 (cons 2 (cons 3 '())))) 6)
 
; List-of-temperatures -> Number 
; counts the temperatures on the given list 
(define (how-many alot)
  (cond
    [(empty? (rest alot)) 1]
    [(cons? (rest alot))
     (+ 1 (how-many (rest alot)))]))

(check-expect (how-many (cons 1 (cons 2 (cons 3 '())))) 3)

