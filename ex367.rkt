;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex367) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; An Xexpr.v2 is a list: 
; – (cons Symbol Body)
; – (cons Symbol (cons [List-of Attribute] Body))
; where Body is short for [List-of Xexpr.v2]
; An Attribute is a list of two items:
;   (cons Symbol (cons String '()))

; Xexpr.v2 -> [List-of Attribute]
; retrieves the list of attributes of xe
(define (xexpr-attr xe)
  (local ((define optional-loa+content (rest xe))
          ; [List-of Xexpr.v2] -> [List-of [List-of Attribute]]
          (define (body-attr b) (map xexpr-attr b)))
    (cond
      [(empty? optional-loa+content) ...]
      [else (... (first optional-loa+content)
             ... (body-attr (rest optional-loa+content)) ...)])))

; Q: Explain why the finished parsing function does not contain
; [the self-reference].
; A: Because we only care about the attributes of the given Xexpr, not about the
; attributes of each of the Xexprs in its body. Therefore, we only check if the
; first element after the tag name is a list of attributes and, if so, produce
; it as the result.
