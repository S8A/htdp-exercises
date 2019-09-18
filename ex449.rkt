;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex449) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(define ε 0.000000000001)

; [Number -> Number] Number Number -> Number
; determines R such that f has a root in [R,(+ R ε)]
; assume f is continuous 
; assume (or (<= (f left) 0 (f right)) (<= (f right) 0 (f left)))
; generative divides interval in half, the root is in one of the two
; halves, picks according to assumption
; termination if S1 is the distance between left and right, S1 is
; divided in half on every iteration until S1 is smaller than or
; equal to ε
(define (find-root f left right)
  (local (; Number Number Number Number -> Number
          (define (find-root-helper l r fl fr)
            (cond
              [(<= (- r l) ε) l]
              [else
               (local ((define mid (/ (+ l r) 2))
                       (define f@mid (f mid)))
                 (cond
                   [(or (<= fl 0 f@mid) (<= f@mid 0 fl))
                    (find-root-helper l mid fl f@mid)]
                   [(or (<= f@mid 0 fr) (<= fr 0 f@mid))
                    (find-root-helper mid r f@mid fr)]))])))
    (find-root-helper left right (f left) (f right))))

(check-satisfied (find-root poly 3 6)
                 (lambda (n) (<= (abs (- (poly n) (poly 4))) ε)))
(check-satisfied (find-root poly 0 6)
                 (lambda (n) (<= (abs (- (poly n) (poly 2))) ε)))


; Number -> Number
(define (poly x)
  (* (- x 2) (- x 4)))
