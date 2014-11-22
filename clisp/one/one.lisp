(defun find-cycle (n)
  "Find the number of recurring digits in 1/n"
  (declare (optimize (speed 3))
	   (fixnum n))
  (let ((refs (make-array n :initial-element nil))
	(refs2 (make-array n :initial-element nil)))
    (labels ((outer (i res res2)
	       (declare (optimize (speed 3))
			(fixnum i res res2))
	       (if (aref refs2 i)
		   res2
		   (let ((rems (rem (* 10 i) n)))
		     (if (= 0 rems)
			 0
			 (if (aref refs i)
			     (progn (setf (aref refs2 i) t)
				    (outer rems res (+ 1 res2)))
			     (progn (setf (aref refs i) t)
				    (outer rems (+ 1 res) res2))))))))
      (outer 1 0 0))))

(defun max-cycle (lim)
  "Returns the n in the range 2-lim of which recurring digits achieve maximum"
  (declare (optimize (speed 3))
	   (fixnum lim))
  (labels ((helper (i n res)
	     (declare (optimize (speed 3))
		      (fixnum i n res))
	     (if (> res i)
		 (list n res)
		 (let ((tmp (find-cycle i)))
		   (if (> tmp res)
		       (helper (- i 1) i tmp)
		       (helper (- i 1) n res))))))
    (helper lim lim 0)))

(defun euler28 (lim)
  (declare (optimize (speed 3)) (fixnum lim))
  (labels ((looper (a b res i)
	      (declare (fixnum a b res i))
	      (if (= i lim)
		  res
		  (let ((tempa (+ a (+ 8 (- a b)))))
		    (looper tempa a (+ res (* 4 tempa)) (+ 2 i))))))
    (looper 6 1 25 3)))

(defun prime? (p)
  (declare (optimize (speed 3)) (fixnum p))
  (if (< p 2)
      nil
      (if (= 2 p)
	  t
	  (if (evenp p)
	      nil
	      (let ((lim (isqrt p)))
		(labels ((helper (i)
			   (declare (optimize (speed 3)) (fixnum i))
			   (if (> i lim)
			       t
			       (if (= 0 (rem p i))
				   nil
				   (helper (+ i 2))))))
		  (helper 3)))))))

(defun next-prime (p)
  (declare (optimize (speed 3)) (fixnum p))
  (cond ((= p 2) 3)
	((prime? (+ p 2)) (+ p 2))
	(:otherwise (next-prime (+ p 2)))))

(defun prev-prime (p)
  (declare (optimize (speed 3)) (fixnum p))
  (cond ((<= p 2) nil)
	((= p 3) 2)
	((prime? (- p 2)) (- p 2))
	(:otherwise (prev-prime (- p 2)))))

(defun euler27 (lim)
  (declare (optimize (speed 3)) (fixnum lim))
  (labels ((blooper (b resb)
	     (declare (fixnum b))
	     (labels ((alooper (a cura resa)
			(declare (fixnum a cura resa))
			(labels ((nlooper (n resn)
				   (declare (fixnum n resn))
				   (if (prime? (+ (* n n) (* a n) b))
				       (nlooper (+ 1 n) (+ 1 resn))
				       resn)))
			  (cond
			    ((> a lim)
			     (list resa cura b))
			    ((<= (+ a b 1) 0)
			     (alooper (+ 1 a) cura resa))
			    (:otherwise
			     (let ((resn (nlooper 1 1)))
			       (if (> resn resa)
				   (alooper (+ 2 a) a resn)
				   (alooper (+ 2 a) cura resa))))))))
	       (if (< b (first resb))
		   (* (second resb) (third resb))
		   (let ((tmpres (alooper (- lim) (- lim) 1)))
		     (if (> (first tmpres) (first resb))
			 (blooper (prev-prime b) tmpres)
			 (blooper (prev-prime b) resb)))))))
    (blooper 997 (list 0 0 0))))

(defun euler27b (lim)
  (declare (optimize (speed 3)) (fixnum lim))
  (labels ((blooper (b resb)
	     (declare (fixnum b))
	     (labels ((alooper (a cura resa)
			(declare (fixnum a cura resa))
			(labels ((nlooper (n resn)
				   (declare (fixnum n resn))
				   (if (prime? (+ (* n n) (* a n) b))
				       (nlooper (+ 1 n) (+ 1 resn))
				       resn)))
			  (cond
			    ((< a (- lim))
			     (list resa cura b))
			    ((<= (+ a b 1) 0)
			     (alooper (- a 2) cura resa))
			    (:otherwise
			     (let ((resn (nlooper 1 1)))
			       (if (> resn resa)
				   (alooper (- a 2) a resn)
				   (alooper (- a 2) cura resa))))))))
	       (if (< b (first resb))
		   (* (second resb) (third resb))
		   (let ((tmpres (alooper lim lim 1)))
		     (if (> (first tmpres) (first resb))
			 (blooper (prev-prime b) tmpres)
			 (blooper (prev-prime b) resb)))))))
    (blooper 997 (list 0 0 0))))

(defun sieves (lim)
  (declare (optimize (speed 3)) (fixnum lim))
  (let ((llim (isqrt lim))
	(refs (make-array lim :initial-element t)))
    (labels ((outer (i res)
	       (declare (optimize (speed 3))
			(fixnum i)
			(dynamic-extent res))
	       (labels ((inner (p)
			  (declare (optimize (speed 3))
				   (fixnum p))
			  (if (< p lim)
			      (progn (setf (aref refs p) nil)
				     (inner (+ p (* 2 i))))
			      (+ 2 i))))
		 (if (< i lim)
		     (if (and (<= i llim) (aref refs i))
			 (progn (inner (* i i))
				(outer (+ i 2)
				       (cons i res)))
			 (outer (+ i 2)
				(if (aref refs i)
				    (cons i res)
				    res)))
		     (reverse res)))))
      (outer 3 (list 2)))))

(defun euler27a (lim)
  (declare (optimize (speed 3)) (fixnum lim))
  (reduce '*
	  (rest
	   (first
	    (sort (loop for b in (sieves lim)
		     collect
		       (labels
			   ((outer (a cura res)
			      (declare (fixnum cura res))
			      (if (null a)
				  (list res cura b)
				  (labels ((inner (n resa)
					     (declare (fixnum n resa))
					     (if (prime? (+ (* n n)
							    (* (first a) n)
							    b))
						 (inner (+ 1 n) (+ 1 resa))
						 resa)))
				    (let ((resn (inner 1 1)))
				      (if (> resn res)
					  (outer (rest a) (first a) resn)
					  (outer (rest a) cura res)))))))
			 (outer (remove-if-not
				 #'(lambda (x) (> (+ 1 x b) 0))
				 (loop for m from (- lim) to lim collect m))
				(- lim)
				1)))
		  '> :key 'first)))))
