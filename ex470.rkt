;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex470) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
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
  '((2 2  3 10) ; an Equation 
    (2 5 12 31)
    (4 1 -2  1)))

(define M2 '((2  3  3 8)
             (2  3 -2 3)
             (4 -2  2 4)))

(define M3 '((2 2 2 6)
             (2 2 4 8)
             (2 2 1 2)))
 
(define S '(1 1 2)) ; a Solution

; A TM is an [NEList-of Equation]
; such that the Equations are of decreasing length: 
;   n + 1, n, n - 1, ..., 2. 
; interpretation represents a triangular matrix

(define N1 '((2 2 3 10)
             (  3 9 21)
             (    1  2)))
(define N2 '((2  2  3   10)
             (   3  9   21)
             (  -3 -8  -19)))
(define N3 '((2  3  3   8)
             (  -8 -4 -12)
             (     -5  -5)))


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


; SOE -> TM
; triangulates the given system of equations 
(define (triangulate M)
  (cond
    [(empty? M) '()]
    [else
     (local ((define first-eq (first M))
             (define rest-eqs (rest M)))
       (if (= (first first-eq) 0)
           (if (andmap (lambda (eq) (= (first eq) 0)) rest-eqs)
               (error 'triangulate "all equations start with coefficient 0")
               (triangulate (append rest-eqs (list first-eq))))
           (cons first-eq
                 (triangulate (map (lambda (eq) (rest (subtract eq first-eq)))
                                   rest-eqs)))))]))

(check-expect (triangulate M) N1)
(check-expect (triangulate M2) N3)
(check-error (triangulate M3))


; Equation Solution -> Solution
; solves the given linear equation of n+1 variables, using the solutions
; for the last n variables
(define (solve-equation eq sol)
  (local ((define left-hand-side (lhs eq))
          (define plugged-in-rest (plug-in (rest left-hand-side) sol)))
    (/ (- (rhs eq) plugged-in-rest) (first left-hand-side))))

(check-expect (solve-equation '(1 2) '()) 2)
(check-expect (solve-equation '(3 9 21) '(2)) 1)
(check-expect (solve-equation '(2 2 3 10) '(1 2)) 1)


; TM -> Solution
; produces the solution of the given triangular system of equations
(define (solve soe)
  (foldr (lambda (eq solved-rest)
           (cons (solve-equation eq solved-rest) solved-rest))
         '() soe))

(check-expect (solve N1) S)
(check-expect (solve N3) '(1 1 1))


; SOE -> Solution
; produces the solution of the given system of equations
(define (gauss soe)
  (solve (triangulate soe)))

(check-expect (gauss M) S)
(check-expect (gauss M2) '(1 1 1))
(check-error (gauss M3))
