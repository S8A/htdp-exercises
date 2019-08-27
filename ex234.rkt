;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname ex234) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp") (lib "itunes.rkt" "teachpack" "2htdp") (lib "web-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp") (lib "itunes.rkt" "teachpack" "2htdp") (lib "web-io.rkt" "teachpack" "2htdp")) #f)))
; A Ranking is a (list Number String)
; interpretation combines the name of a song and its ranking

; A ListOfRankings is one of:
; - '()
; - (list Ranking ListOfRankings


(define one-list
  '("Asia: Heat of the Moment"
    "U2: One"
    "The White Stripes: Seven Nation Army"))


; ListOfStrings -> ListOfRankings
; Creates a list of ranked songs from a list of song names.
(define (ranking los)
  (reverse (add-ranks (reverse los))))


; ListOfStrings -> ListOfRankings
; Generates a list of ranked songs from a list of song names ordered
; from the lowest ranked to the highest ranked (1).
(define (add-ranks los)
  (cond
    [(empty? los) '()]
    [else (cons (list (length los) (first los))
                (add-ranks (rest los)))]))


; String ListOfStrings -> ... nested list ...
; Creates an HTML table from the given list of songs to rank.
(define (make-ranking title los)
  `(html
    (head
     (title ,title))
    (body
     (table ((border "1"))
            ,@(make-rows (ranking los))))))


; ListOfRankings -> ... nested list ...
; Creates table rows from the given song ranking list.
(define (make-rows lor)
  (cond
    [(empty? lor) '()]
    [(cons? lor)
     (cons (make-row (first lor)) (make-rows (rest lor)))]))


; Ranking -> ... nested list ...
; Creates a table row for the given song ranking.
(define (make-row r)
  `(tr (td ,(number->string (first r)))
       (td ,(second r))))



