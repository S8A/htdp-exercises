;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex400) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; A Nucleotide is one of: 'a, 'c, 'g, 't
; A DNA-sequence is a [List-of Nucleotide]

; .: Before simplification :.

; DNA-sequence DNA-sequence -> Boolean
; checks if the given DNA search string starts with the given DNA pattern
(define (DNAprefix pattern search)
  (cond
    [(and (empty? pattern) (empty? search)) #true]
    [(and (empty? pattern) (cons? search)) #true]
    [(and (cons? pattern) (empty? search)) #false]
    [(and (cons? pattern) (cons? search))
     (and (equal? (first pattern) (first search))
          (DNAprefix (rest pattern) (rest search)))]))

(check-expect (DNAprefix '() '()) #true)
(check-expect (DNAprefix '() '(a t c g)) #true)
(check-expect (DNAprefix '(a t c) '()) #false)
(check-expect (DNAprefix '(a t c) '(a t c g)) #true)
(check-expect (DNAprefix '(t c) '(a t c g)) #false)


; DNA-sequence DNA-sequence -> [Maybe Nucleotide]
; Returns the first item in the search string beyond the pattern
(define (DNAdelta pattern search)
  (cond
    [(and (empty? pattern) (empty? search))
     (error 'DNAdelta "no element after end of pattern")]
    [(and (empty? pattern) (cons? search)) (first search)]
    [(and (cons? pattern) (empty? search)) #false]
    [(and (cons? pattern) (cons? search))
     (if (equal? (first pattern) (first search))
         (DNAdelta (rest pattern) (rest search))
         #false)]))

(check-error (DNAdelta '() '()))
(check-expect (DNAdelta '() '(a t c g)) 'a)
(check-expect (DNAdelta '(a t c) '()) #false)
(check-expect (DNAdelta '(a t c) '(a t c g)) 'g)
(check-error (DNAdelta '(a t c g) '(a t c g)))
(check-expect (DNAdelta '(t c) '(a t c g)) #false)


; .: After simplification :.

; DNA-sequence DNA-sequence -> Boolean
; checks if the given DNA search string starts with the given DNA pattern
(define (dna-prefix pattern search)
  (cond
    [(empty? pattern) #true]
    [(and (cons? pattern) (empty? search)) #false]
    [(and (cons? pattern) (cons? search))
     (and (equal? (first pattern) (first search))
          (dna-prefix (rest pattern) (rest search)))]))

(check-expect (dna-prefix '() '()) #true)
(check-expect (dna-prefix '() '(a t c g)) #true)
(check-expect (dna-prefix '(a t c) '()) #false)
(check-expect (dna-prefix '(a t c) '(a t c g)) #true)
(check-expect (dna-prefix '(t c) '(a t c g)) #false)


; DNA-sequence DNA-sequence -> [Maybe Nucleotide]
; Returns the first item in the search string beyond the pattern
(define (dna-delta pattern search) ; can't be simplified
  (cond
    [(and (empty? pattern) (empty? search))
     (error 'dna-delta "no element after end of pattern")]
    [(and (empty? pattern) (cons? search)) (first search)]
    [(and (cons? pattern) (empty? search)) #false]
    [(and (cons? pattern) (cons? search))
     (if (equal? (first pattern) (first search))
         (dna-delta (rest pattern) (rest search))
         #false)]))

(check-error (dna-delta '() '()))
(check-expect (dna-delta '() '(a t c g)) 'a)
(check-expect (dna-delta '(a t c) '()) #false)
(check-expect (dna-delta '(a t c) '(a t c g)) 'g)
(check-error (dna-delta '(a t c g) '(a t c g)))
(check-expect (dna-delta '(t c) '(a t c g)) #false)
