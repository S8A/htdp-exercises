;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex109) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp")) #f)))
(define AA "start, expect an 'a'")
(define BB "expect 'b', 'c', or 'd'")
(define DD "finished")
(define ER "error, illegal key")
; ExpectsToSee is one of:
; – AA
; – BB
; – DD 
; – ER
; interpretation the possible states of a pattern matching program
; looking for sequences that start with "a", followed by an arbitrarily
; long mix of "b" and "c", and ended by a "d".


; Graphical constants
(define WIDTH 100)
(define HEIGHT WIDTH)


; ExpectsToSee -> Image
; Initially the program shows a white rectangle. After encountering
; the first desired letter, it displays a yellow rectangle of the same size.
; After encountering the final letter, the color of the rectangle turns green.
; If any “bad” key event occurs, the program displays a red rectangle.
(define (render ets)
  (rectangle WIDTH HEIGHT "solid" (cond
                                    [(equal? ets AA) "white"]
                                    [(equal? ets BB) "yellow"]
                                    [(equal? ets DD) "green"]
                                    [(equal? ets ER) "red"])))

(check-expect (render AA) (rectangle WIDTH HEIGHT "solid" "white"))
(check-expect (render BB) (rectangle WIDTH HEIGHT "solid" "yellow"))
(check-expect (render DD) (rectangle WIDTH HEIGHT "solid" "green"))
(check-expect (render ER) (rectangle WIDTH HEIGHT "solid" "red"))


; ExpectsToSee KeyEvent -> ExpectsToSee
; Searches for the pattern of keystrokes.
; Added by me: pressing enter in the DD state restarts the search
(define (search-pattern ets ke)
  (cond
    [(equal? ets AA)
     (if (key=? ke "a") BB ER)]
    [(equal? ets BB)
     (cond
       [(or (key=? ke "b") (key=? ke "c")) BB]
       [(key=? ke "d") DD]
       [else ER])]
    [(equal? ets DD)
     (if (key=? ke "\r") AA DD)]
    [else ets]))

(check-expect (search-pattern AA "a") BB)
(check-expect (search-pattern AA "b") ER)
(check-expect (search-pattern AA "z") ER)
(check-expect (search-pattern BB "b") BB)
(check-expect (search-pattern BB "c") BB)
(check-expect (search-pattern BB "a") ER)
(check-expect (search-pattern BB "y") ER)
(check-expect (search-pattern DD "x") DD)
(check-expect (search-pattern DD "\r") AA)
(check-expect (search-pattern ER "c") ER)
(check-expect (search-pattern ER "a") ER)


; ExpectsToSee -> ExpectsToSee
; Program that receives the keyboard input and checks if it matches the
; required pattern, showing coloured rectangles to indicate its status.
; Use (pattern-prog AA) and press enter to restart after a successful search.
(define (pattern-prog init)
  (big-bang init
    [to-draw render]
    [on-key search-pattern]))
