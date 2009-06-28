      integer function mkdlst(strn,npmx,xp)
C- Resolve ascii string as a vector of double-precision numbers
C ----------------------------------------------------------------
Ci Inputs
Ci   strn: syntax: str1,str2,...  where each str is a number or a range
Ci         of numbers, viz:    n   or   n1:n2   or   n1:n2:n3
Ci         which gets expanded into a vector of double-precision numbers
Ci         n1   or   n1,n1+1,..n2   or   n1,n1+n3,n1+n3+n3,...n2
Ci         Example: 3,2:6:2  becomes a vector of 4 d.p. numbers: 3,2,4,6
Ci   npmx: maximum number of points allowed.
Ci         npmx<0 => mkdlst returns np without filling xp
Co Outputs:
Co   xp(1..) the vector of numbers (read only if npmx>0)
Co   mkdlst: number of points read, or would try to read if npmx>0.
Co           If failed to parse ascii input, returns -1.
Co           If np>npmx and npmx>0, returns -npmx
C ----------------------------------------------------------------
C     implicit none
      integer npmx
      double precision xp(*),dv(30),d1mach,dx
      character*(*) strn
      integer it(30),a2vec,ip,i,j,k,n,iprint,i1mach,np

      ip = 0
      call skipbl(strn,len(strn),ip)
      k = a2vec(strn,len(strn),ip,4,',: ',3,3,30,it,dv)
      mkdlst = -1
      if (k .lt. 1) return
      mkdlst = -npmx
C ... loop over all iv
      np = 0
      i = 0
   14 i = i+1
C ... Case dv => a single number
      if (it(i) .ne. 2) then
        np = np+1
        if (npmx .gt. 0) then
          if (np .gt. npmx) return
          xp(np) = dv(i)
        endif
C ... Case dv => n1:n2[:n3]
      else
        dx = 1
        if (it(i+1) .eq. 2 .and. dv(i+2) .ne. 0) dx = dv(i+2)
        n = int((dv(i+1)-dv(i))*(1+2*d1mach(3))/dx)
        do  12  j = 0, n
          np = np+1
          if (npmx .gt. 0) then
            if (np .gt. npmx) return
            xp(np) = dv(i) + j*dx
          endif
   12   continue
        i = i+1
        if (it(i) .eq. 2) i = i+1
      endif
      if (i .lt. k) goto 14


C --- Entry for np = npmax
   20 continue
      mkdlst = np
      if (iprint() .gt. 100 .and. npmx .gt. 0) call
     .  awrit3(' MKDLST: %i points:%n:1g',' ',100,i1mach(2),np,np,xp)
        
      end
C --- Test of mkdlst ---
C      subroutine fmain
CC      implicit none
C      integer np,npmx,mkdlst
C      parameter (npmx=20)
C      double precision xp(npmx)
C
C      call pshpr(101)
C      np = mkdlst('9,3:5:.2 ',npmx,xp)
C      print *, np
C      end
