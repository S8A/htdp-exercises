;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex159) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp")) #f)))
; Basic graphical constants
(define BALLOON (circle 5 "solid" "red"))
(define GRID-SQUARE (square 10 "outline" "black"))

; N Image -> Image
; produces a column of n copies of img
(define (col n img)
  (cond
    [(zero? (sub1 n)) img]
    [(positive? (sub1 n))
     (above img (col (sub1 n) img))]))

(check-expect (col 3 GRID-SQUARE)
              (above GRID-SQUARE (above GRID-SQUARE GRID-SQUARE)))
(check-expect (col 4 GRID-SQUARE)
              (above GRID-SQUARE (above GRID-SQUARE
                                        (above GRID-SQUARE GRID-SQUARE))))


; N Image -> Image
; produces a row of n copies of img
(define (row n img)
  (cond
    [(zero? (sub1 n)) img]
    [(positive? (sub1 n))
     (beside img (row (sub1 n) img))]))

(check-expect (row 3 GRID-SQUARE)
              (beside GRID-SQUARE (beside GRID-SQUARE GRID-SQUARE)))
(check-expect (row 4 GRID-SQUARE)
              (beside GRID-SQUARE (beside GRID-SQUARE
                                          (beside GRID-SQUARE GRID-SQUARE))))


; Computed graphical constants
(define LECTURE-HALL-GRID (row 10 (col 20 GRID-SQUARE)))
(define LECTURE-HALL
  (overlay LECTURE-HALL-GRID
           (rectangle (image-width LECTURE-HALL-GRID)
                      (image-height LECTURE-HALL-GRID) "solid" "white")))
(define WIDTH (image-width LECTURE-HALL))


; An N is one of: 
; – 0
; – (add1 N)
; interpretation represents the counting numbers


; A ListOfPosns is one of:
; - '()
; - (cons Posn ListOfPosns)
(define lop1 (cons (make-posn 2 2.3)
                  (cons (make-posn 7.6 3) '())))
(define lop2
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


(define-struct pair [balloon# lob])
; A Pair is a structure (make-pair N List-of-posns)
; interpretation (make-pair n lob) means n balloons 
; must yet be thrown and added to lob


; N -> List-of-posns
; Throws one balloon after the other to the lecture hall and produces
; the list of positions where the balloons hit.
(define (riot n)
  (pair-lob (big-bang (make-pair n '())
              [to-draw render]
              [on-tick tock])))


; Pair -> Image
; Renders the current state of the lecture hall with the balloons thrown.
(define (render p)
  (add-balloons (pair-lob p) LECTURE-HALL))

(check-expect (render (make-pair 7 lop1))
              (add-balloons lop1 LECTURE-HALL))
(check-expect (render (make-pair 0 lop2))
              (add-balloons lop2 LECTURE-HALL))


; Pair -> Pair
; Makes the balloons fall one real pixel per tick, adding missing
; balloons one by one.
(define (tock p)
  (make-pair (pair-balloon# p)
             (if (< (how-many (pair-lob p)) (pair-balloon# p))
                 (new-balloon (move-balloons (pair-lob p)) (pair-balloon# p))
                 (move-balloons (pair-lob p)))))

(check-random (tock (make-pair 3 '()))
              (make-pair 3 (new-balloon (move-balloons '()) 3)))
(check-expect (tock (make-pair 2 lop1))
              (make-pair 2 (move-balloons lop1)))


; List-of-posns -> Image
; Adds the balloons to the image im at the positions specified by lop.
(define (add-balloons lop im)
  (cond
    [(empty? lop) im]
    [(cons? lop)
     (add-balloon (first lop) (add-balloons (rest lop) im))]))

(check-expect (add-balloons lop1 LECTURE-HALL)
              (place-image BALLOON 76 30
                           (place-image BALLOON 20 23 LECTURE-HALL)))


; Posn -> Image
; Adds ballon to the given image at the coordinates specified by p.
; Each unit in the coordinates maps to 10 pixels in the image.
(define (add-balloon p im)
  (place-image BALLOON (* 10 (posn-x p)) (* 10 (posn-y p)) im))

(check-expect (add-balloon (make-posn 2 2.3) LECTURE-HALL)
              (place-image BALLOON 20 23 LECTURE-HALL))


; List-of-posns -> List-of-posns
; Make all balloons fall one real pixel.
(define (move-balloons lob)
  (cond
    [(empty? lob) '()]
    [(cons? lob)
     (cons (move-balloon (first lob)) (move-balloons (rest lob)))]))

(check-expect (move-balloons '()) '())
(check-expect (move-balloons lop1)
              (cons (make-posn 2 2.4) (cons (make-posn 7.6 3.1) '())))


; Posn -> Posn
; Move ballon down one real pixel (0.1 unit).
(define (move-balloon b)
  (make-posn (posn-x b) (+ (posn-y b) 0.1)))

(check-expect (move-balloon (make-posn 5 3.5)) (make-posn 5 3.6))


; List-of-posns -> Number
; Counts how many positions are in the list.
(define (how-many list)
  (cond
    [(empty? list) 0]
    [(cons? list)
     (+ 1 (how-many (rest list)))]))

(check-expect (how-many lop1) 2)
(check-expect (how-many lop2) 10)


; List-of-posns -> List-of-posns
; Adds one balloon at some point above the canvas.
(define (new-balloon lob n)
  (cons (make-posn (/ (random WIDTH) 10) (* -2 (random n)))
        lob))

(check-random (new-balloon (cons (make-posn 3 5) '()) 3)
              (cons (make-posn (/ (random WIDTH) 10) (* -2 (random 3)))
                    (cons (make-posn 3 5) '())))
