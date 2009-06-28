      subroutine dspbmm(mode,i1,i2,j1,j2,nc,a,lda,ija,offs,x,ldx,b,ldb)
C- Sparse-block-matrix dense-matrix multiply
C ----------------------------------------------------------------------
Ci Inputs
Ci   mode  :1s digit
Ci          0  multiply contents into b
Ci          1  add product  a x to existing contents of b
Ci          2  add product -a x to existing contents of b
Ci   i1,i2 :calculate a(i,j)*x(j) for row subblocks i = i1..i2
Ci   j1,j2 :calculate a(i,j)*x(j) for col subblocks j = j1..j2
Ci   nc    :number of columns in x and the result matrix b
Ci   a     :sparse matrix, stored in block form by rows.
Ci          a consists of a vector of matrix subblocks:
Ci          a(*,*,i) = matrix subblock i
Ci   lda   :leading dimension of a
Ci   ija   :column index packed array pointer data to array a
Ci         ija(1,*) follows essentially the same conventions
Ci         as for scalar packed arrays (see da2spr)
Ci         except that indices now refer to matrix subblocks.
Ci         ija(1,1)= n+2, where n = max(number of rows, number of cols)
Ci         ija(1,i), i = 1,..n+1 = points to first entry in a for row i
Ci         ija(1,i), i = n+2... column index element a(i).  Thus
Co                   for row i, k ranges from ija(i) <= k < ija(i+1) and
Co                   sum_j a_ij x_j -> sum_k a_(ija(2,k)) x_(ija(1,k))
Ci         ija(2,*)  pointers to the matrix subblocks blocks in a:
Ci         ija(2,i), i=1..n  pointers to blocks on the diagonal of a
Ci         ija(2,i), i=n+2.. pointers to elements of a, grouped by rows
Ci   offs  :offsets to first entries in matrix subblocks
Ci          offs(i,i=1..n) offset to first row in x and b for subblock i
Ci          Thus the dimension of row i = offs(i+1) - offs(i)
Ci          If a consists of scalar subblocks, offs(i) = i-1.
Ci   x     :dense matrix, and second operand
Ci   ldx   :leading dimension of x
Co Outputs
Co   b     :result matrix
Co   ldb   :leading dimension of b
Cr Remarks
Cr   This routine multiplies a sparse matrix whose elements
Cr   are matrix subblocks, by a dense matrix.
Cu Updates
C ----------------------------------------------------------------------
C     implicit none
C ... Passed parameters
      integer i1,i2,j1,j2,nc,lda,ldb,ldx,ija(2,*),offs(i2),mode
      double precision a(lda,lda,1),x(ldx,nc),b(ldb,nc)
C ... Local parameters
      integer ir,k,pa,ofxb,ofbb,nra,nca,ic,i,j,n
      double precision alp
C     integer ofx,ofb

C --- Setup ---
      call isanrg(mode,0,2,'dspbmm:','mode',.true.)
      alp = 1
      if (mode .eq. 2) alp = -1
C     offsets shifting origin of x and b.
C     ofx = 0
C     ofb = 0

C --- Initialize contents of b ---
      if (mode .eq. 0) then
C       do  6  i = offs(i1)-ofb+1, offs(i2+1)-ofb
        do  6  j = 1, nc
        do  6  i = offs(i1)+1, offs(i2+1)
          b(i,j) = 0
    6   continue
      endif

C --- For each row ir, multiply a(ir,ic) x(ic) ---
      do  10  ir = i1, i2
C       offset to b for this subblock
C       ofbb = offs(ir) - ofb
        ofbb = offs(ir)
C       row dimension of this subblock
        nra = offs(ir+1) - offs(ir)
C       pointer to diagonal subblock in a
        pa  = ija(2,ir)

C   ... b(ir) += a(ir)*x(ir).  Skip if missing diagonal element
        if (pa .ne. 0 .and. ir .ge. j1 .and. ir .le. j2) then
C         offset to x for this subblock
C         ofxb = offs(ir) - ofx
          ofxb = offs(ir)
          call dgemm('N','N',nra,nc,nra,alp,a(1,1,pa),lda,
     .      x(1+ofxb,1),ldx,1d0,b(ofbb+1,1),ldb)
        endif

C  ...  b(ir) = b(ir) + a(ir,ija(k))*x(ija(k)) for nonzero blocks in a
        do  11  k = ija(1,ir), ija(1,ir+1)-1
