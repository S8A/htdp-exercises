;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex130) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp")) #f)))
; A List-of-names is one of: 
; – '()
; – (cons String List-of-names)
; interpretation a list of invitees, by last name


; Create an element of List-of-names that contains five Strings.

(define 5names
  (cons "Findler"
        (cons "Flatt"
              (cons "Felleisen"
                    (cons "Krishnamurthi"
                          (cons "Ochoa" '()))))))


; Explain why the first is an element of List-of-names and the other isn't

(cons "1" (cons "2" '()))
; Is a List-of-names because its first element is a string and its rest
; is a List-of-names (because its first element is a string and its rest
; is a List-of-names by definition).

(cons 2 '())
; Is not a List-of-names because its first element is not a string.
