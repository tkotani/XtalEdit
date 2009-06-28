      integer function izamax(n,zx,incx)
c
c     finds the index of element having max. absolute value.
c     Adapted from blas, but avoids complex arithmetic:
c     jack dongarra, 1/15/85.
c     modified 3/93 to return if incx .le. 0.
c
C#ifdefC DCMPLX
C      double complex zx(1)
C#else
      double precision zx(2,1)
C#endif
      double precision smax
      integer i,incx,ix,n
      double precision dcabs1
c
      izamax = 0
      if( n.lt.1 .or. incx.le.0 )return
      izamax = 1
      if(n.eq.1)return
      if(incx.eq.1)go to 20
c
c        code for increment not equal to 1
c
      ix = 1
      smax = dcabs1(zx)
      ix = ix + incx
      do 10 i = 2,n
C#ifdefC DCMPLX
C         if(dcabs1(zx(ix)).le.smax) go to 5
C#else
         if(dcabs1(zx(1,ix)).le.smax) go to 5
C#endif
         izamax = i
C#ifdefC DCMPLX
C         smax = dcabs1(zx(ix))
C#else
         smax = dcabs1(zx(1,ix))
C#endif
    5    ix = ix + incx
   10 continue
      return
c
c        code for increment equal to 1
c
   20 smax = dcabs1(zx)
      do 30 i = 2,n
C#ifdefC DCMPLX
C         if(dcabs1(zx(i)).le.smax) go to 30
C#else
         if(dcabs1(zx(1,i)).le.smax) go to 30
C#endif
         izamax = i
C#ifdefC DCMPLX
C         smax = dcabs1(zx(i))
C#else
         smax = dcabs1(zx(1,i))
C#endif
   30 continue
      return
      end
