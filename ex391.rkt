;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex391) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; .: Before simplification :.

; [List-of Number] [List-of Number] -> [List-of Number]
; replaces the final '() in front with end
(define (replace-eol-with_ front end)
  (cond
    [(and (empty? front) (empty? end)) '()]
    [(and (empty? front) (cons? end)) end]
    [(and (cons? front) (empty? end)) front]
    [(and (cons? front) (cons? end))
     (cons (first front)
           (replace-eol-with_ (rest front) end))]))

(check-expect (replace-eol-with_ '() '()) '())
(check-expect (replace-eol-with_ '() '(d e)) '(d e))
(check-expect (replace-eol-with_ '(a b c) '()) '(a b c))
(check-expect (replace-eol-with_ '(a b c) '(d e)) '(a b c d e))


; .: After simplification :.

; [List-of Number] [List-of Number] -> [List-of Number]
; replaces the final '() in front with end
(define (replace-eol-with front end)
  (cond
    [(empty? front) end]
    [(cons? front)
     (cons (first front)
           (replace-eol-with (rest front) end))]))

(check-expect (replace-eol-with '() '()) '())
(check-expect (replace-eol-with '() '(d e)) '(d e))
(check-expect (replace-eol-with '(a b c) '()) '(a b c))
(check-expect (replace-eol-with '(a b c) '(d e)) '(a b c d e))
