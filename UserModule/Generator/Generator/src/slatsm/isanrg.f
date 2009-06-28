      logical function isanrg(i,i1,i2,t1,t2,lreqd)
C- Sanity check for integer value
C ----------------------------------------------------------------------
Ci Inputs
Ci   i     :quantity to be checked
Ci   i1    :test passes if i>=i1
Ci   i2    :test passes if i<=i2
Ci   tol   :allowed tolerance in f, if bounds f2-f1=0
Ci   t1    :first part of error message string, if check fails
Ci   t2    :second part of error message string, if check fails
Ci   lreqd :F, error message printed as warning; isanrg returns
Ci         :T, error message printed; isanrg aborts
Co Outputs
Co   message output to lgunit(1) if check fails
Cu Updates
C ----------------------------------------------------------------------
C     implicit none
      logical lreqd
      integer i,i1,i2,lgunit,iprint,k1,k2
      character*(*) t1,t2
      character*80 strn,strn2
      isanrg = .false.
      if (i.ge.i1 .and. i.le.i2) return
      isanrg = .true.
      if (i1 .eq. i2) then
        strn2 = t1 // ' unexpected value %i for ' // t2 //
     .    ' ... expected %i'
      else
        strn2 = t1 // ' unexpected value %i for ' // t2 //
     .    ' (valid range %i to %i)'
      endif
      call awrit3(strn2,strn,len(strn2),0,i,i1,i2)
      if (lreqd) then
        call strip(strn,k1,k2)
        call rx(strn(k1:k2))
      endif
      if (iprint() .gt. 0) call awrit0(strn,' ',-len(strn),lgunit(1))
      end

      subroutine fsanrg(f,f1,f2,tol,t1,t2,lreqd)
C- Sanity check for double precision value
C ----------------------------------------------------------------------
Ci Inputs
Ci   f     :quantity to be checked
Ci   f1    :(case f2-f1>0) test passes if f>=f1
Ci         :(case f2-f1=0) test passes if f>=f1-tol/2
Ci   f2    :(case f2-f1>0) test passes if f<=f2
Ci         :(case f2-f1=0) test passes if f<=f2+tol/2
Ci   tol   :allowed tolerance in f, if bounds f2-f1=0
Ci   t1    :first part of error message string, if check fails
Ci   t2    :second part of error message string, if check fails
Ci   lreqd :F, error message printed as warning; fsanrg returns
Ci         :T, error message printed; fsanrg aborts
Co Outputs
Co   message output to lgunit(1) if check fails
Cu Updates
Cu   06 Aug 01 Added argument tol (altered argument list)
C ----------------------------------------------------------------------
C     implicit none
C ... Passed parameters
      logical lreqd
      double precision f,f1,f2,tol
      character*(*) t1,t2
C ... Local parameters
      character*80 strn,strn2
      integer lgunit,k1,k2,iprint

      if (f.ge.f1 .and. f.le.f2) return
      if (f1 .eq. f2 .and. f.ge.f1-tol/2 .and. f.le.f2+tol/2) return

      if (f1 .eq. f2) then
        strn2 = t1 // ' unexpected value %g for ' // t2 //
     .    ' ... expected %g'
      else
        strn2 = t1 // ' unexpected value %g for ' // t2 //
     .    ' (valid range %g to %g)'
      endif
      call awrit3(strn2,strn,len(strn),0,f,f1,f2)
      if (lreqd) then
        call strip(strn,k1,k2)
        call rx(strn(k1:k2))
      endif
      if (iprint() .gt. 0) call awrit0(strn,' ',-len(strn),lgunit(1))
      end
