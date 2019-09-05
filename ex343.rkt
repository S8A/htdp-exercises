;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex343) (read-case-sensitive #t) (teachpacks ((lib "abstraction.rkt" "teachpack" "2htdp") (lib "dir.rkt" "teachpack" "htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "abstraction.rkt" "teachpack" "2htdp") (lib "dir.rkt" "teachpack" "htdp")) #f)))
(define file-part1 (make-file "part1" 99 ""))
(define file-part2 (make-file "part2" 52 ""))
(define file-part3 (make-file "part3" 17 ""))
(define file-hang (make-file "hang" 8 ""))
(define file-draw (make-file "draw" 2 ""))
(define file-docs-read (make-file "read!" 19 ""))
(define file-ts-read (make-file "read!" 10 ""))
(define dir-text (make-dir "Text" '() (list file-part1 file-part2 file-part3)))
(define dir-code (make-dir "Code" '() (list file-hang file-draw)))
(define dir-docs (make-dir "Docs" '() (list file-docs-read)))
(define dir-libs (make-dir "Libs" (list dir-code dir-docs) '()))
(define dir-ts (make-dir "TS" (list dir-text dir-libs) (list file-ts-read)))
(define path-part1 '("Text" "part1"))
(define path-part2 '("Text" "part2"))
(define path-part3 '("Text" "part3"))
(define path-hang '("Libs" "Code" "hang"))
(define path-draw '("Libs" "Code" "draw"))
(define path-docs-read '("Libs" "Docs" "read!"))
(define path-ts-read '("read!"))


; Dir -> [List-of Path]
; lists the paths of all files and directories in a given directory tree
(define (ls-R d)
  (local ((define files-paths ; [List-of Path]
            (map (lambda (f) (list (file-name f))) (dir-files d)))
          (define dirs-file-paths ; [List-of Path]
            (foldr append '()
                   (map (lambda (dir)
                          (map (lambda (result) (cons (dir-name dir) result))
                               (ls-R dir)))
                        (dir-dirs d)))))
    (append dirs-file-paths files-paths)))

(check-satisfied (ls-R dir-text) (lambda (l)
                                   (andmap (lambda (p) (member? p l))
                                           `(,(rest path-part1)
                                             ,(rest path-part2)
                                             ,(rest path-part3)))))
(check-satisfied (ls-R dir-code) (lambda (l)
                                   (andmap (lambda (p) (member? p l))
                                           `(,(rest (rest path-hang))
                                             ,(rest (rest path-draw))))))
(check-expect (ls-R dir-docs) `(,(rest (rest path-docs-read))))
(check-satisfied (ls-R dir-libs) (lambda (l)
                                   (andmap (lambda (p) (member? p l))
                                           `(,(rest path-hang) ,(rest path-draw)
                                             ,(rest path-docs-read)))))
(check-satisfied (ls-R dir-ts) (lambda (l)
                                 (andmap (lambda (p) (member? p l))
                                         `(,path-part1 ,path-part2 ,path-part3
                                           ,path-hang ,path-draw
                                           ,path-docs-read
                                           ,path-ts-read))))


; Path Path -> Boolean
; does path 1 come before path 2 (lexicographically)
(define (path-name<? path1 path2)
  (local (; Path -> String
          (define (path-name p)
            (foldr (lambda (parent child) (string-append parent "/" child))
                   "" p)))
    (string<? (path-name path1) (path-name path2))))

(check-expect (path-name<? path-hang path-part1) #true)
(check-expect (path-name<? path-hang path-draw) #false)
