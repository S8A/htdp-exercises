;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex396) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp")) #f)))
(define LOCATION "/usr/share/dict/words")
(define AS-LIST (read-lines LOCATION))
(define SIZE (length AS-LIST))
; ..:: TO PLAY ::..
; (play (list-ref AS-LIST (random SIZE)) 30)


(define LETTERS (explode "abcdefghijklmnopqrstuvwxyz"))

; An HM-Word is a [List-of Letter or "_"]
; interpretation "_" represents a letter to be guessed


; HM-Word N -> String
; runs a simplistic hangman game, produces the current state
(define (play the-pick time-limit)
  (local ((define the-word  (explode (string-downcase the-pick)))
          (define the-guess (make-list (length the-word) "_"))
          ; HM-Word -> HM-Word
          (define (do-nothing s) s)
          ; HM-Word KeyEvent -> HM-Word 
          (define (checked-compare current-status ke)
            (if (member? ke LETTERS)
                (compare-word the-word current-status ke)
                current-status)))
    (implode
     (big-bang the-guess ; HM-Word
       [to-draw render-word]
       [on-tick do-nothing 1 time-limit]
       [on-key  checked-compare]))))


; HM-Word -> Image
(define (render-word w)
  (text (implode w) 22 "black"))


; HM-Word HM-Word KeyEvent -> HM-Word
; Places letter ke in its corresponding position in guessed-word
; according to the word-to-be-guessed. Assumes both words to be of the same
; length and to be equal once there are no underscores left.
(define (compare-word word-to-be-guessed guessed-word ke)
  (cond
    [(empty? guessed-word) guessed-word]
    [(cons? guessed-word)
     (cons (if (and (string-ci=? (first guessed-word) "_")
                    (string-ci=? (first word-to-be-guessed) ke))
               ke
               (first guessed-word))
           (compare-word (rest word-to-be-guessed) (rest guessed-word) ke))]))

(check-expect (compare-word '() '() "d") '())
(check-expect (compare-word (explode "slaughtered") (explode "sl__ght_r_d") "e")
              (explode "sl__ghtered"))
(check-expect (compare-word (explode "slaughtered") (explode "sl__ght_r_d") "f")
              (explode "sl__ght_r_d"))
(check-expect (compare-word (explode "slaughtered") (explode "sl__ght_r_d") "g")
              (explode "sl__ght_r_d"))
