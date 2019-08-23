;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex165) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp")) #f)))
; ListOfStrings -> ListOfStrings
; Replaces all ocurrences of "robot" with "r2d2" in the given
; list of toy descriptions.
(define (subst-robot list)
  (cond
    [(empty? list) '()]
    [(cons? list)
     (cons (if (string=? (first list) "robot")
               "r2d2"
               (first list))
           (subst-robot (rest list)))]))

(check-expect (subst-robot '()) '())
(check-expect (subst-robot (cons "car" (cons "robot" (cons "doll" '()))))
              (cons "car" (cons "r2d2" (cons "doll" '()))))


; ListOfStrings -> ListOfStrings
; Replaces all ocurrences of old with new in the given
; list of strings.
(define (substitute old new list)
  (cond
    [(empty? list) '()]
    [(cons? list)
     (cons (if (string=? (first list) old)
               new
               (first list))
           (substitute old new (rest list)))]))

(check-expect (substitute "pig" "pug" '()) '())
(check-expect (substitute "car" "gun"
                          (cons "car" (cons "robot" (cons "doll" '()))))
              (cons "gun" (cons "robot" (cons "doll" '()))))
