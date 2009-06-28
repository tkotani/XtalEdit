      subroutine dpdot(a,b,n,sum)
C     implicit none

      integer n,i
      double precision a(1),b(1),sum
C#ifdefC APOLLO | HP
C      double precision vec_$ddot
C      sum = vec_$ddot(a,b,n)
C#elseifC CRAY
C      sum = sdot(n,a,1,b,1)
C#elseifC BLAS
C      sum = ddot(n,a,1,b,1)
C#else
      sum = 0d0
      do  10  i = 1, n
   10 sum = sum + a(i)*b(i)
C#endif
      end
