;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex070) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp")) #f)))
(define-struct phone [area number])
(define-struct centry [name home office cell])

(phone-area
 (centry-office
   (make-centry "Shriram Fisler"
                (make-phone 207 "363-2421")
                (make-phone 101 "776-1099")
                (make-phone 208 "112-9981"))))
;(phone-area (make-phone 101 "776-1099"))
;101

