;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex478) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; Q: You can also place the first queen in all squares of the top-most row,
; the right-most column, and the bottom-most row. Explain why all of these
; solutions are just like the three scenarios depicted in figure 173.
; A: Because they are just rotations of the configurations of the figure.
; - Placing the first queen on the left square of the top-most row produces
; the first configuration.
; - Placing the first queen on the middle square of the top-most row leaves
; two options for the second one: the left or right squares of the bottom-most
; row. The first option is just the first configuration rotated 90 degrees
; counter-clockwise, while the second option is just the second configuration
; rotated 90 degrees clockwise.
; - Placing the first queen on the right square of the top-most row produces
; the second configuration.
; - Placing the first queen on the top square of the right-most column also
; produces the second configuration.
; - Placing the first queen on the middle square of the right-most column
; produces the first configuration.
; - Placing the first queen on the bottom square of the right-most column
; leaves two options for the second one: the middle square of the top-most
; row or the middle square of the left-most colum. The first option is just
; the second configuration rotated 90 degrees counter-clockwise, while the
; second option is just the first configuration rotated 180 degrees in
; either direction.
; - Placing the first queen on the left square of the bottom-most row
; produces the third configuration.
; - Placing the first queen on the middle square of the bottom-most row
; leaves two options for the second one: the left or right squares of the
; top-most row. The first option is just the third configuration rotated
; 90 degrees clockwise, while the second option is just the first
; configuration rotated 90 degrees clockwise.
; - Placing the first queen on the right square of the bottom-most row
; leaves two options for the second one: the middle square of the top-most
; row or the middle square of the left-most colum. The first option is just
; the second configuration rotated 90 degrees counter-clockwise, while the
; second option is just the first configuration rotated 180 degrees in
; either direction.

; Q: This leaves the central square. Is it possible to place even a second
; queen after you place one on the central square of a 3 by 3 board?
; A: No, because it would threaten all squares.
