;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex290) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp")) #f)))
; [X] [List-of X] [List-of X] -> [List-of X]
; Appends list2 to list1 using foldr
(check-expect ((lambda (list1 list2) (foldr cons list2 list1))
               (list 1 2 3) (list 4 5 6 7 8))
              (list 1 2 3 4 5 6 7 8))

; Q: What happens if you replace foldr with foldl?
; A: It will append list2 to the reverse of list1
(check-expect ((lambda (list1 list2) (foldl cons list2 list1))
               (list 1 2 3) (list 4 5 6 7 8))
              (list 3 2 1 4 5 6 7 8))


; [List-of Number] -> Number
; Computes the sum of the numbers in the list
(check-expect ((lambda (l) (foldr + 0 l)) '(4 5 6 7 8)) 30)


; [List-of Number] -> Number
; Computes the product of the numbers in the list
(check-expect ((lambda (l) (foldr * 1 l)) '(4 5 6 7 8)) 6720)



(define im1 (circle 10 "solid" "red"))
(define im2 (circle 20 "solid" "blue"))
(define im3 (circle 15 "solid" "gold"))
(define im4 (square 10 "solid" "blue"))
(define im5 (square 15 "solid" "red"))
(define im6 (square 20 "solid" "gold"))
(define lim1 `(,im1 ,im2 ,im3))
(define lim2 `(,im4 ,im5 ,im6))

; Q: With one of the fold functions, you can define a function
; that horizontally composes a list of Images. Which one is it?
; A: foldr

; [List-of Image] -> Image
; Stacks the images from the given list horizontally.
(check-expect ((lambda (l) (foldr beside empty-image l)) lim1)
              (beside im1 (beside im2 (beside im3 empty-image))))
(check-expect ((lambda (l) (foldr beside empty-image l)) lim2)
              (beside im4 (beside im5 (beside im6 empty-image))))

; Q: Can you use the other fold function?
; A: Yes, but we have to reverse the list first.
(check-expect ((lambda (l) (foldl beside empty-image (reverse l))) lim1)
              (beside im1 (beside im2 (beside im3 empty-image))))
(check-expect ((lambda (l) (foldl beside empty-image (reverse l))) lim2)
              (beside im4 (beside im5 (beside im6 empty-image))))


; Also define a function that stacks a list of images vertically.

; [List-of Image] -> Image
; Stacks the images from the given list vertically.
(check-expect ((lambda (l) (foldr above empty-image l)) lim1)
              (above im1 (above im2 (above im3 empty-image))))
(check-expect ((lambda (l) (foldr above empty-image l)) lim2)
              (above im4 (above im5 (above im6 empty-image))))
