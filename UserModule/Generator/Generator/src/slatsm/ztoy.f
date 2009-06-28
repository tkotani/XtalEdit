C#define AUTO-ARRAY
C#define F90
      subroutine ztoy(a,lda,nr,nc,lbak)
C- Separates real and imaginary parts of subblock of a complex*16 matrix
C ----------------------------------------------------------------------
Ci Inputs
Ci   a     :the matrix to separate or recombine
Ci   lda   :leading dimension of a
Ci   nr    :number of rows in a
Ci   nc    :number of columns in a
Ci   wk    :real work array of length nr
Ci   lbak  :0 separates real from imaginary, as described in Remarks
Ci         :1 recombines into double complex format
Co Outputs
Co   a     :transformed between complex*16 and real storage; see Remarks
Cr Remarks
Cr   Case lbak=0: 
Cr     Input a is stored in complex*16 format, i.e. 
Cr     a is effectively dimensioned a(2,lda,nc)
Cr       with a(1,*,*) = real part and a(2,*,*) = imaginary part
Cr     Output a is stored with real and imaginary separated by columns
Cr     a is effectively dimensioned a(lda,2,nc)
Cr       with a(*,1,*) = real part and a(*,2,*) = imaginary part
Cr
Cr   Case lbak=1: the process is reversed.
Cu Updates
Cu  20 Jul 1999 changed convention in cases lda>nr
C ----------------------------------------------------------------------
C     implicit none
      integer lda,lbak,nr,nc
      double precision a(1)
C#ifdef AUTO-ARRAY | F90
      double precision wk(nr)
      call ztoy1(a,lda,nr,nc,wk,lbak)
C#elseC
C      integer w(1),owk
C      common /w/ w
C      call defrr(owk,nr)
C      call ztoy1(a,lda,nr,nc,w(owk),lbak)
C      call rlse(owk)
C#endif

      end
      subroutine ztoy1(a,lda,nr,nc,wk,lbak)
C- Separates real and imaginary parts of subblock of a complex*16 matrix
C ----------------------------------------------------------------------
Ci Inputs
Ci   a     :the matrix to separate or recombine
Ci   lda   :leading dimension of a
Ci   nr    :number of rows in a
Ci   nc    :number of columns in a
Ci   wk    :real work array of length nr
Ci   lbak  :0 separates real from imaginary, as described in Remarks
Ci         :1 recombines into double complex format
Co Outputs
Co   a     :transformed between complex*16 and real storage; see Remarks
Cr Remarks
Cr   Case lbak=0: 
Cr     Input a is stored in complex*16 format, i.e. 
Cr     a is effectively dimensioned a(2,lda,nc)
Cr       with a(1,*,*) = real part and a(2,*,*) = imaginary part
Cr     Output a is stored with real and imaginary separated by columns
Cr     a is effectively dimensioned a(lda,2,nc)
Cr       with a(*,1,*) = real part and a(*,2,*) = imaginary part
Cr
Cr   Case lbak=1: the process is reversed.
Cu Updates
Cu  20 Jul 1999 changed convention in cases lda>nr
C ----------------------------------------------------------------------
C     implicit none
      integer lda,lbak,nr,nc
      double precision a(1),wk(nr)
      integer j,k,l,mdim

      mdim = 2*lda
      if (nr .gt. lda) call rx('ztoy: subblock exceeds array dimension')
      if (lbak .ne. 0) goto 20

C --- Separate real and imaginary parts ---
C ..  k is offset to col j, l to imaginary part
      do  10  j = 1, nc
        k = (j-1)*mdim + 1
        l = k + lda
        call dcopy(nr,a(k+1),2,wk,1)
        call dcopy(nr,a(k),2,a(k),1)
        call dcopy(nr,wk,1,a(l),1)
   10 continue
      return

C --- Restore to complex storage ---
   20 continue
      do  30  j = 1, nc
        k = (j-1)*mdim + 1
        l = k + lda
        call dcopy(nr,a(k),1,wk,1)
        call dcopy(nr,a(l),1,a(k+1),2)
        call dcopy(nr,wk,1,a(k),2)
   30 continue

      end
C#ifdefC TEST
C      subroutine fmain
C      double precision a(2,4,2),z(8),aa(16)
C      data a /1d0,11d0,2d0,12d0,3d0,13d0,4d0,14d0,
C     .        5d0,15d0,6d0,16d0,7d0,17d0,8d0,18d0/
C      equivalence(a,aa)
C#ifdefC AUTO-ARRAY | F90
C#elseC
C      integer w(1000)
C      call wkinit(1000)
C#endifC
C      lda = 4
C      nr  = 3
C      nc  = 2
C      call ywrm('(2f12.6)',a,lda,nr,nc)
C      call ztoy(a,lda,nr,nc,z,0)
C      call yprm('(2f12.6)',a,lda,nr,nc)
C      call ztoy(a,lda,nr,nc,z,1)
C      call ywrm('(2f12.6)',a,lda,nr,nc)
C
C      end
C      subroutine ywrm(fmt,s,ns,nr,nc)
C      double precision s(0:1,ns,nc)
C      character*(8) fmt
C      print *, 'complex*16 s'
C      print *, nr, nc
C      do  10  i = 1, nr
C   10 print fmt, (s(0,i,j), j=1,nc)
C      do  20  i = 1, nr
C   20 print fmt, (s(1,i,j), j=1,nc)
C      end
C
C      subroutine yprm(fmt,s,lds,nr,nc)
C      double precision s(lds,2,nc)
C      character*(8) fmt
C      print *, 'real,imaginary parts separated'
C      print *, nr, nc
C      do  10  i = 1, nr
C   10 print fmt, (s(i,1,j), j=1,nc)
C      do  20  i = 1, nr
C   20 print fmt, (s(i,2,j), j=1,nc)
C      end
C#endif
