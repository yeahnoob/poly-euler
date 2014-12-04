(defun div (a m )
  (declare (optimize (speed 3)))
  (truncate (/ a m)))

(defun div? (a m)
  (zerop (rem a m)))

(defun frequencies (lsm)
  (let ((sls (sort lsm '<)))
    (labels ((helper (ls p i res1 res)
	       (if (null ls)
		   (cons (list p i) (cons res1 res))
		   (if (= p (first ls))
		       (helper (rest ls) p (1+ i) res1 res)
		       (helper (rest ls)
			       (first ls) 1
			       (list p i)
			       (cons res1 res))))))
      (butlast (helper (rest sls) (first sls) 1 nil nil)))))

(defun numcol (n)
  (declare (optimize (speed 3))
	   (fixnum n))
  (labels ((looper (i res)
	      (declare (fixnum i))
	      (if (< i 10)
		  (cons i res)
		  (looper (div i 10)
		     (cons  (rem i 10) res )))))
    (looper n nil)))

(defun range (i j k)
  (declare (optimize (speed 3))
	   (fixnum i j k))
  (if (< i j)
      (loop for m from i to j by k collect m)
      (loop for m from i downto j by k collect m)))

(defun take (n ls)
  (declare (optimize (speed 3))
	   (fixnum n))
  (if (= n 0) '() (cons (first ls) (take (- n 1) (rest ls)))))

(defun drop (n ls)
  (declare (optimize (speed 3))
	   (fixnum n))
  (if (= n 0) ls (drop (- n 1) (rest ls))))

(defun permutations (ls)
  (declare (optimize (speed 3)))
  (if (= 1 (length ls))
      (mapcar 'list ls)
      (loop for i in ls
	 append (loop for rs in (permutations (remove i ls))
		   collect (cons i rs)))))

(defun colnum (ls)
  (declare (optimize (speed 3)))
  (labels ((looper (ls res)
	      (if (null ls)
		  res
		  (looper (rest ls) (+ (* res 10) (first ls))))))
    (looper ls 0)))

(defun permute (n ls)
  (declare (optimize (speed 3))
	   (fixnum n))
  (if (= 1 n)
      (mapcar 'list ls)
      (mapcan #'(lambda (s)
		  (mapcar #'(lambda (x)
			      (cons s x))
			  (permute (- n 1) (remove s ls)))) ls)))

(defun iterate (fn i gn)
  "Returns non-lazy iterate while (gn i) is false"
  (if (funcall gn i)
      nil
      (cons i (iterate fn (funcall fn i) gn))))

(defun take-while (fn ls)
  "Returns the elements of ls starting from first while (fn elmt) is true"
  (if (null ls)
      ls
      (if (not (funcall fn (first ls)))
	  nil
	  (cons (first ls) (take-while fn (rest ls))))))


(defun drop-while (fn ls)
  "Returns the elements of ls starting from first while (fn elmt) is true"
  (if (null ls)
      ls
      (if (funcall fn (first ls))
	  (drop-while fn (rest ls))
	  ls)))

(defun group-by (fn ls)
  (declare (optimize (speed 3)))
  (labels ((looper (lls res)
	      (if (null lls)
		  res
		  (let* ((tmp (funcall fn (first lls)))
			 (pasukan (remove-if-not
				   #'(lambda (x) (equal (funcall fn x) tmp))
				   lls)))
		    (looper (set-difference lls pasukan)
		       (cons (list tmp pasukan) res))))))
    (looper ls nil)))

(defparameter ref-sumpdivs
  (make-array 1000001 :initial-element nil))

(defun sum-pdivs (n)
  (declare (optimize (speed 3)) (fixnum n))
  (let ((lim (isqrt n)))
    (labels ((helper-even (i res)
	       (declare (optimize (speed 3)) (fixnum i res))
	       (if (> i lim)
		   res
		   (if (zerop (rem n i))
		       (let ((divs (div n i)))
			 (if (= i divs)
			     (+ i res)
			     (helper-even (+ i 1) (+ i divs res))))
		       (helper-even (+ i 1) res))))
	     (helper-odd (i res)
	       (declare (optimize (speed 3)) (fixnum i res))
	       (if (> i lim)
		   res
		   (if (zerop (rem n i))
		       (let ((divs (div n i)))
			 (if (= i divs)
			     (+ i res)
			     (helper-odd (+ i 2) (+ i divs res))))
		       (helper-odd (+ i 2) res)))))
      (if (> n 1000000)
	  1
	  (let ((tmp (aref ref-sumpdivs n)))
	    (if tmp tmp
		(if (oddp n)
		    (setf (aref ref-sumpdivs n) (helper-odd 3 1))
		    (setf (aref ref-sumpdivs n) (helper-even 2 1)))))))))

(defparameter refamic
  (make-array 1000001 :initial-element nil))

(defun amic-chain (n)
  (declare (optimize (speed 3))
	   (fixnum n))
  (labels ((looper (i res)
	      (declare (fixnum i))
	      (let ((num (sum-pdivs i)))
		(cond ((= i num)
		       (if (second res)
			   (progn (loop for m in (second res)
				     do (setf (aref refamic m)
					      (first res)))
				  (if (= 1 (first (second res)))
				      res
				      (list (first res)
					    (append (second res) '(1)))))
			   (setf (aref refamic i) 1)))
		      ((> i 1000000)
		       (progn (loop for m in (second res)
				 do (setf (aref refamic m)
					  1))
			      (if (= 1 (first (second res)))
				  res
				  (list (first res)
					(append (second res) '(1))))))
		      ((second res)
		       (if (or (= i 1) (= (first (second res)) i))
			   (progn (loop for m in (second res)
				     do (setf (aref refamic m)
					      (first res)))
				  (if (= 1 (first (second res)))
				      res
				      (list (first res)
					    (append (second res) '(1)))))
			   (looper num
				(list (1+ (first res))
				      (append (second res) (list i))))))
		      (:else
		       (looper num
			    (list (1+ (first res))
				  (append (second res) (list i)))))))))
    (let ((num (aref refamic n)))
      (if num num (looper n (list 0 nil))))))

(defun longest-amic (lim)
  (declare (optimize (speed 3))
	   (fixnum lim))
  (progn (loop for i from 1 to lim
	    do (amic-chain i))
	 (let ((res 0)
	       (ires 0))
	   (loop for i from 1 to lim
	      for m = (aref refamic i)
	      when m
	      do (if (> m res)
		     (progn (setf res m)
			    (setf ires i)))
	      finally (return (list ires res))))))

(defun psqr? (n)
  (let ((num (sqrt n)))
    (= (ceiling num) (floor num))))

(defun finda (howmany?)
  (labels ((inner (b n res)
	     (let ((det (- (* 16 b b) (* 4 n))))
	       (if (< det 0)
		   res
		   (let ((dets (sqrt det)))
		     (if (psqr? dets)
			 (let ((a1 (/ (+ (* 4 b) dets) 2))
			       (a2 (/ (- (* 4 b) dets) 2)))
			   (inner b (1+ n)
				  (if (> a2 b)
				      (cons (list n a1 a2) res)
				      (cons (list n a1) res))))
			 (inner b (1+ n) res))))))
	   (looper (b res)
	      (if (= (length res) howmany?)
		  res
		  (looper (1+ b)
		     (inner b nil nil)))))
    (looper 1 nil)))

(defun efactors (n)
  (declare (optimize (speed 3))
	   (fixnum n))
  (let ((step (if (evenp n) 1 2)))
    (labels ((looper (i res)
		(declare (fixnum i))
		(if (>= (* i i) n)
		    (if (= (* i i) n)
			(if (div? (+ i i) 4)
			    (cons (list i i) res)
			    res)
			res)
		    (if (= 0 (rem n i))
			(looper (+ i step)
			   (let ((num (/ n i)))
			     (if (div? (+ num i) 4)
				 (cons (list i num) res)
				 res)))
			(looper (+ i step) res)))))
      (let ((facts (if (evenp n)
		       (looper 2 (if (div? (1+ n) 4)
				     (list (list 1 n))
				     nil))
		       (looper 3 (if (div? (1+ n) 4)
				     (list (list 1 n))
				     nil)))))
	facts))))

(defun findb (n a)
  (declare (fixnum n a))
  (/ (+ (/ n a) a) 4))

(defun euler135 (target lim)
  (declare (optimize (speed 3))
	   (fixnum target lim))
  (labels ((inner (xs)
	     (reduce '+ (mapcar
			 #'(lambda (x) (let ((b (/ (+ (first x) (second x)) 4)))
				    (if (and (> (first x) b)
					     (not (= (first x) (second x)))) 2 1)))
			 xs)))
	   (looper (i res)
	      (declare (fixnum i))
	      (if (>= i lim)
		  res
		  (let ((num (efactors i)))
		    (if (< (length num) (/ target 2))
			(looper (1+ i) res)
			(let ((tmp (inner num)))
			  (if (= tmp target)
			      (looper (1+ i) (1+ res))
			      (looper (1+ i) res))))))))
    (looper 3 0)))



(defun efactors136 (n)
  (declare (optimize (speed 3))
	   (fixnum n))
  (let ((step (if (evenp n) 1 2)))
    (labels ((looper (i res)
		(declare (fixnum i))
		(if (> (length res) 1)
		    nil
		    (if (>= (* i i) n)
			(if (= (* i i) n)
			    (if (div? (+ i i) 4)
				(cons (list i i) res)
				res)
			    res)
			(if (= 0 (rem n i))
			    (looper (+ i step)
			       (let ((num (/ n i)))
				 (if (div? (+ num i) 4)
				     (cons (list i num) res)
				     res)))
			    (looper (+ i step) res))))))
      (let ((facts (if (evenp n)
		       (looper 2 (if (div? (1+ n) 4)
				     (list (list 1 n))
				     nil))
		       (looper 3 (if (div? (1+ n) 4)
				     (list (list 1 n))
				     nil)))))
	facts))))

(defun euler136 (lim)
  (declare (optimize (speed 3))
	   (fixnum  lim))
  (labels ((looper (i res)
	      (declare (fixnum i))
	      (if (>= i lim)
		  res
		  (let ((num (efactors136 i)))
		    (if num
			(let* ((tmp (first num))
			       (b (/ (+ (first tmp) (second tmp)) 4)))
			  (if (<= (first tmp) b)
			      (looper (1+ i) (1+ res))
			      (looper (1+ i) res)))
			(looper (1+ i) res))))))
    (looper 3 0)))



(defun euler135a (target lim)
  (declare (optimize (speed 3))
	   (fixnum target lim))
  (labels ((looper (n res)
	      (declare (fixnum n))
	      (labels ((inner (i res)
			 (declare (fixnum i res))
			 (let* ((a (/ n i))
				(b (/ (+ i a) 4)))
			   (if (>= b a)
			       res
			       (if (div? (+ a i) 4)
				   (inner (1+ i) (1+ res))
				   (inner (1+ i) res))))))
		(if (> n lim)
		    res
		    (let ((tmp (inner 1 0)))
		      (if (= tmp target)
			  (looper (1+ n) (1+ res))
			  (looper (1+ n) res)))))))
    (looper 3 0)))

(defun sol135b (target lim)
  (declare (optimize (speed 3))
	   (fixnum target lim))
  (let ((refs (make-array lim :initial-element 0))
	(lims (sqrt lim)))
    (labels ((looper (i)
		(declare (fixnum i))
		(labels ((inner (d)
			   (if (<= d 0)
			       nil
			       (let* ((num (* i d))
				      (b (/ (+ i d) 4)))
				 ))))
		  (if (> i lims)
		      (loop for m from 3 to lim
			 when (= target (aref refs m))
			 collect m)
		      (progn (inner (- (* 4 (div (* 2 i) 4)) i))
			     (looper (1+ i))))))))))

(defun expts (a m)
  (declare (optimize (speed 3)))
  (if (= 0 m)
      1
      (if (= 0 (rem m 2))
	  (rem (expts (* a a) (div m 2)) 100000000)
	  (rem (* a (rem (expts (* a a) (div (1- m) 2)) 100000000)) 100000000))))


(defun hexp (a m)
  (declare (optimize (speed 3)))
  (if (= 1 m)
      a
      (if (evenp m)
	  (rem (hexp (expts a a) (div m 2)) 100000000)
	  (rem (expts a (rem (hexp (expt a a) (div (1- m) 2)) 100000000))
	       100000000))))









