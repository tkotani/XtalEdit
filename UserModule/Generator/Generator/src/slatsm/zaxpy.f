      subroutine zaxpy(n,za,zx,incx,zy,incy)
c
c     Adapted from blas, but avoids complex arithmetic
c     constant times a vector plus a vector.
c     jack dongarra, 3/11/78.
c
C#ifdefC DCMPLX
C      double complex zx(1),zy(1),za
C#else
      double precision za(2),zx(2,1),zy(2,1)
C#endif
      double precision dcabs1
      if(n.le.0)return
      if (dcabs1(za) .eq. 0.0d0) return
      if (incx.eq.1.and.incy.eq.1)go to 20
c
c        code for unequal increments or equal increments
c          not equal to 1
c
      ix = 1
      iy = 1
      if(incx.lt.0)ix = (-n+1)*incx + 1
      if(incy.lt.0)iy = (-n+1)*incy + 1
      do 10 i = 1,n
C#ifdefC DCMPLX
C        zy(iy) = zy(iy) + za*zx(ix)
C#else
        zy(1,iy) = zy(1,iy) + za(1)*zx(1,ix) - za(2)*zx(2,ix)
        zy(2,iy) = zy(2,iy) + za(1)*zx(2,ix) + za(2)*zx(1,ix)
C#endif
        ix = ix + incx
        iy = iy + incy
   10 continue
      return
c
c        code for both increments equal to 1
c
   20 do 30 i = 1,n
C#ifdefC DCMPLX
C        zy(i) = zy(i) + za*zx(i)
C#else
        zy(1,i) = zy(1,i) + za(1)*zx(1,i) - za(2)*zx(2,i)
        zy(2,i) = zy(2,i) + za(1)*zx(2,i) + za(2)*zx(1,i)
C#endif
   30 continue
      end
