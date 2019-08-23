;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex170) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp")) #f)))
(define-struct phone [area switch four])
; A Phone is a structure: 
;   (make-phone Three Three Four)
; A Three is a Number between 100 and 999. 
; A Four is a Number between 1000 and 9999.

; A ListOfPhones is one of:
; - '()
; - (cons Phone '())


; ListOfPhones -> ListOfPhones
; Replaces all occurrences of area code 713 with 281 in the list of phones.
(define (replace list)
  (cond
    [(empty? list) '()]
    [(cons? list)
     (cons (replace-phone (first list)) (replace (rest list)))]))

(check-expect (replace '()) '())
(check-expect (replace (cons (make-phone 555 123 4567)
                             (cons (make-phone 713 182 7432)
                                   (cons (make-phone 262 333 2821)
                                         (cons (make-phone 713 596 1861)
                                               '())))))
              (cons (make-phone 555 123 4567)
                    (cons (make-phone 281 182 7432)
                          (cons (make-phone 262 333 2821)
                                (cons (make-phone 281 596 1861) '())))))


; Phone -> Phone
; Replaces area code 713 with 281 in the given phone number, if found.
(define (replace-phone p)
  (make-phone (if (= (phone-area p) 713)
                  281
                  (phone-area p))
              (phone-switch p)
              (phone-four p)))

(check-expect (replace-phone (make-phone 555 123 4567))
              (make-phone 555 123 4567))
(check-expect (replace-phone (make-phone 713 182 7432))
              (make-phone 281 182 7432))
