;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname ex230) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp") (lib "itunes.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp") (lib "itunes.rkt" "teachpack" "2htdp")) #f)))
; Data definitions :.

(define-struct fsm [initial transitions final])
(define-struct transition [current key next])
; An FSM.v2 is a structure: 
;   (make-fsm FSM-State LOT FSM-State)
; A LOT is one of: 
; – '() 
; – (cons Transition.v3 LOT)
; A Transition.v3 is a structure: 
;   (make-transition FSM-State KeyEvent FSM-State)
; An FSM-State is a Color.

(define fsm-traffic
  (make-fsm "red"
            (list (make-transition "red" " " "green")
                  (make-transition "green" " " "yellow")
                  (make-transition "yellow" " " "red"))
            "yellow"))
(define fsm-ex109
  (make-fsm "white"
            (list (make-transition "white" "a" "yellow")
                  (make-transition "yellow" "b" "yellow")
                  (make-transition "yellow" "c" "yellow")
                  (make-transition "yellow" "d" "green"))
            "green"))


; Main ::..
; FSM.v2 -> FSM.v2
; match the keys pressed with the given FSM 
(define (fsm-simulate fsm0)
  (big-bang fsm0
    [to-draw state-as-colored-square]
    [on-key find-next-state]
    [stop-when reached-final-state? state-as-colored-square]))



; Functions

; FSM.v2 -> Image 
; renders current world state as a colored square 
(define (state-as-colored-square fsm)
  (square 100 "solid" (fsm-initial fsm)))

(check-expect (state-as-colored-square fsm-traffic)
              (square 100 "solid" "red"))

 
; FSM.v2 KeyEvent -> SimulationState.v2
; finds the next state from ke and cs
(define (find-next-state fsm ke)
  (make-fsm (find (fsm-transitions fsm) (fsm-initial fsm) ke)
            (fsm-transitions fsm)
            (fsm-final fsm)))

(check-expect (find-next-state
                (make-fsm "red" (fsm-transitions fsm-traffic) "green")
                " ")
              (make-fsm "green" (fsm-transitions fsm-traffic) "green"))
(check-expect (find-next-state
                (make-fsm "green" (fsm-transitions fsm-traffic) "green")
                " ")
              (make-fsm "yellow" (fsm-transitions fsm-traffic) "green"))
(check-expect (find-next-state
                (make-fsm "yellow" (fsm-transitions fsm-traffic) "green")
                " ")
              (make-fsm "red" (fsm-transitions fsm-traffic) "green"))
(check-expect (find-next-state
                (make-fsm "white" (fsm-transitions fsm-ex109) "green")
                "a")
              (make-fsm "yellow" (fsm-transitions fsm-ex109) "green"))
(check-expect (find-next-state
                (make-fsm "yellow" (fsm-transitions fsm-ex109) "green")
                "b")
              (make-fsm "yellow" (fsm-transitions fsm-ex109) "green"))
(check-expect (find-next-state
                (make-fsm "yellow" (fsm-transitions fsm-ex109) "green")
                "c")
              (make-fsm "yellow" (fsm-transitions fsm-ex109) "green"))
(check-expect (find-next-state
                (make-fsm "yellow" (fsm-transitions fsm-ex109) "green")
                "d")
              (make-fsm "green" (fsm-transitions fsm-ex109) "green"))
(check-error (find-next-state
                (make-fsm "white" (fsm-transitions fsm-ex109) "green")
                "c"))
(check-error (find-next-state
                (make-fsm "yellow" (fsm-transitions fsm-ex109) "green")
                "z"))
(check-error (find-next-state
                (make-fsm "green" (fsm-transitions fsm-ex109) "green")
                "x"))


; FSM.v2 -> Boolean
; Ends the simulation if the final state is reached.
(define (reached-final-state? fsm)
  (state=? (fsm-initial fsm) (fsm-final fsm)))

(check-expect (reached-final-state?
                (make-fsm "red" (fsm-transitions fsm-traffic) "yellow"))
              #false)
(check-expect (reached-final-state?
                (make-fsm "green" (fsm-transitions fsm-traffic) "yellow"))
              #false)
(check-expect (reached-final-state?
                (make-fsm "yellow" (fsm-transitions fsm-traffic) "yellow"))
              #true)
(check-expect (reached-final-state?
                (make-fsm "white" (fsm-transitions fsm-ex109) "green"))
              #false)
(check-expect (reached-final-state?
                (make-fsm "yellow" (fsm-transitions fsm-ex109) "green"))
              #false)
(check-expect (reached-final-state?
                (make-fsm "green" (fsm-transitions fsm-ex109) "green"))
              #true)



; Auxiliary functions

; LOT FSM-State KeyEvent -> FSM-State or #false
; finds the state representing current in transitions and retrieves the
; next field if the correct key is pressed.
(define (find transitions current ke)
  (cond
    [(empty? transitions)
     (error "not found: " current " " ke)]
    [(cons? transitions)
     (if (and (state=? current (transition-current (first transitions)))
              (key=? ke (transition-key (first transitions))))
         (transition-next (first transitions))
         (find (rest transitions) current ke))]))

(check-expect (find (fsm-transitions fsm-traffic) "red" " ") "green")
(check-expect (find (fsm-transitions fsm-traffic) "green" " ") "yellow")
(check-error (find (fsm-transitions fsm-traffic) "red" "g"))
(check-error (find (fsm-transitions fsm-traffic) "green" "f"))


; FSM-State FSM-State -> Boolean
; Equality predicate for states.
(define (state=? s1 s2)
  (equal? s1 s2))

(check-expect (state=? "red" "green") #false)
(check-expect (state=? "yellow" "green") #false)
(check-expect (state=? "yellow" "yellow") #true)
(check-expect (state=? "red" "red") #true)
(check-expect (state=? "green" "green") #true)
