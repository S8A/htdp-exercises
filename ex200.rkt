;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname ex200) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp") (lib "itunes.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp") (lib "itunes.rkt" "teachpack" "2htdp")) #f)))
;(define-struct date [year month day hour minute second])
; A Date is a structure:
;   (make-date N N N N N N)
; interpretation An instance records six pieces of information:
; the date's year, month (between 1 and 12 inclusive), 
; day (between 1 and 31), hour (between 0 
; and 23), minute (between 0 and 59), and 
; second (also between 0 and 59).
(define date1 (create-date 2019 08 23 20 10 05))
(define date2 (create-date 2019 08 23 21 07 03))
(define date3 (create-date 2019 08 24 20 10 05))


;(define-struct track [name artist album time track# added play# played])
; A Track is a structure:
;   (make-track String String String N N Date N Date)
; interpretation An instance records in order: the track's 
; title, its producing artist, to which album it belongs, 
; its playing time in milliseconds, its position within the 
; album, the date it was added, how often it has been 
; played, and the date when it was last played
(define tbp (create-track "The Beautiful People"
                          "Marilyn Manson"
                          "Antichrist Superstar"
                          219000
                          2
                          date1
                          1
                          date1))
(define trg (create-track "The Reflecting God"
                          "Marilyn Manson"
                          "Antichrist Superstar"
                          337000
                          15
                          date1
                          2
                          date2))
(define bat (create-track "Blood and Thunder"
                          "Mastodon"
                          "Leviathan"
                          228000
                          1
                          date2
                          4
                          date3))


; An LTracks is one of:
; – '()
; – (cons Track LTracks)
(define lt0 '())
(define lt1 (list tbp))
(define lt2 (list tbp trg))
(define lt3 (list tbp trg bat))


; LTracks -> Number
; produces the total amount of play time for the given list of tracks
(define (total-time lt)
  (cond
    [(empty? lt) 0]
    [(cons? lt)
     (+ (track-time (first lt)) (total-time (rest lt)))]))

(check-expect (total-time lt0) 0)
(check-expect (total-time lt1) 219000)
(check-expect (total-time lt2) (+ 219000 337000))
(check-expect (total-time lt3) (+ 219000 337000 228000))
