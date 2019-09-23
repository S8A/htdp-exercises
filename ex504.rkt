;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex504) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; [List-of N] -> Number
; produces the number corresponding to the list of digits
(define (to10 digits)
  (local (; [List-of N] N -> N
          ; produces the number corresponding to the given list of digits
          ; accumulator pos is the position of the most significant digit in lod
          ; accumulator r is the number corresponding to the digits that are
          ; not in lod
          (define (to10/a lod pos r)
            (cond
              [(empty? lod) r]
              [(cons? lod)
               (to10/a (rest lod) (sub1 pos)
                       (+ (* (first lod) (expt 10 pos)) r))])))
    (to10/a digits (sub1 (length digits)) 0)))

(check-expect (to10 '(1 0 2)) 102)
