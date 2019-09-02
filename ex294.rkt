;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex294) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; X [List-of X] -> [Maybe N]
; determine the index of the first occurrence
; of x in l, #false otherwise
(define (index x l)
  (cond
    [(empty? l) #false]
    [else (if (equal? (first l) x)
              0
              (local ((define i (index x (rest l))))
                (if (boolean? i) i (+ i 1))))]))

(check-expect (index 3 '(5 6 1 8 3 2 0 3 52)) 4)
(check-expect (index "a" (explode "extreme unexpected android man")) 19)
(check-expect (index "z" (explode "a lot of normal words")) #false)


; X [List-of X] -> [ [Maybe N] -> Boolean ]
; is i a valid index of l, and the first one that's equal to x
(define (is-index? x l)
  (lambda (i)
    (local ((define first-x-suffix (memv x l))
            (define first-x-index
              (if (false? first-x-suffix)
                  -1
                  (- (length l) (length first-x-suffix)))))
      (cond
        [(false? i) (false? first-x-suffix)]
        [(number? i)
         (and (< i (length l))
              (equal? x (list-ref l i))
              (= i first-x-index))]))))

(check-expect ((is-index? 3 '(5 6 1 8 3 2 0 3 52)) 4) #true)
(check-expect ((is-index? 3 '(5 6 1 8 3 2 0 3 52)) 7) #false)
(check-expect ((is-index? 3 '(5 6 1 8 3 2 0 3 52)) 5) #false)
(check-expect ((is-index? 3 '(5 6 1 8 2 0 52)) #false) #true)
