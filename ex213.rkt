;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname ex213) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp") (lib "itunes.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp") (lib "itunes.rkt" "teachpack" "2htdp")) #f)))
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
(define (arrangements w)
  (cond
    [(empty? w) (list '())]
    [(cons? w)
     (insert-everywhere/in-all-words (first w) (arrangements (rest w)))]))

(check-expect (arrangements '()) (list '()))
(check-expect (arrangements wde)
              (list (list "d" "e") (list "e" "d")))


; 1String List-of-words -> List-of-words
; produces a list like the given one but with character x inserted at
; the beginning, between all letters, and at the end of all words of the
; given list
(define (insert-everywhere/in-all-words x low)
  (cond
    [(empty? low) '()]
    [(cons? low)
     (append (insert-everywhere x (first low))
             (insert-everywhere/in-all-words x (rest low)))]))

(check-expect (insert-everywhere/in-all-words "d" '()) '())
(check-expect (insert-everywhere/in-all-words "d" (list '()))
              (list (list "d")))
(check-expect (insert-everywhere/in-all-words "d" (list (list "e")))
              (list (list "d" "e") (list "e" "d")))
(check-expect (insert-everywhere/in-all-words "d" (list (list "e" "r")
                                                        (list "r" "e")))
              (list (list "d" "e" "r") (list "e" "d" "r") (list "e" "r" "d")
                    (list "d" "r" "e") (list "r" "d" "e") (list "r" "e" "d")))


; 1String Word -> List-of-words
; inserts the character x at every position between the characters of the word w
(define (insert-everywhere x w)
  (cond
    [(empty? w) (list (list x))]
    [(cons? w)
     (cons (prepend x w)
           (prepend-to-each (first w) (insert-everywhere x (rest w))))]))

(check-expect (insert-everywhere "d" '())
              (list (list "d")))
(check-expect (insert-everywhere "d" (list "e"))
              (list (list "d" "e") (list "e" "d")))
(check-expect (insert-everywhere "d" (list "e" "r"))
              (list (list "d" "e" "r") (list "e" "d" "r") (list "e" "r" "d")))


; 1String Word -> Word
; inserts the character x at the beginning of the given word
(define (prepend x w)
  (cons x w))

(check-expect (prepend "d" '()) (list "d"))
(check-expect (prepend "d" (list "e")) (list "d" "e"))
(check-expect (prepend "d" (list "e" "r")) (list "d" "e" "r"))


; 1String List-of-words -> List-of-words
; inserts the character x at the beginning of each word in the given list
(define (prepend-to-each x low)
  (cond
    [(empty? low) '()]
    [(cons? low)
     (cons (prepend x (first low))
           (prepend-to-each x (rest low)))]))
     

(check-expect (prepend-to-each "d" '()) '())
(check-expect (prepend-to-each "d" (list '())) (list (list "d")))
(check-expect (prepend-to-each "d" (list (list "e") (list "r")))
              (list (explode "de") (explode "dr")))
(check-expect (prepend-to-each "d" (list (explode "er") (explode "re")))
              (list (explode "der") (explode "dre")))


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
