;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex286) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; Data definitions :.

(define-struct ir [name description acquisition-price sales-price])
; An Inventory Record (IR) is a structure:
;   (make-ir String String Number Number)


; Data examples :.

(define ir1 (make-ir "Cup" "Tea cup" 3.00 3.50))
(define ir2 (make-ir "JBL MDR-XB450" "Extrabass cabled headphones" 10.00 12.00))
(define ir3 (make-ir "JBL KD-20" "Bluetooth earphones" 10.00 12.00))
(define ir4 (make-ir "AirPods i9s" "Bluetooth wireless earphones" 20.00 25.00))
(define ir5 (make-ir "Motorola e5" "Smartphone" 142.00 143.00))


; Functions :.

; [List-of IR] -> [List-of IR]
; Sorts the list of inventory records by their price differences.
(define (sort-inventory lir)
  (sort lir (lambda (a b) (> (ir-price-diff a) (ir-price-diff b)))))

(check-expect (sort-inventory '()) '())
(check-expect (sort-inventory `(,ir1 ,ir2 ,ir3 ,ir4 ,ir5))
              `(,ir4 ,ir2 ,ir3 ,ir5 ,ir1))


; IR -> Number
; Calculates the difference between the recommended sales price and the
; acquisition price of an inventory record.
(define (ir-price-diff i)
  (- (ir-sales-price i) (ir-acquisition-price i)))

(check-expect (ir-price-diff ir1) 0.50)
(check-expect (ir-price-diff ir2) 2.00)
(check-expect (ir-price-diff ir3) 2.00)
(check-expect (ir-price-diff ir4) 5.00)
(check-expect (ir-price-diff ir5) 1.00)
