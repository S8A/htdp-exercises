;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex157) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp")) #f)))
; Determine whether changing a single constant definition achieves
; the desired outcome:

; - change the height of the canvas to 220 pixels;
; Yes, change the HEIGHT constant.

; - change the width of the canvas to 30 pixels;
; Yes, change the WIDTH constant.

; - change the x location of the line of shots to
; “somewhere to the left of the middle”;
; Yes, change the XSHOTS constant.

; - change the background to a green rectangle; and
; Yes, change the BACKGROUND constant.

; - change the rendering of shots to a red elongated rectangle.
; Yes, change the SHOT constant.


; Also check whether it is possible to double the size of the shot
; without changing anything else or to change its color to black.

; Yes, change the SHOT constant.
