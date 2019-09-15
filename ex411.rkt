;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex411) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
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

(define presence2-schema `(,(make-spec "Present" boolean?)
                           ,(make-spec "Description" string?)
                           ,(make-spec "Effect" integer?)))
(define presence2-content `((#true  "presence" 1)
                            (#false "absence" -1)))
(define presence2-db (make-db presence2-schema presence2-content))

(define presence3-schema `(,(make-spec "Present" boolean?)
                           ,(make-spec "Description" string?)))
(define presence3-content `((#true  "presence")
                            (#true  "here")
                            (#false "absence")
                            (#false "there")))
(define presence3-db (make-db presence3-schema presence3-content))

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
          ; Spec -> Boolean
          ; does this column belong to the new schema
          (define (keep? c)
            (member? (spec-label c) labels))
          ; Row -> Row 
          ; retains those columns whose name is in labels
          (define (row-project row)
            (foldr (lambda (cell m c) (if m (cons cell c) c))
                   '() row mask))
          (define mask (map keep? schema)))
    (make-db (filter keep? schema)
             (map row-project content))))

(check-expect (db-content (project school-db '("Name" "Present")))
              projected-content)


; DB [List-of Label] [Row -> Boolean] -> Content
; Produces a list of the rows from db that satisfy the given predicate,
; projected down to the given set of labels
(define (select db labels predicate)
  (filter predicate (db-content (project db labels))))

(check-expect (select school-db
                      '("Name" "Present")
                      (lambda (row) (equal? (second row) #true)))
              `(("Alice" #true)
                ("Carol" #true)))


; DB [List-of Label] -> DB
; Produces a database like db but with its columns reordered according
; to the given list of labels
(define (reorder db lol)
  (local ((define db-labels (map spec-label (db-schema db)))
          (define labels (filter (lambda (l) (member? l db-labels)) lol))
          (define projected-db (project db labels))
          (define schema (db-schema projected-db))
          (define content (db-content projected-db))
          (define schema-labels (map spec-label schema))
          ; Label -> N
          ; Finds the original position of the spec with the given label
          (define (original-pos label)
            (length (rest (memv label (reverse schema-labels)))))
          ; Row -> Row
          ; Reorders the content of the given row according to lol
          (define (reorder-row row)
            (map (lambda (i) (list-ref row (original-pos (list-ref labels i))))
                 (range 0 (length row) 1))))
    (make-db (map (lambda (label) (list-ref schema (original-pos label)))
                  labels)
             (map reorder-row content))))

(check-expect (db-content (reorder presence-db '("Description" "Present")))
              `(("presence" #true)
                ("absence" #false)))
(check-expect (db-content (reorder school-db '("Name" "Present" "Age")))
              `(("Alice" #true  35)
                ("Bob"   #false 25)
                ("Carol" #true  30)
                ("Dave"  #false 32)))
(check-expect (db-content (reorder school-db '("Present" "Name")))
              `((#true "Alice")
                (#false "Bob")
                (#true "Carol")
                (#false "Dave")))
(check-expect (db-content (reorder school-db '("Present" "Name" "Gender")))
              `((#true "Alice")
                (#false "Bob")
                (#true "Carol")
                (#false "Dave")))


; DB DB -> DB
; Consumes two databases with the same schema and produces a new database with
; said schema and the joint content of both, removing duplicates.
(define (db-union db1 db2)
  (local ((define schema1 (db-schema db1))
          (define schema-labels (map spec-label schema1))
          (define content1 (db-content db1))
          (define content2 (db-content db2))
          ; Content -> Content
          ; Removes duplicate entries in the given list of rows
          (define (remove-duplicates rows)
            (foldr (lambda (row rest)
                     (if (member? row rest)
                         rest
                         (cons row rest)))
                   '() rows)))
    (make-db schema1 (remove-duplicates (append content1 content2)))))

(check-satisfied
 (db-content (db-union (make-db school-schema
                                (select school-db
                                        (map spec-label school-schema)
                                        (lambda (row) (>= (second row) 30))))
                       (make-db school-schema
                                (select school-db
                                        (map spec-label school-schema)
                                        (lambda (row) (false? (third row)))))))
 (lambda (rows) (andmap (lambda (row) (member? row school-content)) rows)))
(check-satisfied
 (db-content (db-union (make-db school-schema
                                (select school-db
                                        (map spec-label school-schema)
                                        (lambda (row) (< (second row) 30))))
                       (make-db school-schema
                                (select school-db
                                        (map spec-label school-schema)
                                        (lambda (row)
                                          (equal? (third row) #true))))))
 (lambda (rows) (andmap (lambda (row) (member? row '(("Bob"   25 #false)
                                                     ("Alice" 35 #true)
                                                     ("Carol" 30 #true))))
                        rows)))


; DB DB -> DB
; Consumes two databases db-1 and db-2, and creates a database from db-1 by
; replacing the last cell in each row with the translation of the cell in db-2.
; Assumption: The schema of db-2 starts with the same spec that the schema
; of db-2 ends in.
(define (join db-1 db-2)
  (local ((define schema1 (db-schema db-1))
          (define schema2 (db-schema db-2))
          (define content1 (db-content db-1))
          (define content2 (db-content db-2))
          ; Row -> [List-of Row]
          ; Replaces the last cell of the row with its translations from db-2
          ; Produces '() if no translation is found
          (define (add-translation row-db1)
            (local ((define row-without-last (reverse (rest (reverse row-db1))))
                    (define row-last-cell (first (reverse row-db1)))
                    (define translations-of-last
                      (filter (lambda (row-db2)
                                (equal? row-last-cell (first row-db2)))
                              content2)))
              (if (cons? translations-of-last)
                  (map (lambda (translation)
                         (foldr cons translation row-without-last))
                       (map rest translations-of-last))
                  '()))))
    (make-db (append (reverse (rest (reverse schema1))) (rest schema2))
             (filter (lambda (row) (cons? row))
                     (foldr append '() (map add-translation content1))))))

(check-expect (db-content (join school-db presence-db))
              '(("Alice" 35 "presence")
                ("Bob"   25 "absence")
                ("Carol" 30 "presence")
                ("Dave"  32 "absence")))
(check-expect (db-content (join school-db presence2-db))
              '(("Alice" 35 "presence" 1)
                ("Bob"   25 "absence" -1)
                ("Carol" 30 "presence" 1)
                ("Dave"  32 "absence" -1)))
(check-expect (db-content (join school-db presence3-db))
              '(("Alice" 35 "presence")
                ("Alice" 35 "here")
                ("Bob"   25 "absence")
                ("Bob"   25 "there")
                ("Carol" 30 "presence")
                ("Carol" 30 "here")  
                ("Dave"  32 "absence")
                ("Dave"  32 "there")))
