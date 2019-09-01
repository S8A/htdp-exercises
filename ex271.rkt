;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname ex271) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; String [List-of String] -> Boolean
; Determines whether any of the names in the list are equal to n or
; an extension of it.
(define (find-name n los)
  (local (; String -> Boolean
          (define (is-or-contains-name? s) (string-contains-ci? n s)))
    (ormap is-or-contains-name? los)))
    

(check-expect (find-name "Voldemort" '("Alice" "John" "Mary" "Robert"))
              #false)
(check-expect (find-name "Mary" '("Alice" "John" "Mary" "Robert"))
              #true)
(check-expect (find-name "Rob" '("Alice" "John" "Mary" "Robert"))
              #true)


; 1String [List-of String] -> Boolean
; Checks if all names in the lsit start with the given letter
(define (all-start-with letter los)
  (local (; String -> Boolean
          (define (starts-with-letter s) (string-ci=? letter (string-ith s 0))))
    (andmap starts-with-letter los)))

(check-expect (all-start-with "a" '("Alice" "John" "Mary" "Robert")) #false)
(check-expect (all-start-with "a" '("Alice" "Andrew" "Amber" "alexander")) #t)


; Q: Should you use ormap or andmap to define a function that ensures
; that no name on some list exceeds a given width?
; A: It can be implemented either using admap and a negative predicate
; (i.e. checks that the given item doesn't exceed the limit) or with
; a not wrapping an ormap with a positive predicate. This is because of
; Boole's laws: not A and not B == not (A or B)
; See the following two functions:


; N [List-of String] -> Boolean
; Checks that no name on the list exceeds the given width
(define (all-under-width width los)
  (local (; String -> Boolean
          (define (under-width? s) (<= (string-length s) width)))
    (andmap under-width? los)))

(check-expect (all-under-width 6 '("Alice" "John" "Mary" "Robert")) #true)
(check-expect (all-under-width 6 '("Alice" "Andrew" "Amber" "alexander")) #f)


; N [List-of String] -> Boolean
; Checks that no name on the list exceeds the given width
(define (none-over-width width los)
  (local (; String -> Boolean
          (define (over-width? s) (> (string-length s) width)))
    (not (ormap over-width? los))))

(check-expect (none-over-width 6 '("Alice" "John" "Mary" "Robert")) #true)
(check-expect (none-over-width 6 '("Alice" "Andrew" "Amber" "alexander")) #f)
