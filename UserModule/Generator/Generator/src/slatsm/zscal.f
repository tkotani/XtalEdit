      subroutine  zscal(n,za,zx,incx)
c
c     scales a vector by a constant.
c     jack dongarra, 3/11/78.
C     NB: This version uses no internal complex arithmetic.

c
C#ifdefC DCMPLX
C      double complex za,zx(1)
C#else
      double precision za(2),zx(2,1),tmp
C#endif
      if( n.le.0 .or. incx.le.0 )return
      if(incx.eq.1)go to 20
c
c        code for increment not equal to 1
c
      ix = 1
C     if(incx.lt.0)ix = (-n+1)*incx + 1
      do 10 i = 1,n
C#ifdefC DCMPLX
C        zx(ix) = za*zx(ix)
C#else
        tmp      = za(1)*zx(1,ix) - za(2)*zx(2,ix)
        zx(2,ix) = za(1)*zx(2,ix) + za(2)*zx(1,ix)
        zx(1,ix) = tmp
C#endif
        ix = ix + incx
   10 continue
      return
c
c        code for increment equal to 1
c
   20 do 30 i = 1,n
C#ifdefC DCMPLX
C        zx(i) = za*zx(i)
C#else
        tmp     = za(1)*zx(1,i) - za(2)*zx(2,i)
        zx(2,i) = za(1)*zx(2,i) + za(2)*zx(1,i)
        zx(1,i) = tmp
C#endif
   30 continue
      return
      end
