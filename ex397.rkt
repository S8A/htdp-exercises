;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex397) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; .: Data definitions :.

(define-struct tc [id hours])
; A Time Card (TC) is a structure: (make-tc Number Number)
; interpretation records an employee ID number and the amount
; of hours the employee worked in a week.

(define-struct employee [name id pay])
; An Employee is a structure: (make-employee String Number Number)
; interpretation records an employee's ID number, name and hourly
; pay rate

(define-struct wr [name wage])
; A Wage Record (WR) is a structure: (make-wr String Number)
; interpretation records an employee's name and the amount they earned
; in a week


; .: Data examples :.

(define e0 (make-employee "Samuel" 1111 20.00))
(define e1 (make-employee "Alice" 7043 15.00))
(define e2 (make-employee "Mark" 8210 12.00))
(define e3 (make-employee "Jane" 1285 14.00))

(define tc0 (make-tc 1111 54))
(define tc1 (make-tc 7043 40))
(define tc2 (make-tc 8210 46))
(define tc3 (make-tc 1285 35))


; .: Functions :.

; [List-of Employee] [List-of TC] -> [List-of WR]
; Produces a list of wage records according to the pay rate and hours
; worked of each employee.
; Assumption There is at most one time card per employee number.
(define (wages*.v3 employees timecards)
  (cond
    [(and (empty? employees) (empty? timecards)) '()]
    [(and (empty? employees) (cons? timecards))
     (error 'wages*.v3 "employee not found")]
    [(and (cons? employees) (empty? timecards))
     (error 'wages*.v3 "employee not found")]
    [(and (cons? employees) (cons? timecards))
     (local ((define current-employee (first employees))
             (define employee-tc
               (find-timecard (employee-id current-employee) timecards)))
       (if (cons? employee-tc)
           (cons (create-wr current-employee (first employee-tc))
                 (wages*.v3 (rest employees)
                            (remove (first employee-tc) timecards)))
           (wages*.v3 (append (rest employees) (list current-employee))
                      timecards)))]))

(check-expect (wages*.v3 '() '()) '())
(check-error (wages*.v3 '() `(,tc0 ,tc1 ,tc2 ,tc3)))
(check-error (wages*.v3 `(,e0 ,e1 ,e2 ,e3) '()))
(check-expect (wages*.v3 `(,e0 ,e1 ,e2 ,e3) `(,tc0 ,tc1 ,tc2 ,tc3))
              (list (make-wr "Samuel" (* 20.00 54))
                    (make-wr "Alice" (* 15.00 40))
                    (make-wr "Mark" (* 12.00 46))
                    (make-wr "Jane" (* 14.00 35))))


; Number Number -> Number
; Computes the weekly wage from pay-rate and hours
(define (weekly-wage pay-rate hours)
  (* pay-rate hours))


; Employee TC -> WR
(define (create-wr emp timecard)
  (make-wr (employee-name emp)
           (weekly-wage (employee-pay emp) (tc-hours timecard))))


; Number [List-of TC] -> [List-of TC]
(define (find-timecard id timecards)
  (filter (lambda (timecard) (= (tc-id timecard) id)) timecards))
