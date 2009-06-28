      subroutine yyxcpy(n,ar,ai,xr,xi,incx,yr,yi,incy,sw)
C- Complex daxpy, using real arithmetic and complex conjugate of x
C     implicit none
C Passed parameters
      logical sw
      integer n,incx,incy
      double precision ar,ai,xr(1),xi(1),yr(1),yi(1)
C Local variables
      integer ix,iy,i

      if (n .le. 0) return

C#ifdefC BLAS
C      call daxpy(n, ar,xr,incx,yr,incy)
C      if (sw) then
C        call daxpy(n, ai,xi,incx,yr,incy)
C        call daxpy(n,-ar,xi,incx,yi,incy)
C        call daxpy(n, ai,xr,incx,yi,incy)
C      endif
C#elseifC APOLLO | HP
CC --- Do real * real ---
C      if (incx .eq. 1 .and. incy .eq. 1) then
C        if (ar .ne. 0) then
C          call vec_$dmult_add(yr,xr,n, ar,yr)
C          if (sw) call vec_$dmult_add(yi,xi,n,-ar,yi)
C        endif
C        if (ai .ne. 0 .and. sw) then
C          call vec_$dmult_add(yi,xr,n, ai,yi)
C          call vec_$dmult_add(yr,xi,n, ai,yr)
C        endif
C      else
C        if (ar .ne. 0) then
C          call vec_$dmult_add_i(yr,incy,xr,incx,n, ar,yr,incy)
C          if (sw) call vec_$dmult_add_i(yi,incy,xi,incx,n,-ar,yi,incy)
C        endif
C        if (ai .ne. 0 .and. sw) then
C          call vec_$dmult_add_i(yi,incy,xr,incx,n, ai,yi,incy)
C          call vec_$dmult_add_i(yr,incy,xi,incx,n, ai,yr,incy)
C        endif
C      endif
C#else
      ix = 1
      iy = 1
      if (incx .lt. 0) ix = (1-n)*incx + 1
      if (incy .lt. 0) iy = (1-n)*incy + 1
      if (sw .and. ai .ne. 0) then
        if (ar .ne. 0) then
C     --- Case ar != 0 && ai != 0 ---
          do  10  i = 1, n
            yr(iy) = yr(iy) + ar*xr(ix) + ai*xi(ix)
            yi(iy) = yi(iy) - ar*xi(ix) + ai*xr(ix)
            ix = ix + incx
            iy = iy + incy
   10     continue
        else
C     --- Case ar == 0 && ai != 0 ---
          do  20  i = 1, n
            yr(iy) = yr(iy) + ai*xi(ix)
            yi(iy) = yi(iy) + ai*xr(ix)
            ix = ix + incx
            iy = iy + incy
   20     continue
        endif
      else
        if (ar .eq. 0) return
C     --- Case ar != 0 && ai == 0 ---
        if (sw) then
          do  30  i = 1, n
            yr(iy) = yr(iy) + ar*xr(ix)
            yi(iy) = yi(iy) - ar*xi(ix)
            ix = ix + incx
            iy = iy + incy
   30     continue
        else
          do  40  i = 1, n
            yr(iy) = yr(iy) + ar*xr(ix)
            ix = ix + incx
            iy = iy + incy
   40     continue
        endif        
      endif
C#endif

      end
