;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex454) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; N [List-of Number] -> [List-of [List-of Number]]
; produces an nxn matrix from the given list of numbers
(define (create-matrix n lon)
  (local (; [List-of Number] -> [List-of [List-of Number]]
          (define (create-matrix-helper alon)
            (cond
              [(empty? alon) '()]
              [else
               (cons (take alon n) (create-matrix-helper (drop alon n)))])))
    (if (= (length lon) (sqr n))
        (create-matrix-helper lon)
        (error 'create-matrix "list of wrong size"))))

(check-expect (create-matrix 2 '(1 2 3 4))
              '((1 2) (3 4)))
(check-expect (create-matrix 3 (build-list 9 (lambda (n) (sqr n))))
              '((0 1 4) (9 16 25) (36 49 64)))
(check-error (create-matrix 3 '(1 2 3 4)))


; [List-of X] N -> [List-of X]
; keeps the first n items from l if possible or everything
(define (take l n)
  (cond
    [(zero? n) '()]
    [(empty? l) '()]
    [else (cons (first l) (take (rest l) (sub1 n)))]))
 
; [List-of X] N -> [List-of X]
; removes the first n items from l if possible or everything
(define (drop l n)
  (cond
    [(zero? n) l]
    [(empty? l) l]
    [else (drop (rest l) (sub1 n))]))
