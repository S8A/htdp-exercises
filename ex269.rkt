;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname ex269) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
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

(define irlist1 `(,ir1 ,ir2 ,ir3 ,ir4 ,ir5))
(define namelist1 (map ir-name irlist1))


; Functions :.

; [List-of IR] Number -> [List-of IR]
; Eliminates inventory records with sales price above ua.
(define (eliminate-expensive lir ua)
  (local (; IR -> Boolean
          (define (not-expensive? i) (<= (ir-sales-price i) ua)))
    (filter not-expensive? lir)))

(check-expect (eliminate-expensive '() 20.00) '())
(check-expect (eliminate-expensive irlist1 143.00) irlist1)
(check-expect (eliminate-expensive irlist1 20.00) `(,ir1 ,ir2 ,ir3))


; String [List-of IR] -> [List-of IR]
; Produces a list of inventory records that do not use the name ty
(define (recall ty lir)
  (local (; IR -> Boolean
          (define (not-ty? i) (not (string=? (ir-name i) ty))))
    (filter not-ty? lir)))

(check-expect (recall "Motorola e5" '()) '())
(check-expect (recall "Cup" irlist1) (rest irlist1))


; [List-of String] [List-of String] -> [List-of String]
; Selects all names from list2 that are also on list1.
(define (selection list1 list2)
  (local (; String -> Boolean
          (define (in-list1 item) (member? item list1)))
    (filter in-list1 list2)))

(check-expect (selection namelist1 namelist1) namelist1)
(check-expect (selection namelist1 (list "Keyboard"
                                         (second namelist1)
                                         (fourth namelist1)))
              (list (second namelist1) (fourth namelist1)))
(check-expect (selection (list (third namelist1) "Hat") namelist1)
              (list (third namelist1)))
(check-expect (selection (list "Something" "else") namelist1) '())
