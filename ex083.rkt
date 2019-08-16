;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname ex083) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp")) #f)))
(define-struct editor [pre post])
; An Editor is a structure:
;   (make-editor String String)
; interpretation (make-editor s t) describes an editor
; whose visible text is (string-append s t) with 
; the cursor displayed between s and t


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

(check-expect (render (make-editor "hello " "world"))
              (overlay/align "left" "center"
                             (beside (text "hello " TEXT-SIZE TEXT-COLOR)
                                     CURSOR
                                     (text "world" TEXT-SIZE TEXT-COLOR))
                             FRAME))
