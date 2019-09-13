;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex372) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp")) #f)))
; .: Data definitions :.

; An Xexpr is a list:
; – XWord
; – (cons Symbol Body)
; – (cons Symbol (cons [List-of Attribute] Body))
; where Body is short for [List-of Xexpr]
; An Attribute is a list of two items:
;   (cons Symbol (cons String '()))

; An XWord is '(word ((text String))).

; An XEnum.v1 is one of: 
; – (cons 'ul [List-of XItem.v1])
; – (cons 'ul (cons Attributes [List-of XItem.v1]))
; An XItem.v1 is one of:
; – (cons 'li (cons XWord '()))
; – (cons 'li (cons Attributes (cons XWord '())))

; Q: Argue that every element of XEnum.v1 is also in XExpr.
; A: To prove that every element of XEnum.v1 is also in Xexpr, we have to
; prove that all clauses in the former's definition match any of the second's.
; The first clause of the definition of XEnum.v1 is a
; (cons Symbol [List-of XItem.v1]); to prove that this is an Xexpr we have to
; prove that [List-of XItem.v1] is also a [List-of Xexpr]. Therefore, we have
; to prove that any XItem.v1 is also an Xexpr. The first clause in the
; definition of XItem.v1 is a (cons Symbol [List-of Xexpr]), which matches
; the first clause of the definition of Xexpr. The second clause in the
; definition of XItem.v1 is a
; (cons Symbol (cons [List-of Attribute] [List-of Xexpr])), which matches the
; second clause of the definition of Xexpr. Thus, we have proved that any
; XItem.v1 is also an Xexpr and, consequently, the first clause of the
; definition of XEnum.v1 matches the first clause of the definition of Xexpr.
; Moving on to the second clause of XEnum.v1, we have an instance of
; (cons Symbol (cons [List-of Attribute] [List-of Xexpr])), which matches
; the second clause of the definition of Xexpr. As both clauses of the
; definition of XEnum.v1 match the definition of Xexpr, we can claim with
; absolute confidence that all elements of XEnum.v1 are also in Xexpr.



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

(define en0 `(ul (li ,w2) (li ,w3)))



; .: Constants :.

(define BT (circle 2 "solid" "black"))
(define en0-rendered
  (above/align
   'left
   (beside/align 'center BT (text "one" 12 'black))
   (beside/align 'center BT (text "two" 12 'black))))



; .: Functions :.

; XItem.v1 -> Image
; renders an item as a "word" prefixed by a bullet
(define (render-item1 i)
  (local ((define content (xexpr-content i))
          (define element (first content))
          (define a-word (word-text element))
          (define item (text a-word 12 'black)))
    (beside/align 'center BT item)))

(check-expect (render-item1 `(li ,w0))
              (beside/align 'center BT (text "" 12 'black)))
(check-expect (render-item1 `(li ,w1))
              (beside/align 'center BT (text "hello" 12 'black)))
(check-expect (render-item1 `(li ,w2))
              (beside/align 'center BT (text "one" 12 'black)))

; Q: Explain how the function works
; A: First, it extracts the content of the list item (li) element.
; Second, since the list item is guaranteed to contain only one element,
; extract it. Third, because the element is guaranteed to be an XWord,
; extract its text. Fourth, create a graphical version of the text.
; Finally, attach a bullet point to the left of the graphical text item.


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