C         column index to a and row index to x
          ic  = ija(1,k)
          if (ic .lt. j1 .or. ic .gt. j2) goto 11
C         offset to row x for this subblock
C         ofxb = offs(ic) - ofx
          ofxb = offs(ic)
C         col dimension of subblock a and row dimension of x
          nca = offs(ic+1) - offs(ic)
C         pointer to subblock in a
          pa = ija(2,k)
C         b(ir) += a(ir,ija(k))*x(ija(k))
C          do j = 1, nc
C              do i = 1, nra
C            do kk = 1, nca
C                b(i+ofbb,j) = b(i+ofbb,j) + a(i,kk,pa) * x(kk+ofxb,j)
C              end do
C            end do
C          end do
          call dgemm('N','N',nra,nc,nca,alp,a(1,1,pa),lda,
     .      x(1+ofxb,1),ldx,1d0,b(1+ofbb,1),ldb)
   11   continue
   10 continue
      end
      subroutine dmspbm(mode,i1,i2,j1,j2,nr,a,lda,ija,offs,x,ldx,b,ldb)
C- Dense-matrix sparse-block-matrix multiply
C ----------------------------------------------------------------------
Ci Inputs
Ci   mode  :1s digit
Ci          0  multiply contents into b
Ci          1  add product  x a to existing contents of b
Ci          2  add product -x a to existing contents of b
Ci   i1,i2 :calculate x(i)*a(i,j) for row subblocks i = i1..i2
Ci   j1,j2 :calculate x(i)*a(i,j) for col subblocks j = j1..j2
Ci   nr    :number of rows in x and the result matrix b
Ci   a     :sparse matrix, stored in block form by rows.
Ci          a consists of a vector of matrix subblocks:
Ci          a(*,*,i) = matrix subblock i
Ci   lda   :leading dimension of a
Ci   ija   :column index packed array pointer data to array a
Ci         ija(1,*) follows essentially the same conventions
Ci         as for scalar packed arrays (see da2spr)
Ci         except that indices now refer to matrix subblocks.
Ci         ija(1,1)= n+2, where n = max(number of rows, number of cols)
Ci         ija(1,i), i = 1,..n+1 = points to first entry in a for row i
Ci         ija(1,i), i = n+2... column index element a(i).  Thus
Co                   for row i, k ranges from ija(i) <= k < ija(i+1) and
Co                   sum_j a_ij x_j -> sum_k a_(ija(2,k)) x_(ija(1,k))
Ci         ija(2,*)  pointers to the matrix subblocks blocks in a:
Ci         ija(2,i), i=1..n  pointers to blocks on the diagonal of a
Ci         ija(2,i), i=n+2.. pointers to elements of a, grouped by rows
Ci   offs  :offsets to first entries in matrix subblocks
Ci          offs(i,i=1..n) offset to first row in x and b for subblock i
Ci          Thus the dimension of row i = offs(i+1) - offs(i)
Ci          If a consists of scalar subblocks, offs(i) = i-1.
Ci   x     :dense matrix, and first operand
Ci   ldx   :leading dimension of x
Co Outputs
Co   b     :result matrix
Co   ldb   :leading dimension of b
Cr Remarks
Cr   This routine multiplies x a, with a=sparse matrix whose elements
Cr   are matrix subblocks
Cu Updates
C ----------------------------------------------------------------------
C     implicit none
C ... Passed parameters
      integer i1,i2,j1,j2,nr,lda,ldb,ldx,ija(2,*),offs(i2),mode
      double precision a(lda,lda,1),x(ldx,nr),b(ldb,nr)
C ... Local parameters
      integer ir,k,pa,ofxb,ofbb,nra,nca,ic,i,j,k1,k2
      double precision alp
C     integer ofx,ofb

C --- Setup ---
      call isanrg(mode,0,2,'dmspbm:','mode',.true.)
      alp = 1
      if (mode .eq. 2) alp = -1
C     offsets shifting origin of x and b.
C     ofx = 0
C     ofb = 0


C ... Initialize contents of b
      if (mode .eq. 0) then
C       do  6  j = offs(j1)-ofb+1, offs(j2+1)-ofb
        do  6  j = offs(j1)+1, offs(j2+1)
        do  6  i = 1, nr
          b(i,j) = 0
    6   continue
      endif

C ... Product of diagonal elements x(ir)*a(ir). Skip if missing.
      k1 = max(i1,j1)
      k2 = min(i2,j2)
      do  8  ir = k1, k2
