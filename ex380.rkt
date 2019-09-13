;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex380) (read-case-sensitive #t) (teachpacks ((lib "universe.rkt" "teachpack" "2htdp") (lib "image.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "universe.rkt" "teachpack" "2htdp") (lib "image.rkt" "teachpack" "2htdp")) #f)))
; An FSM is a [List-of 1Transition]
(define-struct transition [states key])
; A 1Transition is a structure:
;   (make-transition [List FSM-State FSM-State] KeyEvent)
; An FSM-State is a String that specifies a color
 
; data examples 
(define fsm-traffic
  (list (make-transition '("red" "green") "g")
        (make-transition '("green" "yellow") "y")
        (make-transition '("yellow" "red") "r")))


; FSM FSM-State -> FSM-State 
; matches the keys pressed by a player with the given FSM 
(define (simulate state0 transitions)
  (big-bang state0 ; FSM-State
    [to-draw
      (lambda (current)
        (overlay (text current 20 "black")
                 (square 100 "solid" current)))]
    [on-key
      (lambda (current key-event)
        (find (map transition-states
                   (filter (lambda (t) (key=? key-event (transition-key t)))
                           transitions))
              current))]))


; [X Y] [List-of [List X Y]] X -> Y
; finds the matching Y for the given X in alist
(define (find alist x)
  (local ((define fm (assoc x alist)))
    (if (cons? fm) (second fm) (error "not found"))))

(check-expect (find (map transition-states fsm-traffic) "yellow") "red")
(check-error (find (map transition-states fsm-traffic) "blue"))
(check-expect (find (map transition-states fsm-traffic) "red") "green")
(check-expect (find '(("a" 1) ("b" 2)) "b") 2)
