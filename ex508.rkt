;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex508) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp")) #f)))
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
(define (split-structural ed x)
  (local (; [List-of 1String] -> [List-of 1String]
          ; produces the prefix of the given list that fits at the
          ; cursor position marked by x
          (define (fitting-prefix lo1s)
            (cond
              [(empty? lo1s) '()]
              [(cons? lo1s)
               (local ((define p lo1s)
                       (define s (ed-suffix (length p)))
                       (define p-text (editor-text p))
                       (define p+1-text
                         (editor-text (append p (if (cons? s)
                                                    (list (first s))
                                                    '())))))
                 (if (<= (image-width p-text)
                         x
                         (image-width p+1-text))
                     lo1s
                     (fitting-prefix (rest lo1s))))]))
          ; N -> [List-of 1String]
          ; produces the list of characters from ed starting at the given
          ; position
          (define (ed-suffix start)
            (explode (substring (implode ed) start)))
          (define pre (fitting-prefix (reverse ed))))
    (make-editor pre (ed-suffix (length pre)))))

(check-expect (split-structural (explode "abcdef") 0)
              (make-editor '() (explode "abcdef")))
(check-expect (split-structural (explode "abcdef") 7)
              (make-editor '("a") (explode "bcdef")))
(check-expect (split-structural (explode "abcdef") 12)
              (make-editor (explode "ba") (explode "cdef")))
(check-expect (split-structural (explode "abcdef") 33)
              (make-editor (explode "fedcba") '()))
