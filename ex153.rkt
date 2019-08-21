;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex153) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp")) #f)))
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


(define lh (row 10 (col 20 sq3)))
(define lhw
  (overlay lh (rectangle (image-width lh) (image-height lh) "solid" "white")))


; A ListOfPosns is one of:
; - '()
; - (cons Posn ListOfPosns)
(define ex1 (cons (make-posn 2 2.3)
                  (cons (make-posn 7.6 3) '())))
(define ex2
  (cons (make-posn 1 2)
        (cons (make-posn 2 4)
              (cons (make-posn 3 6)
                    (cons (make-posn 4 8)
                          (cons (make-posn 5 10)
                                (cons (make-posn 6 12)
                                      (cons (make-posn 7 14)
                                            (cons (make-posn 8 16)
                                                  (cons (make-posn 9 18)
                                                        (cons (make-posn 10 20)
                                                              '())))))))))))


; ListOfPosns -> Image
; adds ballons to the lecture hall image at the coordinates listed in cl
(define (add-balloons cl)
  (cond
    [(empty? cl) lhw]
    [(cons? cl)
     (add-balloon (first cl) (add-balloons (rest cl)))]))

(check-expect (add-balloons ex1)
              (place-image sq1 76 30
                           (place-image sq1 20 23 lhw)))


; Posn -> Image
; adds ballon to the given image at the coordinates specified by p
; each unit in the coordinates maps to 10 pixels in the image
(define (add-balloon p im)
  (place-image sq1 (* 10 (posn-x p)) (* 10 (posn-y p)) im))

(check-expect (add-balloon (make-posn 2 2.3) lhw)
              (place-image sq1 20 23 lhw))
