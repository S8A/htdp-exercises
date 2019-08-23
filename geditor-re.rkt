;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname geditor-re) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp")) #f)))
(define-struct editor [pre post])
; An Editor is a structure:
;   (make-editor Lo1S Lo1S) 
; An Lo1S is one of: 
; – '()
; – (cons 1String Lo1S)

(define good
  (cons "g" (cons "o" (cons "o" (cons "d" '())))))
(define all
  (cons "a" (cons "l" (cons "l" '()))))
(define lla
  (cons "l" (cons "l" (cons "a" '()))))
 
; data example 1: 
(make-editor all good)
 
; data example 2:
(make-editor lla good)


; Graphical constants
(define HEIGHT 20) ; the height of the editor 
(define WIDTH 200) ; its width 
(define FONT-SIZE 16) ; the font size 
(define FONT-COLOR "black") ; the font color 
 
(define MT (empty-scene WIDTH HEIGHT))
(define CURSOR (rectangle 1 HEIGHT "solid" "red"))


; main : String -> Editor
; launches the editor given some initial string 
(define (main s)
   (big-bang (create-editor s "")
     [on-key editor-kh]
     [to-draw editor-render]))


; String String -> Editor
; creates an editor from two strings representing the text before and after
; the cursor
(define (create-editor left right)
  (make-editor (reverse (explode left)) (explode right)))

(check-expect (create-editor "abc" "def")
              (make-editor (reverse (explode "abc")) (explode "def")))


; Editor -> Image
; renders an editor as an image of the two texts 
; separated by the cursor 
(define (editor-render e)
  (place-image/align (beside (editor-text (reverse (editor-pre e)))
                             CURSOR
                             (editor-text (editor-post e)))
                     1 1 "left" "top" MT))

(check-expect (editor-render (create-editor "pre" "post"))
              (place-image/align (beside (text "pre" FONT-SIZE FONT-COLOR)
                                         CURSOR
                                         (text "post" FONT-SIZE FONT-COLOR))
                                 1 1 "left" "top" MT))
(check-expect (editor-render (create-editor "" "post"))
              (place-image/align (beside (text "" FONT-SIZE FONT-COLOR)
                                         CURSOR
                                         (text "post" FONT-SIZE FONT-COLOR))
                                 1 1 "left" "top" MT))
(check-expect (editor-render (create-editor "pre" ""))
              (place-image/align (beside (text "pre" FONT-SIZE FONT-COLOR)
                                         CURSOR
                                         (text "" FONT-SIZE FONT-COLOR))
                                 1 1 "left" "top" MT))
(check-expect (editor-render (create-editor "" ""))
              (place-image/align (beside (text "" FONT-SIZE FONT-COLOR)
                                         CURSOR
                                         (text "" FONT-SIZE FONT-COLOR))
                                 1 1 "left" "top" MT))


; Editor KeyEvent -> Editor
; deals with a key event, given some editor
(define (editor-kh ed ke)
  (cond
    [(key=? ke "left") (editor-lft ed)]
    [(key=? ke "right") (editor-rgt ed)]
    [(key=? ke "\b") (editor-del ed)]
    [(key=? ke "\t") ed]
    [(key=? ke "\r") ed]
    [(key=? ke "\u007F") ed] ; delete key
    [(= (string-length ke) 1) (editor-ins ed ke)]
    [else ed]))

(check-expect (editor-kh (create-editor "" "") "e")
              (create-editor "e" ""))
(check-expect (editor-kh (create-editor "cd" "fgh") "e")
              (create-editor "cde" "fgh"))
(check-expect (editor-kh (create-editor "" "") "\b")
              (create-editor "" ""))
(check-expect (editor-kh (create-editor "cd" "fgh") "\b")
              (create-editor "c" "fgh"))
(check-expect (editor-kh (create-editor "" "") "left")
              (create-editor "" ""))
(check-expect (editor-kh (create-editor "cd" "fgh") "left")
              (create-editor "c" "dfgh"))
(check-expect (editor-kh (create-editor "" "") "right")
              (create-editor "" ""))
(check-expect (editor-kh (create-editor "cd" "fgh") "right")
              (create-editor "cdf" "gh"))
(check-expect (editor-kh (create-editor "" "") "\r")
              (create-editor "" ""))
(check-expect (editor-kh (create-editor "cd" "fgh") "\r")
              (create-editor "cd" "fgh"))
(check-expect (editor-kh (create-editor "" "") "\t")
              (create-editor "" ""))
(check-expect (editor-kh (create-editor "cd" "fgh") "\t")
              (create-editor "cd" "fgh"))
(check-expect (editor-kh (create-editor "" "") "down")
              (create-editor "" ""))
(check-expect (editor-kh (create-editor "cd" "fgh") "down")
              (create-editor "cd" "fgh"))


; Lo1s -> Image
; renders a list of 1Strings as a text image 
(define (editor-text s)
  (text (implode s) FONT-SIZE FONT-COLOR))

(check-expect (editor-text (cons "p" (cons "o" (cons "s" (cons "t" '())))))
              (text "post" FONT-SIZE FONT-COLOR))


; Editor -> Editor
; moves the cursor of the editor one position to the left
(define (editor-lft ed)
  (if (empty? (editor-pre ed))
      ed
      (make-editor (rest (editor-pre ed))
                   (cons (first (editor-pre ed)) (editor-post ed)))))

(check-expect (editor-lft (create-editor "" ""))
              (create-editor "" ""))
(check-expect (editor-lft (create-editor "cd" "fgh"))
              (create-editor "c" "dfgh"))


; Editor -> Editor
; moves the cursor of the editor one position to the right
(define (editor-rgt ed)
  (if (empty? (editor-post ed))
      ed
      (make-editor (cons (first (editor-post ed)) (editor-pre ed))
                   (rest (editor-post ed)))))

(check-expect (editor-rgt (create-editor "" ""))
              (create-editor "" ""))
(check-expect (editor-rgt (create-editor "cd" "fgh"))
              (create-editor "cdf" "gh"))


; Editor -> Editor
; deletes the character right before the cursor of the editor, if any
(define (editor-del ed)
  (if (empty? (editor-pre ed))
      ed
      (make-editor (rest (editor-pre ed)) (editor-post ed))))

(check-expect (editor-del (create-editor "" ""))
              (create-editor "" ""))
(check-expect (editor-del (create-editor "cd" "fgh"))
              (create-editor "c" "fgh"))


; Editor -> Editor
; inserts the character c right before the cursor of the editor
(define (editor-ins ed c)
  (make-editor (cons c (editor-pre ed)) (editor-post ed)))

(check-expect (editor-ins (create-editor "" "") "e")
              (create-editor "e" ""))
(check-expect (editor-ins (create-editor "cd" "fgh") "e")
              (create-editor "cde" "fgh"))
