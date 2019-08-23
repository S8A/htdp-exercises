;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex166.b) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp")) #f)))
(define-struct employee [name number])
; An Employee is a structure:
;   (make-employee String Number)
; interpretation (make-employee na nu) is an employee
; named na with number nu
(define robby (make-employee "Robby" 5911))
(define matt (make-employee "Matthew" 5921))


(define-struct work [employee rate hours])
; A (piece of) Work is a structure: 
;   (make-work Employee Number Number)
; interpretation (make-work n r h) combines the employee 
; with the pay rate r and the number of hours h


; Low (short for list of works) is one of: 
; – '()
; – (cons Work Low)
; interpretation an instance of Low represents the 
; hours worked for a number of employees
(define low1 '())
(define low2 (cons (make-work robby 11.95 39) '()))
(define low3 (cons (make-work matt 12.95 45)
                   (cons (make-work robby 11.95 39) '())))


(define-struct paycheck [employee amount])
; A Paycheck is a structure:
;   (make-paycheck String Number)
; interpretation (make-paycheck n a) combines the name
; with the pay amount a


; Lop (short por list of paychecks) is one of:
; - '()
; - (cons Paycheck Lop)
; interpretation an instance of Lop represents the paychecks
; for a number of employees
(define lop1 '())
(define lop2 (cons (make-paycheck robby (* 11.95 39)) '()))
(define lop3 (cons (make-paycheck matt (* 12.95 45))
                   (cons (make-paycheck robby (* 11.95 39)) '())))


; Low -> Lop
; computes the weekly wages for the given records
(define (wage*.v4 an-low)
  (cond
    [(empty? an-low) '()]
    [(cons? an-low)
     (cons (wage.v4 (first an-low)) (wage*.v4 (rest an-low)))]))

(check-expect (wage*.v4 low1) lop1)
(check-expect (wage*.v4 low2) lop2)
(check-expect (wage*.v4 low3) lop3)


; Work -> Paycheck
; computes the wage for the given work record w as a paycheck
(define (wage.v4 w)
  (make-paycheck (work-employee w) (* (work-rate w) (work-hours w))))

(check-expect (wage.v4 (first low2)) (first lop2))
(check-expect (wage.v4 (first low3)) (first lop3))
