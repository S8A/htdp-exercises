;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex103) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp")) #f)))
(define-struct spider [remaining-legs transport-space])
; A Spider is a structure:
;   (make-spider Number Number)
; interpretation (make-spider n s) is a spider that has
; n remaining legs (at most 8) and requires a space of volume
; s m^3 to be transported
(define SPIDER1 (make-spider 8 0.03))


(define-struct elephant [transport-space])
; An Elephant is a structure:
;   (make-elephant Number)
; interpretation (make-elephant s) is an elephant that
; requires a space of volume s m^3 to be transported
(define ELEPHANT1 (make-elephant 64))


(define-struct boa [length girth])
; A Boa is a structure:
;   (make-boa Number Number)
; interpretation (make-boa l g) is a boa constrictor of
; length l metres and girth g metres
(define BOA1 (make-boa 3 0.25))


(define-struct armadillo [weight transport-space])
; An Armadillo is a structure:
;   (make-armadillo Number Number)
; interpretation (make-armadillo w s) is an armadillo that
; weighs w kilograms and requires a space of volume s m^3
; to be transported
(define ARMADILLO1 (make-armadillo 5 0.4))


; A ZooAnimal is one of the following
; - Spider
; - Elephant
; - Boa
; - Armadillo


(define-struct cage [width length height])
; A Cage is a structure:
;   (make-cage Number Number Number)
; interpretation (make-cage x y z) is a cage of width
; x metres, length y metres and height z metres
(define TINY-CAGE (make-cage 0.5 0.5 0.5))
(define SMALL-CAGE (make-cage 1 1 1))
(define MEDIUM-CAGE (make-cage 3 3 3))
(define BIG-CAGE (make-cage 6 6 6))
(define GIANT-CAGE (make-cage 9 9 12))


; Cage -> Number
; calculates the volume of the cage c
(define (volume-cage c)
  (* (cage-width c) (cage-length c) (cage-height c)))

(check-expect (volume-cage TINY-CAGE) (* 0.5 0.5 0.5))
(check-expect (volume-cage SMALL-CAGE) (* 1 1 1))
(check-expect (volume-cage MEDIUM-CAGE) (* 3 3 3))
(check-expect (volume-cage BIG-CAGE) (* 6 6 6))
(check-expect (volume-cage GIANT-CAGE) (* 9 9 12))


; ZooAnimal -> Boolean
; determines whether the cage's volume is large enough for the animal
(define (fits? a c)
  (>= (volume-cage c)
      (cond
        [(spider? a) (spider-transport-space a)]
        [(elephant? a) (elephant-transport-space a)]
        [(boa? a) (* (boa-length a) (boa-length a) (* (boa-girth a) 2))]
        [(armadillo? a) (armadillo-transport-space a)])))

(check-expect (fits? SPIDER1 TINY-CAGE) #true)
(check-expect (fits? ELEPHANT1 MEDIUM-CAGE) #false)
(check-expect (fits? ELEPHANT1 BIG-CAGE) #true)
(check-expect (fits? BOA1 SMALL-CAGE) #false)
(check-expect (fits? BOA1 MEDIUM-CAGE) #true)
(check-expect (fits? ARMADILLO1 SMALL-CAGE) #true)
