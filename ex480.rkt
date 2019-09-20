;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex480) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp")) #f)))
(define QUEENS 8)
; A QP is a structure:
;   (make-posn CI CI)
; A CI is an N in [0,QUEENS).
; interpretation (make-posn c r) denotes the square at 
; the r-th row and c-th column


; QP QP -> Boolean
; determines whether two queens placed on the given squares would
; threaten each other
(define (threatening? qp1 qp2)
  (local ((define qp1x (posn-x qp1))
          (define qp1y (posn-y qp1))
          (define qp2x (posn-x qp2))
          (define qp2y (posn-y qp2))
          (define same-row? (= qp1y qp2y))
          (define same-col? (= qp1x qp2x))
          (define same-first-diagonal?
            (= (- qp1x qp1y) (- qp2x qp2y)))
          (define same-second-diagonal?
            (= (+ qp1x qp1y) (+ qp2x qp2y))))
    (or same-row? same-col? same-first-diagonal? same-second-diagonal?)))

(check-expect (threatening? (make-posn 0 0) (make-posn 1 2)) #false)
(check-expect (threatening? (make-posn 1 0) (make-posn 1 2)) #true)
(check-expect (threatening? (make-posn 0 2) (make-posn 1 2)) #true)
(check-expect (threatening? (make-posn 3 0) (make-posn 1 2)) #true)


(define SQUARE-SIZE 20) ; side length of each square in pixels
(define HALF-SQUARE-SIZE (/ SQUARE-SIZE 2))
(define WSQ (square SQUARE-SIZE "solid" "white"))
(define BSQ (square SQUARE-SIZE "solid" "black"))

(define OUTER-RADIUS (* 2/5 SQUARE-SIZE))
(define INNER-RADIUS (* 3/4 OUTER-RADIUS))
(define QUEEN
  (overlay (radial-star QUEENS INNER-RADIUS OUTER-RADIUS "solid" "black")
           (radial-star QUEENS INNER-RADIUS OUTER-RADIUS "outline" "white")))

; N [List-of QP] Image -> Image
; renders the image of a chessboard of size nxn with the given
; image placed according to the given queen positions
(define (render-queens n loq queen-image)
  (foldr (lambda (q img)
           (place-image queen-image
                        (queen-px-distance (posn-x q))
                        (queen-px-distance (posn-y q))
                        img))
         (render-chessboard n WSQ BSQ) loq))

(check-expect
 (render-queens 4 (list (make-posn 0 0) (make-posn 1 2) (make-posn 3 0)) QUEEN)
 (place-image QUEEN (queen-px-distance 0) (queen-px-distance 0)
              (place-image QUEEN (queen-px-distance 1) (queen-px-distance 2)
                           (place-image QUEEN
                                        (queen-px-distance 3)
                                        (queen-px-distance 0)
                                        (render-chessboard 4 WSQ BSQ)))))

; N -> Image
; renders a chessboard of size nxn using the given
; square images
(define (render-chessboard n white-square-img black-square-img)
  (foldr above empty-image
         (build-list n
                     (lambda (row)
                       (local ((define white-pos? (if (odd? row) odd? even?)))
                         (foldr beside empty-image
                                (build-list n
                                            (lambda (col)
                                              (if (white-pos? col)
                                                  white-square-img
                                                  black-square-img)))))))))

(check-expect (render-chessboard 0 WSQ BSQ) empty-image)
(check-expect (render-chessboard 2 WSQ BSQ)
              (above (beside WSQ BSQ) (beside BSQ WSQ)))


; N -> Number
; converts the given distance in squares to the correct distance in pixels
(define (queen-px-distance d)
  (+ HALF-SQUARE-SIZE (* SQUARE-SIZE d)))

(check-expect (queen-px-distance 0) HALF-SQUARE-SIZE)
(check-expect (queen-px-distance 5) (+ HALF-SQUARE-SIZE (* SQUARE-SIZE 5)))
