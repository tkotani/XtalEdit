      subroutine zhev(n,h,s,lov,lx,nmx,emx,nev,wk,linv,ltime,e,z)
C- Eigenvalues and/or some eigenvectors of a Hermetian matrix
C ----------------------------------------------------------------
Ci Inputs:
Ci   h,n:  hermetian matrix, declared as h(n,*)
Ci   s:    overlap matrix, (used only if lov is true)
Ci   nmx:  maximum number of eigenvectors to be found
Ci   emx:  eigenvalue limit for eigenvectors to be found
Ci   wk:   work array of length at least 11n
Ci   lov:  if T, non-orthogonal
Ci   lx:   if T, calls routines to exploit unit stride lengths (risc)
Ci   linv: if T, using inverse iteration
Co Outputs:
Co   e:    eigenvalues
Co   nev:  number of eigenvectors found
Co   z:    eigenvectors (1..nev)  (declared as z(n,*)
Cr Remarks:
Cr   z must be at least of dimension z(n,n), even though nev<n.
Cr   h and s are destroyed on exit.
Cr   Aborts on exit
Cp Procedures used:
Cp   (lapack)  zhegv
Cp   (eispack) htribk, htridx, imtql2, tqlrat
Cu Updates
Cu   21 Jan 02 Added code to invoke LAPACK zhegv in place of diagno
C ----------------------------------------------------------------
C     implicit none
C Passed parameters
      logical linv,lx
      integer n,nev,nmx,ltime
      double precision h(1),s(1),e(n),wk(1),z(2),emx
      logical lov
C Local parameters
      integer i,j,k,l,m,mdim,k1,k2,k3,k4,k5,k6,k7,k8,k9,n2,ier

C#ifdefC LAPACK
C      character jobz
C      integer lwork
C      call tcn('zhev')
C      if (nmx .le. 0) then
C        jobz = 'N'
C        lwork = 4*n
C        call zhegv(1,jobz,'U',n,h,n,s,n,e,wk(1+3*n),lwork,wk(1),ier)
C        nev = 0
C      else
C        jobz = 'V'
C        lwork = n*nmx
C        call zhegv(1,jobz,'U',n,h,n,s,n,e,z,lwork,wk(1),ier)
C        call zcopy(n*nmx,h,1,z,1)
C        nev = nmx
C      endif
C      call rxx(ier.ne.0,'zhev: zhegv cannot find all evals')
C#else

C     call prm('(5f20.15)',s,n,n)
      call tcn('zhev')
      n2 = n**2

C --- Take care of n=1 case ---
      if (n .eq. 1) then
         e(1) = h(1)
         if (lov) e(1) = h(1)/s(1)
         if (1 .gt. nev .or. e(1) .gt. emx) return
         z(1) = 1
         z(2) = 0
         return
      endif

CC --- Use diagno if lx ---
C      if (lx) then
C        call cplx2r(n2,0,h,z)
C        if (lov) call cplx2r(n2,0,s,z)
C        i = 0
C        if (lov) i = 1
C        call diagno(n,h,s,wk,lx,i,linv,nmx,emx,nev,z,e)
C        call cplx2r(n2,1,z,h)
C        goto 40
C      endif

C --- Separate real and imaginary parts ---
      mdim = 2*n
      do  10  j = 1, n
        k = (j-1)*mdim + 1
        l = k + n
        call dcopy(n,h(k+1),2,wk,1)
        call dcopy(n,h(k),2,h(k),1)
        call dcopy(n,wk,1,h(l),1)
        if (lov) then
          call dcopy(n,s(k+1),2,wk,1)
          call dcopy(n,s(k),2,s(k),1)
          call dcopy(n,wk,1,s(l),1)
        endif
   10 continue

C --- Debugging: eigenvalues of overlap ---
C      call htridx(mdim,n,s(1),s(n+1),e,wk,wk(3*n+1),wk(n+1))
C      do  11  j = 1, n
C   11 wk(j) = wk(j)**2
C      call tqlrat(n,e,wk,ier)
C      write(6,600) e
C  600 format(' evl='/(1x,1p,5e14.6))
C      call rx('eigenvalues of overlap')

C --- H <- S^-1/2  H  S^-1/2 ---
      if (lov) then
        call yyhchd(mdim,n,s,s(n+1),wk,lx,.true.,ier)
        call rxx(ier.ne.0,'ZHEV: error in yyhchd')
        if (lx) then
          call yyhrdx(mdim,n,h,h(n+1),s,s(n+1),z,z(n+1))
        else
          call yyhred(mdim,n,h,h(n+1),s,s(n+1),.true.)
        endif
      endif

C --- Transform to tridiagonal matrix ---
      if (linv) then
        k1 = 1
        k2 = k1 + 3*n
        k3 = k2 + n
        k4 = k3 + n
        k5 = k4 + n
        k6 = k5 + n
        k7 = k6 + n
        k8 = k7 + n
        k9 = k8 + n
C#ifndef GENERIC
        call htridx(mdim,n,h(1),h(n+1),wk(k1),wk(k2),wk(k3),wk(n+1))
C#elseC
C        call htridi(mdim,n,h(1),h(n+1),wk(k1),wk(k2),wk(k3),wk(n+1))
C#endif
      else
C#ifndef GENERIC
        call htridx(mdim,n,h(1),h(n+1),e,wk,wk(3*n+1),wk(n+1))
C#elseC
C        call htridi(mdim,n,h(1),h(n+1),e,wk,wk(3*n+1),wk(n+1))
C#endif
      endif

C --- Eigenvalues only ---
      if (nmx .le. 0) then
        do  12  j = 1, n
   12   wk(j) = wk(j)**2
        call tqlrat(n,e,wk,ier)
        call rxx(ier.ne.0,'ZHEV: tqlrat cannot find all evals')
        nev = 0
        goto 100

C --- Eigenvalues and eigenvectors ---
      else if (linv) then
        call imtqlv(n,wk(k1),wk(k2),wk(k3),e,wk(k9),ier,wk(k4))
        call rxx(ier.ne.0,'ZHEV: imtqlv cannot find all evals')
C   --- Determine number of eigenvectors to be calculated ---
        nev = 1
        do  14  j = 2, n
          if (j .le. nmx .and. e(j-1) .le. emx) nev = j
   14   continue
        call tinvit(mdim,n,wk(k1),wk(k2),wk(k3),nev,e,wk(k9),z,ier,
     .    wk(k4),wk(k5),wk(k6),wk(k7),wk(k8))
        call rxx(ier.ne.0,'ZHEV: tinvit cannot find all evecs')
      else
        do  17  j = 1, n
          k = (j-1)*mdim
          m = k+n
          do  16  i = k+1, m
   16     z(i) = 0d0
          z(k+j) = 1d0
   17   continue
        call imtql2(mdim,n,e,wk,z,ier)
        call rxx(ier.ne.0,'ZHEV: imtql2 cannot find all evecs')

C   --- Determine number of eigenvectors to be calculated ---
        nev = 1
        do  15  j = 2, n
          if (j .le. nmx .and. e(j-1) .le. emx) nev = j
   15   continue
      endif

      if (nev .gt. 0) then
C#ifndef GENERIC
        call htribx(mdim,n,h(1),h(n+1),wk(n+1),nev,z(1),z(n+1))
C#elseC
C        call htribk(mdim,n,h(1),h(n+1),wk(n+1),nev,z(1),z(n+1))
C#endif

C --- Get the eigenvectors of H - E O ---
        if (lov) then
          if (lx) then
            call dcopy(n2*2,z,1,h,1)
            call yympy(s,s(n+1),mdim,1,h,h(n+1),mdim,1,z,z(n+1),mdim,1,
     .        n,nev,n)
          else
            call yyhbak(mdim,n,s,s(n+1),nev,z,z(n+1),.true.)
          endif
        endif

C   --- Convert eigenvectors to complex storage ---
        do  20  j = 1, nev
          k = (j-1)*mdim + 1
          i = (j-1)*2*n + 1
          l = k+n
          call dcopy(n,z(k),1,wk,1)
          call dcopy(n,z(l),1,z(i+1),2)
          call dcopy(n,wk,1,z(i),2)
   20   continue
      endif

C  40 if (nev .gt. 0 .and. ltime .ge. 0) print 337, nev,nmx,n,emx
C  337 format(' nev, nevmx, ndim=',3i4,' emx=',f10.5)
C#endif

  100 call tcx('zhev')
      end
C      subroutine cplx2r(n,job,h,z)
CC      implicit none
C      integer n,job
C      double precision h(1), z(1)
C      integer i
C
CC --- Complex to real ---
C      if (job .eq. 0) then
C
CC  ...  Save imaginary part in z
C        do  10  i = 1, n
C   10   z(i) = h(2*i)
C
CC ...   Copy real part to bottom half of h
C        do  12  i = 1, n
C   12   h(i) = h(2*i-1)
C
CC ...   Imaginary part to top half of h
C        do  14  i = 1, n
C   14   h(n+i) = z(i)
C
CC --- Real to complex ---
C      else
C
CC  ...  Save imaginary part in z
C        do  24  i = 1, n
C   24   z(i) = h(n+i)
C
CC ...   Distribute bottom half of h to real part
C        do  22  i = n, 1, -1
C   22   h(2*i-1) = h(i)
C
CC ...   Imaginary part from z
C        do  20  i = 1, n
C   20   h(2*i) = z(i)
C
C      endif
C      end
C      subroutine prm(fmt,s,nr,nc)
CC      implicit none
C      integer nr,nc
C      double precision s(2,nr,nc)
C      character*(20) fmt
C      integer i,j
C      print *, nr, nc
C      do  10  i = 1, nr
C   10 print fmt, (s(1,i,j), j=1,nc)
C      do  20  i = 1, nr
C   20 print fmt, (s(2,i,j), j=1,nc)
C      end
