;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname ex189) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp")) #f)))
; Number List-of-numbers -> Boolean
; determines whether n occurs in a list of numbers
(define (search n alon)
  (cond
    [(empty? alon) #false]
    [else (or (= (first alon) n)
              (search n (rest alon)))]))

(check-expect (search 5 '()) #false)
(check-expect (search 10 (list 5 14 10 4 3)) #true)
(check-expect (search 3 (list 4 5 7 2 6)) #false)


; Number List-of-numbers -> Boolean
; determines whether n occurs in a sorted list of numbers
(define (search-sorted n sln)
  (cond
    [(empty? sln) #false]
    [else
     (cond
       [(= n (first sln)) #true]
       [(> n (first sln)) #false]
       [else (search n (rest sln))])]))

(check-expect (search-sorted 3 '()) #false)
(check-expect (search-sorted 10 (list 14 10 5 4 3)) #true)
(check-expect (search-sorted 5 (list 7 6 4 3 2)) #false)
