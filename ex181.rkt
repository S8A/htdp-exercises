;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname ex181) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp")) #f)))
(check-expect (cons "a" (cons "b" (cons "c" (cons "d" '()))))
              (list "a" "b" "c" "d"))

(check-expect (cons (cons 1 (cons 2 '())) '())
              (list (list 1 2)))

(check-expect (cons "a" (cons (cons 1 '()) (cons #false '())))
              (cons "a" (cons (list 1) (list #false))))

(check-expect (cons (cons "a" (cons 2 '())) (cons "hello" '()))
              (cons (cons "a" (list 2)) (list "hello")))

(check-expect (cons (cons 1 (cons 2 '()))
                    (cons (cons 2 '())
                          '()))
              (cons (list 1 2) (list (list 2))))
