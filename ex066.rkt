;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex066) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp")) #f)))
; String String Number
(define-struct movie [title producer year])

(make-movie "Justice League" "Zack Snyder" 2018)


; String String String String
(define-struct person [name hair eyes phone])

(make-person "Samuel" "black" "black" "(+58)4142415927")


; String Number
(define-struct pet [name number])

(make-pet "Mortadela" 1)


; String String Number
(define-struct CD [artist title price])

(make-CD "Pantera" "Vulgar Display of Power" 19.92)


; String String String
(define-struct sweater [material size producer])

(make-sweater "Merino wool" "M" "Cosby Threads, Inc.")
