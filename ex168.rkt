;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex168) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp")) #f)))
; ListOfPosns -> ListOfPosns
; translates a list of posns by moving each one 1 unit along
; the y direction.
(define (translate list)
  (cond
    [(empty? list) '()]
    [(cons? list)
     (cons (translate-posn (first list)) (translate (rest list)))]))

(check-expect (translate '()) '())
(check-expect (translate (cons (make-posn 128 2) (cons (make-posn 3 7.4) '())))
              (cons (make-posn 128 3) (cons (make-posn 3 8.4) '())))


; Posn -> Posn
; translates a posn by moving it 1 unit along the y direction.
(define (translate-posn p)
  (make-posn (posn-x p) (+ (posn-y p) 1)))

(check-expect (translate-posn (make-posn 317 182)) (make-posn 317 183))
