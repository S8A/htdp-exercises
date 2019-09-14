;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex389) (read-case-sensitive #t) (teachpacks ((lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "batch-io.rkt" "teachpack" "2htdp")) #f)))
(define-struct phone-record [name number])
; A PhoneRecord is a structure:
;   (make-phone-record String String)

; [List-of String] [List-of String] -> [List-of PhoneRecord]
; Combines two equally long lists, of names and phone numbers respectively.
; Assumes that the corresponding list items belong to the same person.
(define (zip names phones)
  (cond
    [(empty? names) '()]
    [(cons? names)
     (cons (make-phone-record (first names) (first phones))
           (zip (rest names) (rest phones)))]))

(check-expect (zip '() '()) '())
(check-expect (zip '("Amber" "Bob" "Carol" "Dave")
                   '("04141623701" "04167623782" "04122276523" "04143284334"))
              (list (make-phone-record "Amber" "04141623701")
                    (make-phone-record "Bob" "04167623782")
                    (make-phone-record "Carol" "04122276523")
                    (make-phone-record "Dave" "04143284334")))
