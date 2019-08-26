;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname ex220) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp") (lib "itunes.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp") (lib "itunes.rkt" "teachpack" "2htdp")) #f)))
; Constants :.

(define WIDTH 10) ; # of blocks, horizontally
(define HEIGHT WIDTH)
(define SIZE 10) ; blocks are squares
(define SCENE-SIZE (* WIDTH SIZE))
 
(define BLOCK ; red squares with black rims
  (overlay
    (square (- SIZE 1) "solid" "red")
    (square SIZE "outline" "black")))
(define HALF-BLOCK (/ SIZE 2))

(define BACKG (empty-scene SCENE-SIZE SCENE-SIZE "midnightblue"))



; Data definitions :.

(define-struct tetris [block landscape])
(define-struct block [x y])
 
; A Tetris is a structure:
;   (make-tetris Block Landscape)
; A Landscape is one of: 
; – '() 
; – (cons Block Landscape)
; A Block is a structure:
;   (make-block N N)
 
; interpretations
; (make-block x y) depicts a block whose left 
; corner is (* x SIZE) pixels from the left and
; (* y SIZE) pixels from the top;
; (make-tetris b0 (list b1 b2 ...)) means b0 is the
; dropping block, while b1, b2, and ... are resting


; Data examples :.

(define block-dropping0 (make-block 0 0))
(define block-dropping1 (make-block 3 4))
(define block-landed (make-block 0 (- HEIGHT 1)))
(define block-on-block (make-block 0 (- HEIGHT 2)))
(define landscape0 '())
(define landscape1 (list block-landed))
(define landscape2 (list block-on-block block-landed))
(define tetris0 (make-tetris block-dropping0 landscape0))
(define tetris1 (make-tetris block-dropping1 landscape0))
(define tetris2 (make-tetris block-dropping0 landscape1))
(define tetris3 (make-tetris block-dropping1 landscape2))


; Functions :.

; Tetris -> Image
; renders the current state of the tetris game as an image
(define (tetris-render t)
  (block-render (tetris-block t)
                (landscape-render (tetris-landscape t) BACKG)))

(check-expect (tetris-render tetris0)
              (block-render block-dropping0
                            (landscape-render landscape0 BACKG)))
(check-expect (tetris-render tetris1)
              (block-render block-dropping1
                            (landscape-render landscape0 BACKG)))
(check-expect (tetris-render tetris2)
              (block-render block-dropping0
                            (landscape-render landscape1 BACKG)))
(check-expect (tetris-render tetris3)
              (block-render block-dropping1
                            (landscape-render landscape2 BACKG)))


; Landscape Image -> Image
; renders the landscape over the given image
(define (landscape-render ls im)
  (cond
    [(empty? ls) im]
    [(cons? ls)
     (block-render (first ls) (landscape-render (rest ls) im))]))

(check-expect (landscape-render landscape0 BACKG) BACKG)
(check-expect (landscape-render landscape1 BACKG)
              (block-render block-landed BACKG))
(check-expect (landscape-render landscape2 BACKG)
              (block-render block-on-block (block-render block-landed BACKG)))


; Block Image -> Image
; renders the block at its corresponding position over the given image
(define (block-render b im)
  (place-image BLOCK
               (+ (* (block-x b) SIZE) HALF-BLOCK)
               (+ (* (block-y b) SIZE) HALF-BLOCK)
               im))

(check-expect (block-render block-dropping0 BACKG)
              (place-image BLOCK HALF-BLOCK HALF-BLOCK BACKG))
(check-expect (block-render block-dropping1 BACKG)
              (place-image BLOCK
                           (+ (* 3 SIZE) HALF-BLOCK)
                           (+ (* 4 SIZE) HALF-BLOCK)
                           BACKG))
(check-expect (block-render block-landed BACKG)
              (place-image BLOCK
                           HALF-BLOCK
                           (+ (* (- HEIGHT 1) SIZE) HALF-BLOCK)
                           BACKG))
(check-expect (block-render block-on-block BACKG)
              (place-image BLOCK
                           HALF-BLOCK
                           (+ (* (- HEIGHT 2) SIZE) HALF-BLOCK)
                           BACKG))

