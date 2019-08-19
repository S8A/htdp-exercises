;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex113) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp")) #f)))
; A UFO is a Posn. 
; interpretation (make-posn x y) is the UFO's location 
; (using the top-down, left-to-right convention)
 
(define-struct tank [loc vel])
; A Tank is a structure:
;   (make-tank Number Number). 
; interpretation (make-tank x dx) specifies the position:
; (x, HEIGHT) and the tank's speed: dx pixels/tick 
 
; A Missile is a Posn. 
; interpretation (make-posn x y) is the missile's place

(define-struct aim [ufo tank])
(define-struct fired [ufo tank missile])
; A SIGS is one of: 
; – (make-aim UFO Tank)
; – (make-fired UFO Tank Missile)
; interpretation represents the complete state of a 
; space invader game


; Any -> Boolean
; is a an element of the SIGS collection
(define (sigs? a)
  (or (aim? a) (fired? a)))



; A Coordinate is one of: 
; – a NegativeNumber 
; interpretation on the y axis, distance from top
; – a PositiveNumber 
; interpretation on the x axis, distance from left
; – a Posn
; interpretation an ordinary Cartesian point


; Any -> Boolean
; is a an element of the Coordinate collection
(define (coordinate? a)
  (or (number? a) (posn? a)))



(define LEFT "left")
(define RIGHT "right")
; A Direction is one of the following:
; - LEFT
; - RIGHT
; interpretation the direction in which the pet is walking

(define RED "red")
(define GREEN "green")
(define BLUE "blue")
; A ChameleonColor is one of the following:
; - RED
; - GREEN
; - BLUE

; A Happiness is a Number
; interpretation the "level of happiness" measured by the gauge,
; The level of happiness is in the range [0,100]

(define-struct vcat [x happiness direction])
; A VCat is a structure:
;   (make-vcat Number Happiness)
; interpretation (make-vcat x h d) is a virtual pet cat
; whose horizontal position is x pixels from the left margin
; and whose happiness level is h in a scale from 0 to 100 inclusive,
; and which is moving in the direction specified by d

(define-struct vcham [x happiness direction color])
; A VCham is a structure:
;   (make-vcham Number Happiness Direction ChameleonColor)
; interpretation (make-vcham x h d c) is a virtual pet chameleon
; whose horizontal position is x pixels from the left margin
; whose happiness level is h in a scale from 0 to 100 inclusive,
; which is moving in the direction specified by d and whose color is c

; A VAnimal is either
; – a VCat
; – a VCham


; Any -> Boolean
; is a an element of the VAnimal collection
(define (vanimal? a)
  (or (vcat? a) (vcham? a)))
