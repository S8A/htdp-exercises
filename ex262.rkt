;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname ex262) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp") (lib "web-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp") (lib "web-io.rkt" "teachpack" "2htdp")) #f)))
; A Row is a [List-of Number]
; A Matrix is a [List-of Row]


; N -> Matrix
; Creates an identity matrix of size n (n>0).
(define (identityM n)
  (local (; N -> N
          ; Generates each item of the first row.
          (define (first-row-item i) (if (= i 0) 1 0))
          ; Row -> Row
          ; Adds a zero at the start of the row.
          (define (prepend0 row) (cons 0 row)))
    (cond
      [(zero? n) '()]
      [else
       (cons (build-list n first-row-item)
             (map prepend0 (identityM (sub1 n))))])))

(check-expect (identityM 1) (list (list 1)))
(check-expect (identityM 2)
              (list (list 1 0) (list 0 1)))
(check-expect (identityM 3)
              (list (list 1 0 0) (list 0 1 0) (list 0 0 1)))
