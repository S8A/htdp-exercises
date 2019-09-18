;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex453) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(define NEWLINE "\n") ; the 1String

; A File is one of:
; – '()
; – (cons "\n" File)
; – (cons 1String File)
; interpretation represents the content of a file 
; "\n" is the newline character

; A Line is a [List-of 1String].

; A Token is one of:
; - 1String[not string-whitespace?]
; - String[not string-whitespace?]
; interpretation a bundle of non-whitespace characters or
; a single non-letter, non-whitespace character


; Line -> [List-of Token]
; converts the given line into a list of tokens
(define (tokenize line)
  (cond
    [(empty? line) '()]
    [else
     (cons (first-token line) (tokenize (remove-first-token line)))]))

(check-expect (tokenize (explode "what the hell is happening, people?"))
              (list "what" "the" "hell" "is" "happening," "people?"))


; Line -> Token
; produces the first token of the given line (i.e. the sequence of characters
; before the first whitespace)
(define (first-token line)
  (cond
    [(empty? line) ""]
    [(string-whitespace? (first line)) ""]
    [else
     (string-append (first line) (first-token (rest line)))]))


; Line -> Line
; produces a copy of the given line without its first token (i.e. the sequence
; of characters after the first whitespace)
(define (remove-first-token line)
  (cond
    [(empty? line) '()]
    [(string-whitespace? (first line)) (rest line)]
    [else (remove-first-token (rest line))]))


; File -> [List-of Line]
; converts a file into a list of lines 
(define (file->list-of-lines afile)
  (cond
    [(empty? afile) '()]
    [else
     (cons (first-line afile)
           (file->list-of-lines (remove-first-line afile)))]))

(check-expect (file->list-of-lines
                (list "a" "b" "c" "\n"
                      "d" "e" "\n"
                      "f" "g" "h" "\n"))
              (list (list "a" "b" "c")
                    (list "d" "e")
                    (list "f" "g" "h")))


; File -> Line
; produces the first line of the given file (i.e. all characters
; from the beginning until the first newline)
(define (first-line afile)
  (cond
    [(empty? afile) '()]
    [(string=? (first afile) NEWLINE) '()]
    [else (cons (first afile) (first-line (rest afile)))]))


; File -> File
; produces a copy of the file without its first line (i.e. all characters
; after the first newline)
(define (remove-first-line afile)
  (cond
    [(empty? afile) '()]
    [(string=? (first afile) NEWLINE) (rest afile)]
    [else (remove-first-line (rest afile))]))
