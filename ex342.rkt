;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex342) (read-case-sensitive #t) (teachpacks ((lib "abstraction.rkt" "teachpack" "2htdp") (lib "dir.rkt" "teachpack" "htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "abstraction.rkt" "teachpack" "2htdp") (lib "dir.rkt" "teachpack" "htdp")) #f)))
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


; String Dir -> [Maybe Path]
; if there's a file f in the given directory tree, produce its path; otherwise
; produce #false
(define (find f d)
  (local ((define this-dir-name (dir-name d))
          ; Dir -> Boolean
          (define (file-in-dir? dir)
            (member? f (map file-name (dir-files dir))))
          ; [List-of Dir] -> [Maybe Path]
          (define (find-in-dirs lod)
            (first (filter (lambda (item) (not (false? item)))
                           (map (lambda (dir) (find f dir)) lod)))))
    (if (find? f d)
        (cond
          [(file-in-dir? d) (list this-dir-name f)]
          [else (cons this-dir-name (find-in-dirs (dir-dirs d)))])
        #false)))

(check-expect (find "read!" dir-text) #false)
(check-expect (find "read!" dir-code) #false)
(check-expect (find "read!" dir-docs) '("Docs" "read!"))
(check-expect (find "read!" dir-libs) '("Libs" "Docs" "read!"))
(check-expect (find "read!" dir-ts) '("TS" "read!"))


; String Dir -> [List-of Path]
; produces the lists of paths belonging to files named f in the given
; directory tree
(define (find-all f d)
  (local ((define this-dir-name (dir-name d))
          ; Dir -> [List-of Path]
          (define (find-everywhere dir)
            (if (file-in-dir? dir)
                (cons (list f) (find-in-dirs (dir-dirs dir)))
                (find-in-dirs (dir-dirs dir))))
          ; Dir -> Boolean
          (define (file-in-dir? dir)
            (member? f (map file-name (dir-files dir))))
          ; [List-of Dir] -> [List-of Path]
          (define (find-in-dirs lod)
            (filter (lambda (item) (not (false? item)))
                    (foldr append '()
                           (map (lambda (dir) (find-all f dir)) lod)))))
    (if (find? f d)
        (map (lambda (path) (cons this-dir-name path))
             (find-everywhere d))
        '())))

(check-expect (find-all "read!" dir-text) '())
(check-expect (find-all "read!" dir-code) '())
(check-expect (find-all "read!" dir-docs) '(("Docs" "read!")))
(check-expect (find-all "read!" dir-libs) '(("Libs" "Docs" "read!")))
(check-expect (find-all "read!" dir-ts) '(("TS" "read!")
                                          ("TS" "Libs" "Docs" "read!")))



; String Dir -> Boolean
; determines whether a file named n exists in the given directory tree
(define (find? n d)
  (or (member? n (map file-name (dir-files d)))
      (ormap (lambda (sub) (find? n sub)) (dir-dirs d))))
