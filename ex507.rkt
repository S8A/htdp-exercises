;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex507) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; [X Y] [X Y -> Y] Y [List-of X] -> Y
; combines the elements in l0 from right to left using f
; and using e as the base value
(define (f*ldl f e l0)
  (local (; Y [List-of X] -> Y
          ; combines the elements in l from right to left using f
          ; accumulator a is the combination of the elements from l0
          ; not in l and the base value e
          (define (fold/a a l)
            (cond
              [(empty? l) a]
              [else
               (fold/a (f (first l) a) (rest l))])))
    (fold/a e l0)))

(check-expect (f*ldl + 0 '(1 2 3)) (foldl + 0 '(1 2 3)))
(check-expect (f*ldl cons '() '(a b c)) (foldl cons '() '(a b c)))


; N [N -> X] -> [List-of X]
; builds a list of n items by applying f to each natural number in the
; sequence 0,1,...,n-1
(define (build-l*st n f)
  (local (; N [List-of X] -> [List-of X]
          ; builds a list of ni items by applying f to each number in
          ; the sequence
          ; accumulator a contains the result of applying f to each
          ; natural number in the interval [ni,n)
          (define (bl/a ni a)
            (cond
              [(zero? ni) a]
              [else (bl/a (sub1 ni) (cons (f (sub1 ni)) a))])))
    (bl/a n '())))

(check-expect (build-l*st 0 add1) (build-list 0 add1))
(check-expect (build-l*st 3 sqr) (build-list 3 sqr))
(check-expect (build-l*st 9 (lambda (n) (sub1 (sqr (add1 n)))))
              (build-list 9 (lambda (n) (sub1 (sqr (add1 n))))))
