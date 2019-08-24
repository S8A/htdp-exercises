;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname ex192) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp")) #f)))
; An NELoP is one of: 
; – (cons Posn '())
; – (cons Posn NELoP)


; A Polygon is one of:
; – (list Posn Posn Posn)
; – (cons Posn Polygon)

(define triangle-p
  (list
    (make-posn 20 10)
    (make-posn 20 20)
    (make-posn 30 20)))

(define square-p
  (list
    (make-posn 10 10)
    (make-posn 20 10)
    (make-posn 20 20)
    (make-posn 10 20)))


; a plain background image 
(define MT (empty-scene 50 50))


; Image Polygon -> Image
; renders the given polygon p into img
(define (render-polygon img p)
  (render-line (connect-dots img p)
               (first p)
               (last p)))

(check-expect
  (render-polygon MT triangle-p)
  (scene+line
    (scene+line
      (scene+line MT 20 10 20 20 "red")
      20 20 30 20 "red")
    30 20 20 10 "red"))

(check-expect
  (render-polygon MT square-p)
  (scene+line
    (scene+line
      (scene+line
        (scene+line MT 10 10 20 10 "red")
        20 10 20 20 "red")
      20 20 10 20 "red")
    10 20 10 10 "red"))


; Image Posn Posn -> Image 
; renders a line from p to q into img
(define (render-line img p q)
  (scene+line
    img
    (posn-x p) (posn-y p) (posn-x q) (posn-y q)
    "red"))

(check-expect (render-line MT (make-posn 10 10) (make-posn 20 20))
              (scene+line MT 10 10 20 20 "red"))


; Image NELoP -> Image 
; connects the dots in p by rendering lines in img
(define (connect-dots img p)
  (cond
    [(empty? (rest p)) MT]
    [else
     (render-line (connect-dots img (rest p)) (first p) (second p))]))

(check-expect (connect-dots MT triangle-p)
              (scene+line
               (scene+line MT 20 20 30 20 "red")
               20 10 20 20 "red"))

(check-expect (connect-dots MT square-p)
               (scene+line
                (scene+line
                 (scene+line MT 10 10 20 10 "red")
                 20 10 20 20 "red")
                20 20 10 20 "red"))


; NELoP -> Posn
; extracts the last item from p
(define (last-nelop p)
  (cond
    [(empty? (rest p)) (first p)]
    [else (last-nelop (rest p))]))

(check-expect (last-nelop triangle-p) (make-posn 30 20))
(check-expect (last-nelop square-p) (make-posn 10 20))


; Q: Argue why it is acceptable to use last on Polygons.
; A: Because Polygon is just a subset of NELoP that excludes
; lists of two posns or less, so all operations that work on
; NELoP should work on Polygon.

; Q: Also argue why you may adapt the template for connect-dots to last.
; A: Because both functions are designed for the NELoP data definition.
; More specifically, getting the last item of a lif of posns is the same
; procedure whether or not the list is guaranteed to have at least three
; items.


; Polygon -> Posn
; extracts the last item from p
(define (last p)
  (cond
    [(empty? (rest (rest (rest p)))) (third p)]
    [else (last (rest p))]))

(check-expect (last triangle-p) (make-posn 30 20))
(check-expect (last square-p) (make-posn 10 20))
