;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex152) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp")) #f)))
(define sq1 (square 10 "solid" "red"))
(define sq2 (square 10 "solid" "blue"))
(define sq3 (square 10 "outline" "black"))

; N Image -> Image
; produces a column of n copies of img
(define (col n img)
  (cond
    [(zero? (sub1 n)) img]
    [(positive? (sub1 n))
     (above img (col (sub1 n) img))]))

(check-expect (col 3 sq1)
              (above sq1 (above sq1 sq1)))
(check-expect (col 4 sq2)
              (above sq2 (above sq2 (above sq2 sq2))))

; N Image -> Image
; produces a row of n copies of img
(define (row n img)
  (cond
    [(zero? (sub1 n)) img]
    [(positive? (sub1 n))
     (beside img (row (sub1 n) img))]))

(check-expect (row 3 sq1)
              (beside sq1 (beside sq1 sq1)))
(check-expect (row 4 sq2)
              (beside sq2 (beside sq2 (beside sq2 sq2))))
