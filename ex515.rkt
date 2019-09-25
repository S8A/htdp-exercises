;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex515) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; A Lam is one of: 
; – a Symbol
; – (list 'λ (list Symbol) Lam)
; – (list Lam Lam)

; data examples: Lam
(define ex1 '(λ (x) x))
(define ex2 '(λ (x) y))
(define ex3 '(λ (y) (λ (x) y)))
(define ex4 '((λ (x) (x x)) (λ (x) (x x))))
(define ex5 '((λ (x) x) (λ (x) x)))
(define ex6 '(((λ (y) (λ (x) y)) (λ (z) z)) (λ (w) w)))


; Lam -> Lam 
; marks all symbols s in le0 with '*undeclared
; if they do not occur within the body of a λ 
; expression whose parameter is s, or with '*declared
; if they do occur
(define (undeclareds le0)
  (local (; Lam [List-of Symbol] -> Lam
          ; accumulator declareds is a list of all λ 
          ; parameters on the path from le0 to le
          (define (undeclareds/a le declareds)
            (cond
              [(is-var? le)
               (list (if (member? le declareds) '*declared '*undeclared)
                     le)]
              [(is-λ? le)
               (local ((define para (λ-para le))
                       (define body (λ-body le))
                       (define newd (cons para declareds)))
                 (list 'λ (list para)
                   (undeclareds/a body newd)))]
              [(is-app? le)
               (local ((define fun (app-fun le))
                       (define arg (app-arg le)))
               (list (undeclareds/a fun declareds)
                     (undeclareds/a arg declareds)))])))
    (undeclareds/a le0 '())))

(check-expect (undeclareds ex1) '(λ (x) (*declared x)))
(check-expect (undeclareds ex2) '(λ (x) (*undeclared y)))
(check-expect (undeclareds ex3) '(λ (y) (λ (x) (*declared y))))
(check-expect (undeclareds ex4) '((λ (x) ((*declared x) (*declared x)))
                                  (λ (x) ((*declared x) (*declared x)))))
(check-expect (undeclareds '(λ (*undeclared) ((λ (x) (x *undeclared)) y)))
              '(λ (*undeclared)
                 ((λ (x) ((*declared x) (*declared *undeclared)))
                  (*undeclared y))))


; Any -> Boolean
; is expr a variable Lam
(define (is-var? expr)
  (symbol? expr))

(check-expect (is-var? 'x) #true)
(check-expect (is-var? 'varname) #true)
(check-expect (is-var? ex1) #false)
(check-expect (is-var? ex2) #false)
(check-expect (is-var? ex3) #false)
(check-expect (is-var? ex4) #false)
(check-expect (is-var? ex5) #false)
(check-expect (is-var? ex6) #false)


; Any -> Boolean
; is expr a λ Lam
(define (is-λ? expr)
  (and (cons? expr)
       (is-var? (first expr))
       (cons? (rest expr))
       (cons? (first (rest expr)))
       (is-var? (first (first (rest expr))))
       (cons? (rest (rest expr)))))

(check-expect (is-λ? 'x) #false)
(check-expect (is-λ? 'varname) #false)
(check-expect (is-λ? ex1) #true)
(check-expect (is-λ? ex2) #true)
(check-expect (is-λ? ex3) #true)
(check-expect (is-λ? ex4) #false)
(check-expect (is-λ? ex5) #false)
(check-expect (is-λ? ex6) #false)


; Any -> Boolean
; is expr a Lam application
(define (is-app? expr)
  (and (cons? expr)
       (or (is-var? (first expr)) (is-λ? (first expr)) (is-app? (first expr)))
       (cons? (rest expr))
       (or (is-var? (first (rest expr)))
           (is-λ? (first (rest expr)))
           (is-app? (first (rest expr))))))

(check-expect (is-app? 'x) #false)
(check-expect (is-app? 'varname) #false)
(check-expect (is-app? ex1) #false)
(check-expect (is-app? ex2) #false)
(check-expect (is-app? ex3) #false)
(check-expect (is-app? ex4) #true)
(check-expect (is-app? ex5) #true)
(check-expect (is-app? ex6) #true)


; Lam[is-λ?] -> Symbol
; extracts the parameter from a λ expression
(define (λ-para le)
  (first (first (rest le))))

(check-expect (λ-para ex1) 'x)
(check-expect (λ-para ex2) 'x)
(check-expect (λ-para ex3) 'y)


; Lam[is-λ?] -> Lam
; extracts the body from a λ expression
(define (λ-body le)
  (first (rest (rest le))))

(check-expect (λ-body ex1) 'x)
(check-expect (λ-body ex2) 'y)
(check-expect (λ-body ex3) '(λ (x) y))


; Lam[is-app?] -> Lam
; extracts the function from an application
(define (app-fun le)
  (first le))

(check-expect (app-fun ex4) '(λ (x) (x x)))
(check-expect (app-fun ex5) '(λ (x) x))
(check-expect (app-fun ex6) '((λ (y) (λ (x) y)) (λ (z) z)))


; Lam[is-app?] -> Lam
; extracts the argument from an application
(define (app-arg le)
  (first (rest le)))

(check-expect (app-arg ex4) '(λ (x) (x x)))
(check-expect (app-arg ex5) '(λ (x) x))
(check-expect (app-arg ex6) '(λ (w) w))


; Lam -> [List-of Symbol]
; produces the list of all symbols used as λ parameters in a λ term
(define (declareds le)
  (cond
    [(is-var? le) '()]
    [(is-λ? le)
     (cons (λ-para le) (declareds (λ-body le)))]
    [(is-app? le)
     (append (declareds (app-fun le)) (declareds (app-arg le)))]))

(check-expect (declareds 'x) '())
(check-expect (declareds 'varname) '())
(check-expect (declareds ex1) '(x))
(check-expect (declareds ex2) '(x))
(check-expect (declareds ex3) '(y x))
(check-expect (declareds ex4) '(x x))
(check-expect (declareds ex5) '(x x))
(check-expect (declareds ex6) '(y x z w))
