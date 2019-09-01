;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname ex276) (read-case-sensitive #t) (teachpacks ((lib "batch-io.rkt" "teachpack" "2htdp") (lib "itunes.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "batch-io.rkt" "teachpack" "2htdp") (lib "itunes.rkt" "teachpack" "2htdp")) #f)))
; Data examples :.

(define date1 (create-date 2019 08 23 20 10 05))
(define date2 (create-date 2019 08 23 21 07 03))
(define date3 (create-date 2019 08 24 20 10 05))

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
(define lt0 '())
(define lt1 (list tbp))
(define lt2 (list tbp trg))
(define lt3 (list tbp trg bat))



; Functions :.

; [List-of Track] -> Number
; produces the total amount of play time for the given list of tracks
(define (total-time lt)
  (foldr + 0 (map track-time lt)))

(check-expect (total-time lt0) 0)
(check-expect (total-time lt1) 219000)
(check-expect (total-time lt2) (+ 219000 337000))
(check-expect (total-time lt3) (+ 219000 337000 228000))


; [List-of Track] -> [List-of String]
; produces the list of all album titles from the given list of tracks
(define (select-all-album-titles lt)
  (map track-album lt))

(check-expect (select-all-album-titles lt0) '())
(check-expect (select-all-album-titles lt1) (list "Antichrist Superstar"))
(check-expect (select-all-album-titles lt2) (list "Antichrist Superstar"
                                                  "Antichrist Superstar"))
(check-expect (select-all-album-titles lt3) (list "Antichrist Superstar"
                                                  "Antichrist Superstar"
                                                  "Leviathan"))


; [List-of Track] -> [List-of String]
; produces the list of album titles from the given list of tracks,
; without repeated elements
(define (select-album-titles/unique lt)
  (create-set (select-all-album-titles lt)))

(check-expect (select-album-titles/unique lt0) '())
(check-expect (select-album-titles/unique lt1) (list "Antichrist Superstar"))
(check-expect (select-album-titles/unique lt2) (list "Antichrist Superstar"))
(check-expect (select-album-titles/unique lt3) (list "Antichrist Superstar"
                                                     "Leviathan"))


; String [List-of Track] -> [List-of Track]
; extracts the tracks from the list that belong to the given album
(define (select-album album lt)
  (local (; Track -> Boolean
          (define (keep? t) (belongs-to-album? album t)))
    (filter keep? lt)))

(check-expect (select-album "Antichrist Superstar" lt0) '())
(check-expect (select-album "Leviathan" lt1) '())
(check-expect (select-album "Antichrist Superstar" lt2) lt2)
(check-expect (select-album "Leviathan" lt3) (list bat))


; String Date [List-of Track] -> [List-of Track]
; extracts from the given list the tracks that belong to the given album
; and have been played after the given date
(define (select-album-date alb d lt)
  (local (; Track -> Boolean
          (define (keep? t)
            (and (belongs-to-album? alb t) (played-after? d t))))
    (filter keep? lt)))

(check-expect (select-album-date "Antichrist Superstar" date1 lt0) '())
(check-expect (select-album-date "Leviathan" date2 lt1) '())
(check-expect (select-album-date "Antichrist Superstar" date1 lt2) (list trg))
(check-expect (select-album-date "Leviathan" date2 lt3) (list bat))


; [List-of Track] -> [List-of [List-of Track]]
; groups the tracks of the list into lists by album
(define (select-albums lt)
  (local (; String -> [List-of Track]
          (define (list-tracks album) (select-album album lt)))
    (map list-tracks (select-album-titles/unique lt))))

(check-expect (select-albums lt0) '())
(check-expect (select-albums lt1) (list (list tbp)))
(check-expect (select-albums lt2) (list (list tbp trg)))
(check-expect (select-albums lt3) (list (list tbp trg) (list bat)))



; Auxiliary functions

; String Track -> Boolean
; does the given track belong to the given album
(define (belongs-to-album? album t)
  (string=? album (track-album t)))

(check-expect (belongs-to-album? "Leviathan" tbp) #false)
(check-expect (belongs-to-album? "Leviathan" bat) #true)


; Date Track -> Boolean
; was the track played after the given date
(define (played-after? d t)
  (date>? (track-played t) d))

(check-expect (played-after? date2 tbp) #false)
(check-expect (played-after? date2 trg) #false)


; Date Date -> Boolean
; does date A occur after date B
(define (date>? d1 d2) ; see date_gt_table.ods for the truth table
  (or (> (date-year d1) (date-year d2))
      (and (= (date-year d1) (date-year d2))
           (or (> (date-month d1) (date-month d2))
               (and (= (date-month d1) (date-month d2))
                    (or (> (date-day d1) (date-day d2))
                        (and (= (date-day d1) (date-day d2))
                             (or (> (date-hour d1) (date-hour d2))
                                 (and (= (date-hour d1) (date-hour d2))
                                      (or (> (date-minute d1) (date-minute d2))
                                          (and (= (date-minute d1)
                                                  (date-minute d2))
                                               (> (date-second d1)
                                                  (date-second d2)))))))))))))

(check-expect (date>? date1 date2) #false)
(check-expect (date>? date2 date2) #false)
(check-expect (date>? date3 date2) #true)


; [X] [List-of X] -> [List-of X]
; creates a copy of the list without repetitions
(define (create-set l)
  (cond
    [(empty? l) '()]
    [(cons? l)
     (if (member? (first l) (rest l))
         (create-set (rest l))
         (cons (first l) (create-set (rest l))))]))

(check-expect (create-set '(1 2 4 5 7 5 6 4)) '(1 2 7 5 6 4))
(check-expect (create-set (list "a" "b" "c")) (list "a" "b" "c"))
(check-expect (create-set (list "a" "b" "c" "b" "a")) (list "c" "b" "a"))
