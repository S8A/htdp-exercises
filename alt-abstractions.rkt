;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname alt-abstractions) (read-case-sensitive #t) (teachpacks ((lib "abstraction.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "abstraction.rkt" "teachpack" "2htdp")) #f)))
; [X] [X -> Boolean] [List-of X] -> Boolean
(define (and-map p lx)
  (cond
    [(empty? (rest lx)) (p (first lx))]
    [(cons? (rest lx))
     (if (false? (p (first lx)))
         #false
         (and-map p (rest lx)))]))

(check-expect (and-map even? '(0 2 4 6 8 9)) #false)
(check-expect (and-map even? '(0 2 4 6 8)) #true)
(check-expect (and-map (lambda (s) (= (string-length s) 1))
                       '("a" "b" "c" "dee"))
              #false)
(check-expect (and-map (lambda (s) (= (string-length s) 1)) '("a" "b" "c"))
              #true)


; [X] [X -> Boolean] [List-of X] -> Boolean
(define (or-map p lx)
  (cond
    [(empty? (rest lx)) (p (first lx))]
    [(cons? lx)
     (if (and (boolean? (p (first lx))) (not (false? (p (first lx)))))
         #true
         (or-map p (rest lx)))]))

(check-expect (or-map odd? '(0 2 4 6 8 9)) #true)
(check-expect (or-map odd? '(0 2 4 6 8)) #false)
(check-expect (or-map (lambda (s) (> (string-length s) 1)) '("a" "b" "c" "dee"))
              #true)
(check-expect (or-map (lambda (s) (> (string-length s) 1)) '("a" "b" "c"))
              #false)


(check-expect (and-map (lambda (i) (> (- 9 i) 0))
                       (build-list 10 (lambda (x) x)))
              #false)
(check-expect (and-map (lambda (i) (if (>= i 0) i #false))
                       (build-list 10 (lambda (x) x)))
              9)
(check-expect (or-map (lambda (i) (if (= (- 9 i) 0) i #false))
                      (build-list 10 (lambda (x) x)))
              9)
(check-expect (or-map (lambda (i) (if (< i 0) i #false))
                      (build-list 10 (lambda (x) x)))
              #false)
(check-expect (foldr + 0 (map string->int (explode "abc"))) 294)
(check-expect (foldr * 1 (map (lambda (c) (+ (string->int c) 1))
                              (explode "abc")))
              970200)
(define a (string->int "a"))
(check-expect (foldr string-append "" (build-list 10
                                                  (lambda (j)
                                                    (int->string (+ a j)))))
              "abcdefghij")

