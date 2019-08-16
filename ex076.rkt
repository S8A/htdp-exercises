;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex076) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp")) #f)))
(define-struct movie [title producer year])
; A Movie is a structure:
;   (make-movie String String Number)
; interpretation (make-movie t p y) is a movie with
; name t, produced by p, from the year y


(define-struct person [name hair eyes phone])
; A Person is a structure:
;   (make-person String String String String)
; inteprepretation (make-person n h e p) is a person with 
; name n, hair color h, eye color e, and phone number p


(define-struct pet [name number])
; A Pet is a structure:
;   (make-pet String Number)
; interpretation (make-pet name num) is a pet named name,
; with identifier number num


(define-struct CD [artist title price])
; A CD is a structure:
;   (make-CD String String NonnegativeNumber)
; interpretation (make-CD a t p) is a music CD from an artist
; named a, titled t, with price p


(define-struct sweater [material size producer])
; A Sweater is a structure:
;   (make-sweater String String String)
; interpretation (make-sweater m s p) is a sweater made of
; material m, of size s, manufactured by a producer named p
