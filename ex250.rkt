;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname ex250) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp") (lib "web-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp") (lib "web-io.rkt" "teachpack" "2htdp")) #f)))
; Number [Number -> Number] -> [List-of Number]
; tabulates f between n and 0 (incl.) in a list
(define (tab n f)
  (cond
    [(= n 0) (list (f 0))]
    [else
     (cons (f n) (tab (sub1 n) f))]))


; Number -> [List-of Number]
; tabulates sin between n 
; and 0 (incl.) in a list
(define (tab-sin n)
  (tab n sin))

(check-within (tab-sin 0) (list (sin 0)) 0.00001)
(check-within (tab-sin 2) (list (sin 2) (sin 1) (sin 0)) 0.00001)

	
; Number -> [List-of Number]
; tabulates sqrt between n 
; and 0 (incl.) in a list
(define (tab-sqrt n)
  (tab n sqrt))

(check-within (tab-sqrt 0) (list (sqrt 0)) 0.00001)
(check-within (tab-sqrt 2) (list (sqrt 2) (sqrt 1) (sqrt 0)) 0.00001)