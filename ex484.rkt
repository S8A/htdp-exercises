;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex484) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; [NEList-of Number] -> Number
; gets the smallest item from the given list of numbers
(define (infL l)
  (cond
    [(empty? (rest l)) (first l)]
    [else (local ((define s (infL (rest l))))
            (if (< (first l) s) (first l) s))]))


; Q: Argue that infL uses on the "order of n steps" in the best
; and worst case.
; A: The best case is having the smallest item at the beginning of the
; list, while the worst case is having it at the end of the list.
; No matter the order of the elements, we always need n-1 recursive steps for
; a list of n items:
; Only case, n = 1: 0 (recursive) steps
; (infL '(1)) is just 1
; Best case, n = 2: 1 step
; (infL '(0 1)) requires one evaluation of (infL '(1))
; Worst case, n = 2: 1 step
; (infL '(1 0)) requires one evaluation of (infL '(0))
; Best case, n = 3: 2 steps
; (infL '(0 1 2)) requires one evaluation of (infL '(1 2))
; (infL '(1 2)) requires one evaluation of (infL '(2))
; Worst case, n = 3: 2 steps
; (infL '(2 1 0)) requires one evaluation of (infL '(1 0))
; (infL '(1 0)) requires one evaluation of (infL '(0))
; Best case, n = 6: 5 steps
; (infL '(5 4 3 2 1 0)) requires one evaluation of (infL '(4 3 2 1 0))
; (infL '(4 3 2 1 0)) requires one evaluation of (infL '(3 2 1 0))
; (infL '(3 2 1 0)) requires one evaluation of (infL '(2 1 0))
; (infL '(2 1 0)) requires one evaluation of (infL '(1 0))
; (infL '(1 0)) requires one evaluation of (infL '(0))


; .: Hand evaluation :.
;(infL '(3 2 1 0))
;(local ((define s (infL '(2 1 0))))
;  (if (< 3 s) 3 s))
;(local ((define s
;          (local ((define s (infL '(1 0))))
;            (if (< 2 s) 2 s))))
;  (if (< 3 s) 3 s))
;(local ((define s
;          (local ((define s
;                    (local ((define s (infL '(0))))
;                      (if (< 1 s) 1 s))))
;            (if (< 2 s) 2 s))))
;  (if (< 3 s) 3 s))
;(local ((define s
;          (local ((define s
;                    (local ((define s 0))
;                      (if (< 1 s) 1 s))))
;            (if (< 2 s) 2 s))))
;  (if (< 3 s) 3 s))
;(local ((define s
;          (local ((define s 0))
;            (if (< 2 s) 2 s))))
;  (if (< 3 s) 3 s))
;(local ((define s 0))
;  (if (< 3 s) 3 s))
;0
