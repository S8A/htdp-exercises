;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex5) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp")) #f)))
; Proportionality constants
(define P 0.7) ; Portion of image occupied by leaves
(define d 0.05) ; Portion of image left blank / percent difference between leaves' radii
(define p (- 1 (+ P d))) ; Portion of image occupied by trunk
(define a 0.3) ; Trunk's width-to-height ratio

; Dimensions of the image
(define width 300)
(define center-width (/ width 2))
(define height 300)

; Smaller of the two dimensions
(define smaller-dimension
  (if (< height width) height width))

; Size of the tree's leaves
(define outer-radius (* (/ P 2) smaller-dimension))
(define inner-radius (* (- 1 d) outer-radius))

; Size of the tree's trunk
(define trunk-height (* p smaller-dimension))
(define trunk-width (* a trunk-height))

; Tree parts
(define (leaves points stroke-width)
  (overlay (radial-star points inner-radius outer-radius "outline" (make-pen "darkgreen" stroke-width "solid" "round" "round"))
           (radial-star points inner-radius outer-radius "solid" "forestgreen")))

(define (trunk stroke-width)
  (overlay (rectangle trunk-width trunk-height "outline" (make-pen "darkbrown" stroke-width "solid" "projecting" "miter"))
           (rectangle trunk-width trunk-height "solid" "brown")))

(define background
  (overlay (rectangle width height "solid" "blue")
           (empty-scene width height)))

; Tree parts' position
(define trunk-center-to-top (- height (/ trunk-height 2)))
(define leaves-to-top (- height (+ trunk-height inner-radius)))

; Draw tree image
(define (draw-tree points stroke-width)
  (place-image (leaves points stroke-width) 
               center-width
               leaves-to-top
               (place-image (trunk stroke-width)
                            center-width
                            trunk-center-to-top
                            background)))