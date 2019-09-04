;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex307) (read-case-sensitive #t) (teachpacks ((lib "abstraction.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "abstraction.rkt" "teachpack" "2htdp")) #f)))
; String [List-of String] -> String
; Retrieves the first name from the list that is equal to
; or an extension of n
(define (find-name n l)
  (for/or ([name l]) (if (string-contains-ci? n name) name #false)))

(check-expect (find-name "Voldemort" '("Alice" "John" "Mary" "Robert"))
              #false)
(check-expect (find-name "Mary" '("Alice" "John" "Mary" "Robert"))
              "Mary")
(check-expect (find-name "Rob" '("Alice" "John" "Mary" "Robert"))
              "Robert")


; N [List-of String] -> Boolean
; Checks that no name on the list exceeds the given width
(define (all-under-width width l)
  (for/and ([name l]) (<= (string-length name) width)))

(check-expect (all-under-width 6 '("Alice" "John" "Mary" "Robert")) #true)
(check-expect (all-under-width 6 '("Alice" "Andrew" "Amber" "alexander"))
              #false)
