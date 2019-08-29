;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname ex255) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp") (lib "web-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp") (lib "web-io.rkt" "teachpack" "2htdp")) #f)))
; [List-of X] [X -> X] -> [List-of X]
; Applies function f to each item from the list.
(define (map-l l f)
  (cond
    [(empty? l) '()]
    [(cons? l)
     (cons (f (first l)) (map-l (rest l) f))]))


; [List-of Number] [Number -> Number] -> [List-of Number]
; Applies function f to each item from the list of numbers.
(define (map-n lon f)
  (map-l lon f))

(check-expect (map-n '() sqr) '())
(check-within (map-n '(1 4 2) sqrt) `(1 2 ,(sqrt 2)) 0.00001)
(check-expect (map-n '(100 7 23) sqr) '(10000 49 529))


; [List-of String] [String -> String] -> [List-of String]
; Applies function f to each item from the list of strings.
(define (map-s los f)
  (map-l los f))

(check-expect (map-s '() string-downcase) '())
(check-expect (map-s '("tea" "BAG" "Everyone") string-upcase)
              '("TEA" "BAG" "EVERYONE"))
(check-expect (map-s '("We" "aRe" "noT" "YOUR" "kind") string-downcase)
              '("we" "are" "not" "your" "kind"))
(check-expect (map-s '("We" "aRe" "noT" "YOUR" "kind") string-copy)
              '("We" "aRe" "noT" "YOUR" "kind"))



; [List-of X] [X -> Y] -> [List-of Y]
(define (map1 k g)
  (map-l k g))
	

   
