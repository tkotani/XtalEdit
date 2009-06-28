      subroutine  zswap (n,zx,incx,zy,incy)
c
c     interchanges two vectors.
c     Adapted from blas, but avoids complex arithmetic:
c     jack dongarra, 3/11/78.
c
C#ifdefC DCMPLX
C      double complex zx(1),zy(1),ztemp
C#else
      double precision zx(2,1),zy(2,1),ztemp
C#endif
c
      if(n.le.0)return
      if(incx.eq.1.and.incy.eq.1)go to 20
c
c       code for unequal increments or equal increments not equal
c         to 1
c
      ix = 1
      iy = 1
      if(incx.lt.0)ix = (-n+1)*incx + 1
      if(incy.lt.0)iy = (-n+1)*incy + 1
      do 10 i = 1,n
C#ifdefC DCMPLX
C        ztemp = zx(ix)
C        zx(ix) = zy(iy)
C        zy(iy) = ztemp
C#else
        ztemp = zx(1,ix)
        zx(1,ix) = zy(1,iy)
        zy(1,iy) = ztemp
        ztemp = zx(2,ix)
        zx(2,ix) = zy(2,iy)
        zy(2,iy) = ztemp
C#endif
        ix = ix + incx
        iy = iy + incy
   10 continue
      return
c
c       code for both increments equal to 1
   20 do 30 i = 1,n
C#ifdefC DCMPLX
C        ztemp = zx(i)
C        zx(i) = zy(i)
C        zy(i) = ztemp
C#else
        ztemp = zx(1,i)
        zx(1,i) = zy(1,i)
        zy(1,i) = ztemp
        ztemp = zx(2,i)
        zx(2,i) = zy(2,i)
        zy(2,i) = ztemp
C#endif
   30 continue
      return
      end
