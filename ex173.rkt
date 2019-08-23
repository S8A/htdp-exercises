;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex173) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp")) #f)))
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
; removes all articles from a text file named n
(define (remove-articles-file n)
  (write-file (string-append "no-articles-" n)
              (collapse (remove-articles (read-words/line n)))))


; LLS -> LLS
; removes articles from the list of lines
(define (remove-articles lls)
  (cond
    [(empty? lls) '()]
    [(cons? lls)
     (cons (remove-articles-line (first lls))
           (remove-articles (rest lls)))]))

(check-expect (remove-articles lls0) lls0)
(check-expect (remove-articles lls1) lls1)
(check-expect (remove-articles (cons line2
                                     (cons line3
                                           (cons line4 '()))))
              (cons line2ra (cons line3ra (cons line4ra '()))))


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


; List-of-strings -> List-of-strings
; removes articles from the list of strings
(define (remove-articles-line list)
  (cond
    [(empty? list) '()]
    [(cons? list)
     (if (is-article? (first list))
         (remove-articles-line (rest list))
         (cons (first list) (remove-articles-line (rest list))))]))

(check-expect (remove-articles-line line0) line0)
(check-expect (remove-articles-line line1) line1)
(check-expect (remove-articles-line line2) line2ra)
(check-expect (remove-articles-line line3) line3ra)
(check-expect (remove-articles-line line4) line4ra)


; String -> Boolean
; is the given string equal to "a", "an" or "the"
(define (is-article? str)
  (or (string=? str "a") (string=? str "an") (string=? str "the")))

(check-expect (is-article? "hello") #false)
(check-expect (is-article? "a") #true)
(check-expect (is-article? "an") #true)
(check-expect (is-article? "the") #true)

