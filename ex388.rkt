;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex388) (read-case-sensitive #t) (teachpacks ((lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "batch-io.rkt" "teachpack" "2htdp")) #f)))
; .: Data definitions :.

(define-struct employee [name ssn wage])
; An Employee is a structure:
;   (make-employee String Number Number)
; interpretation (make-employee n s w) combines:
; - n: the employee's name
; - s: the employee's social security number
; - w: the employee's hourly pay rate

(define-struct wr [name hours])
; A Work Record (WR) is a structure:
;   (make-wr String Number)
; interpretation (make-wr n h) combines:
; - n: the employee's name
; - h: the number of hours worked by said employee in a week


; .: Data examples :.
(define e0 (make-employee "Samuel" 1111 20.00))
(define e1 (make-employee "Alice" 7043 15.00))
(define e2 (make-employee "Mark" 8210 12.00))
(define e3 (make-employee "Jane" 1285 14.00))

(define wr0 (make-wr "Samuel" 54))
(define wr1 (make-wr "Alice" 40))
(define wr2 (make-wr "Mark" 46))
(define wr3 (make-wr "Jane" 35))


; [List-of Employee] [List-of WR] -> [List-of [List String Number]]
; Computes the weekly wage of each employee according to their pay rates
; and hours worked. Assumes that the list of employees and the list of
; work records have the same length and are in the same order.
(define (wages* employees records)
  (local (; Employee WR -> [List String Number]
          (define (weekly-wage-struct e r)
            (list (employee-name e)
                  (weekly-wage (employee-wage e) (wr-hours r)))))
    (cond
      [(empty? employees) '()]
      [(cons? employees)
       (cons (weekly-wage-struct (first employees) (first records))
             (wages* (rest employees) (rest records)))])))

(check-expect (wages* '() '()) '())
(check-expect (wages* `(,e0 ,e1 ,e2 ,e3) `(,wr0 ,wr1 ,wr2 ,wr3))
              `(("Samuel" ,(* 20.00 54))
                ("Alice" ,(* 15.00 40))
                ("Mark" ,(* 12.00 46))
                ("Jane" ,(* 14.00 35))))


; Number Number -> Number
; Computes the weekly wage from pay-rate and hours
(define (weekly-wage pay-rate hours)
  (* pay-rate hours))
