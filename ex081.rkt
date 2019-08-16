;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex081) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp")) #f)))
; An Hour is a Number between 0 and 23, inclusive.
; interpretation one of the 24 divisions of the day, each equivalent 
; to a time interval of 60 minutes

; A Minute is a Number between 0 and 59, inclusive.
; intepretation one of the 60 divisions of an hour, each equivalent
; to a time interval of 60 seconds

; A Second is a Number between 0 and 59, inclusive.
; interpretation one of the 60 divisions of a minute; the formal,
; precise definition of the duration of a second is established 
; in the International System of Units.


(define-struct time [hours minutes seconds])
; A Time is a structure:
;   (make-time Hour Minute Second)
; interpretation (make-time h m s) represents a point in time
; h hours, m minutes and s seconds after midnight.


; Minute -> Second
; converts m minutes to seconds
(define (minutes->seconds m) (* 60 m))

(check-expect (minutes->seconds 3) 180)


; Hour -> Minute
; converts h hours to minutes
(define (hours->minutes h) (* 60 h))

(check-expect (hours->minutes 0.5) 30)

; Hour -> Second
; converts h hours to seconds
(define (hours->seconds h) (minutes->seconds (hours->minutes h)))

(check-expect (hours->seconds 2) 7200)


; Time -> Second
; converts time structures to their equivalent in seconds
(define (time->seconds t)
  (+ (hours->seconds (time-hours t))
     (minutes->seconds (time-minutes t))
     (time-seconds t)))

(check-expect (time->seconds (make-time 12 30 2)) 45002)
