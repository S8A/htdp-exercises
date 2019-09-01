;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname ex275) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp")) #f)))
; Data definitions :.

; A Letter is one of the following 1Strings: 
; – "a"
; – ... 
; – "z"
; or, equivalently, a member? of this list: 
(define LETTERS (explode "abcdefghijklmnopqrstuvwxyz"))

; A Dictionary is a List-of-strings.

(define-struct lc [letter count])
; A LetterCount (LC) is a structure:
;   (make-lc Letter Number)
; intepretation (make-lc ltr n) combines a letter ltr
; with the number of times it occurs somewhere


; Data examples :.

(define DICT-AS-LIST (read-lines "/usr/share/dict/words"))
(define dict1 (list "applause" "bitch" "dark" "opera" "technology"
                    "xylophone" "zealot"))
(define dict2 (list "anarchist" "apparatus" "ballast" "beautiful" "bitcoin"
                    "capital" "cash" "creative" "chaos" "dollar" "electron"
                    "empty" "fake" "first" "freedom" "giant" "God" "good" "holy"
                    "Hollywood" "human" "idiot" "innovation" "imitation"
                    "jazz" "joke" "june" "kilogram" "koala" "lame" "laugh"
                    "liar" "liberal" "live" "love" "lunatic" "massacre"
                    "messiah" "millions" "money" "nazarene" "nectar"
                    "nymphomaniac" "null" "obituary" "obvious" "opus" "other"
                    "pathetic" "pier" "port" "push" "quick" "quirk" "radical"
                    "realist" "reasonable" "responsible" "right" "robot"
                    "secret" "September" "silence" "sober" "special" "standard" 
                    "stoicism" "stupid" "Superman" "technology" "titan"
                    "therianthropy" "trade" "turning" "umbrella" "unique"
                    "vague" "vigilante" "vulture" "walk" "warrior" "wish"
                    "x-ray" "yankee" "zipline" "zombie"))

(define dict1lc (list (make-lc "a" 1) (make-lc "b" 1) (make-lc "c" 0)
                      (make-lc "d" 1) (make-lc "e" 0) (make-lc "f" 0)
                      (make-lc "g" 0) (make-lc "h" 0) (make-lc "i" 0)
                      (make-lc "j" 0) (make-lc "k" 0) (make-lc "l" 0)
                      (make-lc "m" 0) (make-lc "n" 0) (make-lc "o" 1)
                      (make-lc "p" 0) (make-lc "q" 0) (make-lc "r" 0)
                      (make-lc "s" 0) (make-lc "t" 1) (make-lc "u" 0)
                      (make-lc "v" 0) (make-lc "w" 0) (make-lc "x" 1)
                      (make-lc "y" 0) (make-lc "z" 1)))
(define dict2lc (list (make-lc "a" 2) (make-lc "b" 3) (make-lc "c" 4)
                      (make-lc "d" 1) (make-lc "e" 2) (make-lc "f" 3)
                      (make-lc "g" 3) (make-lc "h" 3) (make-lc "i" 3)
                      (make-lc "j" 3) (make-lc "k" 2) (make-lc "l" 7)
                      (make-lc "m" 4) (make-lc "n" 4) (make-lc "o" 4)
                      (make-lc "p" 4) (make-lc "q" 2) (make-lc "r" 6)
                      (make-lc "s" 9) (make-lc "t" 5) (make-lc "u" 2)
                      (make-lc "v" 3) (make-lc "w" 3) (make-lc "x" 1)
                      (make-lc "y" 1) (make-lc "z" 2)))



; Letter Dictionary -> Number
; Counts how many words in the given dictionary start with the given letter
(define (starts-with# letter dict)
  (local (; String -> Boolean
          (define (starts-with-letter? s)
            (string-ci=? letter (string-ith s 0))))
    (length (filter starts-with-letter? dict))))

(check-expect (starts-with# "a" dict1) 1)
(check-expect (starts-with# "o" dict1) 1)
(check-expect (starts-with# "l" dict1) 0)
(check-expect (starts-with# "a" dict2) 2)
(check-expect (starts-with# "o" dict2) 4)
(check-expect (starts-with# "l" dict2) 7)


; [List-of Letter] Dictionary -> [List-of LetterCount]
; Counts how often each letter of the list is used as the first one of
; a word in the given dictionary
(define (count-by-letter lol dict)
  (local (; Letter -> LetterCount
          (define (count-letter letter)
            (make-lc letter (starts-with# letter dict))))
  (map count-letter lol)))

(check-expect (count-by-letter LETTERS dict1) dict1lc)
(check-expect (count-by-letter LETTERS dict2) dict2lc)


; Dictionary -> LetterCount
; Produces the LetterCount for the letter that is most frequently
; used as the first one in the words of the given dictionary.
(define (most-frequent dict)
  (local (; LetterCount LetterCount -> Boolean
          (define (lc-count>? a b)
            (> (lc-count a) (lc-count b))))
    (first (sort (count-by-letter LETTERS dict) lc-count>?))))

(check-expect (most-frequent dict1) (make-lc "a" 1))
(check-expect (most-frequent dict2) (make-lc "s" 9))


; Dictionary -> [List-of Dictionary]
; Produces a list of dictionaries, each one including only words that
; start with the same letter.
(define (words-by-first-letter dict)
  (local (; Dictionary -> Boolean
          (define (not-empty? d) (not (empty? d)))
          ; Letter -> Dictionary
          (define (create-dict letter)
            (local (; String -> Boolean
                    (define (starts-with-letter? s)
                      (string-ci=? letter (string-ith s 0))))
              (filter starts-with-letter? dict))))
    (filter not-empty? (map create-dict LETTERS))))

(check-expect (words-by-first-letter dict1)
              (list '("applause") '("bitch") '("dark") '("opera")
                    '("technology") '("xylophone") '("zealot")))
