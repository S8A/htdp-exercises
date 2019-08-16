;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex087) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp")) #f)))
(define-struct editor [text index])
; An Editor is a structure:
;   (make-editor String Number)
; interpretation (make-editor s i) describes an editor
; whose visible text is s with the cursor displayed before
; index i (i is in the interval 0 to (string-length s), inclusive)
(define ex1 (make-editor "helloworld" 5))
(define ex2 (make-editor "hello world" 6))
(define ex3 (make-editor "hello world" 5))
(define ex4 (make-editor "hello world" 7))
(define ex5 (make-editor "ello world" 0))
(define ex6 (make-editor "hello world" 1))
(define ex7 (make-editor "hello world" 0))
(define ex8 (make-editor "ello world" 1))
(define ex9 (make-editor "longtextlongtextlongtextlongtextlongtextlo" 42))
(define ex10 (make-editor "longtextlongtextlongtextlongtextlongtextlon" 43))


(define HEIGHT 20)
(define WIDTH (* 10 HEIGHT))
(define TEXT-SIZE 11)
(define TEXT-COLOR "black")
(define CURSOR-COLOR "red")
(define FRAME (empty-scene WIDTH HEIGHT))
(define CURSOR (rectangle 1 HEIGHT "solid" CURSOR-COLOR))


; Editor -> String
; returns the string of characters of the editor before the index
(define (editor-pre ed)
  (substring (editor-text ed) 0 (editor-index ed)))

(check-expect (editor-pre ex1) "hello")
(check-expect (editor-pre ex5) "")


; Editor -> String
; returns the string of characters of the editor after the index
(define (editor-post ed)
  (substring (editor-text ed) (editor-index ed)))

(check-expect (editor-post ex1) "world")
(check-expect (editor-post ex9) "")


; Editor -> Image
; renders the text of the editor in its current state (ed)
(define (render-text ed)
  (beside (text (editor-pre ed) TEXT-SIZE TEXT-COLOR)
          CURSOR
          (text (editor-post ed) TEXT-SIZE TEXT-COLOR)))

(check-expect (render-text ex2)
              (beside (text "hello " TEXT-SIZE TEXT-COLOR)
                      CURSOR
                      (text "world" TEXT-SIZE TEXT-COLOR)))


; Editor -> Image
; shows the graphical interface of the current state of the editor (ed)
(define (render ed)
  (overlay/align "left" "center" (render-text ed) FRAME))

(check-expect (render ex2)
              (overlay/align "left" "center" (render-text ex2) FRAME))


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
     (make-editor (string-append (string-remove-last (editor-pre ed))
                                 (editor-post ed))
                  (- (editor-index ed) (if (= (editor-index ed) 0) 0 1)))]
    [(and (= (string-length ke) 1)
          (not (or (key=? ke "\r") (key=? ke "\t") (key=? ke "\u007F"))))
     (make-editor (string-append (string-append (editor-pre ed) ke)
                                 (editor-post ed))
                  (add1 (editor-index ed)))]
    [(key=? ke "left")
     (make-editor (editor-text ed)
                  (- (editor-index ed) (if (= (editor-index ed) 0) 0 1)))]
    [(key=? ke "right")
     (make-editor (editor-text ed)
                  (+ (editor-index ed)
                     (if (= (editor-index ed) (string-length (editor-text ed)))
                         0 1)))]
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
(check-expect (edit ex9 "n") ex10)


; Editor KeyEvent -> Editor
; applies the edit function only if the text would fit inside the canvas
(define (edit-limited ed ke)
  (if (> (image-width (render-text (edit ed ke))) WIDTH)
      ed
      (edit ed ke)))

(check-expect (edit-limited ex1 " ") ex2)
(check-expect (edit-limited ex9 "n") ex9)


; Editor -> Editor
; launches a text editor program given an initial text
(define (run pre)
  (big-bang (make-editor pre (string-length pre))
    [to-draw render]
    [on-key edit-limited]))
