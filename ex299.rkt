;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex299) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp")) #f)))
; A Set is a function
;   [Number -> Boolean]
; interpretation if s is a set and n a number,
; (s p) produces #true if n belongs to s, or
; #false otherwise


; Number Set -> Boolean
(define (belongs? n s)
  (s n))


; [Number -> Boolean] -> Set
; Creates an infinite set defined by predicate p
(define (mk-infinite-set p)
  (lambda (n) (p n)))

(check-expect (belongs? 16384 (mk-infinite-set odd?)) #false)
(check-expect (belongs? 16384 (mk-infinite-set even?)) #true)
(check-expect (belongs? 65001 (mk-infinite-set odd?)) #true)
(check-expect (belongs? 65001 (mk-infinite-set even?)) #false)
(check-expect (belongs? 2048
                        (mk-infinite-set (lambda (x) (= (remainder x 10) 0))))
              #false)
(check-expect (belongs? 2040
                        (mk-infinite-set (lambda (x) (= (remainder x 10) 0))))
              #true)


; [List-of Number] -> Set
; Creates a finite set with the elements in l
(define (mk-finite-set l)
  (mk-infinite-set (lambda (x) (member? x l))))

(check-expect (belongs? 3 (mk-finite-set '(0 1 2 3 4 5))) #true)
(check-expect (belongs? 7 (mk-finite-set '(0 1 2 3 4 5))) #false)


; Number Set -> Set
; Adds element e to set s
(define (add-element e s)
  (lambda (n) (or (belongs? n s) (= n e))))

(check-expect (belongs? 7 (add-element 7 (mk-finite-set '(0 1 2 3 4 5)))) #true)
(check-expect (belongs? 384 (add-element 384 (mk-infinite-set odd?))) #true)
(check-expect (belongs? 501 (add-element 501 (mk-infinite-set even?))) #true)
(check-expect (belongs? 4 (add-element 7 (mk-finite-set '(0 1 2 3 5)))) #false)
(check-expect (belongs? 484 (add-element 384 (mk-infinite-set odd?))) #false)
(check-expect (belongs? 601 (add-element 501 (mk-infinite-set even?))) #false)


; Set Set -> Set
; Combines the elements of set1 and set2
(define (union set1 set2)
  (lambda (n) (or (belongs? n set1) (belongs? n set2))))

(check-expect (belongs? 7 (union (mk-finite-set '(0 1 2 3 4 5))
                                 (mk-finite-set '(6 7 8 9))))
              #true)
(check-expect (belongs? 5 (union (mk-infinite-set even?)
                                 (mk-finite-set '(3 5 7 9))))
              #true)
(check-expect (belongs? 10 (union (mk-finite-set '(0 1 2 3 4 5))
                                 (mk-finite-set '(6 7 8 9))))
              #false)
(check-expect (belongs? 1 (union (mk-infinite-set even?)
                                 (mk-finite-set '(3 5 7 9))))
              #false)


; Set Set -> Set
; Collects the elements that are both in set1 and set2
(define (intersect set1 set2)
  (lambda (n) (and (belongs? n set1) (belongs? n set2))))

(check-expect (belongs? 4 (intersect (mk-finite-set '(0 1 2 3 4 5))
                                     (mk-finite-set '(4 5 6 7 8 9))))
              #true)
(check-expect (belongs? 5 (intersect (mk-infinite-set odd?)
                                     (mk-finite-set '(1 2 3 5 7))))
              #true)
(check-expect (belongs? 7 (intersect (mk-finite-set '(0 1 2 3 4 5))
                                     (mk-finite-set '(4 5 6 7 8 9))))
              #false)
(check-expect (belongs? 1 (intersect (mk-infinite-set even?)
                                     (mk-finite-set '(1 2 3 5 7))))
              #false)
