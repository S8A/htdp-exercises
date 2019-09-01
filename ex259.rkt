;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname ex259) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp") (lib "web-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp") (lib "web-io.rkt" "teachpack" "2htdp")) #f)))
; A Word is a [List-of 1String]
(define wde (explode "de"))
(define wcat (explode "cat"))
(define wrat (explode "rat"))


(define low0 '())
(define low1 (list wde))
(define low2 (list wde wcat))
(define low3 (list wde wcat wrat))


; A Dictionary is a [List-of Strings].


; A Letter is one of the following 1Strings: 
; – "a"
; – ... 
; – "z"
; or, equivalently, a member? of this list: 
(define LETTERS (explode "abcdefghijklmnopqrstuvwxyz"))


; String -> [List-of String]
; finds all words that the letters of some given word spell
(define (alternative-words s)
  (local (; The dictionary to be used:
          (define DICT-AS-LIST (read-lines "/usr/share/dict/words"))
          ; Find all the arrangements of the word s:
          (define arrangement-list (arrangements (string->word s)))
          ; Converts the arrangements to strings:
          (define arrangements-as-strings (words->strings arrangement-list))
          ; String -> Boolean
          ; Checks if the given string is a word in the dictionary.
          (define (string-in-dict? s) (member? s DICT-AS-LIST))
          ; [List-of String] -> [List-of String]
          ; Picks out all those Strings that occur in the dictionary.
          (define (in-dictionary los) (filter string-in-dict? los)))
    (create-set (in-dictionary arrangements-as-strings))))

(check-member-of (alternative-words "cat")
                 (list "act" "cat") (list "cat" "act"))
 
(check-satisfied (alternative-words "rat") all-words-from-rat?)



; [X] [List-of X] -> [List-of X]
; Creates a copy of the list without repetitions
(define (create-set l)
  (cond
    [(empty? l) '()]
    [(cons? l)
     (if (member? (first l) (rest l))
         (create-set (rest l))
         (cons (first l) (create-set (rest l))))]))

(check-expect (create-set (list "a" "b" "c")) (list "a" "b" "c"))
(check-expect (create-set (list "a" "b" "c" "b" "a")) (list "c" "b" "a"))


; [List-of Word] -> [List-of String]
; Turns all words in low into strings
(define (words->strings low) (map word->string low))

(check-expect (words->strings '()) '())
(check-expect (words->strings (list (explode "cat") (explode "act")))
              (list "cat" "act"))


; Word -> [List-of Word]
; Finds all rearrangements of word
(define (arrangements w)
  (cond
    [(empty? w) (list '())]
    [(cons? w)
     (insert-everywhere/in-all-words (first w) (arrangements (rest w)))]))

(check-expect (arrangements '()) (list '()))
(check-expect (arrangements wde)
              (list (list "d" "e") (list "e" "d")))


; 1String [List-of Word] -> [List-of Word]
; Produces a list like the given one but with character x inserted at
; every position in all words of the given list.
(define (insert-everywhere/in-all-words x low)
  (local (; 1String Word -> [List-of Word]
          ; Inserts the character x at every position between the characters
          ; of the word w
          (define (insert-everywhere w)
            (cond
              [(empty? w) (list (list x))]
              [(cons? w)
               (cons (prepend x w)
                     (prepend-to-each (first w)
                                      (insert-everywhere (rest w))))])))
    (foldr append '() (map insert-everywhere low))))

(check-expect (insert-everywhere/in-all-words "d" '()) '())
(check-expect (insert-everywhere/in-all-words "d" (list '()))
              (list (list "d")))
(check-expect (insert-everywhere/in-all-words "d" (list (list "e")))
              (list (list "d" "e") (list "e" "d")))
(check-expect (insert-everywhere/in-all-words "d" (list (list "e" "r")
                                                        (list "r" "e")))
              (list (list "d" "e" "r") (list "e" "d" "r") (list "e" "r" "d")
                    (list "d" "r" "e") (list "r" "d" "e") (list "r" "e" "d")))


; 1String [List-of Word] -> [List-of Word]
; Inserts the character x at the beginning of each word in the given list
(define (prepend-to-each x low)
  (local (; Prepends x to the given word
          (define (prepend-x w) (prepend x w)))
    (map prepend-x low)))

(check-expect (prepend-to-each "d" '()) '())
(check-expect (prepend-to-each "d" (list '())) (list (list "d")))
(check-expect (prepend-to-each "d" (list (list "e") (list "r")))
              (list (explode "de") (explode "dr")))
(check-expect (prepend-to-each "d" (list (explode "er") (explode "re")))
              (list (explode "der") (explode "dre")))


; 1String Word -> Word
; Inserts the character x at the beginning of the given word
(define (prepend x w) (cons x w))

(check-expect (prepend "d" '()) (list "d"))
(check-expect (prepend "d" (list "e")) (list "d" "e"))
(check-expect (prepend "d" (list "e" "r")) (list "d" "e" "r"))


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


; [List-of String] -> Boolean
(define (all-words-from-rat? w)
  (and (member? "rat" w) (member? "art" w) (member? "tar" w)))
