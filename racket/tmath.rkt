#lang typed/racket

(define: (sqr [x : Number]) : Number (* x x))

(define: (prime? [p : Integer])
  : Boolean
  (define: (helper [i : Integer])
      : Boolean
      (if (> (* i i) p)
          true
          (if (= 0 (remainder p i))
              false
              (helper (+ 2 i)))))
    (helper 3))

(: true-prime? (-> Integer Boolean))
(define (true-prime? p)
  (cond ((= 2 p) true)
        ((even? p) false)
        (true (define: (helper (i : Integer))
                : Boolean
                (if (> (* i i) p)
                    true
                    (if (= 0 (remainder p i))
                        false
                        (helper (+ i 2)))))
              (helper 3))))

(define: (next-prime (i : Integer))
  : Integer
  (if (= i 2)
      3
      (if (prime? (+ i 2))
          (+ i 2)
          (next-prime (+ i 2)))))

(define: (sum-primes [lim : Integer])
  : Integer
  (define: (helper [i : Integer] [res : Integer])
    : Integer
    (if (> i lim)
        res
        (if (prime? i)
            (helper (+ i 2) (+ i res))
            (helper (+ i 2) res))))
  (helper 7 10))

(define: limits : Integer (expt 10 1000))

(define: (fibo (lim : Integer))
  : Integer
  (define: (helper (i : Integer) (j : Integer) (idx : Integer))
    : Integer
    (if (> i lim)
        idx 
        (helper (+ i j) i (+ 1 idx))))
  (helper 1 1 1))

(define: (pfactors (n : Integer))
  : (Listof Integer)
  (define: (helper (i : Integer)
                   (p : Integer) 
                   (lasti : Integer)
                   (res : (Listof Integer)))
    : (Listof Integer)
    (if (true-prime? p)
        (if (= p lasti)
            res
            (cons p res))
        (let: ((rems : Integer (remainder p i))
               (divs : Integer (quotient p i)))
          (if (= 0 rems)
              (helper 2 divs i (cons i res))
              (helper (next-prime i) p lasti res)))))
  (helper 2 n 2 (list)))

(define: (count-factors (n : Integer))
  : Integer
    (define: (helper-odd (i : Integer) (res : Integer))
      : Integer
      (if (> (* i i) n)
          res
          (if (= 0 (remainder n i))
              (let: ((divs : Integer (quotient n i)))
                (if (= i divs)
                    (+ 1 res)
                    (helper-odd (+ i 2) (+ 2 res))))
              (helper-odd (+ i 2) res))))
    (define: (helper-even (i : Integer) (res : Integer))
      : Integer
      (if (> (* i i) n)
          res
          (if (= 0 (remainder n i))
              (let: ((divs : Integer (quotient n i)))
                (if (= i divs)
                    (+ 1 res)
                    (helper-even (+ i 1) (+ 2 res))))
              (helper-even (+ i 1) res))))
    (if (even? n)
        (helper-even 2 2)
        (helper-odd 3 2)))

(define: (first-triangle-having-lim-factors (n : Integer) (lim : Integer))
  : (Listof Integer)
  (let: ((triangle : Integer (quotient (* n (+ n 1)) 2)))
    (if (> (count-factors triangle) lim)
        (list n triangle)
        (first-triangle-having-lim-factors (+ 1 n) lim))))

(define: (collatz (n : Integer))
  : Integer
  (if (= n 1)
      1
      (+ 1 (if (even? n)
               (collatz (quotient n 2))
               (collatz (+ 1 (* 3 n)))))))

(define: (max-collatz (start : Integer) (lim : Integer))
  : Integer
  (define: (helper (i : Integer)
                   (res : Integer)
                   (lres : Integer))
    : Integer
    (if (> i lim)
        res
        (let: ((collz : Integer (collatz i)))
          (if (> collz lres)
              (helper (+ 2 i) i collz)
              (helper (+ 2 i) res lres)))))
  (helper start 1 1))

(define: (sum-pdivs (n : Integer))
  : Integer
    (define: (helper-odd (i : Integer) (res : Integer))
      : Integer
      (if (> (* i i) n)
          res
          (if (= 0 (remainder n i))
              (let: ((divs : Integer (quotient n i)))
                (if (= i divs)
                    (+ i res)
                    (helper-odd (+ i 2) (+ i divs res))))
              (helper-odd (+ i 2) res))))
    (define: (helper-even (i : Integer) (res : Integer))
      : Integer
      (if (> (* i i) n)
          res
          (if (= 0 (remainder n i))
              (let: ((divs : Integer (quotient n i)))
                (if (= i divs)
                    (+ i res)
                    (helper-even (+ i 1) (+ i divs res))))
              (helper-even (+ i 1) res))))
    (if (even? n)
        (helper-even 2 1)
        (helper-odd 3 1)))

(define: (sum-amic (lim : Integer))
  : Integer
  (define: (helper (i : Integer) (res : Integer))
    : Integer
    (if (> i lim)
        res
        (let: ((amic : Integer (sum-pdivs i)))
          (if (= i amic)
              (helper (+ 1 i) res)
              (let: ((div-amic : Integer (sum-pdivs amic)))
                (if (= i div-amic)
                    (helper (+ 1 i) (+ i res))
                    (helper (+ 1 i) res)))))))
  (helper 2 0))


















