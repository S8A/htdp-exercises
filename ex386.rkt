;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex386) (read-case-sensitive #t) (teachpacks ((lib "universe.rkt" "teachpack" "2htdp") (lib "image.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "universe.rkt" "teachpack" "2htdp") (lib "image.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp")) #f)))
(define PREFIX "https://www.google.com/finance?q=") ; doesn't work anymore
(define SIZE 22) ; font size 
 
(define-struct data [price delta])
; A StockWorld is a structure: (make-data String String)
; interpretation (make-data p d) combines the current price
; of some stock and the amount it has changed since the
; last time it was posted
 
; String -> StockWorld
; retrieves the stock price of co and its change every 15s
(define (stock-alert co)
  (local ((define url (string-append PREFIX co))
          ; [StockWorld -> StockWorld]
          ; retrieves new data of the stock from the URL,
          ; discarding the previous information
          (define (retrieve-stock-data __w)
            (local ((define x (read-xexpr/web url)))
              (make-data (get x "price")
                         (get x "priceChange"))))
          ; StockWorld -> Image
          ; renders the current price and the price change of the
          ; stock as an image
          (define (render-stock-data w)
            (local (; [StockWorld -> String] Color -> Image
                    ; creates a text image using a selector for the stock object
                    (define (word sel col)
                      (text (sel w) SIZE col)))
              (overlay (beside (word data-price 'black)
                               (text "  " SIZE 'white)
                               (word data-delta 'red))
                       (rectangle 300 35 'solid 'white)))))
    (big-bang (retrieve-stock-data 'no-use)
      [on-tick retrieve-stock-data 15]
      [to-draw render-stock-data])))


; Xexpr.v3 String -> String
; retrieves the value of the "content" attribute 
; from a 'meta element that has attribute "itemprop"
; with value s
(define (get x s)
  (local ((define result (get-xexpr x s)))
    (if (string? result)
        result
        (error "not found"))))

(check-expect (get '(meta ((content "+1") (itemprop "F"))) "F") "+1")
(check-expect (get '(meta ((content "+0.95") (itemprop "AMZN"))) "AMZN")
              "+0.95")
(check-error (get '(meta ((content "+1") (itemprop "F"))) "MSFT"))
(check-error (get '(meta ((content "+0.95") (itemprop "AMZN"))) "AAPL"))


; Xexpr.v3 String -> [Maybe String]
; tries to retrieve the value of the "content" attribute from
; a 'meta element that has attribute "itemprop" with value s
(define (get-xexpr x s)
  (local (; Get the element's attributes
          (define attrs (xexpr-attr x))
          ; Check if this is a meta element
          (define is-meta? (symbol=? 'meta (xexpr-name x)))
          ; Get its "itemprop" attribute, if any
          (define itemprop-attr (find-attr 'itemprop attrs))
          ; Check if its "itemprop" attribute has value s
          (define correct-itemprop?
            (and (string? itemprop-attr) (string=? itemprop-attr s))))
    (if (and is-meta? correct-itemprop?)
        (find-attr 'content attrs)
        #false)))

(check-expect (get-xexpr '(meta ((content "+1") (itemprop "F"))) "F") "+1")
(check-expect (get-xexpr '(meta ((content "+0.95") (itemprop "AMZN"))) "AMZN")
              "+0.95")
(check-expect (get-xexpr '(meta ((content "+1") (itemprop "F"))) "MSFT") #false)
(check-expect (get-xexpr '(meta ((content "+0.95") (itemprop "AMZN"))) "AAPL")
              #false)


; For testing
(define a0 '((initial "X"))) 
(define e0 '(machine))
(define e1 `(machine ,a0))
(define e2 '(machine (action)))
(define e3 '(machine () (action)))
(define e4 `(machine ,a0 (action) (action)))


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
