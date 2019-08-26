;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname ex223) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp") (lib "itunes.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp") (lib "itunes.rkt" "teachpack" "2htdp")) #f)))
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

(define TEXT-SIZE 10)
(define TEXT-COLOR "white")
(define TEXT-GAME-OVER "..:: GAME OVER ::..")
(define TEXT-BACKG
  (rectangle SCENE-SIZE (* 4 SIZE) "solid" (make-color 0 0 0 200)))



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
(define block-landed0 (make-block 0 (- HEIGHT 1)))
(define block-on-block0 (make-block 0 (- HEIGHT 2)))
(define block-between-towers (make-block 1 (- HEIGHT 2)))
(define block-landed1 (make-block 2 (- HEIGHT 1)))
(define block-on-block1 (make-block 2 (- HEIGHT 2)))
(define landscape0 '())
(define landscape1 (list block-landed0))
(define landscape2 (list block-on-block0 block-landed0))
(define landscape3 (list block-landed1))
(define landscape4 (list block-on-block1 block-landed1))
(define landscape5 (list (make-block 2 0)
                         (make-block 2 1)
                         (make-block 2 2)
                         (make-block 2 3)
                         (make-block 2 4)
                         (make-block 2 5)
                         (make-block 2 6)
                         (make-block 2 7)
                         (make-block 2 8)
                         (make-block 2 9)))
(define tetris0 (make-tetris block-dropping0 landscape0))
(define tetris1 (make-tetris block-dropping1 landscape0))
(define tetris2 (make-tetris block-dropping0 landscape1))
(define tetris3 (make-tetris block-dropping1 landscape2))
(define tetris4 (make-tetris block-landed0 landscape0))
(define tetris5 (make-tetris block-on-block0 landscape1))
(define tetris6 (make-tetris block-between-towers landscape1))
(define tetris7 (make-tetris block-between-towers landscape2))
(define tetris8 (make-tetris block-between-towers landscape3))
(define tetris9 (make-tetris block-between-towers landscape4))
(define tetris10 (make-tetris block-dropping0 landscape5))
(define tetris11 (make-tetris block-dropping1 landscape5)) ; not possible



; Main ::..
; Number -> Tetris
; Runs the simplified tetris game with a clock that ticks every x seconds.
(define (tetris-main x)
  (big-bang (make-tetris block-dropping0 landscape0)
    [to-draw tetris-render]
    [on-tick tetris-tock x]
    [on-key tetris-control]
    [stop-when tetris-over? tetris-render-end]))


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
              (make-tetris (new-block block-landed0)
                           (cons block-landed0 landscape0)))
(check-expect (tetris-tock tetris5)
              (make-tetris (new-block block-on-block0)
                           (cons block-on-block0 landscape1)))


; Tetris KeyEvent -> Tetris
; Controls the horizontal movement of the dropping block with the
; "left" and "right" arrow keys.
(define (tetris-control t ke)
  (cond
    [(key=? ke "left") (tetris-move-left t)]
    [(key=? ke "right") (tetris-move-right t)]
    [else t]))

(check-expect (tetris-control tetris0 "left") tetris0)
(check-expect (tetris-control tetris0 "right") (tetris-move-right tetris0))
(check-expect (tetris-control tetris0 "a") tetris0)
(check-expect (tetris-control tetris1 "left") (tetris-move-left tetris1))
(check-expect (tetris-control tetris1 "right") (tetris-move-right tetris1))
(check-expect (tetris-control tetris1 " ") tetris1)
(check-expect (tetris-control tetris2 "left") tetris2)
(check-expect (tetris-control tetris2 "right") (tetris-move-right tetris2))
(check-expect (tetris-control tetris2 "\r") tetris2)
(check-expect (tetris-control tetris3 "left") (tetris-move-left tetris3))
(check-expect (tetris-control tetris3 "right") (tetris-move-right tetris3))
(check-expect (tetris-control tetris3 "\b") tetris3)


; Tetris -> Boolean
; Ends the game when the landscape blocks reach the top of the frame.
(define (tetris-over? t)
  (reached-top? (tetris-landscape t)))

