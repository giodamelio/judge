  $ source $TESTDIR/scaffold

Accepting refuses to run if file has been modified:

  $ use test.janet <<EOF
  > (use judge)
  > (deftest "test"
  >   (test 1))
  > (os/sleep 1)
  > EOF

  $ judge test.janet -a &
  $ sleep 0.5
  $ echo "modified" > test.janet
  $ sleep 1
  ! running test: test
  ! <red>- (test 1)</>
  ! <grn>+ (test 1 1)</>
  ! <red>test.janet changed since test runner began; refusing to overwrite</>
  ! 0 passed 1 failed 0 skipped 0 unreachable

Accepting changes on a file preserves the permissions on that file:

  $ use test.janet <<EOF
  > #!/usr/bin/env janet
  > (use judge)
  > (test 1 2)
  > EOF

  $ chmod 523 test.janet
  $ stat -c '%A' test.janet
  -r-x-w--wx

  $ judge test.janet --accept >/dev/null
  [1]

  $ stat -c '%A' test.janet
  -r-x-w--wx
  $ rm -f test.janet
