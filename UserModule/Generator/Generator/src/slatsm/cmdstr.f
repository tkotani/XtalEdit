      logical function cmdstr(iarg,a)
C- Returns generalized command-line argument iarg
C ----------------------------------------------------------------------
Ci Inputs
Ci   iarg  :return generalized command-line argument i
Co Outputs
Co   a     :argument returned in string a
Co  cmdstr :returns false if iarg is outside the range of arguments
Cr Remarks
Cr   The usual command-line arguments may be enlarged; see cmdopt.f.
Cr   The functionality of cmdstr is similar to that of cmdopt, but
Cr   with a simpler interface.
Cu Updates
C ----------------------------------------------------------------------
C     implicit none
      character*(*) a
      integer iarg,nargc,n1,n2

      cmdstr = .true.
      n1 = nargc()
      if (iarg .lt. n1) then
        call getarf(iarg,a)
      else
        call ncmdop(n2)
        if (iarg .lt. n1+n2) then
          call gcmdop(iarg-n1+1,a)
        else
          cmdstr = .false.
        endif
      endif
      end
      integer function nxargc()
C- Number of generalized command-line arguments
C     implicit none
      integer n,nargc

      call ncmdop(n)
      nxargc = nargc() + n
      end
