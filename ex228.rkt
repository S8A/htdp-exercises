;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname ex228) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp") (lib "itunes.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp") (lib "itunes.rkt" "teachpack" "2htdp")) #f)))
; Data definitions :.

(define-struct transition [current next])
(define-struct fs [fsm current])


; An FSM is one of:
;   – '()
;   – (cons Transition FSM)
(define fsm-traffic
  (list (make-transition "red" "green")
        (make-transition "green" "yellow")
        (make-transition "yellow" "red")))
(define fsm-bw
  (list (make-transition "black" "white")
        (make-transition "white" "black")))


; A Transition is a structure:
;   (make-transition FSM-State FSM-State)


; FSM-State is a Color.


; interpretation An FSM represents the transitions that a
; finite state machine can take from one state to another 
; in reaction to keystrokes


; A SimulationState.v2 is a structure: 
;   (make-fs FSM FSM-State)



; FSM FSM-State -> SimulationState.v2 
; match the keys pressed with the given FSM 
(define (simulate.v2 an-fsm s0)
  (big-bang (make-fs an-fsm s0)
    [to-draw state-as-colored-square]
    [on-key find-next-state]))



; Functions

; SimulationState.v2 -> Image 
; renders current world state as a colored square 
(define (state-as-colored-square an-fsm)
  (square 100 "solid" (fs-current an-fsm)))

(check-expect (state-as-colored-square (make-fs fsm-traffic "red"))
              (square 100 "solid" "red"))

 
; SimulationState.v2 KeyEvent -> SimulationState.v2
; finds the next state from ke and cs
(define (find-next-state an-fsm ke)
  (make-fs (fs-fsm an-fsm)
           (find (fs-fsm an-fsm) (fs-current an-fsm))))

(check-expect
  (find-next-state (make-fs fsm-traffic "red") "n")
  (make-fs fsm-traffic "green"))
(check-expect
  (find-next-state (make-fs fsm-traffic "red") "a")
  (make-fs fsm-traffic "green"))
(check-expect
  (find-next-state (make-fs fsm-traffic "green") "q")
  (make-fs fsm-traffic "yellow"))
(check-expect
  (find-next-state (make-fs fsm-traffic "yellow") "i")
  (make-fs fsm-traffic "red"))



; Auxiliary functions

; FSM FSM-State -> FSM-State
; finds the state representing current in transitions
; and retrieves the next field 
(define (find transitions current)
  (cond
    [(empty? transitions) (error (string-append "not found: " current))]
    [(cons? transitions)
     (if (state=? current (transition-current (first transitions)))
         (transition-next (first transitions))
         (find (rest transitions) current))]))

(check-expect (find fsm-traffic "red") "green")
(check-expect (find fsm-traffic "green") "yellow")
(check-error (find fsm-traffic "black")
             "not found: black")


; FSM-State FSM-State -> Boolean
; Equality predicate for states.
(define (state=? s1 s2)
  (equal? s1 s2))

(check-expect (state=? "red" "green") #false)
(check-expect (state=? "yellow" "green") #false)
(check-expect (state=? "yellow" "yellow") #true)
(check-expect (state=? "red" "red") #true)
(check-expect (state=? "green" "green") #true)
