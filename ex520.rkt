;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname ex520) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; Q: The solve* function generates all states reachable with n boat trips
; before it looks at states that require n + 1 boat trips, even if some of
; those boat trips return to previously encountered states. Because of this
; systematic way of traversing the tree, solve* cannot go into an infinite
; loop. Why?
; A: Let's say that some state is at level n on the game tree if n boat trips
; are required to reach it. The alternative to the aforementioned way of
; generating the next states is to traverse each path that starting from a
; given n level state before checking the other n-level states. The problem
; with that strategy is that the program would have to check all paths that
; lead to dead-ends and loops all the way to their ends before moving on to
; the next n-level branch. By generating all n level states before generating
; the n+1 level states we are able to find the right path without wasting
; resources in many wrong ones.
