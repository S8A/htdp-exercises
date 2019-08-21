;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex142) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp")) #f)))
; ListOfImages is one of:
; - '()
; - (cons Image ListOfImages)
(define ex1 '())
(define ex2 (cons (rectangle 30 20 "solid" "red") '()))
(define ex3 (cons (circle 10 "solid" "blue")
                  (cons (rectangle 30 20 "solid" "red") '())))
(define ex4 (cons (text "Hello world" 16 "black")
                  (cons (circle 10 "solid" "blue")
                        (cons (rectangle 30 20 "solid" "red") '()))))
(define ex5 (cons (square 50 "solid" "red")
                  (cons (square 40 "outline" "green")
                        (cons (square 30 "solid" "blue")
                              (cons (square 20 "outline" "black") '())))))


; ImageOrFalse is one of:
; – Image
; – #false


; ListOfImages -> ImageOrFalse
; produces the first image on loi that isn't an nxn square, or #false if
; none can be found
(define (ill-sized? loi n)
  (cond
    [(empty? loi) #false]
    [(cons? loi)
     (if (not-n-square? (first loi) n)
         (first loi)
         (ill-sized? (rest loi) n))]))

(check-expect (ill-sized? ex1 10) #false)
(check-expect (ill-sized? ex2 30) (rectangle 30 20 "solid" "red"))
(check-expect (ill-sized? ex3 20) (rectangle 30 20 "solid" "red"))
(check-expect (ill-sized? ex4 40) (text "Hello world" 16 "black"))
(check-expect (ill-sized? ex5 50) (square 40 "outline" "green"))


; Image Number -> Boolean
; is the image not a square of n by n pixels
(define (not-n-square? im n)
  (not (and (= (image-height im) n) (= (image-width im) n))))

(check-expect (not-n-square? (rectangle 30 20 "solid" "red") 20) #t)
(check-expect (not-n-square? (circle 10 "solid" "blue") 30) #t)
(check-expect (not-n-square? (circle 10 "solid" "blue") 20) #f)
(check-expect (not-n-square? (text "Hello world" 16 "black") 16) #t)
(check-expect (not-n-square? (square 50 "solid" "red") 50) #f)
(check-expect (not-n-square? (square 40 "outline" "green") 40) #f)
(check-expect (not-n-square? (square 30 "solid" "blue") 30) #f)
(check-expect (not-n-square? (square 20 "outline" "black") 20) #f)
(check-expect (not-n-square? (square 50 "solid" "red") 20) #t)
(check-expect (not-n-square? (square 40 "outline" "green") 30) #t)
(check-expect (not-n-square? (square 30 "solid" "blue") 40) #t)
(check-expect (not-n-square? (square 20 "outline" "black") 50) #t)
