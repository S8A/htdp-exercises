;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex521) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp")) #f)))
; A RiverSide is one of:
; - 'left
; - 'right

(define-struct ps [lm lc boat])
; A PuzzleState (PS) is a structure:
;   (make-ps N N RiverSide)
; interpretation a PuzzleState instance contains, in order:
; - the number of missionaries on the left side of the river
; - the number of cannibals on the left side of the river
; - the side of the river in which the boat is currently at

(define initial-puzzle (make-ps 3 3 'left))
(define puzzle1 (make-ps 3 2 'right))
(define puzzle2 (make-ps 3 1 'right))
(define puzzle3 (make-ps 2 2 'right))
(define final-puzzle (make-ps 0 0 'right))


; PuzzleState -> Boolean
; determines if s is the final state
(define (final? s)
  (= 0 (ps-lc s) (ps-lm s)))

(check-expect (final? initial-puzzle) #false)
(check-expect (final? puzzle1) #false)
(check-expect (final? puzzle2) #false)
(check-expect (final? puzzle3) #false)
(check-expect (final? final-puzzle) #true)


(define UNIT 5) ; 1 unit = 10 px
(define SPACE (square UNIT "solid" "transparent"))
(define MISSIONARY (circle UNIT "solid" "black"))
(define CANNIBAL
  (overlay (circle UNIT "solid" "white") (circle UNIT "outline" "black")))
(define BANK-WIDTH (* 8 UNIT))
(define BANK-HEIGHT (* 10 UNIT))
(define RIVER-BANK (frame (rectangle BANK-WIDTH BANK-HEIGHT "solid" "white")))
(define RIVER-WIDTH (* 2 BANK-WIDTH))
(define BOAT (rectangle (* 2 UNIT) UNIT "solid" "black"))
(define RIVER (frame (rectangle RIVER-WIDTH BANK-HEIGHT "solid" "white")))
; PuzzleState -> Image
; Renders the current state of the missionary-and-cannibal puzzle
(define (render-mc s)
  (local ((define lm (ps-lm s))
          (define lc (ps-lc s))
          (define boat (ps-boat s))
          (define rm (- 3 lm))
          (define rc (- 3 lc)))
    (beside (render-bank lm lc) (render-river boat) (render-bank rm rc))))

(check-expect (render-mc initial-puzzle)
              (beside (render-bank 3 3)
                      (render-river 'left)
                      (render-bank 0 0)))
(check-expect (render-mc puzzle1)
              (beside (render-bank 3 2)
                      (render-river 'right)
                      (render-bank 0 1)))
(check-expect (render-mc puzzle2)
              (beside (render-bank 3 1)
                      (render-river 'right)
                      (render-bank 0 2)))
(check-expect (render-mc puzzle3)
              (beside (render-bank 2 2)
                      (render-river 'right)
                      (render-bank 1 1)))
(check-expect (render-mc final-puzzle)
              (beside (render-bank 0 0)
                      (render-river 'right)
                      (render-bank 3 3)))


; N N -> Image
; Renders a river bank with m missionaries and c cannibals
(define (render-bank m c)
  (local (; N Image -> [List-of Image]
          ; Produces a list with n copies of img and n+1 separating spaces
          (define (create-img-list n img)
            (build-list (* 2 n) (lambda (n) (if (even? n) SPACE img)))))
    (overlay/align "middle" "top"
                   (beside/align "top"
                                 (foldr above empty-image
                                        (create-img-list m MISSIONARY))
                                 SPACE
                                 (foldr above empty-image
                                        (create-img-list c CANNIBAL)))
                   RIVER-BANK)))

(check-expect (render-bank 0 0) RIVER-BANK)
(check-expect (render-bank 1 2)
              (overlay/align "middle" "top"
                             (beside/align "top"
                                           (above SPACE MISSIONARY SPACE)
                                           SPACE
                                           (above SPACE CANNIBAL
                                                  SPACE CANNIBAL SPACE))
                             RIVER-BANK))


; RiverSide -> Image
; Renders a river with a boat on the given side
(define (render-river side)
  (overlay/align (symbol->string side) "middle"
                 (beside SPACE BOAT SPACE) RIVER))

(check-expect (render-river 'left)
              (overlay/align "left" "middle" (beside SPACE BOAT SPACE) RIVER))
(check-expect (render-river 'right)
              (overlay/align "right" "middle" (beside SPACE BOAT SPACE) RIVER))
