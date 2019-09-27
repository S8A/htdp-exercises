;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex526) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp")) #f)))
(define CENTER (make-posn 200 200))
(define RADIUS 200) ; the radius in pixels 
 
; Number -> Posn
; determines the point on the circle with CENTER 
; and RADIUS whose angle is (* factor 360) degrees
(define (circle-pt factor)
  (local ((define angle-degrees (* factor 360))
          (define angle-radians (* (/ angle-degrees 180) pi))
          (define x-from-center (* RADIUS (cos angle-radians)))
          (define y-from-center (* RADIUS (sin angle-radians)))
          (define x-img (+ (posn-x CENTER) x-from-center))
          (define y-img (- (posn-y CENTER) y-from-center)))
    (make-posn x-img y-img)))

(check-within (circle-pt 120/360) (make-posn 100.001 26.795) 0.001)
(check-within (circle-pt 240/360) (make-posn 100 373.205) 0.001)
(check-within (circle-pt 360/360) (make-posn 400 200) 0.001)
