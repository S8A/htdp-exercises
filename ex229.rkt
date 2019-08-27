;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname ex229) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp") (lib "itunes.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp") (lib "itunes.rkt" "teachpack" "2htdp")) #f)))
; Data definitions :.

(define-struct ktransition [current key next])
(define-struct fs [fsm current])


; An FSM is one of:
;   – '()
;   – (cons Transition.v2 FSM)
(define fsm-traffic
  (list (make-ktransition "red" " " "green")
        (make-ktransition "green" " " "yellow")
        (make-ktransition "yellow" " " "red")))
(define fsm-bw
  (list (make-ktransition "black" " " "white")
        (make-ktransition "white" " " "black")))
(define fsm-ex109
  (list (make-ktransition "white" "a" "yellow")
        (make-ktransition "yellow" "b" "yellow")
        (make-ktransition "yellow" "c" "yellow")
        (make-ktransition "yellow" "d" "green")
        (make-ktransition "green" "\r" "white")))


; A Transition.v2 is a structure:
;   (make-ktransition FSM-State KeyEvent FSM-State)


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
           (find (fs-fsm an-fsm) (fs-current an-fsm) ke)))
(check-expect (find-next-state (make-fs fsm-traffic "red") " ")
              (make-fs fsm-traffic "green"))
(check-expect (find-next-state (make-fs fsm-traffic "green") " ")
              (make-fs fsm-traffic "yellow"))
(check-expect (find-next-state (make-fs fsm-traffic "yellow") " ")
              (make-fs fsm-traffic "red"))
(check-expect (find-next-state (make-fs fsm-ex109 "white") "a")
              (make-fs fsm-ex109 "yellow"))
(check-expect (find-next-state (make-fs fsm-ex109 "yellow") "b")
              (make-fs fsm-ex109 "yellow"))
(check-expect (find-next-state (make-fs fsm-ex109 "yellow") "c")
              (make-fs fsm-ex109 "yellow"))
(check-expect (find-next-state (make-fs fsm-ex109 "yellow") "d")
              (make-fs fsm-ex109 "green"))
(check-expect (find-next-state (make-fs fsm-ex109 "green") "\r")
              (make-fs fsm-ex109 "white"))
(check-error (find-next-state (make-fs fsm-ex109 "white") "c"))
(check-error (find-next-state (make-fs fsm-ex109 "yellow") "z"))
(check-error (find-next-state (make-fs fsm-ex109 "green") "x"))



; Auxiliary functions

; FSM FSM-State KeyEvent -> FSM-State or #false
; finds the state representing current in transitions and retrieves the
; next field if the correct key is pressed.
(define (find transitions current ke)
  (cond
    [(empty? transitions)
     (error "not found: " current " " ke)]
    [(cons? transitions)
     (if (and (state=? current (ktransition-current (first transitions)))
              (key=? ke (ktransition-key (first transitions))))
         (ktransition-next (first transitions))
         (find (rest transitions) current ke))]))

(check-expect (find fsm-traffic "red" " ") "green")
(check-expect (find fsm-traffic "green" " ") "yellow")
(check-error (find fsm-traffic "red" "g"))
(check-error (find fsm-traffic "green" "f"))


; FSM-State FSM-State -> Boolean
; Equality predicate for states.
(define (state=? s1 s2)
  (equal? s1 s2))

(check-expect (state=? "red" "green") #false)
(check-expect (state=? "yellow" "green") #false)
(check-expect (state=? "yellow" "yellow") #true)
(check-expect (state=? "red" "red") #true)
(check-expect (state=? "green" "green") #true)
