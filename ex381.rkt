;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex381) (read-case-sensitive #t) (teachpacks ((lib "universe.rkt" "teachpack" "2htdp") (lib "image.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "universe.rkt" "teachpack" "2htdp") (lib "image.rkt" "teachpack" "2htdp")) #f)))
; An XMachine is a nested list of this shape:
;   (list 'machine (list (list 'initial FSM-State)) [List-of X1T])
; An X1T is a nested list of this shape:
;   (list 'action (list (list 'state FSM-State) (list 'next FSM-State)))


; An XMachine is a nested list of this shape:
;   (cons 'machine
;         (cons (cons (cons 'initial (cons FSM-State '())) '())
;                (cons [List-of X1T] '())))
; An X1T is a nested list of this shape:
;   (cons 'action
;         (cons (cons (cons 'state (cons FSM-State '())) '())
;               (cons (cons 'next (cons FSM-State '())) '())))