C       Pointer to diagonal subblock in a
        pa  = ija(2,ir)
C       offset to x and b for this subblock
C       ofxb = offs(ir) - ofx
C       ofbb = offs(ir) - ofb
        ofxb = offs(ir)
        ofbb = offs(ir)
C       row and column dimension of this subblock
        nra = offs(ir+1) - offs(ir)
C   ... b(ir) <- x(ir)*a(ir).
        if (pa .ne. 0) then
          call dgemm('N','N',nr,nra,nra,alp,x(1,ofxb+1),ldx,a(1,1,pa),
     .      lda,1d0,b(1,ofbb+1),ldb)
        endif
    8 continue

C ... b(ija(k)) += x(ir) * a(ir,ija(k)) for nonzero blocks ija
      do  10  ir = i1, i2
C       Pointer to diagonal subblock in a
        pa  = ija(2,ir)
C       offset to x for this subblock
C       ofxb = offs(ir) - ofx
        ofxb = offs(ir)
C       col dimension of x and row dimension of a in this subblock
        nra = offs(ir+1) - offs(ir)
        do  11  k = ija(1,ir), ija(1,ir+1)-1
C         column index to a and row index to x
          ic  = ija(1,k)
          if (ic .lt. j1 .or. ic .gt. j2) goto 11
C         offset to row x for this subblock
C         ofbb = offs(ic) - ofb
          ofbb = offs(ic)
C         row dimension of subblocks a and col dimension of b
          nca = offs(ic+1) - offs(ic)
C         pointer to subblock in a
          pa = ija(2,k)
C         b(ija(k)) += x(ir) * a(ir,ija(k))
          call dgemm('N','N',nr,nca,nra,alp,x(1,1+ofxb),ldx,
     .      a(1,1,pa),lda,1d0,b(1,1+ofbb),ldb)
   11   continue
   10 continue
      end

