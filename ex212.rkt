;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname ex212) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp") (lib "itunes.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp") (lib "itunes.rkt" "teachpack" "2htdp")) #f)))
; A Word is one of:
; – '() or
; – (cons 1String Word)
; interpretation a Word is a list of 1Strings (letters)
(define wde (explode "de"))
(define wcat (explode "cat"))
(define wrat (explode "rat"))

 
; A List-of-words is one of:
; - '()
; - (cons Word List-of-words)
(define low0 '())
(define low1 (list wde))
(define low2 (list wde wcat))
(define low3 (list wde wcat wrat))


(define LOCATION "/usr/share/dict/words")
; A Dictionary is a List-of-strings.
(define DICT-AS-LIST (read-lines LOCATION))


; A Letter is one of the following 1Strings: 
; – "a"
; – ... 
; – "z"
; or, equivalently, a member? of this list: 
(define LETTERS (explode "abcdefghijklmnopqrstuvwxyz"))


; Word -> List-of-words
; finds all rearrangements of word
(define (arrangements word)
  (list word))

(check-expect (arrangements '()) (list '()))
(check-expect (arrangements wde)
              (list (list "d" "e") (list "e" "d")))


; List-of-strings -> Boolean
(define (all-words-from-rat? w)
  (and (member? "rat" w) (member? "art" w) (member? "tar" w)))


; String -> List-of-strings
; finds all words that the letters of some given word spell
(define (alternative-words s)
  (in-dictionary (words->strings (arrangements (string->word s)))))

;(check-member-of (alternative-words "cat")
;                 (list "act" "cat") (list "cat" "act"))
 
;(check-satisfied (alternative-words "rat") all-words-from-rat?)

 
; List-of-words -> List-of-strings
; turns all Words in low into Strings 
(define (words->strings low)
  (cond
    [(empty? low) '()]
    [(cons? low)
     (cons (word->string (first low)) (words->strings (rest low)))]))

(check-expect (words->strings '()) '())
(check-expect (words->strings (list (explode "cat") (explode "act")))
              (list "cat" "act"))


; List-of-strings -> List-of-strings
; picks out all those Strings that occur in the dictionary 
(define (in-dictionary los)
  (cond
    [(empty? los) '()]
    [(cons? los)
     (if (member? (first los) DICT-AS-LIST)
         (cons (first los) (in-dictionary (rest los)))
         (in-dictionary (rest los)))]))

(check-expect (in-dictionary '()) '())
(check-expect (in-dictionary (list "act" "atc" "cat" "cta" "tac" "tca"))
              (list "act" "cat"))


; String -> Word
; converts s to the chosen word representation 
(define (string->word s) (explode s))

(check-expect (string->word "") '())
(check-expect (string->word "cat") (list "c" "a" "t"))

 
; Word -> String
; converts w to a string
(define (word->string w) (implode w))

(check-expect (word->string '()) "")
(check-expect (word->string (list "c" "a" "t")) "cat")
