;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex301) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(define (insertion-sort alon)
  ; sort: lexical scope ---------------------------------
  (local ((define (sort alon)
            (cond
              [(empty? alon) '()]
              [else
               (add (first alon) (sort (rest alon)))]))
          (define (add an alon)
            (cond
              [(empty? alon) (list an)]
              [else
               (cond
                 [(> an (first alon)) (cons an alon)]
                 [else (cons (first alon)
                             (add an (rest alon)))])])))
    (sort alon))
  ; --------------------------------- sort: lexical scope
  )


;(define (sort alon) ; Generates a name conflict
(define (sort1 alon) ; Solution
  ; sort1: lexical scope --------------------------------
  ; sort2: lexical scope --------------------------------
  (local ((define (sort alon)
            (cond
              [(empty? alon) '()]
              [else
               (add (first alon) (sort (rest alon)))]))
          (define (add an alon)
            (cond
              [(empty? alon) (list an)]
              [else
                (cond
                  [(> an (first alon)) (cons an alon)]
                  [else (cons (first alon)
                              (add an (rest alon)))])])))
    (sort alon))
  ; -------------------------------- sort2: lexical scope
  ; -------------------------------- sort1: lexical scope
  )
