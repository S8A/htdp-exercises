;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex104) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp")) #f)))
(define-struct vehicle [passenger-capacity license-plate fuel-consumption])
; A Vehicle is a structure:
;   (make-vehicle Number String Number)
; interpretation (make-vehicle n p c) is a vehicle that
; can carry n passengers, has a license plate number p,
; and has a fuel consumption of c miles/gallon


; Vehicle -> String
; describes the vehicle in a one-line string
(define (describe-vehicle v)
  (... (vehicle-passenger-capacity v) ...
       (vehicle-license-plate v) ...
       (vehicle-fuel-consumption v) ...))
