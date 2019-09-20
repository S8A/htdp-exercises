;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex483) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp")) #f)))
(define QUEENS 8)
; A QP is a structure:
;   (make-posn CI CI)
; A CI is an N in [0,QUEENS).
; interpretation (make-posn c r) denotes the square at 
; the r-th row and c-th column

(define-struct sqp [x y threatened])
; A Board is a [List-of Square]
; A Square Position (Sqp) is a structure: (make-sqp N N Boolean)
; interpretation the position of a square and whether it is
; threatened or not.

; data examples: QP
(define 0-1 (make-posn 0 1))
(define 1-3 (make-posn 1 3))
(define 2-0 (make-posn 2 0))
(define 3-2 (make-posn 3 2))

; data examples: [List-of QP]
(define 4QUEEN-SOLUTION-1
  (list (make-posn 0 1) (make-posn 1 3)
        (make-posn 2 0) (make-posn 3 2)))
(define 4QUEEN-SOLUTION-2
  (list (make-posn 0 2) (make-posn 1 0)
        (make-posn 2 3) (make-posn 3 1)))
(define loq1 (list (make-posn 0 1) (make-posn 0 0)
                   (make-posn 1 2) (make-posn 3 0)))


; N -> [Maybe [List-of QP]]
; finds a solution to the n queens problem 
(define (n-queens n)
  (place-queens (board0 n) n))

(check-expect (n-queens 2) #false)
(check-expect (n-queens 3) #false)
(check-satisfied (n-queens 4) (n-queens-solution? 4))
(check-satisfied (n-queens 4) is-queens-result?)


; Board N -> [Maybe [List-of QP]]
; places n queens on board; otherwise, returns #false
(define (place-queens a-board n)
  (cond
    [(zero? n) '()]
    [(positive? n)
     (local ((define available (find-open-spots a-board))
             (define result (place-queens/list a-board available n)))
       result)]))


; Board [List-of QP] N -> [Maybe [List-of QP]]
; places n queens on board starting from a position from the list;
; otherwise, returns false
(define (place-queens/list a-board positions n)
  (cond
    [(empty? positions) #false]
    [(cons? positions)
     (local ((define new-board (add-queen a-board (first positions)))
             (define next (place-queens new-board (sub1 n))))
       (if (false? next)
           (place-queens/list a-board (rest positions) n)
           (cons (first positions) next)))]))


; N -> Board 
; creates the initial n by n board
(define (board0 n)
  (foldr (lambda (y rest-pairs)
           (append (build-list n (lambda (x) (make-sqp x y #false)))
                   rest-pairs))
         '() (build-list n (lambda (y) y))))

(check-expect (board0 0) '())
(check-expect (board0 1) (list (make-sqp 0 0 #false)))
(check-expect (board0 3) (list (make-sqp 0 0 #false)
                               (make-sqp 1 0 #false)
                               (make-sqp 2 0 #false)
                               (make-sqp 0 1 #false)
                               (make-sqp 1 1 #false)
                               (make-sqp 2 1 #false)
                               (make-sqp 0 2 #false)
                               (make-sqp 1 2 #false)
                               (make-sqp 2 2 #false)))


; Board QP -> Board 
; places a queen at qp on a-board
(define (add-queen a-board qp)
  (map (lambda (sq)
         (make-sqp (sqp-x sq) (sqp-y sq)
                   (or (sqp-threatened sq) (threatening? qp (sqp-posn sq)))))
       a-board))

(check-expect (add-queen (board0 0) (make-posn 0 0)) '())
(check-expect (add-queen (board0 1) (make-posn 0 0))
              (list (make-sqp 0 0 #true)))
(check-expect (add-queen (board0 3) (make-posn 2 1))
              (list (make-sqp 0 0 #false)
                    (make-sqp 1 0 #true)
                    (make-sqp 2 0 #true)
                    (make-sqp 0 1 #true)
                    (make-sqp 1 1 #true)
                    (make-sqp 2 1 #true)
                    (make-sqp 0 2 #false)
                    (make-sqp 1 2 #true)
                    (make-sqp 2 2 #true)))


; Board -> [List-of QP]
; finds spots where it is still safe to place a queen
(define (find-open-spots a-board)
  (map sqp-posn
       (filter (lambda (sq) (false? (sqp-threatened sq))) a-board)))

(check-expect (find-open-spots (board0 0)) '())
(check-expect (find-open-spots (board0 1)) (list (make-posn 0 0)))
(check-expect (find-open-spots (list (make-sqp 0 0 #false)
                                     (make-sqp 1 0 #true)
                                     (make-sqp 2 0 #true)
                                     (make-sqp 0 1 #true)
                                     (make-sqp 1 1 #true)
                                     (make-sqp 2 1 #true)
                                     (make-sqp 0 2 #false)
                                     (make-sqp 1 2 #true)
                                     (make-sqp 2 2 #true)))
              (list (make-posn 0 0) (make-posn 0 2)))


; Square -> GP
; gets the position of the given square
(define (sqp-posn sq)
  (make-posn (sqp-x sq) (sqp-y sq)))

(check-expect (sqp-posn (make-sqp 2 1 #false)) (make-posn 2 1))
(check-expect (sqp-posn (make-sqp 3 5 #true)) (make-posn 3 5))


; N -> [[List-of QP] -> Boolean]
; produces a test that determines whether some list of queen positions
; is a valid solution to the puzzle
(define (n-queens-solution? n)
  (lambda (loq)
    (cond
      [(false? loq) #false]
      [(cons? loq)
       (local ((define pairs
                 (foldr (lambda (q1 rest-of-pairs)
                          (append (foldr (lambda (q2 rest)
                                           (if (equal? q1 q2)
                                               rest
                                               (cons (list q1 q2) rest)))
                                         '() loq)
                                  rest-of-pairs))
                        '() loq)))
         (and (= (length loq) n)
              (andmap (lambda (pair)
                        (not (threatening? (first pair) (second pair))))
                      pairs)))])))

(check-expect ((n-queens-solution? 4) 4QUEEN-SOLUTION-2) #true)
(check-expect ((n-queens-solution? 4) loq1) #false)
(check-expect ((n-queens-solution? 3) loq1) #false)


; [List-of QP] -> Boolean
; is the result equal [as a set] to one of two lists
(define (is-queens-result? x)
  (or (set=? 4QUEEN-SOLUTION-1 x)
      (set=? 4QUEEN-SOLUTION-2 x)))

(check-expect (is-queens-result? 4QUEEN-SOLUTION-1) #true)
(check-expect (is-queens-result? 4QUEEN-SOLUTION-2) #true)
(check-expect (is-queens-result? loq1) #false)


; [List-of X] [List-of X] -> Boolean
; determines whether the given lsits contain the same items, regardless
; of order
(define (set=? l1 l2)
  (and (= (length l1) (length l2))
       (andmap (lambda (i1) (member? i1 l2)) l1)
       (andmap (lambda (i2) (member? i2 l1)) l2)))

(check-expect (set=? '(a b c d) '(a b c)) #false)
(check-expect (set=? '(a b c) '(a b c d)) #false)
(check-expect (set=? '(a b c d) '(d b a c)) #true)


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
 (render-queens 4 (rest loq1) QUEEN)
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
