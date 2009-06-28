      subroutine politg(x,y,np,n,lopt,errmx,yp)
C- Integral by polynomial interpolation of function tabulated on mesh
C ----------------------------------------------------------------
Ci Inputs
Ci    x,y,np: table of x-y pairs and number of points
Ci    n: maximum number of points to interpolate
C     lopt nonzero => evaluate intermediate results in quad precision
Co Outputs
Co    yp: integrated value of y at each x
Co    errmx: estimate of error
C ----------------------------------------------------------------
C     implicit none
      integer np,n,lopt
      double precision x(np),y(np),yp(np),errmx
C Local variables
      integer i,nmax,ip,i0,i1
      parameter (nmax=50)
      double precision c(nmax),xmid,sum

      if (n .gt. nmax) call rx('politg: increase nmax')
      if (n+1 .ge. np) call rx('politg: n ge np')
      if (n .le. 0 .or. np .lt. 1) return
      yp(1) = 0
      errmx = 0
      if (np .eq. 1) return

      do  10  ip = 2, np

C --- Get i0,i1 = left-to-leftmost and rightmost in tableau ---
      xmid = (x(ip)+x(ip-1))/2
      i0 = ip-1
      i1 = ip
      do  2  i = 1, n-1
        if (i0 .eq. 0) then
          i1 = i1+1
        elseif (i1 .eq. np) then
          i0 = i0-1
        elseif (dabs(x(i0)-xmid) .lt. dabs(x(i1+1)-xmid))  then
          i0 = i0-1
        else
          i1 = i1+1
        endif
    2  continue

       call polcof(lopt,x(ip-1),x(i0+1),y(i0+1),n,c)
       sum = c(n)/n
       errmx = errmx + sum*(x(ip)-x(ip-1))**(n+1)
       do  12  i = n-1, 1, -1
   12  sum = c(i)/i + sum*(x(ip)-x(ip-1))
       sum = sum*(x(ip)-x(ip-1))
       yp(ip) = yp(ip-1) + sum

C       print 333, (c(i), i=1,n)
C  333  format(5f15.10)
C       print *, 'sum=',sum

   10 continue

      end
