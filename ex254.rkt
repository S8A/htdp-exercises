;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname ex254) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp") (lib "web-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp") (lib "web-io.rkt" "teachpack" "2htdp")) #f)))
; [List-of X] [X X -> Boolean] -> [List-of X]
; Sorts the given list using comparator c
(define (sort-l l c)
  (cond
    [(empty? l) '()]
    [(cons? l)
     (if (or (empty? (sort-l (rest l) c))
             (c (first l) (first (sort-l (rest l) c))))
         (cons (first l) (sort-l (rest l) c))
         (sort-l (append (rest l) (list (first l))) c))]))


; [List-of Number] [Number Number -> Boolean] -> [List-of Number]
; Sorts the given list of numbers using comparator c
(define (sort-n lon c)
  (sort-l lon c))

(check-expect (sort-n '() >) '())
(check-expect (sort-n '(1) <) '(1))
(check-expect (sort-n '(4 10 2 7) >) '(10 7 4 2))
(check-expect (sort-n '(25 23 20 17 8 3 1) <) '(1 3 8 17 20 23 25))


; [List-of String] [String String -> Boolean] -> [List-of String]
; Sorts the given list of strings using comparator c
(define (sort-s los c)
  (sort-l los c))

(check-expect (sort-s '() string>?) '())
(check-expect (sort-s '("a") string<?) '("a"))
(check-expect (sort-s '("drugs" "jetpack" "bitcoin" "guns") string>?)
              '("jetpack" "guns" "drugs" "bitcoin"))
(check-expect (sort-s '("yen" "workaholic" "titan" "quiet" "holy wood"
                              "cocaine" "alpha") string<?)
              '("alpha" "cocaine" "holy wood" "quiet" "titan"
                        "workaholic" "yen"))



(define-struct ir [name price])
; An IR is a structure:
;   (make-ir String Number)


; IR IR -> Boolean
; Checks if the price of inventory record 1 is higher than inventory record 2's
(define (ir-price>? ir1 ir2)
  (> (ir-price ir1) (ir-price ir2)))


; [List-of IR] [IR IR -> Boolean] -> [List-of IR]
; Sorts the given list of inventory records by price in descending order.
(define (sort-ir lir)
  (sort-l lir ir-price>?))

(check-expect (sort-ir '()) '())
(check-expect (sort-ir `(,(make-ir "Cup" 3.56)
                         ,(make-ir "Keyboard" 19.99)
                         ,(make-ir "Shoelaces" 5.00)))
              `(,(make-ir "Keyboard" 19.99)
                ,(make-ir "Shoelaces" 5.00)
                ,(make-ir "Cup" 3.56)))