C#ifdefC TEST
Cc     Test dspbmm
C      subroutine fmain
C      implicit none
C      integer ldap,na,nmax,mda
C      parameter(ldap=3,na=5,mda=15,nmax=na*na+1)
C      double precision ap(ldap,ldap,na),b(mda,2),bb(mda,2),x(mda,2)
C      double precision a(mda,mda),xt(2,mda),bt(2,mda),bbt(2,mda)
C      integer offs(na+1),ija(2,nmax)
C      integer ipiax(na,na),i,j,k,n,ii,ip,jj,m,ni,nj,offi,offj
C      integer i1,i2,j1,j2
C
C      data ap/-3d0,1d0,2d0,
C     .       1d0,-4d0,-7d0,
C     .       -1d0,2d0,9d0,
C     .       1d0,-4d0,-6d0,
C     .       -3d0,8d0,1d0,
C     .       5d0,-2d0,-5d0,
C     .       -1d0,9d0,8d0,
C     .       4d0,-2d0,-5d0,
C     .       -1d0,3d0,2d0,
C     .       3d0,-2d0,-1d0,
C     .       -6d0,7d0,6d0,
C     .       2d0,-3d0,-4d0,
C     .       -1d0,9d0,8d0,
C     .       2d0,-5d0,-2d0,
C     .      -2d0,3d0,1d0/
C
C      data x/-3d0,2d0,
C     .       -7d0,0d0,
C     .       -1d0,9d0,
C     .       -6d0,1d0,
C     .       -3d0,1d0,
C     .       -5d0,5d0,
C     .       -9d0,8d0,
C     .       -5d0,2d0,
C     .       2d0,3d0,
C     .       3d0,-2d0,
C     .       -6d0,7d0,
C     .       -3d0,2d0,
C     .       -0d0,9d0,
C     .       -5d0,0d0,
C     .       0d0,3d0/
C
C      data ipiax / 1,0,3,0,0,
C     .             5,0,2,4,0,
C     .             4,5,3,2,1,
C     .             0,0,0,0,4,
C     .             1,0,2,0,3/
C
C      data offs / 0,1,2,5,8,9/
C
CC ... Unpack a
C      call dpzero(a,mda*mda)
C      n = na
C      m = na
C      do  10  i = 1, n
C      do  12  j = 1, m
C        ip = ipiax(i,j)
C        offi = offs(i)
C        offj = offs(j)
C        ni   = offs(i+1) - offi
C        nj   = offs(j+1) - offj
C        if (ip .eq. 0 .and. i .ne. j) goto 12
C        print 332, i,j,ip,ni,nj
C  332   format(' block',2i2,' ip =',i2,' dimensions',2i2)
C        if (ip .eq. 0) goto 12
C        do  20  ii = 1, ni
C        do  20  jj = 1, nj
C          a(offi+ii,offj+jj) = ap(ii,jj,ip)
Cc          print *, ii,jj,offi+ii,offj+jj,ip,ap(ii,jj,ip)
C   20   continue
C   12 continue
C   10 continue
C      ni = offs(n+1)
C      nj = offs(m+1)
C     call yprm('a',1,a,mda*mda,mda,ni,nj)
C     call yprm('x',1,x,mda*mda,mda,ni,2)
C
CC ... Assemble ija
C      ija(1,1) = n+2
C      k = ija(1,1)-1
C      do  30  i = 1, n
C      do  32  j = 1, m
C        ip = ipiax(i,j)
C        if (ip .ne. 0 .and. i .ne. j) then
C          k = k+1
C          ija(2,k) = ip
C          ija(1,k) = j
C        endif
C   32 continue
C      ija(2,i) = ipiax(i,i)
C      ija(1,i+1) = k+1
C   30 continue
C
C      call dvset(b,1,2*mda,-99d0)
C
C      print 331, offs
C  331 format(' offsets =',6i3)
C      i1 = 2
C      i2 = n
C      j1 = 1 + 1
C      j2 = m-1
C
CC ... Test a x
C      call dspbmm(0,i1,i2,j1,j2,2,ap,ldap,ija,offs,x,mda,b,mda)
CC     call yprm('b',1,b,mda*2,mda,ni,2)
C
C      print 345, ni,nj, nj,2,i1,i2,j1,j2
C  345 format(/' Multiply a x, dimensioned (',i2,',',i2,') and (',
C     .  i2,',',i2,').'/' Multiply subblocks',4i2)
C
C      call dgemm('N','N',offs(i2+1)-offs(i1),2,offs(j2+1)-offs(j1),1d0,
C     .  a(offs(i1)+1,offs(j1)+1),mda,x(offs(j1)+1,1),mda,0d0,
C     .  bb(1+offs(i1),1),mda)
C      write(*,'(t2,a,t9,a,t22,a,t42,a)')
C     .  'row','reference','dspbmm result','diff'
C      do  40  i = offs(i1)+1,offs(i2+1)
C        write(*,333) i,bb(i,1),bb(i,2),b(i,1),b(i,2),
C     .    b(i,1)-bb(i,1),b(i,2)-bb(i,2)
C  333   format(i3,t5,2f7.1,t20,2f7.1,t35,2f7.1)
C   40 continue
C
CC ... Test xT a
C      call dvset(xt,1,2*mda,-99d0)
C      call dvset(bt,1,2*mda,-99d0)
C      do  100  i = 1, mda
C        xt(1,i) = x(i,1)
C        xt(2,i) = x(i,2)
C  100 continue
CC      call yprm('a',1,a,mda*mda,mda,ni,nj)
CC      call yprm('xt',1,xt,2*mda,2,2,ni)
C
C      call dmspbm(0,i1,i2,j1,j2,2,ap,ldap,ija,offs,xt,2,bt,2)
CC     call yprm('bt',1,bt,2*mda,2,2,ni)
C
C      print 355, 2,ni, ni,nj, i1,i2,j1,j2
C  355 format(/' Multiply x a, dimensioned (',i2,',',i2,') and (',
C     .  i2,',',i2,').'/' Multiply subblocks',4i2)
C
C      call dgemm('N','N',2,offs(j2+1)-offs(j1),offs(i2+1)-offs(i1),1d0,
C     .  xt(1,offs(i1)+1),2,a(offs(i1)+1,offs(j1)+1),mda,0d0,
C     .  bbt(1,1+offs(j1)),2)
C
C      write(*,'(t2,a,t9,a,t22,a,t42,a)')
C     .  'row','reference','dspbmm result','diff'
C      do  50  i = offs(j1)+1, offs(j2+1)
C        ii = i
C        write(*,333) ii,bbt(1,i),bbt(2,i),bt(1,i),bt(2,i),
C     .    bt(1,i)-bbt(1,i),bt(2,i)-bbt(2,i)
C   50 continue
C
C      end
C#endif
