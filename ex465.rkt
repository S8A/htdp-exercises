;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex465) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
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

(define N1 '((2 2 3 10)
             (  3 9 21)
             (    1  2)))
(define N2 '((2  2  3   10)
             (   3  9   21)
             (  -3 -8  -19)))


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
(check-expect (check-solution N1 S) #true)
(check-expect (check-solution N2 S) #true)


; [List-of Number] Solution -> Number
; plugs in the numbers from the solution for the variables in the given
; left-hand side of an equation
(define (plug-in left-hand-side sol)
  (local (; [List-of Number] Solution -> Number
          (define (plug-in-helper lhs-reversed sol-reversed)
            (cond
              [(empty? lhs-reversed) 0]
              [(cons? lhs-reversed)
               (+ (* (first lhs-reversed) (first sol-reversed))
                  (plug-in-helper (rest lhs-reversed) (rest sol-reversed)))])))
    (plug-in-helper (reverse left-hand-side) (reverse sol))))

(check-expect (plug-in (lhs (first M)) S) (+ (* 2 1) (* 2 1) (* 3 2)))
(check-expect (plug-in (lhs (second N1)) S) (+ (* 3 1) (* 9 2)))


; Equation Equation -> Equation
; subtracts a multiple of the second equation from the first, item by item,
; so that the resulting equation has a 0 in the first position
; assumes both equations are of the same length
(define (subtract eq1 eq2)
  (local ((define multiple (/ (first eq1) (first eq2))))
    (map (lambda (a1 a2) (- a1 (* multiple a2))) eq1 eq2)))

(check-expect (subtract (second M) (first M)) '(0 3 9 21))
(check-expect (subtract (third M) (first M)) '(0 -3 -8 -19))
