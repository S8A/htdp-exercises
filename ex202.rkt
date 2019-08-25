;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname ex202) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp") (lib "itunes.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp") (lib "itunes.rkt" "teachpack" "2htdp")) #f)))
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


; LTracks -> List-of-strings
; produces the list of all album titles from the given list of tracks
(define (select-all-album-titles lt)
  (cond
    [(empty? lt) '()]
    [(cons? lt)
     (cons (track-album (first lt)) (select-all-album-titles (rest lt)))]))

(check-expect (select-all-album-titles lt0) '())
(check-expect (select-all-album-titles lt1) (list "Antichrist Superstar"))
(check-expect (select-all-album-titles lt2) (list "Antichrist Superstar"
                                                  "Antichrist Superstar"))
(check-expect (select-all-album-titles lt3) (list "Antichrist Superstar"
                                                  "Antichrist Superstar"
                                                  "Leviathan"))


; List-of-strings -> List-of-strings
; creates a copy of the list without repetitions
(define (create-set los)
  (cond
    [(empty? los) '()]
    [(cons? los)
     (if (member? (first los) (create-set (rest los)))
         (create-set (rest los))
         (cons (first los) (create-set (rest los))))]))

(check-expect (create-set (list "a" "b" "c")) (list "a" "b" "c"))
(check-expect (create-set (list "a" "b" "c" "b" "a")) (list "c" "b" "a"))


; LTracks -> List-of-strings
; produces the list of album titles from the given list of tracks,
; without repeated elements
(define (select-album-titles/unique lt)
  (create-set (select-all-album-titles lt)))

(check-expect (select-album-titles/unique lt0) '())
(check-expect (select-album-titles/unique lt1) (list "Antichrist Superstar"))
(check-expect (select-album-titles/unique lt2) (list "Antichrist Superstar"))
(check-expect (select-album-titles/unique lt3) (list "Antichrist Superstar"
                                                     "Leviathan"))


; String LTracks -> LTracks
; extracts the tracks from the list that belong to the given album
(define (select-album album lt)
  (cond
    [(empty? lt) '()]
    [(cons? lt)
     (if (belongs-to-album album (first lt))
         (cons (first lt) (select-album album (rest lt)))
         (select-album album (rest lt)))]))

(check-expect (select-album "Antichrist Superstar" lt0) '())
(check-expect (select-album "Leviathan" lt1) '())
(check-expect (select-album "Antichrist Superstar" lt2) lt2)
(check-expect (select-album "Leviathan" lt3) (list bat))


; String Track -> Boolean
; does the given track belong to the given album
(define (belongs-to-album album t)
  (string=? album (track-album t)))

(check-expect (belongs-to-album "Leviathan" tbp) #false)
(check-expect (belongs-to-album "Leviathan" bat) #true)
