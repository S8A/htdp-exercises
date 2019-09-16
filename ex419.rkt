;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex419) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(define JANUS
  (list 31.0
        #i2e+34
        #i-1.2345678901235e+80
        2749.0
        -2939234.0
        #i-2e+33
        #i3.2e+270
        17.0
        #i-2.4e+270
        #i4.2344294738446e+170
        1.0
        #i-8e+269
        0.0
        99.0))


; [List-of Number] -> Number
; Sums the numbers in the given list
(define (sum l)
  (foldl + 0 l))


; Determine the values of these expressions:
; > (sum JANUS)
; #i99.0
; > (sum (reverse JANUS))
; #i-1.2345678901234999e+80
; > (sum (sort JANUS <))
; #i0.0

; Assuming sum adds the numbers in a list from left to right,
; explain what these expressions compute. What do you think of the results?
; A: The order in which the numbers are added changes which ones are discarded
; as too small in comparison to the next one. Specifically, in the sorted one
; the result is zero because at the end the sum is #i-3.2e+270 (the sum of the
; smallest two numbers) and #i3.2e+270, which is its opposite.


; Evaluate this expression and compare the result to the three sums above.
; > (exact->inexact (sum (map inexact->exact JANUS)))
; #i4.2344294738446e+170
; What do you think now about advice from the web?
; A: That when given the possibility of using real numbers the advice is not
; useful.
