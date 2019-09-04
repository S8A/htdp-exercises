;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex308) (read-case-sensitive #t) (teachpacks ((lib "abstraction.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "abstraction.rkt" "teachpack" "2htdp")) #f)))
(define-struct phone [area switch four])


; [List-of Phone] -> [List-of Phone]
; Substitutes the area code 713 with 281 in the given list of phone records.
(define (replace lop)
  (for/list ([p lop])
    (match p
      [(phone 713 switch four) (make-phone 281 switch four)]
      [(phone area switch four) p])))

(check-expect (replace (list (make-phone 555 321 7164)
                             (make-phone 713 664 9993)
                             (make-phone 747 897 1234)))
              (list (make-phone 555 321 7164)
                    (make-phone 281 664 9993)
                    (make-phone 747 897 1234)))
