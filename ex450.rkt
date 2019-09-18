;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex450) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(define ε 0.000000000001)

; [Number -> Number] Number Number -> Number
; determines R such that f has a root in [R,(+ R ε)]
; assume f is continuous and monotonically increasing
; assume (<= (f left) 0 (f right))
; generative divides interval in half, the root is in one of the two
; halves, picks according to assumption
(define (find-root-mi f left right)
  (local (; Number Number Number Number -> Number
          (define (find-root-helper l r fl fr)
            (cond
              [(<= (- r l) ε) l]
              [else
               (local ((define mid (/ (+ l r) 2))
                       (define f@mid (f mid)))
                 (cond
                   [(<= fl 0 f@mid)
                    (find-root-helper l mid fl f@mid)]
                   [(<= f@mid 0 fr)
                    (find-root-helper mid r f@mid fr)]))])))
    (find-root-helper left right (f left) (f right))))

(check-satisfied (find-root-mi poly 3 6)
                 (lambda (n) (<= (abs (- (poly n) (poly 4))) ε)))


; Number -> Number
(define (poly x)
  (* (- x 2) (- x 4)))
