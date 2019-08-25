;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname ex208) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp") (lib "itunes.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp") (lib "itunes.rkt" "teachpack" "2htdp")) #f)))
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
                  (list "played" date1)
                  (list "vulgar" #true)
                  (list "bad" #false)
                  (list "catchy" #true)))
(define la2 (list (list "name" trg)
                  (list "artist" mm15)
                  (list "album" acss)
                  (list "time" trg-t)
                  (list "track#" 15)
                  (list "added" date1)
                  (list "play#" 2)
                  (list "played" date2)
                  (list "deep" #true)
                  (list "vulgar" #true)
                  (list "bad" #false)))
(define la3 (list (list "name" bat)
                  (list "artist" mtdn)
                  (list "album" lvtn)
                  (list "time" bat-t)
                  (list "track#" 1)
                  (list "added" date2)
                  (list "play#" 4)
                  (list "played" date3)
                  (list "heavy" #true)))


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


; LLists -> Number
; produces the total amount of play time from a list of tracks
(define (total-time/list ll)
  (cond
    [(empty? ll) 0]
    [(cons? ll)
     (+ (second (find-association "time" (first ll) (list "not found" 0)))
        (total-time/list (rest ll)))]))

(check-expect (total-time/list ll0) 0)
(check-expect (total-time/list ll1) tbp-t)
(check-expect (total-time/list ll2) (+ tbp-t trg-t))
(check-expect (total-time/list ll3) (+ tbp-t trg-t bat-t))


; LLists -> List-of-strings
; produces the strings that are associated with a boolean attribute
; on any track of the list
(define (boolean-attributes ll)
  (cond
    [(empty? ll) '()]
    [(cons? ll)
     (create-set (prepend (boolean-attributes-track (first ll))
                          (boolean-attributes (rest ll))))]))

(check-expect (boolean-attributes ll0) '())
(check-expect (boolean-attributes ll1) (list "vulgar" "bad" "catchy"))
(check-expect (boolean-attributes ll2) (list "catchy" "deep" "vulgar" "bad"))
(check-expect (boolean-attributes ll3)
              (list "catchy" "deep" "vulgar" "bad" "heavy"))


; LAssoc -> List-of-strings
; produces the strings that are associated with a boolean attribute
; on the given track
(define (boolean-attributes-track track-attrs)
  (cond
    [(empty? track-attrs) '()]
    [(cons? track-attrs)
     (if (boolean? (second (first track-attrs)))
         (cons (first (first track-attrs))
               (boolean-attributes-track (rest track-attrs)))
         (boolean-attributes-track (rest track-attrs)))]))

(check-expect (boolean-attributes-track la0) '())
(check-expect (boolean-attributes-track la1) (list "vulgar" "bad" "catchy"))
(check-expect (boolean-attributes-track la2) (list "deep" "vulgar" "bad"))
(check-expect (boolean-attributes-track la3) (list "heavy"))


; List-of-strings List-of-strings -> List-of-strings
; adds all elements from list 1 to the front of list 2
(define (prepend list1 list2)
  (cond
    [(empty? list1) list2]
    [(cons? list1)
     (cons (first list1) (prepend (rest list1) list2))]))

(check-expect (prepend '() '()) '())
(check-expect (prepend '() (list "b" "c")) (list "b" "c"))
(check-expect (prepend (list "a" "b") '()) (list "a" "b"))
(check-expect (prepend (list "a" "b") (list "b" "c")) (list "a" "b" "b" "c"))


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



; LAssoc -> Track or #false
; converts an LAssoc to a Track if possible, otherwise produces #false
(define (track-as-struct la)
  (if (and (string? (second (find-association "name" la (list "" #false))))
           (string? (second (find-association "artist" la (list "" #false))))
           (string? (second (find-association "album" la (list "" #false))))
           (number? (second (find-association "time" la (list "" #false))))
           (number? (second (find-association "track#" la (list "" #false))))
           (date? (second (find-association "added" la (list "" #false))))
           (number? (second (find-association "play#" la (list "" #false))))
           (date? (second (find-association "played" la (list "" #false)))))
      (create-track (second (find-association "name" la (list "name" "")))
                    (second (find-association "artist" la (list "artist" "")))
                    (second (find-association "album" la (list "album" "")))
                    (second (find-association "time" la (list "time" 0)))
                    (second (find-association "track#" la (list "track#" 0)))
                    (second (find-association "added" la (list "added" date1)))
                    (second (find-association "play#" la (list "play#" 0)))
                    (second (find-association "played" la
                                              (list "played" date1))))
      #false))

(check-expect (track-as-struct la0) #false)
(check-expect (track-as-struct la1)
              (create-track tbp mm15 acss tbp-t 2 date1 1 date1))
