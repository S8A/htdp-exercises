;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex424) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;                             '(11 9 2 18 12 14 4 1)
;                             /        |            \       
;                   '(9 2 4 1)         11            '(18 12 14)
;                  /       |  \        !            /        |  \
;          '(2 4 1)        9  '()      !     '(12 14)        18 '()
;          /   |   \       !   !       !     /  |  \         !   !
;      '(1)    2   '(4)    !   !       !   '()  12  '(14)    !   !
;      / | \   !   / | \   !   !       !    !   !   / |  \   !   !
;    '() 1 '() ! '() 4 '() !   !       !    !   ! '() 14 '() !   !
;      \ ! /   !   \ ! /   !   !       !    !   !   \ |  /   !   !
;      '(1)    !   '(4)    !   !       !    !   !   '(14)    !   !
;          \   !   /       !   !       !     \  !   /        !   !
;          '(1 2 4)        !   !       !     '(12 14)        !   !
;                   \      /  /        !            \       /   /
;                    '(1 2 4 9)        !             '(12 14 18)
;                              \       !             /
;                               '(1 2 4 9 11 12 14 18)