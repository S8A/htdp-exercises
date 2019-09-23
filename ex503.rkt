;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex503) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; Matrix -> Matrix 
; finds a row that doesn't start with 0 and
; uses it as the first one
; generative moves the first row to last place 
; no termination if all rows start with 0
(define (rotate M)
  (cond
    [(not (= (first (first M)) 0)) M]
    [else
     (rotate (append (rest M) (list (first M))))]))

(check-expect (rotate '((0 4 5) (1 2 3)))
              '((1 2 3) (0 4 5)))


; Matrix -> Matrix
; tries to find a row that doesn't start with 0 and use it as the first one
(define (rotate.v2 m0)
  (local (; Matrix [List-of Row] -> Matrix
          ; tries to find a row that doesn't start with 0 and use it as
          ; the first one, signaling an error if there are none
          ; generative if such a row is found, the previously checked rows
          ; are added to the end
          ; accumulator seen contains the rows that are in m0 but not in m,
          ; i.e. the ones that are known to start with 0
          (define (rot m seen)
            (cond
              [(empty? m)
               (error 'rotate "can't find row that doesn't start with 0")]
              [(not (= (first (first m)) 0)) (append m seen)]
              [else (rot (rest m) (cons (first m) seen))])))
    (rot m0 '())))

(check-expect (rotate.v2 '((0 4 5) (1 2 3))) '((1 2 3) (0 4 5)))
(check-error (rotate.v2 '((0 4 5) (0 9 8) (0 0 7))))


; N -> Matrix
; creates a matrix with n rows of three items, where each row starts
; with 0 except the last one
(define (create-test-matrix n)
  (build-list n (lambda (row)
                  (cons (if (= row (sub1 n)) (add1 (random 9)) 0)
                        (build-list 2 (lambda (i) (random 10)))))))

; ..:: Perfomance comparison : Sep. 23, 2019 ::..
(define matrix-list
  (build-list 5 (lambda (n) (create-test-matrix (* (add1 n) 1000)))))
(define rv1-test (map (lambda (matrix) (time (rotate matrix))) matrix-list))
;cpu time: 55 real time: 55 gc time: 40
;cpu time: 100 real time: 101 gc time: 44
;cpu time: 254 real time: 255 gc time: 127
;cpu time: 417 real time: 419 gc time: 209
;cpu time: 660 real time: 662 gc time: 327
(define rv2-test (map (lambda (matrix) (time (rotate.v2 matrix))) matrix-list))
;cpu time: 1 real time: 1 gc time: 0
;cpu time: 3 real time: 3 gc time: 0
;cpu time: 4 real time: 4 gc time: 0
;cpu time: 6 real time: 6 gc time: 0
;cpu time: 7 real time: 7 gc time: 0
