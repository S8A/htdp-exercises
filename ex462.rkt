;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex462) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; An SOE is a non-empty Matrix.
; constraint for (list r1 ... rn), (length ri) is (+ n 1)
; interpretation represents a system of linear equations
 
; An Equation is a [List-of Number].
; constraint an Equation contains at least two numbers. 
; interpretation if (list a1 ... an b) is an Equation, 
; a1, ..., an are the left-hand-side variable coefficients 
; and b is the right-hand side
 
; A Solution is a [List-of Number]
 
(define M ; an SOE 
  (list (list 2 2  3 10) ; an Equation 
        (list 2 5 12 31)
        (list 4 1 -2  1)))
 
(define S '(1 1 2)) ; a Solution


; Equation -> [List-of Number]
; extracts the left-hand side from a row in a matrix
(check-expect (lhs (first M)) '(2 2 3))
(define (lhs e)
  (reverse (rest (reverse e))))
 
; Equation -> Number
; extracts the right-hand side from a row in a matrix
(check-expect (rhs (first M)) 10)
(define (rhs e)
  (first (reverse e)))


; SOE Solution -> Boolean
; checks if plugging in the numbers from the solution for the variables
; in the given system of equations produces equal left-hand-side values
; and right-hand-side values
(define (check-solution soe sol)
  (andmap (lambda (eq) (= (plug-in (lhs eq) sol) (rhs eq))) soe))

(check-expect (check-solution M S) #true)
(check-expect (check-solution M '(2 1 1)) #false)


; [List-of Number] Solution -> Number
; plugs in the numbers from the solution for the variables in the given
; left-hand side of an equation
(define (plug-in left-hand-side sol)
  (foldr + 0 (map (lambda (coef val) (* coef val)) left-hand-side sol)))

(check-expect (plug-in (lhs (first M)) S) (+ (* 2 1) (* 2 1) (* 3 2)))
