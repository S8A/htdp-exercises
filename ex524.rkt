;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex524) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp")) #f)))
; A RiverSide is one of:
; - 'left
; - 'right

(define-struct ps [lm lc boat prev])
; A PuzzleState (PS) is a structure:
;   (make-ps N N RiverSide [Maybe PS])
; interpretation a PuzzleState instance contains, in order:
; - the number of missionaries on the left side of the river
; - the number of cannibals on the left side of the river
; - the side of the river in which the boat is currently at
; accumulator prev contains previously traversed state, or #false if none

(define initial-puzzle (make-ps 3 3 'left #false))
(define puzzle1 (make-ps 3 2 'right initial-puzzle))
(define puzzle2 (make-ps 3 1 'right initial-puzzle))
(define puzzle3 (make-ps 2 2 'right initial-puzzle))
(define final-puzzle (make-ps 0 0 'right #false)) ; testing final? only


; main ::..
; displays the solution of the missionaries and cannibals puzzles, step by step,
; spending s seconds per image
(define (main s)
  (run-movie s (map render-mc (solve-path initial-puzzle))))


; PuzzleState -> [List-of PuzzleState]
; solves the missionaries and cannibals puzzles starting from state0
; and produces the sequence of states required to do so
(define (solve-path state0)
  (reverse (ps-path (solve state0))))


; PuzzleState -> PuzzleState
; is the final state reachable from state0
; generative creates a tree of possible boat rides 
; termination generates all possible next states until inevitably
; reaching the final one
(define (solve state0)
  (local (; [List-of PuzzleState] -> PuzzleState
          ; generative generates the successors of los
          (define (solve* los)
            (cond
              [(ormap final? los)
               (first (filter final? los))]
              [else
               (solve* (create-next-states los))])))
    (solve* (list state0))))

;(check-expect (solve initial-puzzle) final-puzzle)


; [List-of PuzzleState] -> [List-of PuzzleState]
; creates a list with all possible next states from the ones on los0
(define (create-next-states los0)
  (local (; [List-of PuzzleState] -> [List-of PuzzleState]
          ; removes states from the list that already occur in their
          ; own previous paths
          (define (remove-repeated los)
            (filter (lambda (s)
                      (not (ormap (lambda (p) (ps=? s p)) (rest (ps-path s)))))
                    los))
          ; PuzzleState -> [List-of PuzzleState]
          ; produces a list with all possible next states from the given state
          (define (gen-possibilities s)
            (filter good?
                    (rest (foldr append '()
                                 (build-list 3
                                   (lambda (m)
                                     (build-list (- 3 m)
                                         (lambda (c) (move-people s m c)))))))))
          ; PuzzleState N N -> PuzzleState
          ; move m missionaries and c cannibals across the river
          (define (move-people s m c)
            (cond
              [(symbol=? (ps-boat s) 'left)
               (make-ps (- (ps-lm s) m) (- (ps-lc s) c) 'right s)]
              [(symbol=? (ps-boat s) 'right)
               (make-ps (+ (ps-lm s) m) (+ (ps-lc s) c) 'left s)])))
    (foldr append '() (map remove-repeated (map gen-possibilities los0)))))

(check-expect (create-next-states (list initial-puzzle))
              (list puzzle1 puzzle2 puzzle3))
(check-expect (create-next-states (list puzzle1 puzzle2 puzzle3))
              (list (make-ps 3 2 'left puzzle2) (make-ps 3 2 'left puzzle3)))


; PuzzleState -> [List-of PuzzleState]
; produces a list with all the states traversed to reach s0
(define (ps-path s0)
  (local (; PuzzleState [List-of PuzzleState] -> [List-of PuzzleState]
          ; accumulator path is the list of the states that have to be traversed
          ; from s to reach s0, with their prev attributes empty
          (define (path-finder s path)
            (local ((define prev-s (ps-prev s)))
              (cond
                [(false? prev-s) (reverse (cons s path))]
                [(ps? prev-s)
                 (path-finder prev-s (cons (remove-prev s) path))])))
          ; PuzzleState -> PuzzleState
          ; removes the prev attribute from the given state
          (define (remove-prev s)
            (make-ps (ps-lm s) (ps-lc s) (ps-boat s) #false)))
    (path-finder s0 '())))

(check-expect (ps-path (make-ps 3 3 'left puzzle1))
              (list (make-ps 3 3 'left #false)
                    (make-ps 3 2 'right #false)
                    (make-ps 3 3 'left #false)))
(check-expect (ps-path (make-ps 3 2 'left puzzle2))
              (list (make-ps 3 2 'left #false)
                    (make-ps 3 1 'right #false)
                    (make-ps 3 3 'left #false)))


; PuzzleState PuzzleState -> Boolean
; determines if s1 and s2 are the same state ignoring their prev attribute
(define (ps=? s1 s2)
  (and (= (ps-lm s1) (ps-lm s2))
       (= (ps-lc s1) (ps-lc s2))
       (symbol=? (ps-boat s1) (ps-boat s2))))

(check-expect (ps=? initial-puzzle initial-puzzle) #true)
(check-expect (ps=? (make-ps 3 3 'left puzzle1) (make-ps 3 3 'left puzzle2))
              #true)
(check-expect (ps=? puzzle2 puzzle3) #false)


; PuzzleState -> Boolean
; determines if s is the final state
(define (final? s)
  (= 0 (ps-lc s) (ps-lm s)))

(check-expect (final? initial-puzzle) #false)
(check-expect (final? puzzle1) #false)
(check-expect (final? puzzle2) #false)
(check-expect (final? puzzle3) #false)
(check-expect (final? final-puzzle) #true)


; PuzzleState -> Boolean
; determines if s is a valid state where the missionaries survive
(define (good? s)
  (local ((define lm (ps-lm s))
          (define lc (ps-lc s))
          (define boat (ps-boat s))
          (define rm (- 3 lm))
          (define rc (- 3 lc)))
    (and (member? boat '(left right))
         (<= 0 lm 3)
         (<= 0 lc 3)
         (if (> lm 0) (<= lc lm) #true)
         (if (> rm 0) (<= rc rm) #true))))

(check-expect (good? initial-puzzle) #true)
(check-expect (good? puzzle1) #true)
(check-expect (good? puzzle2) #true)
(check-expect (good? puzzle3) #true)
(check-expect (good? final-puzzle) #true)
(check-expect (good? (make-ps 4 2 'left '())) #false)
(check-expect (good? (make-ps 2 3 'right '())) #false)


(define UNIT 5) ; 1 unit = 10 px
(define SPACE (square UNIT "solid" "transparent"))
(define MISSIONARY (circle UNIT "solid" "black"))
(define CANNIBAL
  (overlay (circle UNIT "solid" "white") (circle UNIT "outline" "black")))
(define BANK-WIDTH (* 7 UNIT))
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
    (overlay/align "left" "top"
                   (beside/align "top" SPACE
                                 (foldr above empty-image
                                        (create-img-list m MISSIONARY)))
                   (overlay/align "right" "top"
                                  (beside/align "top"
                                                (foldr above empty-image
                                                  (create-img-list c CANNIBAL))
                                                SPACE)
                                  RIVER-BANK))))

(check-expect (render-bank 0 0) RIVER-BANK)
(check-expect (render-bank 1 2)
 (overlay/align "left" "top"
                (beside/align "top" SPACE
                              (above SPACE MISSIONARY SPACE))
                (overlay/align "right" "top"
                               (beside/align "top"
                                             (above SPACE CANNIBAL
                                                    SPACE CANNIBAL SPACE)
                                             SPACE)
                               RIVER-BANK)))


; RiverSide -> Image
; Renders a river with a boat on the given side
(define (render-river side)
  (overlay/align (symbol->string side) "middle"
                 (beside SPACE BOAT SPACE) RIVER))

(check-expect (render-river 'left)
              (overlay/align "left" "middle" (beside SPACE BOAT SPACE) RIVER))
(check-expect (render-river 'right)
              (overlay/align "right" "middle" (beside SPACE BOAT SPACE) RIVER))
