      subroutine dpadd(a,b,n1,n2,fac)
C- Adds fac*vector into another vector
      double precision a(1),b(1),fac

      if (fac .eq. 1) then
        do  10  i = n1, n2
   10   a(i) = a(i) + b(i)
      else
        do  20  i = n1, n2
   20   a(i) = a(i) + fac*b(i)
      endif
      end
