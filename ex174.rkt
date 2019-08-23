;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex174) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp")) #f)))
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


; String -> String
; encodes text file f numerically
(define (encode-file f)
  (write-file (string-append "numeric-" f)
              (encode-string (collapse (read-words/line f)))))


; LLS -> String
; converts a list of lines into a string, words separated by blank spaces
; and lines separated by newlines.
(define (collapse lls)
  (cond
    [(empty? lls) ""]
    [(cons? lls)
     (string-append (line-string (first lls)) (collapse (rest lls)))]))

(check-expect (collapse lls0) "")
(check-expect (collapse lls1) "hello world\n\n")
(check-expect (collapse ex3) "TTT\n\nPut up in\ndamn\n")


; String -> String
; converts a text string into a numerically encoded one
(define (encode-string s)
  (list-string (encode (explode s))))

(check-expect (encode-string "a blue\nworld.")
              "097032098108117101010119111114108100046")


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


; List-of-strings -> String
; converts a list of strings into a string, without separation
(define (list-string los)
  (cond
    [(empty? los) ""]
    [(cons? los)
     (string-append (first los) (list-string (rest los)))]))

(check-expect (list-string '()) "")
(check-expect (list-string (cons "w" (cons "o" (cons "w" '())))) "wow")


; List-of-1String -> List-of-strings
; encodes each 1String in the list
(define (encode list)
  (cond
    [(empty? list) '()]
    [(cons? list)
     (cons (encode-letter (first list)) (encode (rest list)))]))

(check-expect (encode (cons "c" (cons "a" (cons "t" (cons "\n" '())))))
              (cons "099" (cons "097" (cons "116" (cons "010" '())))))


; 1String -> String
; converts the given 1String to a 3-letter numeric String
(define (encode-letter s)
  (cond
    [(>= (string->int s) 100) (code1 s)]
    [(< (string->int s) 10)
     (string-append "00" (code1 s))]
    [(< (string->int s) 100)
     (string-append "0" (code1 s))]))

(check-expect (encode-letter "z") (code1 "z"))
(check-expect (encode-letter "\t")
              (string-append "00" (code1 "\t")))
(check-expect (encode-letter "a")
              (string-append "0" (code1 "a")))


; 1String -> String
; converts the given 1String into a String 
(define (code1 c)
  (number->string (string->int c)))

(check-expect (code1 "z") "122")
