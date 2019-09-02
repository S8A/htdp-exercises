;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex293) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; X [List-of X] -> [Maybe [List-of X]]
; returns the first sublist of l that starts
; with x, #false otherwise
(define (find x l)
  (cond
    [(empty? l) #false]
    [else
     (if (equal? (first l) x) l (find x (rest l)))]))

(check-expect (find 3 '(5 6 1 8 3 2 0 52)) '(3 2 0 52))
(check-expect (find "a" (explode "extreme unexpected android man"))
              (explode "android man"))
(check-expect (find "z" (explode "a lot of normal words")) #false)
(check-satisfied (find 3 '(5 6 1 8 3 2 0 52))
                 (found? 3 '(5 6 1 8 3 2 0 52)))
(check-satisfied (find "a" (explode "extreme unexpected android man"))
                 (found? "a" (explode "extreme unexpected android man")))
(check-satisfied (find "z" (explode "a lot of normal words"))
                 (found? "z" (explode "a lot of normal words")))


; X [List-of X] -> [ [Maybe [List-of X]] -> Boolean ]
; is l0 a subset of l that starts with x, or #false
(define (found? x l)
  (lambda (l0)
    (cond
      [(false? l0) (not (member? x l))]
      [(cons? l0)
       (and (not (empty? l0))
            (equal? x (first l0))
            (sublist-of? l l0))])))

(check-expect ((found? 3 '(5 6 1 8 3 2 0 52)) '(3 2 0 52)) #true)
(check-expect ((found? 3 '(5 6 1 8 3 2 0 52)) '(3 2 52)) #false)
(check-expect ((found? 3 '(5 6 1 8 3 2 0 52)) '(8 3 2 0 52)) #false)
(check-expect ((found? 3 '(5 6 1 8 3 2 52)) '(3 2 0 52)) #false)
(check-expect ((found? 7 '(5 6 1 8 3 2 52)) #false) #true)


; [List-of X] [NEList-of X] -> Boolean
; is l0 a sublist of l
(define (sublist-of? l l0)
  (and (>= (length l) (length l0))
       (cond
         [(empty? (rest l0)) (equal? (first l) (first l0))]
         [(cons? (rest l0))
          (if (equal? (first l) (first l0))
              (sublist-of? (rest l) (rest l0))
              (sublist-of? (rest l) l0))])))

(check-expect (sublist-of? '(5 6 1 8 3 2 0 52) '(3 2 0 52)) #true)
(check-expect (sublist-of? '(5 6 1 8 3 2 0 52) '(8 3 2 0 52)) #true)
(check-expect (sublist-of? '(5 6 1 8 3 2 0 52) '(3 2 52)) #false)
(check-expect (sublist-of? '(5 6 1 8 3 2 52) '(3 2 0 52)) #false)
(check-expect (sublist-of? '(3 2 0 52) '(5 6 1 8 3 2 0 52)) #false)
