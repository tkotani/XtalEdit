      subroutine spchar(i,ch)
C- Returns special characters
Ci Inputs
Ci   i=1  return backward slash in ch
Ci   i=2  return tab in ch
Ci   i=2  return newline in ch
Ci Outputs
Co   ch
C     implicit none
      integer i
      character*(1) ch
      character*1 sch*1,tch*1,nch*1

C#ifdefC CRAY
C      data sch /'\'/ tch /'	'/  nch /''/
C#else
      data sch /'\\'/ tch /'\t'/  nch /'\n'/
C#endif

      if (i .eq. 1) ch = sch
      if (i .eq. 2) ch = tch
      if (i .eq. 3) ch = nch

      end
C#ifdefC TEST
C      character ch*1
C      call spchar(1,ch)
C      print 333, 'backslash',ch
C      call spchar(2,ch)
C      print 333, 'tab',ch
C      call spchar(3,ch)
C      print 333, 'newline',ch
C  333 format(a,' :',a1,':')
C      end
C#endif
