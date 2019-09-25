;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex511) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(λ (x) x)
;   ↑  ↑
;   1->2
; 1: binding occurrence of x
; 2: bound occurrence of x
; The scope of 1 is the body of the lambda, which contains 2.

(λ (x) y)
;   ↑  ↑
;   1  2
; 1: binding occurrence of x
; 2: free variable
; The scope of 1 is the body of the lambda, which has no bound occurrences of x,
; but an occurrence of y, which is undefined in this context.

(λ (y) (λ (x) y))
;   ↑      ↑  ↑
;   1-------->3
;          2
; 1: binding occurrence of y
; 2: binding occurrence of x
; 3: bound occurrence of y
; The scope of 1 is the body of its lambda, which contains another lambda whose
; body contains 3, the bound occurrence of y. The scope of 2 is the body of its
; lambda, which has no bound occurrences of x.

((λ (x) x) (λ (x) x))
;    ↑  ↑      ↑  ↑
;    1->2      3->4
; 1: binding occurrence of x
; 2: bound occurrence of x
; 3: binding occurrence of x
; 4: bound occurrence of x
; The scope of 1 is the body of its lambda, which contains 2. The scope of 3 is
; the body of its lambda, which contains 4. Also, to apply the function, the
; second lambda expression replaces x in the first one.

;((λ (x) (x x)) (λ (x) (x x)))
;    ↑   ↑ ↑       ↑   ↑ ↑
;    1-->2 2       3-->4 4
; 1: binding occurrence of x
; 2: bound occurrences of x
; 3: binding occurrence of x
; 4: bound occurrences of x
; The scope of 1 is the body of its lambda, which contains 2. The scope of 3 is
; the body of its lambda, which contains 4. Also, to apply the function, the
; second lambda expression replaces x inthe first one.

(((λ (y) (λ (x) y)) (λ (z) z)) (λ (w) w))
;     ↑      ↑  ↑       ↑  ↑       ↑  ↑
;     1-------->3       4->5       6->7
;            2
; 1: binding occurrence of y
; 2: binding occurrence of x
; 3: bound occurrence of y
; 4: binding occurrence of z
; 5: bound occurrence of z
; 6: binding occurrence of w
; 7: bound occurrence of w
; The scope of 1 is the body of its lambda, which contains another lambda whose
; body contains 3. The scope of 2 is the body of its lambda, which contains no
; bound occurences of x. The scope of 4 is the body of its lambda, which
; contains 5. The scope of 6 is the body of its lambda, which contains 7.
