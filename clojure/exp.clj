(ns euler.exp)

;; (load-file "math.clj")

(defn div? [a b] (zero? (rem a b)))

(declare sieve)

(defn sieve
  [[x & xs]]
  (cons x (lazy-seq (remove #(div? % x) (sieve xs)))))

(defn sieves
  [lim]
  (cons 2 (take-while #(< % lim) (sieve (iterate #(+ 2 %) 3)))))

(defn primes
  [lim]
  (let [tmp (+ 20 (int (Math/sqrt lim)))
        siva (sieves tmp)]
    (loop [p (+ 2 (last siva)) res []]
      (if (> p lim)
        (concat siva res)
        (recur (+ 2 p)
               (if-let [res1 (let [temp (Math/sqrt p)]
                               (loop [[fl & ls] siva]
                                 (if (> fl temp)
                                   p
                                   (if (div? p fl)
                                     nil
                                     (recur ls)))))]
                 (conj res res1)
                 res))))))

(defn removes
  [e ls]
  (remove #(= e %) ls))

(defn elm-permute
  [elm ])

(defn permute
  [ls]
  (loop [l ls res [[]]]
    (if (empty? l)
      res
      (recur (rest ls)
             (mapcat #(elm-permute l %) res)))))

(defn irange
  ([] (iterate inc 0))
  ([i] (take (inc i) (iterate inc 0)))
  ([i j] (take (inc (- j i)) (iterate inc i)))
  ([i j k] (take-while #(<= % j) (iterate #(+ k %) i))))






