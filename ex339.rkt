;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex339) (read-case-sensitive #t) (teachpacks ((lib "abstraction.rkt" "teachpack" "2htdp") (lib "dir.rkt" "teachpack" "htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "abstraction.rkt" "teachpack" "2htdp") (lib "dir.rkt" "teachpack" "htdp")) #f)))
(define htdpex (create-dir "/home/s8a/htdp-exercises/"))
(define documents (create-dir "/home/s8a/Documents/"))
(define umc (create-dir "/home/s8a/Documents/Umc/"))


; String Dir -> Boolean
; determines whether a file named n exists in the given directory tree
(define (find? n d)
  (or (member? n (map file-name (dir-files d)))
      (ormap (lambda (sub) (find? n sub)) (dir-dirs d))))

(check-expect (find? "ex339.rkt" htdpex) #true)
(check-expect (find? "ex339.rkt" documents) #false)
(check-expect (find? "ex339.rkt" umc) #false)
(check-expect (find? "backer.conf" htdpex) #false)
(check-expect (find? "backer.conf" documents) #true)
(check-expect (find? "backer.conf" umc) #false)
(check-expect (find? "Fis324Magnetismo.odt" htdpex) #false)
(check-expect (find? "Fis324Magnetismo.odt" documents) #true)
(check-expect (find? "Fis324Magnetismo.odt" umc) #true)