(check-expect (tetris-over? tetris0) #false)
(check-expect (tetris-over? tetris1) #false)
(check-expect (tetris-over? tetris2) #false)
(check-expect (tetris-over? tetris3) #false)
(check-expect (tetris-over? tetris4) #false)
(check-expect (tetris-over? tetris5) #false)
(check-expect (tetris-over? tetris6) #false)
(check-expect (tetris-over? tetris7) #false)
(check-expect (tetris-over? tetris8) #false)
(check-expect (tetris-over? tetris9) #false)
(check-expect (tetris-over? tetris10) #true)
(check-expect (tetris-over? tetris11) #true)


; Tetris -> Image
; Renders the final image of the game, with "Game Over" and the number of
; stacked blocks overlaid.
(define (tetris-render-end t)
  (render-final-text (tetris-landscape t) (tetris-render t)))

(check-expect (tetris-render-end tetris10)
              (render-final-text landscape5 (tetris-render tetris10)))
(check-expect (tetris-render-end tetris11)
              (render-final-text landscape5 (tetris-render tetris11)))


; Landscape Image -> Image
; Renders the landscape over the given image.
(define (landscape-render ls im)
  (cond
    [(empty? ls) im]
    [(cons? ls)
     (block-render (first ls) (landscape-render (rest ls) im))]))

(check-expect (landscape-render landscape0 BACKG) BACKG)
(check-expect (landscape-render landscape1 BACKG)
              (block-render block-landed0 BACKG))
(check-expect (landscape-render landscape2 BACKG)
              (block-render block-on-block0 (block-render block-landed0 BACKG)))


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
(check-expect (block-render block-landed0 BACKG)
              (place-image BLOCK
                           HALF-BLOCK
                           (+ (* (- HEIGHT 1) SIZE) HALF-BLOCK)
                           BACKG))
(check-expect (block-render block-on-block0 BACKG)
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

(check-expect (new-block block-landed0) (make-block 1 0))
(check-expect (new-block block-dropping1) (make-block 4 0))
(check-expect (new-block (make-block (- WIDTH 1) 5)) (make-block 0 0))


; Tetris -> Tetris
; Shifts the dropping block one column to the left if possible.
(define (tetris-move-left t)
  (if (or (= (block-x (tetris-block t)) 0)
          (member? (move-x -1 (tetris-block t)) (tetris-landscape t)))
      t
      (make-tetris (move-x -1 (tetris-block t)) (tetris-landscape t))))

(check-expect (tetris-move-left tetris0) tetris0)
(check-expect (tetris-move-left tetris1)
              (make-tetris (move-x -1 block-dropping1) landscape0))
(check-expect (tetris-move-left tetris6)
              (make-tetris block-on-block0 landscape1))
(check-expect (tetris-move-left tetris7) tetris7)


; Tetris -> Tetris
; Shifts the dropping block one column to the right if possible.
(define (tetris-move-right t)
  (if (or (= (block-x (tetris-block t)) (- WIDTH 1))
          (member? (move-x 1 (tetris-block t)) (tetris-landscape t)))
      t
      (make-tetris (move-x 1 (tetris-block t)) (tetris-landscape t))))

(check-expect (tetris-move-right tetris0)
              (make-tetris (move-x 1 block-dropping0) landscape0))
(check-expect (tetris-move-right tetris1)
              (make-tetris (move-x 1 block-dropping1) landscape0))
(check-expect (tetris-move-right tetris8)
              (make-tetris block-on-block1 landscape3))
(check-expect (tetris-move-right tetris9) tetris9)


; Block -> Block
; Moves the block dx columns to the right (or left if negative)
(define (move-x dx b)
  (make-block (+ (block-x b) dx) (block-y b)))

(check-expect (move-x 1 block-dropping0) (make-block 1 0))
(check-expect (move-x 1 block-dropping1) (make-block (+ 3 1) 4))
(check-expect (move-x -1 block-dropping1) (make-block (+ 3 -1) 4))
(check-expect (move-x -1 block-between-towers) block-on-block0)
(check-expect (move-x 1 block-between-towers) block-on-block1)


; Landscape -> Boolean
; Checks if any block of the landscape has reached the top of the frame.
(define (reached-top? ls)
  (cond
    [(empty? ls) #false]
    [(cons? ls)
     (or (= (block-y (first ls)) 0) (reached-top? (rest ls)))]))

(check-expect (reached-top? landscape0) #false)
(check-expect (reached-top? landscape1) #false)
(check-expect (reached-top? landscape2) #false)
(check-expect (reached-top? landscape3) #false)
(check-expect (reached-top? landscape4) #false)
(check-expect (reached-top? landscape5) #true)


; Landscape Image -> Image
; Renders the text "Game Over" and the number of blocks stacked in the given 
; landscape over the image im.
(define (render-final-text ls im)
  (overlay (above (text TEXT-GAME-OVER TEXT-SIZE TEXT-COLOR)
                  (text (string-append "Stacked blocks: "
                                       (number->string (length ls)))
                        TEXT-SIZE TEXT-COLOR))
           TEXT-BACKG im))

(check-expect (render-final-text landscape5 BACKG)
              (overlay (above (text TEXT-GAME-OVER TEXT-SIZE TEXT-COLOR)
                              (text "Stacked blocks: 10" TEXT-SIZE TEXT-COLOR))
                       TEXT-BACKG BACKG))
