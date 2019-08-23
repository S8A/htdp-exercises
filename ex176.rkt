;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex176) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp")) #f)))
; A Matrix is one of: 
;  – (cons Row '())
;  – (cons Row Matrix)
; constraint all rows in matrix are of the same length
 
; A Row is one of: 
;  – '() 
;  – (cons Number Row)

(define row1 (cons 11 (cons 12 '())))
(define row2 (cons 21 (cons 22 '())))
(define mat1 (cons row1 (cons row2 '())))

(define wor1 (cons 11 (cons 21 '())))
(define wor2 (cons 12 (cons 22 '())))
(define tam1 (cons wor1 (cons wor2 '())))


; Matrix -> Matrix
; transposes the given matrix along the diagonal 
(define (transpose lln)
  (cond
    [(empty? (first lln)) '()]
    [else (cons (first* lln) (transpose (rest* lln)))]))

(check-expect (transpose mat1) tam1)

; Q: Why does transpose ask (empty? (first lln))?
; A: Because the base case for a matrix is if its first row is empty.
; The transpose function conses the first column of the matrix
; and the transposition of the remaining columns; at the end, the
; last column will be composed of two empty lists, at which point
; transpose just returns '() to mark the end of the previous column
; turned into a row.


; Matrix -> Row
; creates row with the elements of the first column of a given matrix
(define (first* lln)
  (cond
    [(or (empty? lln) (empty? (first lln))) '()]
    [(cons? (first lln))
     (cons (first (first lln)) (first* (rest lln)))]))

(check-expect (first* mat1) wor1)


; Matrix -> Matrix
; creates copy of a matrix without its first column
(define (rest* lln)
  (cond
    [(or (empty? lln) (empty? (first lln))) '()]
    [(cons? (first lln))
     (cons (rest (first lln)) (rest* (rest lln)))]))

(check-expect (rest* mat1) (cons (rest row1) (cons (rest row2) '())))


; Q: You should also understand that you cannot design this function with
; the design recipes you have seen so far. Explain why.
; A: Because at the end of both first* and rest* the argument will NOT
; be a matrix, but an empty list, which is not part of the matrix data
; definition. That's the result of using rest repetitively.
