;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex295) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; distances in terms of pixels 
(define WIDTH 300)
(define HEIGHT 300)
 
; N -> [List-of Posn]
; generates n random Posns in [0,WIDTH) by [0,HEIGHT)
(define (random-posns n)
  (build-list n
              (lambda (i) (make-posn (random WIDTH) (random HEIGHT)))))
(check-satisfied (random-posns 3) (n-inside-playground? 3))


; Test lists
(define lop1 (list (make-posn 1 54)
                   (make-posn 51 97)
                   (make-posn 156 659)))
(define lop2 (list (make-posn 1 54)
                   (make-posn 51 97)
                   (make-posn 156 69)))
(define lop3 (list (make-posn 1 54)
                   (make-posn 156 659)))
(define lop4 (list (make-posn 1 54)
                   (make-posn 51 97)
                   (make-posn 156 69)
                   (make-posn 49 254)))


; N -> [ [List-of Posn] -> Boolean ]
; are there n posns in the list and are they inside the playground
(define (n-inside-playground? n)
  (lambda (lop)
    (local (; Posn -> Boolean
            (define (posn-inside? p)
              (and (<= 0 (posn-x p) WIDTH) (<= 0 (posn-y p) HEIGHT))))
      (and (= n (length lop)) (andmap posn-inside? lop)))))

(check-expect ((n-inside-playground? 3) lop1) #false)
(check-expect ((n-inside-playground? 3) lop2) #true)
(check-expect ((n-inside-playground? 3) lop3) #false)
(check-expect ((n-inside-playground? 3) lop4) #false)


; N -> [List-of Posn]
; always produces the same posns, fooling the specification
(define (random-posns/bad n)
  (build-list n (lambda (n) (make-posn 1 1))))

(check-satisfied (random-posns/bad 3) (n-inside-playground? 3))
(check-satisfied (random-posns/bad 33) (n-inside-playground? 33))
