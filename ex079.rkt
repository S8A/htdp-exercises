;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex079) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp")) #f)))
; A Color is one of: 
; — "white"
; — "yellow"
; — "orange"
; — "green"
; — "red"
; — "blue"
; — "black"
(define BLUE "blue") ; Color blue


; H is a Number between 0 and 100.
; interpretation represents a happiness value
(define VERY-SAD 16) ; A low happiness value
(define NORMAL 50) ; A medium happiness value
(define VERY-HAPPY 84) ; A high happiness value


(define-struct person [fstname lstname male?])
; A Person is a structure:
;   (make-person String String Boolean)
(define S8A "Samuel" "Ochoa" #true) ; A male named Samuel Ochoa
(define CT "Charlize" "Theron" #false) ; A female named Charlize Theron

; Q: Is it a good idea to use a field name that looks
; like the name of a predicate?
; A: No.


(define-struct dog [owner name age happiness])
; A Dog is a structure:
;   (make-dog Person String PositiveInteger H)
; interpretation (make-dog o n a h) is a dog named n,
; owned by o, of age a, and currently has a happiness
; level of h
(define FIRU (make-dog "Bob" "Firulais" 5 VERY-HAPPY))


; A Weapon is one of: 
; — #false
; — Posn
; interpretation #false means the missile hasn't 
; been fired yet; a Posn means it is in flight
(define ICBM (posn 50 2000)) ; An ICBM flying at position (50, 2000)
(define NUKE #false) ; A nuclear bomb that hasn't been fired
