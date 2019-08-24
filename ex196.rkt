;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname ex196) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp")) #f)))
; A Letter is one of the following 1Strings: 
; – "a"
; – ... 
; – "z"
; or, equivalently, a member? of this list: 
(define LETTERS
  (explode "abcdefghijklmnopqrstuvwxyz"))


(define LOCATION "/usr/share/dict/words")
; A Dictionary is a List-of-strings.
(define AS-LIST (read-lines LOCATION))


(define-struct letter-count [letter count])
; A LetterCount is a structure:
;   (make-letter-count Letter Number)
; intepretation (make-letter-count ltr n) combines a letter ltr
; with the number of times it occurs somewhere


; Letter Dictionary -> Number
; counts how many words in the given Dictionary start with the given Letter
(define (starts-with# letter dict)
  (cond
    [(empty? dict) 0]
    [(cons? dict)
     (+ (if (string=? letter (string-ith (first dict) 0)) 1 0)
        (starts-with# letter (rest dict)))]))

(check-expect (starts-with# "x" AS-LIST) 17)


; ListOfLetters Dictionary -> List-of-letter-counts
; counts how often each letter of the list is used as the first one of
; a word in the given dictionary
(define (count-by-letter lol dict)
  (cond
    [(empty? lol) '()]
    [(cons? lol)
     (cons (make-letter-count (first lol) (starts-with# (first lol) dict))
           (count-by-letter (rest lol) dict))]))

(check-expect (count-by-letter (explode "exz") AS-LIST)
              (list (make-letter-count "e" 3296)
                    (make-letter-count "x" 17)
                    (make-letter-count "z" 146)))
