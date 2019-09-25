;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex516) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(define-struct lmb [para body])
(define-struct app [fun arg])
; A Lam is one of:
; - a Symbol
; - (make-lmb Symbol Lam)
; - (make-app Lam Lam)

; data examples: Lam
(define ex1 (make-lmb 'x 'x))
(define ex2 (make-lmb 'x 'y))
(define ex3 (make-lmb 'y (make-lmb 'x 'y)))
(define ex4 (make-app (make-lmb 'x (make-app 'x 'x))
                      (make-lmb 'x (make-app 'x 'x))))
(define ex5 (make-app (make-lmb 'x 'x)
                      (make-lmb 'x 'x)))
(define ex6 (make-app (make-app (make-lmb 'y (make-lmb 'x 'y)) (make-lmb 'z 'z))
                      (make-lmb 'w 'w)))


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
              [(symbol? le)
               (list (if (member? le declareds) '*declared '*undeclared)
                     le)]
              [(lmb? le)
               (local ((define para (lmb-para le))
                       (define body (lmb-body le))
                       (define newd (cons para declareds)))
                 (make-lmb para (undeclareds/a body newd)))]
              [(app? le)
               (local ((define fun (app-fun le))
                       (define arg (app-arg le)))
               (make-app (undeclareds/a fun declareds)
                     (undeclareds/a arg declareds)))])))
    (undeclareds/a le0 '())))

(check-expect (undeclareds ex1)
              (make-lmb 'x '(*declared x)))
(check-expect (undeclareds ex2)
              (make-lmb 'x '(*undeclared y)))
(check-expect (undeclareds ex3)
              (make-lmb 'y (make-lmb 'x '(*declared y))))
(check-expect (undeclareds ex4)
              (make-app (make-lmb 'x (make-app '(*declared x) '(*declared x)))
                        (make-lmb 'x (make-app '(*declared x) '(*declared x)))))
(check-expect (undeclareds
               (make-lmb '*undeclared
                         (make-app (make-lmb 'x (make-app 'x '*undeclared))
                                   'y)))
              (make-lmb '*undeclared
                        (make-app (make-lmb 'x
                                            (make-app '(*declared x)
                                                      '(*declared *undeclared)))
                                  '(*undeclared y))))


; Lam -> [List-of Symbol]
; produces the list of all symbols used as λ parameters in a λ term
(define (declareds le)
  (cond
    [(symbol? le) '()]
    [(lmb? le)
     (cons (lmb-para le) (declareds (lmb-body le)))]
    [(app? le)
     (append (declareds (app-fun le)) (declareds (app-arg le)))]))

(check-expect (declareds 'x) '())
(check-expect (declareds 'varname) '())
(check-expect (declareds ex1) '(x))
(check-expect (declareds ex2) '(x))
(check-expect (declareds ex3) '(y x))
(check-expect (declareds ex4) '(x x))
(check-expect (declareds ex5) '(x x))
(check-expect (declareds ex6) '(y x z w))
