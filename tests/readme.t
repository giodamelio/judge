  $ source $TESTDIR/scaffold

  $ use <<EOF
  > (use judge)
  > 
  > (defn slow-sort [list]
  >   (case (length list)
  >     0 list
  >     1 list
  >     2 (let [[x y] list] [(min x y) (max x y)])
  >     (do
  >       (def pivot (in list (math/floor (/ (length list) 2))))
  >       (def bigs (filter |(> $ pivot) list))
  >       (def smalls (filter |(< $ pivot) list))
  >       [;(slow-sort smalls) pivot ;(slow-sort bigs)])))
  > 
  > (test (slow-sort [3 1 4 2]))
  > EOF

  $ judge
  ! <dim># script.janet</>
  ! 
  ! <red>(test (slow-sort [3 1 4 2]))</>
  ! <grn>(test (slow-sort [3 1 4 2]) [1 2 3 4])</>
  ! 
  ! 0 passed 1 failed
  [1]

test-error:

  $ use <<EOF
  > (use judge)
  > (test-error (in [1 2 3] 5) "expected integer key in range [0, 3), got 5")
  > EOF
  $ judge
  ! <dim># script.janet</>
  ! 
  ! 1 passed

test-macro:

  $ use <<EOF
  > (use judge)
  > (test-macro (let [x 1] x) (do (def x 1) x))
  > EOF
  $ judge
  ! <dim># script.janet</>
  ! 
  ! 1 passed

test-macro gensyms:

  $ use <<EOF
  > (use judge)
  > (test-macro (and x (+ 1 2)) (if (def <1> x) (+ 1 2) <1>))
  > EOF
  $ judge
  ! <dim># script.janet</>
  ! 
  ! 1 passed
