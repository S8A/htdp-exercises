;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex175) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp")) #f)))
; A List-of-strings (LS) is one of:
; - '()
; - (cons String LS)
(define ex1 (cons "TTT"
                  (cons ""
                        (cons "Put up in a place"
                              (cons "something" '())))))
(define ex2 (cons "TTT"
                  (cons "Put"
                        (cons "up"
                              (cons "in"
                                    (cons "a" '()))))))
(define ttt1 (read-lines "ttt.txt"))
(define ttt2 (read-words "ttt.txt"))

; List-of-list-of-strings (LLS) is one of:
; - '()
; - (cons List-of-strings LLS)
(define ex3 (cons (cons "TTT" '())
                  (cons '()
                        (cons (cons "Put"
                                    (cons "up"
                                          (cons "in" '())))
                              (cons (cons "damn" '()) '())))))
(define ttt3 (read-words/line "ttt.txt"))


(define line0 (cons "hello" (cons "world" '())))
(define line1 '())
(define line2 (cons "look" (cons "an" (cons "elephant" '()))))
(define line3 (cons "a" (cons "bird" (cons "or" (cons "a" (cons "bug" '()))))))
(define line4 (cons "Batman"
                    (cons "the"
                          (cons "bold"
                                (cons "and" (cons "the" (cons "brave" '())))))))
(define line2ra (cons "look" (cons "elephant" '())))
(define line3ra (cons "bird" (cons "or" (cons "bug" '()))))
(define line4ra (cons "Batman" (cons "bold" (cons "and" (cons "brave" '())))))
 
(define lls0 '())
(define lls1 (cons line0 (cons line1 '())))
(define lls2 (cons line2 (cons line3 (cons line4 '()))))
(define lls3 (cons line2ra (cons line3ra (cons line4ra '()))))


(define-struct stat [characters words lines])
; A Stat is a structure:
;   (make-stat Number Number Number)
; interpretation (make-stat c w l) combines the number
; of characters (c), words (w) and lines (l) in a text file


; String -> Stat
; counts the number of 1Strings, words and lines in file f
(define (wc f)
  (make-stat (count-characters (read-words/line f))
             (count-words (read-words/line f))
             (count-lines (read-words/line f))))


; LLS -> Number
; counts the number of characters in lls
(define (count-characters lls)
  (cond
    [(empty? lls) 0]
    [(cons? lls)
     (+ (count-characters-line (first lls)) (count-characters (rest lls)))]))

(check-expect (count-characters lls0) 0)
(check-expect (count-characters lls1) 13)


; LLS -> Number
; counts the number of words in lls
(define (count-words lls)
  (cond
    [(empty? lls) 0]
    [(cons? lls)
     (+ (length (first lls)) (count-words (rest lls)))]))

(check-expect (count-words lls0) 0)
(check-expect (count-words lls1) 2)
(check-expect (count-words lls2) 14)
(check-expect (count-words lls3) 9)


; LLS -> Number
; counts the number of lines in lls
(define (count-lines lls)
  (length lls))

(check-expect (count-lines lls0) 0)
(check-expect (count-lines lls1) 2)
(check-expect (count-lines lls2) 3)
(check-expect (count-lines lls3) 3)


; List-of-strings -> Number
; counts the number of characters in a line
(define (count-characters-line line)
  (string-length (line-string line)))

(check-expect (count-characters-line line0) 12)
(check-expect (count-characters-line line1) 1)


; List-of-strings -> String
; converts a line into a string, words separated by blank spaces
(define (line-string los)
  (cond
    [(empty? los) "\n"]
    [(cons? los)
     (string-append (first los)
                    (if (= (length (rest los)) 0) "" " ")
                    (line-string (rest los)))]))

(check-expect (line-string line0) "hello world\n")
(check-expect (line-string line1) "\n")
