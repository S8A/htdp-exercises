;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex134) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp")) #f)))
; A List-of-names is one of: 
; – '()
; – (cons String List-of-names)
; interpretation a list of invitees, by last name

; String List-of-names -> Boolean
; determines whether str is on alon (a list of names)
(define (contains? str alon)
  (cond
    [(empty? alon) #false]
    [(cons? alon)
     (or (string=? (first alon) str)
         (contains? str (rest alon)))]))

(check-expect (contains? "Samuel" '()) #false)
(check-expect (contains? "Jane" (cons "Find" '()))
              #false)
(check-expect (contains? "Flatt" (cons "Flatt" '()))
              #true)
(check-expect (contains? "Flatt" (cons "A" (cons "Flatt" (cons "C" '()))))
              #true)
(check-expect (contains? "Ochoa"
               (cons "Findler"
                     (cons "Felleisen"
                           (cons "Krishnamurthi"
                                 (cons "Ochoa" '())))))
              #true)

(check-expect (contains? "Flatt"
               (cons "Fagan"
                     (cons "Findler"
                           (cons "Fisler"
                                 (cons "Flanagan"
                                       (cons "Flatt"
                                             (cons "Felleisen"
                                                   (cons "Friedman" '()))))))))
              #true)
