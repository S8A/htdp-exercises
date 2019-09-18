;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex451) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(define-struct table [length array])
; A Table is a structure:
;   (make-table N [N -> Number])

(define table1 (make-table 3 (lambda (i) i)))
(define table2
  (make-table 1
              (lambda (i)
                (if (= i 0)
                    pi
                    (error "table2 is not defined for i =!= 0")))))
(define table3 (make-table 8 (lambda (x) (- x 3))))


; Table N -> Number
; looks up the ith value in array of t
(define (table-ref t i)
  ((table-array t) i))


(define epsilon 0.000000001)

; Table -> N
; finds the smallest index for a root of the table t
; assumes that the table is monotonically increasing
(define (find-linear t)
  (local ((define len (table-length t))
          (define (find-linear-helper i)
            (cond
              [(= i len) (error 'find-linear "no root found")]
              [else
               (if (<= (abs (table-ref t i)) epsilon)
                   i
                   (find-linear-helper (add1 i)))])))
    (find-linear-helper 0)))

(check-expect (find-linear table1) 0)
(check-error (find-linear table2))
(check-expect (find-linear table3) 3)


; Table -> N
; finds the smallest index for a root of the table t
; assumes that the table is monotonically increasing
; assume (<= (table-ref t left) 0 (table-ref t right))
; generative roughly divides the table in half, the root is in one of
; the halves
; termination at some point the interval will be reduced to
; a length of 1, at which point the result is one of the
; interval's boundaries
(define (find-binary t)
  (local ((define len (table-length t))
          (define (find-binary-helper left right fleft fright)
            (cond
              [(= (- right left) 1)
               (if (<= (abs fleft) (abs fright)) left right)]
              [else
               (local ((define mid (quotient (+ left right) 2))
                       (define fmid (table-ref t mid)))
                 (cond
                   [(<= fleft 0 fmid)
                    (find-binary-helper left mid fleft fmid)]
                   [(<= fmid 0 fright)
                    (find-binary-helper mid right fmid fright)]))])))
    (find-binary-helper 0 (sub1 len)
                        (table-ref t 0) (table-ref t (sub1 len)))))

(check-within (find-binary table3) 3 epsilon)
