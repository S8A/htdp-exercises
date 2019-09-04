;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex303) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(lambda (x y)
  ; x: lexical scope ----------
  (+ x (* x y))
  ; ---------- x: lexical scope
  )


(lambda (x y)
  ; x: lexical scope ------------
  (+ x
     ; local x: lexical scope ---
     (local ((define x (* y y)))
       (+ (* 3 x)
          (/ 1 x)))
     ; --- local x: lexical scope
     )
  ; ------------ x: lexical scope
  )


(lambda (x y)
  ; x: lexical scope ----------
  (+ x
     ((lambda (x)
        ; x: lexical scope ----
        (+ (* 3 x)
           (/ 1 x))
        ; ---- x: lexical scope
        )
      (* y y)))
  ; ---------- x: lexical scope
  )
