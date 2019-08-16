;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex080) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp")) #f)))
(define-struct movie [title director year])
(define (movie-info m)
  (... (movie-title m) ... (movie-director m) ... (movie-year m) ...))

(define-struct pet [name number])
(define (pet-info p)
  (... (pet-name p) ... (pet-number p) ...))

(define-struct CD [artist title price])
(define (CD-details c)
  (... (CD-artist c) ... (CD-title c) ... (CD-price c) ...))

(define-struct sweater [material size color])
(define (sweater-description s)
  (... (sweater-material s) ... (sweater-size s) ... (sweater-color s) ...))