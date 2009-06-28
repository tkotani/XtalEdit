      integer function idamax(n,dx,incx)
c
c     finds the index of element having max. abs. value.  Adapted from:
c     jack dongarra, linpack, 3/11/78.
c
      double precision dx(1),dmax
      integer i,incx,ix,n
c
      idamax = 0
      if ( n .lt. 1 ) return
      idamax = 1
      if ( n .eq. 1 ) return
C#ifdefC APOLLO
C      if (incx .eq. 1) then
C        call vec_$dmax(dx,n,dmax,idamax)
C      else
C        call vec_$dmax_i(dx,inc,n,dmax,idamax)
C      endif
C#else
      ix = 1
      dmax = dabs(dx(1))
      ix = ix + incx
      do  10  i = 2, n
         if (dabs(dx(ix)) .le. dmax) goto 5
         idamax = i
         dmax = dabs(dx(ix))
    5    ix = ix + incx
   10 continue
C#endif
      end
