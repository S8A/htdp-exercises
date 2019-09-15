;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex407) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(define-struct db [schema content])
; A DB is a structure: (make-db Schema Content)
 
; A Schema is a [List-of Spec]
(define-struct spec [label predicate])
; Spec is a structure: (make-spec Label Predicate)
; A Label is a String
; A Predicate is a [Any -> Boolean]
 
; A (piece of) Content is a [List-of Row]
; A Row is a [List-of Cell]
; A Cell is Any
; constraint cells do not contain functions 
 
; integrity constraint In (make-db sch con), 
; for every row in con,
; (I1) its length is the same as sch's, and
; (I2) its ith Cell satisfies the ith Predicate in sch


(define school-schema `(,(make-spec "Name" string?)
                        ,(make-spec "Age" integer?)
                        ,(make-spec "Present" boolean?)))
(define school-content `(("Alice" 35 #true)
                         ("Bob"   25 #false)
                         ("Carol" 30 #true)
                         ("Dave"  32 #false)))
(define school-db (make-db school-schema school-content))
    
(define presence-schema `(,(make-spec "Present" boolean?)
                          ,(make-spec "Description" string?)))
(define presence-content `((#true  "presence")
                           (#false "absence")))
(define presence-db (make-db presence-schema presence-content))

(define projected-content
  `(("Alice" #true)
    ("Bob"   #false)
    ("Carol" #true)
    ("Dave"  #false)))
(define projected-schema `(("Name" ,string?) ("Present" ,boolean?)))
(define projected-db (make-db projected-schema projected-content))


; DB -> Boolean
; do all rows in db satisfy (I1) and (I2)
(define (integrity-check db)
  (local ((define schema  (db-schema db))
          (define content (db-content db))
          (define width   (length schema))
          ; Row -> Boolean 
          ; does row satisfy (I1) and (I2) 
          (define (row-integrity-check row)
            (and (= (length row) width)
                 (andmap (lambda (s c) [(spec-predicate s) c])
                         schema
                         row))))
    (andmap row-integrity-check content)))

(check-expect (integrity-check school-db) #true)
(check-expect (integrity-check presence-db) #true)
(check-expect (integrity-check (make-db school-schema
                                        `(("Alice" 35 #true)
                                          ("Bob" 25)
                                          ("Carol" 30 #true)
                                          ("Dave" 32 #false))))
              #false)


; DB [List-of Label] -> DB
; retains a column from db if its label is in labels
(define (project db labels)
  (local ((define schema  (db-schema db))
          (define content (db-content db))
          (define schema-labels (map spec-label schema))
          ; Spec -> Boolean
          ; does this spec belong to the new schema
          (define (keep? c) (member? (spec-label c) labels))
          ; Row -> Row
          ; retains those columns whose name is in labels
          (define (row-project row)
            (row-filter row schema-labels))
          ; Row [List-of Label] -> Row
          ; retains those cells whose corresponding element 
          ; in names is also in labels
          (define (row-filter row names)
            (foldr (lambda (cell name r)
                     (if (member? name labels)
                         (cons cell r)
                         r))
                   '() row names))
    (make-db (filter keep? schema)
             (map row-project content))))

(check-expect (db-content (project school-db '("Name" "Present")))
              projected-content)
