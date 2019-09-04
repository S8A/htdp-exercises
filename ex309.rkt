;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex309) (read-case-sensitive #t) (teachpacks ((lib "abstraction.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "abstraction.rkt" "teachpack" "2htdp")) #f)))
; [List-of [List-of String]] -> [List-of N]
; Determines the number of Strings per item in a list of list of strings.
(define (words-on-line lls)
  (for/list ([ls lls])
    (match ls
      [(? empty?) 0]
      [(cons fst rst) (+ 1 (length rst))])))

(check-expect (words-on-line '(("once" "upon" "a" "time" "in" "Hollywood")
                               ("there" "was" "an" "actor")
                               ()
                               ("his" "name" "was" "Nicholas" "Cage")))
              '(6 4 0 5))
