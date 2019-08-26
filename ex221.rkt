;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname ex221) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp") (lib "itunes.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp") (lib "itunes.rkt" "teachpack" "2htdp")) #f)))
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
(define tetris4 (make-tetris block-landed landscape0))
(define tetris5 (make-tetris block-on-block landscape1))


; Main ::..
; Number -> Tetris
; Runs the simplified tetris game with a clock that ticks every x seconds.
(define (tetris-main x)
  (big-bang (make-tetris block-dropping0 landscape0)
    [to-draw tetris-render]
    [on-tick tetris-tock x]))


; Functions :.

; Tetris -> Image
; Renders the current state of the tetris game as an image.
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


; Tetris -> Tetris
; After each tick, makes block fall one unit. If the block reaches the
; ground or the top of another block, add it to the landscape and make
; another block fall.
(define (tetris-tock t)
  (if (block-landed? t)
      (make-tetris (new-block (tetris-block t))
                   (cons (tetris-block t) (tetris-landscape t)))
      (make-tetris (move-down (tetris-block t))
                   (tetris-landscape t))))

(check-expect (tetris-tock tetris0)
              (make-tetris (move-down block-dropping0) landscape0))
(check-expect (tetris-tock tetris1)
              (make-tetris (move-down block-dropping1) landscape0))
(check-expect (tetris-tock tetris2)
              (make-tetris (move-down block-dropping0) landscape1))
(check-expect (tetris-tock tetris3)
              (make-tetris (move-down block-dropping1) landscape2))
(check-expect (tetris-tock tetris4)
              (make-tetris (new-block block-landed)
                           (cons block-landed landscape0)))
(check-expect (tetris-tock tetris5)
              (make-tetris (new-block block-on-block)
                           (cons block-on-block landscape1)))


; Landscape Image -> Image
; Renders the landscape over the given image.
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
; Renders the block at its corresponding position over the given image.
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


; Tetris -> Boolean
; Determines whether the block of the given Tetris has landed on the ground
; or over any block of its landscape
(define (block-landed? t)
  (or (= (block-y (tetris-block t)) (- HEIGHT 1))
      (member? (move-down (tetris-block t)) (tetris-landscape t))))

(check-expect (block-landed? tetris0) #false)
(check-expect (block-landed? tetris1) #false)
(check-expect (block-landed? tetris2) #false)
(check-expect (block-landed? tetris3) #false)
(check-expect (block-landed? tetris4) #true)
(check-expect (block-landed? tetris5) #true)


; Block -> Block
; Moves the given block down by one unit.
(define (move-down b)
  (make-block (block-x b) (+ (block-y b) 1)))

(check-expect (move-down block-dropping0) (make-block 0 1))
(check-expect (move-down block-dropping1) (make-block 3 5))


; Block -> Block
; Creates a new block that descends on the column to the right of
; the given one, or at the left-most column if the given block is at
; the right-most column
(define (new-block b)
  (make-block (modulo (+ (block-x b) 1) WIDTH) 0))

(check-expect (new-block block-landed) (make-block 1 0))
(check-expect (new-block block-dropping1) (make-block 4 0))
(check-expect (new-block (make-block (- WIDTH 1) 5)) (make-block 0 0))
