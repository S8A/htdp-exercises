;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex084) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp")) #f)))
(define-struct editor [pre post])
; An Editor is a structure:
;   (make-editor String String)
; interpretation (make-editor s t) describes an editor
; whose visible text is (string-append s t) with 
; the cursor displayed between s and t
(define ex1 (make-editor "hello" "world"))
(define ex2 (make-editor "hello " "world"))
(define ex3 (make-editor "hello" " world"))
(define ex4 (make-editor "hello w" "orld"))
(define ex5 (make-editor "" "ello world"))
(define ex6 (make-editor "h" "ello world"))
(define ex7 (make-editor "" "hello world"))
(define ex8 (make-editor "e" "llo world"))


(define HEIGHT 20)
(define WIDTH (* 10 HEIGHT))
(define TEXT-SIZE 11)
(define TEXT-COLOR "black")
(define CURSOR-COLOR "red")
(define FRAME (empty-scene WIDTH HEIGHT))
(define CURSOR (rectangle 1 HEIGHT "solid" CURSOR-COLOR))


; Editor -> Image
; shows the graphical interface of the current state of the editor (ed)
(define (render ed)
  (overlay/align "left" "center"
                 (beside (text (editor-pre ed) TEXT-SIZE TEXT-COLOR)
                         CURSOR
                         (text (editor-post ed) TEXT-SIZE TEXT-COLOR))
                 FRAME))

(check-expect (render ex2)
              (overlay/align "left" "center"
                             (beside (text "hello " TEXT-SIZE TEXT-COLOR)
                                     CURSOR
                                     (text "world" TEXT-SIZE TEXT-COLOR))
                             FRAME))


; String -> Boolean
; checks if the str is empty
(define (string-empty? str) (= (string-length str) 0))

(check-expect (string-empty? "Uppercase randoM") #false)
(check-expect (string-empty? "") #true)


; String -> 1String
; extracts the first character from non-empty string str.
(define (string-first str)
  (substring str 0 (if (string-empty? str) 0 1)))

(check-expect (string-first "Uppercase randoM") "U")
(check-expect (string-first "") "")


; String -> 1String
; extracts the last character from non-empty string str.
(define (string-last str)
  (substring str
             (- (string-length str)
                (if (string-empty? str) 0 1))))

(check-expect (string-last "Uppercase randoM") "M")
(check-expect (string-last "") "")


; String -> String
; produces a copy of string str without its first character
(define (string-rest str)
  (substring str (if (string-empty? str) 0 1)))

(check-expect (string-rest "Uppercase randoM") "ppercase randoM")
(check-expect (string-rest "") "")


; String -> String
; produces a string like str with its last character removed
(define (string-remove-last str)
  (substring str 0 (- (string-length str) (if (string-empty? str) 0 1))))

(check-expect (string-remove-last "Uppercase randoM") "Uppercase rando")
(check-expect (string-remove-last "") "")


; Editor KeyEvent -> Editor
; adds the character typed before the cursor (except \r and \t),
; deletes the character before the cursor if the backspace key is pressed,
; or moves the cursor to the left or right if the corresponding key is pressed
(define (edit ed ke)
  (cond 
    [(key=? ke "\b")
     (make-editor (string-remove-last (editor-pre ed))
                  (editor-post ed))]
    [(and (= (string-length ke) 1)
          (not (or (key=? ke "\r") (key=? ke "\t") (key=? ke "\u007F"))))
     (make-editor (string-append (editor-pre ed) ke)
                  (editor-post ed))]
    [(key=? ke "left")
     (make-editor (string-remove-last (editor-pre ed))
                  (string-append (string-last (editor-pre ed))
                                 (editor-post ed)))]
    [(key=? ke "right")
     (make-editor (string-append (editor-pre ed)
                                 (string-first (editor-post ed)))
                  (string-rest (editor-post ed)))]
    [else ed]))

(check-expect (edit ex1 " ") ex2)
(check-expect (edit ex1 "\r") ex1)
(check-expect (edit ex1 "\t") ex1)
(check-expect (edit ex2 "left") ex3)
(check-expect (edit ex2 "right") ex4)
(check-expect (edit ex2 "\b") ex1)
(check-expect (edit ex3 "right") ex2)
(check-expect (edit ex4 "left") ex2)
(check-expect (edit ex6 "\b") ex5)
(check-expect (edit ex5 "h") ex6)
(check-expect (edit ex6 "left") ex7)
(check-expect (edit ex7 "right") ex6)
(check-expect (edit ex5 "right") ex8)
(check-expect (edit ex8 "left") ex5)
