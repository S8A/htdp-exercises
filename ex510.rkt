;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex510) (read-case-sensitive #t) (teachpacks ((lib "batch-io.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "batch-io.rkt" "teachpack" "2htdp")) #f)))
; N String String -> String
; arranges all the words from the in-f into lines of maximal width w
; and writes them out to out-f
(define (fmt w in-f out-f)
  (write-file out-f (lines->string (arrange-lines w (read-words/line in-f)))))


; [List-of [List-of String]] -> [List-of [List-of String]]
; arranges the given lines into new ones of maximal width w0
(define (arrange-lines w0 lines)
  (local (; [List-of String] -> [List-of [List-of String]]
          ; arranges the given line into new ones of maximal width w0
          (define (arrange-line l)
            (cond
              [(empty? l) '()]
              [(cons? l)
               (local ((define separated (separate-first '() l 0)))
                 (cons (first separated)
                       (arrange-line (first (rest separated)))))]))
          ; [List-of String] -> [List [List-of String] [List-of String]]
          ; separates the first line of maximal width w0 from the rest of the
          ; given line
          ; accumulator fst contains the words that form the first line.
          ; accumulator rst contains the rest of the words.
          ; accumulator w is the width of the first line i.e. the number of
          ; characters in all words of fst plus a space after each one.
          (define (separate-first fst rst w)
            (cond
              [(<= w (add1 w0))
               (cond
                 [(empty? rst) (list (reverse fst) '())]
                 [(cons? rst)
                  (local ((define next (first rst)))
                    (separate-first (cons next fst)
                                    (rest rst)
                                    (+ w (length (explode next)) 1)))])]
              [else (list (reverse (rest fst)) (cons (first fst) rst))])))
    (foldr (lambda (fst rst)
             (append (if (equal? fst '())
                         (list '())
                         fst)
                     rst))
           '() (map arrange-line lines))))

(check-expect (arrange-lines 12
                             '(("hello" "world," "great" "big" "white" "world")
                               ("my" "name" "is" "Samuel")
                               ()
                               ("Cheers.")))
              '(("hello" "world,")
                ("great" "big")
                ("white" "world")
                ("my" "name" "is")
                ("Samuel")
                ()
                ("Cheers.")))


; [List-of [List-of String]] -> String
; converts the given lines into a string
(define (lines->string lines)
  (local (; [List-of String] -> String
          ; converts the given line into a single string ending with a newline
          (define (line->string l)
            (local ((define str
                      (foldr (lambda (fst rst) (string-append fst rst))  "\n"
                             (map (lambda (w) (string-append " " w)) l))))
              (if (string=? str "\n") str (substring str 1)))))
    (foldr string-append "" (map line->string lines))))

(check-expect (lines->string '(("I'm" "not" "attached")
                               ("to" "your" "world")
                               ("nothing" "heals")
                               ("nothing" "grows")
                               ()
                               ("M.M.")))
              (string-append "I'm not attached\n"
                             "to your world\n"
                             "nothing heals\n"
                             "nothing grows\n\n"
                             "M.M.\n"))
