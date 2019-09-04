;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex319) (read-case-sensitive #t) (teachpacks ((lib "abstraction.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "abstraction.rkt" "teachpack" "2htdp")) #f)))
; .: Data definitions :.
; An Atom is one of: 
; – Number
; – String
; – Symbol

; An S-expr is one of: 
; – Atom
; – SL

; An SL is one of: 
; – '()
; – (cons S-expr SL)

; .: Data examples :.
(define a1 'hello)
(define a2 20.12)
(define a3 "world")
(define se1 '())
(define se2 '(hello 20.12 "world"))
(define se3 '((hello 20.12 "world")))



; S-expr Symbol Symbol -> S-expr
; Replaces old with new in the given s-expression
(define (substitute s old new)
  (local (; Atom -> Atom
          (define (substitute-atom at)
            (cond
              [(symbol? at) (if (symbol=? at old) new at)]
              [else at]))
          ; SL -> SL
          (define (substitute-sl sl)
            (cond
              [(empty? sl) '()]
              [(cons? sl)
               (cons (substitute (first sl) old new)
                     (substitute-sl (rest sl)))])))
    (cond
      [(atom? s) (substitute-atom s)]
      [else (substitute-sl s)])))

(check-expect (substitute se1 'world 'hello) se1)
(check-expect (substitute se2 'world 'hello) se2)
(check-expect (substitute se3 'world 'hello) se3)
(check-expect (substitute 'world 'world 'hello) 'hello)
(check-expect (substitute '(world hello) 'world 'hello) '(hello hello))
(check-expect (substitute '(((world) hello) hello) 'world 'hello)
              '(((hello) hello) hello))


; Any -> Boolean
; Checks if x is an Atom
(define (atom? x)
  (or (number? x) (string? x) (symbol? x)))

(check-expect (atom? 69420) #true)
(check-expect (atom? "Meshuggah") #true)
(check-expect (atom? 'x) #true)
(check-expect (atom? '()) #false)
(check-expect (atom? #true) #false)
