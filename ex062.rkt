;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex062) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp")) #f)))
(define LOCKED "locked")
(define CLOSED "closed")
(define OPEN "open")

; A DoorState is one of:
; – LOCKED
; – CLOSED
; – OPEN


; DoorState -> DoorState
; closes the door after a tick, if it's open
(define (door-closer ds)
  (cond
    [(equal? ds LOCKED) LOCKED]
    [(equal? ds CLOSED) CLOSED]
    [(equal? ds OPEN) CLOSED]))

(check-expect (door-closer LOCKED) LOCKED)
(check-expect (door-closer CLOSED) CLOSED)
(check-expect (door-closer OPEN) CLOSED)


; DoorState KeyEvent -> DoorState
; acts on the door in response to a key press
; "u" for unlocking it, "l" for locking it, " " for pushing it open
(define (door-action ds ke)
  (cond
    [(and (equal? ds LOCKED) (key=? ke "u")) CLOSED]
    [(and (equal? ds CLOSED) (key=? ke "l")) LOCKED]
    [(and (equal? ds CLOSED) (key=? ke " ")) OPEN]
    [else ds]))

(check-expect (door-action LOCKED "u") CLOSED)
(check-expect (door-action CLOSED "l") LOCKED)
(check-expect (door-action CLOSED " ") OPEN)
(check-expect (door-action OPEN "a") OPEN)
(check-expect (door-action CLOSED "a") CLOSED)


; DoorState -> Image
; draws the current state of the door
(define (door-render ds) (text ds 40 "red"))

(check-expect (door-render CLOSED)
              (text CLOSED 40 "red"))


; DoorState -> DoorState
; simulates a door with an automatic door closer
(define (door-simulation initial-state)
  (big-bang initial-state
    [on-tick door-closer 3]
    [on-key door-action]
    [to-draw door-render]))
