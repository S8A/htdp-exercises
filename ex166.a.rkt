;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex166) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp")) #f)))
(define-struct work [employee rate hours])
; A (piece of) Work is a structure: 
;   (make-work String Number Number)
; interpretation (make-work n r h) combines the name 
; with the pay rate r and the number of hours h


; Low (short for list of works) is one of: 
; – '()
; – (cons Work Low)
; interpretation an instance of Low represents the 
; hours worked for a number of employees
(define low1 '())
(define low2 (cons (make-work "Robby" 11.95 39) '()))
(define low3 (cons (make-work "Matthew" 12.95 45)
                   (cons (make-work "Robby" 11.95 39) '())))


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
(define lop2 (cons (make-paycheck "Robby" (* 11.95 39)) '()))
(define lop3 (cons (make-paycheck "Matthew" (* 12.95 45))
                   (cons (make-paycheck "Robby" (* 11.95 39)) '())))


; Low -> Lop
; computes the weekly wages for the given records
(define (wage*.v3 an-low)
  (cond
    [(empty? an-low) '()]
    [(cons? an-low)
     (cons (wage.v3 (first an-low)) (wage*.v3 (rest an-low)))]))

(check-expect (wage*.v3 low1) lop1)
(check-expect (wage*.v3 low2) lop2)
(check-expect (wage*.v3 low3) lop3)


; Work -> Paycheck
; computes the wage for the given work record w as a paycheck
(define (wage.v3 w)
  (make-paycheck (work-employee w) (* (work-rate w) (work-hours w))))

(check-expect (wage.v3 (first low2)) (first lop2))
(check-expect (wage.v3 (first low3)) (first lop3))
