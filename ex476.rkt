;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex476) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(define-struct transition [current key next])
(define-struct fsm [initial transitions final])
 
; An FSM is a structure:
;   (make-fsm FSM-State [List-of 1Transition] FSM-State)
; A 1Transition is a structure:
;   (make-transition FSM-State 1String FSM-State)
; An FSM-State is String.
 
; data example: see exercise 109
 
(define fsm-a-bc*-d
  (make-fsm
   "AA"
   (list (make-transition "AA" "a" "BC")
         (make-transition "BC" "b" "BC")
         (make-transition "BC" "c" "BC")
         (make-transition "BC" "d" "DD"))
   "DD"))


; FSM String -> Boolean 
; does an-fsm recognize the given string
(define (fsm-match? an-fsm a-string)
  (local ((define initial (fsm-initial an-fsm))
          (define transitions (fsm-transitions an-fsm))
          (define final (fsm-final an-fsm))
          ; FSM-State [List-of 1String] -> Boolean
          ; checks if the given input of characters is recognized
          ; by the FSM, starting from the current state
          (define (fsm-matcher current input)
            (cond
              [(empty? input) #true]
              [(equal? current final) #false]
              [else
               (local ((define next (get-state current (first input))))
                 (if (false? next)
                     #false
                     (fsm-matcher next (rest input))))]))
          ; FSM-State 1String -> [Maybe FSM-State]
          ; tries to retrieve the next state of the FSM given its current
          ; state and the given character
          (define (get-state current key)
            (local ((define result
                      (filter (lambda (t)
                                (and (string=? (transition-current t)
                                               current)
                                     (string=? (transition-key t)
                                               key)))
                              transitions)))
              (if (empty? result)
                  #false
                  (transition-next (first result))))))
    (fsm-matcher initial (explode a-string))))

(check-expect (fsm-match? fsm-a-bc*-d "acbd") #true)
(check-expect (fsm-match? fsm-a-bc*-d "ad") #true)
(check-expect (fsm-match? fsm-a-bc*-d "abcd") #true)
(check-expect (fsm-match? fsm-a-bc*-d "da") #false)
(check-expect (fsm-match? fsm-a-bc*-d "aa") #false)
(check-expect (fsm-match? fsm-a-bc*-d "dd") #false)
(check-expect (fsm-match? fsm-a-bc*-d "abcda") #false)
