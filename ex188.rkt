;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname ex188) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp")) #f)))
(define-struct email [from date message])
; An Email Message is a structure: 
;   (make-email String Number String)
; interpretation (make-email f d m) represents text m 
; sent by f, d seconds after the beginning of time
(define ea3 (make-email "Abraham" 300000000 "Que paso bruja?"))
(define eb2 (make-email "Bruce" 200000000
                        "Pretty girl. Bad habit. Don't quote me."))
(define ec1 (make-email "Carol" 100000000
                        "I'm Carol Danvers, nice to meet you."))
(define ed12 (make-email "Dave" 1200000000 "It's pronounced deiv, not da-veh"))
(define ee20 (make-email "Eve" 2000000000 "What could go wrong?"))
(define ef5 (make-email "Felicia" 500000000 "bye too"))
(define eg6 (make-email "Greg" 600000000 "hello world"))
(define eh4 (make-email "Helen" 400000000 "No, I'm not Greek."))


; A ListOfEmails (LOE) is one of:
; - '()
; - (cons Email LOE)


; LOE -> LOE
; sorts a list of emails by their date in descending order
(define (sort-emails-date> loe)
  (cond
    [(empty? loe) '()]
    [else
     (insert-by-date (first loe) (sort-emails-date> (rest loe)))]))

(check-expect (sort-emails-date> (list ea3 eb2 ec1))
              (list ea3 eb2 ec1))
(check-expect (sort-emails-date> (list ec1 eb2 ea3))
              (list ea3 eb2 ec1))
(check-expect (sort-emails-date> (list ed12 ee20 ef5))
              (list ee20 ed12 ef5))


; LOE -> LOE
; sorts a list of emails by their sender's name in descending order
(define (sort-emails-name> loe)
  (cond
    [(empty? loe) '()]
    [else
     (insert-by-name (first loe) (sort-emails-name> (rest loe)))]))

(check-expect (sort-emails-name> (list ea3 eb2 ec1))
              (list ec1 eb2 ea3))
(check-expect (sort-emails-name> (list ec1 eb2 ea3))
              (list ec1 eb2 ea3))
(check-expect (sort-emails-name> (list ee20 ed12 ef5))
              (list ef5 ee20 ed12))


; Email LOE -> LOE
; inserts email p into the sorted list of emails by date
(define (insert-by-date p loe)
  (cond
    [(empty? loe) (list p)]
    [else
     (if (email-date>= p (first loe))
         (cons p loe)
         (cons (first loe) (insert-by-date p (rest loe))))]))

(check-expect (insert-by-date ef5 '()) (list ef5))
(check-expect (insert-by-date ef5 (list eg6)) (list eg6 ef5))
(check-expect (insert-by-date ef5 (list eh4)) (list ef5 eh4))
(check-expect (insert-by-date ed12 (list ee20 ef5))
              (list ee20 ed12 ef5))


; Email LOE -> LOE
; inserts email p into the sorted list of emails by name
(define (insert-by-name p loe)
  (cond
    [(empty? loe) (list p)]
    [else
     (if (string<? (email-from (first loe)) (email-from p))
         (cons p loe)
         (cons (first loe) (insert-by-name p (rest loe))))]))

(check-expect (insert-by-name ef5 '()) (list ef5))
(check-expect (insert-by-name eg6 (list ef5)) (list eg6  ef5))
(check-expect (insert-by-name ef5 (list eh4)) (list eh4 ef5))
(check-expect (insert-by-name ed12 (list ef5 ee20))
              (list ef5 ee20 ed12))


; Email Email -> Boolean
; is player A's score greater than or equal to player B's
(define (email-date>= a b)
  (>= (email-date a) (email-date b)))

(check-expect (email-date>= ef5 eg6) #false)
(check-expect (email-date>= ee20 ed12) #true)

