;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex506) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; [X -> Y] [List-of X] -> [List-of Y]
; applies f to each item in the given list
(define (mapac f l0)
  (local (; [List-of X] ??? -> [List-of Y]
          ; applies f to each item in l
          ; accumulator a contains the items from l0 not in l after
          ; applying f to them
          (define (map/a l a)
            (cond
              [(empty? l) (reverse a)]
              [(cons? l)
               (map/a (rest l) (cons (f (first l)) a))])))
    (map/a l0 '())))

(check-expect (mapac sqr '(1 2 3 5 7)) '(1 4 9 25 49))
(check-expect (mapac string-downcase '("weird" "Looking" "MF"))
              '("weird" "looking" "mf"))
