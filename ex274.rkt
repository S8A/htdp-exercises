;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname ex274) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp")) #f)))
; Lo1S -> LLo1S
; produces all the prefixes of list l
(define (prefixes l)
  (local (; N -> Lo1S
          (define (remove-last n)
            (cond
              [(zero? n) l]
              [else (reverse (rest (reverse (remove-last (sub1 n)))))])))
    (reverse (build-list (length l) remove-last))))

(check-expect (prefixes '()) '())
(check-expect (prefixes (list "a")) (list (list "a")))
(check-expect (prefixes (list "a" "b"))
              (list (list "a") (list "a" "b")))
(check-expect (prefixes (list "a" "b" "c"))
              (list (list "a") (list "a" "b") (list "a" "b" "c")))


; Lo1S -> LLo1S
; produces a list of all the suffixes of list l
(define (suffixes l)
  (local (; N -> Lo1S
          (define (remove-first n)
            (cond
              [(zero? n) l]
              [else (rest (remove-first (sub1 n)))])))
    (reverse (build-list (length l) remove-first))))

(check-expect (suffixes '()) '())
(check-expect (suffixes (list "a")) (list (list "a")))
(check-expect (suffixes (list "a" "b"))
              (list (list "b") (list "a" "b")))
(check-expect (suffixes (list "a" "b" "c"))
              (list (list "c") (list "b" "c") (list "a" "b" "c")))
