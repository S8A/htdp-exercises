;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname stockprice) (read-case-sensitive #t) (teachpacks ((lib "universe.rkt" "teachpack" "2htdp") (lib "image.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "universe.rkt" "teachpack" "2htdp") (lib "image.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp")) #f)))
; ALERT: DOESN'T WORK >:(


;(define PREFIX "https://www.google.com/finance?q=") ; doesn't work anymore
(define PREFIX "https://stockprice.com/ticker/?symbol=")
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
              (make-data (get-stock-price x)
                         (get-stock-delta x))))
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


; For testing
(define a0 '((initial "X"))) 
(define e0 '(machine))
(define e1 `(machine ,a0))
(define e2 '(machine (action)))
(define e3 '(machine () (action)))
(define e4 `(machine ,a0 (action) (action)))
(define amzn
  '(div ((class "qmod-mkt-top"))
        (span ((class "qmod-last")) "$ 1,836.95")
        (span ((class "qmod-change qmod-ch-down")
               (rv-qmodchange= "data.pricedata.change"))
              (span ((class "qmod-change-icon fa fa-arrow-circle-down")
                     (rv-qmodchange-icon= "data.pricedata.change")))
              (span "-6.605")
              (span ((class "qmod-pipe-sep")) " | ")
              (span "-0.36%"))))
(define as1 '(span ((class "qmod-last")) "$ 1,836.95"))
(define as2 '(span ((class "qmod-change qmod-ch-down")
                    (rv-qmodchange= "data.pricedata.change"))
                   (span ((class "qmod-change-icon fa fa-arrow-circle-down")
                          (rv-qmodchange-icon= "data.pricedata.change")))
                   (span "-6.605")
                   (span ((class "qmod-pipe-sep")) " | ")
                   (span "-0.36%")))



; Xexpr.v3 -> String
; gets the current stock price from the given XML document
(define (get-stock-price x)
  (local ((define result (find-by-class x "qmod-last")))
    (if (xexpr? result)
        (first (xexpr-content result))
        (error "not found"))))

(check-error (get-stock-price '(meta ((content "1836") (itemprop "AMZN")))))
(check-expect (get-stock-price amzn) "$ 1,836.95")


; Xexpr.v3 -> String
; gets the last change in stock price from the given XML document
(define (get-stock-delta x)
  (local ((define result (find-by-class x "qmod-change")))
    (if (xexpr? result)
        (first (xexpr-content (second (xexpr-content result))))
        (error "not found"))))

(check-error (get-stock-delta '(meta ((content "1836") (itemprop "AMZN")))))
(check-expect (get-stock-delta amzn) "-6.605")


; Xexpr.v3 String -> [Maybe Xexpr.v3]
; tries to retrieve the first element in the given expression
; that has an attribute "class" with value s
(define (find-by-class xe s)
  (local (; [List-of Xexpr.v3] -> [Maybe Xexpr.v3]
          ; tries to find an element in the list lox whose classname is s
          (define (find-in-list lox)
            (local ((define result
                      (filter xexpr?
                              (map (lambda (x) (find-by-class x s)) lox))))
              (if (empty? result)
                  #false
                  (first result))))
          ; Xexpr.v3 -> [Maybe Xexpr.v3]
          ; checks if the given element's classname is s, or looks in its
          ; content otherwise
          (define (find-in-xml x)
            (local ((define attrs (xexpr-attr x)))
              (cond
                [(empty? attrs) (find-in-list (xexpr-content x))]
                [(cons? attrs)
                 (local ((define class-attr (find-attr 'class attrs))
                         (define correct-classname?
                           (and (string? class-attr)
                                (or (string=? class-attr s)
                                    (string-contains? (string-append s " ")
                                                      class-attr)
                                    (string-contains? (string-append " " s)
                                                      class-attr)))))
                   (if correct-classname?
                       x
                       (find-in-list (xexpr-content x))))]))))
    (cond
      [(symbol? xe) #false]
      [(string? xe) #false]
      [(number? xe) #false]
      [else (find-in-xml xe)])))

(check-expect (find-by-class e4 "qmod-last") #false)
(check-expect (find-by-class amzn "qmod-last") as1)
(check-expect (find-by-class amzn "qmod-change") as2)
(check-expect (find-by-class as1 "qmod-last") as1)
(check-expect (find-by-class as2 "qmod-change") as2)
(check-expect (find-by-class as1 "qmod-change") #false)
(check-expect (find-by-class as2 "qmod-last") #false)


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
    [(cons? x) (local ((define possible-attribute (first x)))
                 (cons? possible-attribute))]
    [else #false]))
