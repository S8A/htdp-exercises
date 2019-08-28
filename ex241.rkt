;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname ex241) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp") (lib "web-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp") (lib "batch-io.rkt" "teachpack" "2htdp") (lib "web-io.rkt" "teachpack" "2htdp")) #f)))
; A [NEList-of ITEM] is one of:
; - (list ITEM)
; - (cons ITEM [NEList-of ITEM])


; [NEList-of Temperature]
; A NEList-of-Temperatures is one of:
; - (list Temperature)
; - (cons Temperature NE-List-of-Temperatures)


; [NEList-of Boolean]
; A NEList-of-Booleans is one of:
; - (list Boolean)
; - (cons Boolean NE-List-of-Booleans)
