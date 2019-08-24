;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname ex190) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp")) #f)))
; Lo1S -> LLo1S
; produces all the prefixes of list l
(define (prefixes l)
  (cond
    [(empty? l) '()]
    [(cons? l)
     (cons (list (first l)) (prepend (first l) (prefixes (rest l))))]))

(check-expect (prefixes '()) '())
(check-expect (prefixes (list "a")) (list (list "a")))
(check-expect (prefixes (list "a" "b"))
              (list (list "a") (list "a" "b")))
(check-expect (prefixes (list "a" "b" "c"))
              (list (list "a") (list "a" "b") (list "a" "b" "c")))


; Lo1S -> LLo1S
; produces a list of all the suffixes of list l
(define (suffixes l)
  (deep-reverse (prefixes (reverse l))))

(check-expect (suffixes '()) '())
(check-expect (suffixes (list "a")) (list (list "a")))
(check-expect (suffixes (list "a" "b"))
              (list (list "b") (list "a" "b")))
(check-expect (suffixes (list "a" "b" "c"))
              (list (list "c") (list "b" "c") (list "a" "b" "c")))


; 1String LLo1S -> LLo1S
; adds x to the start of each list in ll
(define (prepend x ll)
  (cond
    [(empty? ll) '()]
    [(cons? ll)
     (cons (cons x (first ll)) (prepend x (rest ll)))]))

(check-expect (prepend "a" '()) '())
(check-expect (prepend "a" (list (list "b"))) (list (list "a" "b")))
(check-expect (prepend "a" (list (list "b") (list "b" "c")))
              (list (list "a" "b") (list "a" "b" "c")))


; LLo1S -> LLo1S
; reverses each list in the list of lists ll
(define (deep-reverse ll)
  (cond
    [(empty? ll) '()]
    [(cons? ll)
     (cons (reverse (first ll)) (deep-reverse (rest ll)))]))

(check-expect (deep-reverse '()) '())
(check-expect (deep-reverse (list (list "a"))) (list (list "a")))
(check-expect (deep-reverse (list (list "a") (list "a" "b") (list "a" "b" "c")))
              (list (list "a") (list "b" "a") (list "c" "b" "a")))

