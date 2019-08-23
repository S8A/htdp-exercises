;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex169) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp")) #f)))
; ListOfPosns -> ListOfPosns
; Creates copy of a given list of posns that includes only those
; whose x-coordinates are between 0 and 100 and whose y-coordinates
; are between 0 and 200.
(define (legal list)
  (cond
    [(empty? list) '()]
    [(cons? list)
     (if (posn-legal? (first list))
         (cons (first list) (legal (rest list)))
         (legal (rest list)))]))

(check-expect (legal '()) '())
(check-expect (legal (cons (make-posn 7.4 3)
                           (cons (make-posn 128 2)
                                 (cons (make-posn 17 182)
                                       (cons (make-posn 10.7 27) '())))))
              (cons (make-posn 7.4 3)
                    (cons (make-posn 17 182)
                          (cons (make-posn 10.7 27) '()))))


; Posn -> Boolean
; Checks if the given posn has its x-coordinate between 0 and 100 and
; its y-coordinate between 0 and 200.
(define (posn-legal? p)
  (and (<= 0 (posn-x p) 100) (<= 0 (posn-y p) 200)))

(check-expect (posn-legal? (make-posn 7.4 3)) #true)
(check-expect (posn-legal? (make-posn 128 2)) #false)
(check-expect (posn-legal? (make-posn 17 182)) #true)
(check-expect (posn-legal? (make-posn 10.7 27)) #true)
