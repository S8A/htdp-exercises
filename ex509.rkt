;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex509) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp")) #f)))
(define FONT-SIZE 11)
(define FONT-COLOR "black")
 
; [List-of 1String] -> Image
; renders a string as an image for the editor 
(define (editor-text s)
  (text (implode s) FONT-SIZE FONT-COLOR))
 
(define-struct editor [pre post])
; An Editor is a structure:
;   (make-editor [List-of 1String] [List-of 1String])
; interpretation if (make-editor p s) is the state of 
; an interactive editor, (reverse p) corresponds to
; the text to the left of the cursor and s to the
; text on the right


; [List-of 1String] N -> Editor
; produces an editor after clicking on the given horizontal position,
; given a list of characters representing the current editor text
(define (split ed x)
  (local (; [List-of 1String] [List-of 1String] -> Editor
          ; produces a split of ed which is the result of clicking at x,
          ; by trying smaller and smaller prefixes of ed until it fits
          ; into the desired width
          ; accumulator p represents the characters before the cursor,
          ; in reverse
          ; accumulator s represents the characters after the cursor
          (define (splitter p s)
            (cond
              [(<= (image-width (editor-text p))
                   x
                   (image-width (editor-text (if (cons? s)
                                                 (append p (list (first s)))
                                                 p))))
               (make-editor p s)]
              [else (splitter (rest p) (cons (first p) s))])))
    (splitter (reverse ed) '())))

(check-expect (split (explode "abcdef") 0)
              (make-editor '() (explode "abcdef")))
(check-expect (split (explode "abcdef") 7)
              (make-editor '("a") (explode "bcdef")))
(check-expect (split (explode "abcdef") 12)
              (make-editor (explode "ba") (explode "cdef")))
(check-expect (split (explode "abcdef") 33)
              (make-editor (explode "fedcba") '()))
