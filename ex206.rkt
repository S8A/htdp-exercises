;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname ex206) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp") (lib "itunes.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp") (lib "itunes.rkt" "teachpack" "2htdp")) #f)))
; A BSDN is one of: 
; – Boolean
; – Number
; – String
; – Date
(define tbp "The Beautiful People")
(define trg "The Reflecting God")
(define bat "Blood and Thunder")
(define mm15 "Marilyn Manson")
(define mtdn "Mastodon")
(define tbp-t 219000)
(define trg-t 337000)
(define bat-t 228000)
(define acss "Antichrist Superstar")
(define lvtn "Leviathan")
(define date1 (create-date 2019 08 23 20 10 05))
(define date2 (create-date 2019 08 23 21 07 03))
(define date3 (create-date 2019 08 24 20 10 05))


; An Association is a list of two items: 
;   (cons String (cons BSDN '()))

 
; An LAssoc is one of: 
; – '()
; – (cons Association LAssoc)
(define la0 '())
(define la1 (list (list "name" tbp)
                  (list "artist" mm15)
                  (list "album" acss)
                  (list "time" tbp-t)
                  (list "track#" 2)
                  (list "added" date1)
                  (list "play#" 1)
                  (list "played" date1)))
(define la2 (list (list "name" trg)
                  (list "artist" mm15)
                  (list "album" acss)
                  (list "time" trg-t)
                  (list "track#" 15)
                  (list "added" date1)
                  (list "play#" 2)
                  (list "played" date2)))
(define la3 (list (list "name" bat)
                  (list "artist" mtdn)
                  (list "album" lvtn)
                  (list "time" bat-t)
                  (list "track#" 1)
                  (list "added" date2)
                  (list "play#" 4)
                  (list "played" date3)))


; An LLists is one of:
; – '()
; – (cons LAssoc LLists)
(define ll0 '())
(define ll1 (list la1))
(define ll2 (list la1 la2))
(define ll3 (list la1 la2 la3))


; String LAssoc Any -> Association or Any
; finds the first association in the list whose first item is equal to key,
; or default if none is found
(define (find-association key la default)
  (cond
    [(empty? la) default]
    [(cons? la)
     (if (string=? key (first (first la)))
         (first la)
         (find-association key (rest la) default))]))

(check-expect (find-association "name" la0 "error") "error")
(check-expect (find-association "artist" la1 "not found") (list "artist" mm15))
(check-expect (find-association "album" la3 #false) (list "album" lvtn))
