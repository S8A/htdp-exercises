;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex375) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp")) #f)))
; .: Data definitions :.

; An Xexpr is a list:
; – XWord
; – (cons Symbol Body)
; – (cons Symbol (cons [List-of Attribute] Body))
; where Body is short for [List-of Xexpr]
; An Attribute is a list of two items:
;   (cons Symbol (cons String '()))

; An XWord is '(word ((text String))).

; An XItem.v2 is one of: 
; – (cons 'li (cons XWord '()))
; – (cons 'li (cons [List-of Attribute] (list XWord)))
; – (cons 'li (cons XEnum.v2 '()))
; – (cons 'li (cons [List-of Attribute] (list XEnum.v2)))
; 
; An XEnum.v2 is one of:
; – (cons 'ul [List-of XItem.v2])
; – (cons 'ul (cons [List-of Attribute] [List-of XItem.v2]))



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
(define en1 `(ul (li ,w1) (li ,en0) (li ,w4) (li ,w5)))



; .: Constants :.

(define SIZE 12) ; font size 
(define COLOR "black") ; font color 
(define BT ; a graphical constant 
  (beside (circle 1 'solid 'black) (text " " SIZE COLOR)))

(define en0-rendered
  (above/align 'left
               (beside/align 'center BT (text "one" SIZE COLOR))
               (beside/align 'center BT (text "two" SIZE COLOR))))

(define en1-rendered
  (above/align 'left
               (beside/align 'center BT (text "hello" SIZE COLOR))
               (beside/align 'center BT en0-rendered)
               (beside/align 'center BT (text "world" SIZE COLOR))
               (beside/align 'center BT (text "good bye" SIZE COLOR))))



; .: Functions :.

; Image -> Image
; marks item with bullet  
(define (bulletize item)
  (beside/align 'center BT item))


; XEnum.v2 -> Image
; renders an XEnum.v2 as an image 
(define (render-enum xe)
  (local ((define content (xexpr-content xe))
          ; XItem.v2 Image -> Image 
          (define (deal-with-one item so-far)
            (above/align 'left (render-item item) so-far)))
    (foldr deal-with-one empty-image content)))

(check-expect (render-enum en0) en0-rendered)
(check-expect (render-enum en1) en1-rendered)


; Edit the function definition so that the wrap-around appears once
; in each clause.

; XItem.v2 -> Image
; renders one XItem.v2 as an image 
(define (render-item an-item)
  (local ((define content (first (xexpr-content an-item))))
    (cond
      [(word? content) (bulletize (text (word-text content) SIZE 'black))]
      [else (bulletize (render-enum content))])))

(check-expect (render-item `(li ,w0))
              (beside/align 'center BT (text "" SIZE COLOR)))
(check-expect (render-item `(li ,w1))
              (beside/align 'center BT (text "hello" SIZE COLOR)))
(check-expect (render-item `(li ,w2))
              (beside/align 'center BT (text "one" SIZE COLOR)))
(check-expect (render-item `(li ,en0))
              (beside/align 'center BT en0-rendered))

; Q: Why are you confident that your change works?
; A: Because both clauses apply functions that produce images and after the
; change we are still applying bulletize to the result of either one.

; Q: Which version do you prefer?
; A: The original because it's shorter to write and expresses the intent of
; the function in a more straightforward manner.


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
