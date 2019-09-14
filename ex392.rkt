;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex392) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; .: Data definitions :.

(define-struct branch [left right])
 
; A TOS is one of:
; – Symbol
; – (make-branch TOS TOS)
 
; A Direction is one of:
; – 'left
; – 'right
 
; A [List-of Direction] is also called a Path.


; .: Data examples :.
(define tos0 'a)
(define tos1 (make-branch 'a 'b))
(define tos2 (make-branch 'a (make-branch 'b 'c)))
(define tos3 (make-branch (make-branch 'a 'b) 'c))
(define tos4 (make-branch (make-branch 'a 'b) (make-branch 'c 'd)))
(define tos5 (make-branch
              (make-branch (make-branch 'a 'b)
                           (make-branch 'c 'd))
              (make-branch (make-branch 'e 'f)
                           (make-branch 'g 'h))))

(define p0 '(right))
(define p1 '(left))
(define p2 '(right left))
(define p3 '(left right))
(define p4 '(right left))
(define p5 '(left right right))



; .: Functions :.

; .: Before simplification :.

; TOS Path -> TOS
; Follows the given path along the given tree's branches
(define (tree-pick_ tree path)
  (cond
    [(and (symbol? tree) (empty? path)) tree]
    [(and (symbol? tree) (cons? path)) tree]
    [(and (branch? tree) (empty? path)) tree]
    [(and (branch? tree) (cons? path))
     (local ((define direction (first path)))
       (tree-pick_ (cond
                     [(symbol=? direction 'left) (branch-left tree)]
                     [(symbol=? direction 'right) (branch-right tree)])
                   (rest path)))]))

(check-expect (tree-pick_ tos0 p0) tos0)
(check-expect (tree-pick_ tos1 p1) 'a)
(check-expect (tree-pick_ tos2 p2) 'b)
(check-expect (tree-pick_ tos3 p3) 'b)
(check-expect (tree-pick_ tos4 p4) 'c)
(check-expect (tree-pick_ tos5 p5) 'd)
(check-expect (tree-pick_ tos5 p4) (make-branch 'e 'f))


; .: After simplification :.

; TOS Path -> TOS
; Follows the given path along the given tree's branches
(define (tree-pick tree path)
  (cond
    [(and (branch? tree) (cons? path))
     (local ((define direction (first path)))
       (tree-pick (cond
                     [(symbol=? direction 'left) (branch-left tree)]
                     [(symbol=? direction 'right) (branch-right tree)])
                   (rest path)))]
    [else tree]))

(check-expect (tree-pick tos0 p0) tos0)
(check-expect (tree-pick tos1 p1) 'a)
(check-expect (tree-pick tos2 p2) 'b)
(check-expect (tree-pick tos3 p3) 'b)
(check-expect (tree-pick tos4 p4) 'c)
(check-expect (tree-pick tos5 p5) 'd)
(check-expect (tree-pick tos5 p4) (make-branch 'e 'f))
