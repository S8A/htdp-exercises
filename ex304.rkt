;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex304) (read-case-sensitive #t) (teachpacks ((lib "abstraction.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "abstraction.rkt" "teachpack" "2htdp")) #f)))
(check-expect (for/list ([i 2] [j '(a b)]) (list i j))
              '((0 a) (1 b)))

(check-expect (for*/list ([i 2] [j '(a b)]) (list i j))
              '((0 a) (0 b) (1 a) (1 b)))
