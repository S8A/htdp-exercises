;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex370) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; .: Data definitions :.

; An Xexpr is a list: 
; – (cons Symbol Body)
; – (cons Symbol (cons [List-of Attribute] Body))
; where Body is short for [List-of Xexpr]
; An Attribute is a list of two items:
;   (cons Symbol (cons String '()))

; An XWord is '(word ((text String))).



; .: Data examples :.

(define a0 '((initial "X")))
 
(define e0 '(machine))
(define e1 `(machine ,a0))
(define e2 '(machine (action)))
(define e3 '(machine () (action)))
(define e4 `(machine ,a0 (action) (action)))

(define w0 '(word ((text ""))))
(define w1 '(word ((text "hello"))))
(define w2 '(word ((text "one"))))
(define w3 '(word ((text "two"))))
(define w4 '(word ((text "world"))))
(define w5 '(word ((text "good bye"))))



; .: Functions :.

; Xexpr -> Boolean
; is xe an XWord
(define (word? xe)
  (local ((define attrs (xexpr-attr xe)))
    (and (symbol=? (xexpr-name xe) 'word)
         (= (length attrs) 1)
         (symbol=? (first (first attrs)) 'text))))

(check-expect (word? e0) #false)
(check-expect (word? e1) #false)
(check-expect (word? e2) #false)
(check-expect (word? e3) #false)
(check-expect (word? e4) #false)
(check-expect (word? w0) #true)
(check-expect (word? w1) #true)
(check-expect (word? w2) #true)
(check-expect (word? w3) #true)
(check-expect (word? w4) #true)
(check-expect (word? w5) #true)


; XWord -> String
; extracts the value of the given word's text attribute
(define (word-text w)
  (find-attr 'text (xexpr-attr w)))

(check-expect (word-text w0) "")
(check-expect (word-text w1) "hello")
(check-expect (word-text w2) "one")
(check-expect (word-text w3) "two")
(check-expect (word-text w4) "world")
(check-expect (word-text w5) "good bye")


; Symbol [List-of Attribute] -> [Maybe String]
; if the given attributes list associates symbol s with a string,
; retrieve the string
(define (find-attr s loa)
  (local ((define matching-attr (assq s loa)))
    (if (cons? matching-attr)
        (second matching-attr)
        #false)))

(check-expect (find-attr 'x '()) #false)
(check-expect (find-attr 'x a0) #false)
(check-expect (find-attr 'initial a0) "X")


; Xexpr -> Symbol
; extracts the tag of the given element representation
(define (xexpr-name xe)
  (first xe))

(check-expect (xexpr-name e0) 'machine)
(check-expect (xexpr-name e1) 'machine)
(check-expect (xexpr-name e2) 'machine)
(check-expect (xexpr-name e3) 'machine)
(check-expect (xexpr-name e4) 'machine)


; Xexpr -> [List-of Attribute]
; retrieves the list of attributes of xe
(define (xexpr-attr xe)
  (local ((define optional-loa+content (rest xe)))
    (cond
      [(empty? optional-loa+content) '()]
      [else (local ((define loa-or-x (first optional-loa+content)))
              (if (list-of-attributes? loa-or-x)
                  loa-or-x
                  '()))])))

(check-expect (xexpr-attr e0) '())
(check-expect (xexpr-attr e1) '((initial "X")))
(check-expect (xexpr-attr e2) '())
(check-expect (xexpr-attr e3) '())
(check-expect (xexpr-attr e4) '((initial "X")))


; Xexpr -> [List-of Xexpr]
; extracts the list of content elements from the given element representation
(define (xexpr-content xe)
  (local ((define optional-loa+content (rest xe)))
    (cond
      [(empty? optional-loa+content) '()]
      [else (if (list-of-attributes? (first optional-loa+content))
                (rest optional-loa+content)
                optional-loa+content)])))

(check-expect (xexpr-content e0) '())
(check-expect (xexpr-content e1) '())
(check-expect (xexpr-content e2) '((action)))
(check-expect (xexpr-content e3) '((action)))
(check-expect (xexpr-content e4) '((action) (action)))


; [List-of Attribute] or Xexpr -> Boolean
; is x a list of attributes
(define (list-of-attributes? x)
  (cond
    [(empty? x) #true]
    [else (local ((define possible-attribute (first x)))
            (cons? possible-attribute))]))
