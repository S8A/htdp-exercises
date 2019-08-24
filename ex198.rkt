;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname ex198) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp")) #f)))
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


(define-struct lc [letter count])
; A LetterCount (LC) is a structure:
;   (make-lc Letter Number)
; intepretation (make-lc ltr n) combines a letter ltr
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
     (cons (make-lc (first lol) (starts-with# (first lol) dict))
           (count-by-letter (rest lol) dict))]))

(check-expect (count-by-letter (explode "exz") AS-LIST)
              (list (make-lc "e" 3296)
                    (make-lc "x" 17)
                    (make-lc "z" 146)))


; ListOfLetters Dictionary -> LetterCount
; produces the LetterCount for the letter of the list that occurs most
; often as the first one in the given dictionary
(define (most-frequent lol dict)
  (most-frequent-llc (count-by-letter lol dict)))

(check-expect (most-frequent (explode "exz") AS-LIST)
              (make-lc "e" 3296))


; List-of-letter-counts -> LetterCount
; produces the LetterCount with the highest count
(define (most-frequent-llc llc)
  (cond
    [(empty? (rest llc)) (first llc)]
    [(cons? (rest llc))
     (if (lc-count<? (first llc) (second llc))
         (most-frequent-llc (rest llc))
         (most-frequent-llc (cons (first llc)
                                  (rest (rest llc)))))]))

(check-expect (most-frequent-llc (list (make-lc "x" 17)
                                       (make-lc "z" 146)
                                       (make-lc "e" 3296)))
              (make-lc "e" 3296))
(check-expect (most-frequent-llc (list (make-lc "e" 3296)
                                       (make-lc "x" 17)
                                       (make-lc "z" 146)))
              (make-lc "e" 3296))


; LetterCount LetterCount -> Boolean
; is LetterCount 1's count lower than LetterCount 2's
(define (lc-count<? lc1 lc2)
  (< (lc-count lc1) (lc-count lc2)))

(check-expect (lc-count<? (make-lc "e" 3296) (make-lc "x" 17)) #false)
(check-expect (lc-count<? (make-lc "x" 17) (make-lc "z" 146)) #true)


; LetterCount LetterCount -> Boolean
; is LetterCount 1's count higher than or equal to LetterCount 2's
(define (lc-count>=? lc1 lc2)
  (>= (lc-count lc1) (lc-count lc2)))

(check-expect (lc-count>=? (make-lc "e" 3296) (make-lc "x" 17)) #true)
(check-expect (lc-count>=? (make-lc "x" 17) (make-lc "z" 146)) #false)


; ListOfLetters Dictionary -> LetterCount
; produces the LetterCount for the letter of the list that occurs most
; often as the first one in the given dictionary
(define (most-frequent-alt lol dict)
  (first (sort-llc> (count-by-letter lol dict))))

(check-expect (most-frequent-alt (explode "exz") AS-LIST)
              (make-lc "e" 3296))


; List-of-letter-counts -> List-of-letter-counts
; sorts the list of letter counts in descending order by their count
(define (sort-llc> llc)
  (cond
    [(empty? llc) '()]
    [else
     (insert-llc (first llc) (sort-llc> (rest llc)))]))

(check-expect (sort-llc> (list (make-lc "x" 17)
                               (make-lc "e" 3296)
                               (make-lc "z" 146)))
              (list (make-lc "e" 3296) (make-lc "z" 146) (make-lc "x" 17)))


; LetterCount List-of-letter-counts -> List-of-letter-counts
; inserts the given letter count in its proper place on a list of letter counts
; already sorted in descending order by their count
(define (insert-llc lc llc)
  (cond
    [(empty? llc) (list lc)]
    [else
     (if (lc-count>=? lc (first llc))
         (cons lc llc)
         (cons (first llc) (insert-llc lc (rest llc))))]))

(check-expect (insert-llc (make-lc "x" 17) (list (make-lc "e" 3296)
                                                 (make-lc "z" 146)))
              (list (make-lc "e" 3296) (make-lc "z" 146) (make-lc "x" 17)))


; ListOfLetters Dictionary -> ListOfDictionaries
; produces a list of dictionaries, one per letter, where each
; contains words that start with the same letter
(define (words-by-first-letter lol dict)
  (cond
    [(empty? (rest lol))
     (list (words-by-letter (first lol) dict))]
    [(cons? (rest lol))
     (cons (words-by-letter (first lol) dict)
           (words-by-first-letter (rest lol) dict))]))

(check-expect (words-by-first-letter (explode "exz") AS-LIST)
              (list (words-by-letter "e" AS-LIST)
                    (words-by-letter "x" AS-LIST)
                    (words-by-letter "z" AS-LIST)))


; ListOfLetters ListDictionary -> LetterCount
; produces the LetterCount for the letter of the list that occurs most
; often as the first one in the given dictionary
(define (most-frequent.v2 lol dict)
  (most-frequent-by-dict (words-by-first-letter lol dict)))

(check-expect (most-frequent.v2 (explode "exz") AS-LIST)
              (make-lc "e" 3296))


; Letter Dictionary -> Dictionary
; produces a copy of the given dictionary containing only the words
; that start with the given letter
(define (words-by-letter ltr dict)
  (cond
    [(empty? dict) '()]
    [(cons? dict)
     (if (string=? ltr (string-ith (first dict) 0))
         (cons (first dict) (words-by-letter ltr (rest dict)))
         (words-by-letter ltr (rest dict)))]))

(check-expect (words-by-letter "x" (list "applause"
                                         "bitch"
                                         "dark"
                                         "opera"
                                         "technology"
                                         "xylophone"
                                         "zealot"))
              (list "xylophone"))


; ListOfDictionaries -> LetterCount
; produces a letter count of the most common first letter from
; a list of dictionaries, each containing words that start with the
; same letter
(define (most-frequent-by-dict lod)
  (cond
    [(empty? (rest lod))
     (make-lc (string-ith (first (first lod)) 0) (length (first lod)))]
    [(cons? (rest lod))
     (if (< (length (first lod)) (length (second lod)))
         (most-frequent-by-dict (rest lod))
         (most-frequent-by-dict (cons (first lod)
                                      (rest (rest lod)))))]))

(check-expect (most-frequent-by-dict (list (words-by-letter "x" AS-LIST)
                                           (words-by-letter "e" AS-LIST)
                                           (words-by-letter "z" AS-LIST)))
              (make-lc "e" 3296))
(check-expect (most-frequent-by-dict (list (words-by-letter "e" AS-LIST)
                                           (words-by-letter "x" AS-LIST)
                                           (words-by-letter "z" AS-LIST)))
              (make-lc "e" 3296))


(check-expect (most-frequent LETTERS AS-LIST)
              (most-frequent.v2 LETTERS AS-LIST))
