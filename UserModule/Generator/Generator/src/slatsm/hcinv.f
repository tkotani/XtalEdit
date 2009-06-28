      subroutine hcinv(nm,n,br,bi,dl,lopt)
C- Obtain inverse from Cholesky decomposed matrix
C ----------------------------------------------------------------
Ci Inputs
Ci   nm: true row dimension of arrays b and z, as declared by caller
Ci   n:  order of the matrix system.
Ci   b:  Cholesky-decomposed nonorthogonality matrix
Ci       (strict lower triangle; see hchd)
Ci   dl: diagonal elements of l (see hchd).
Ci   lopt: false, only upper half of b^-1 is generated, and lower
Ci         half continues to hold the c.d. of b
Ci         true,  lower half of b also filled in
Co Outputs
Co   b:  Inverse of Cholesky matrix
Cr Remarks
Cr   Adapted from eispack reduc for hermetian matrices
C ----------------------------------------------------------------
C Passed parameters 
      integer n,nm
      logical lopt
      double precision br(nm,n),bi(nm,n),dl(n)
C Local parameters 
      integer i,im1,j,k
      double precision xr,xi,y
C#ifdefC BLAS
C      double precision ddot
C#endif

C --- form inv(l) and store transpose in full upper triangle of b ---
C  (l^-1)_ij  =  (del_ij - sum_k<i  l_ik * (l^-1)_kj) / l_ii
      do 200 j = 1, n
        do 200 i = j, n
          y = dl(i)
C#ifdefC BLAS
C          if (j .eq. i) then
C            xr = 1d0
C            xi = 0
C          else
C            xr = - ddot(i-j,br(i,j),nm,br(j,j),nm)
C     .           + ddot(i-j,bi(i,j),nm,bi(j,j),nm)
C            xi = - ddot(i-j,br(i,j),nm,bi(j,j),nm)
C     .           - ddot(i-j,bi(i,j),nm,br(j,j),nm)
C          endif
C#else
          xr = 0
          xi = 0
          if (j .eq. i) xr = 1d0
          im1 = i-1
          do 160 k = j, im1
            xr = xr - (br(i,k)*br(j,k) - bi(i,k)*bi(j,k))
            xi = xi - (br(i,k)*bi(j,k) + bi(i,k)*br(j,k))
  160     continue
C#endif
          br(j,i) = xr / y
          bi(j,i) = xi / y
  200 continue
c
c     .......... pre-multiply by inv(l) and overwrite ..........
      do 300 i = 1, n
         do 300 j = i, n
C           x = x - l^dag_ik * l_kj; here i <= j <= k
C#ifdefC BLAS
C           br(i,j) = ddot(n+1-j,br(i,j),nm,br(j,j),nm) +
C     .               ddot(n+1-j,bi(i,j),nm,bi(j,j),nm)
C           bi(i,j) = ddot(n+1-j,br(i,j),nm,bi(j,j),nm) -
C     .               ddot(n+1-j,bi(i,j),nm,br(j,j),nm)
C#else
            xr = 0
            xi = 0
            do 260 k = j, n
              xr = xr + (br(i,k)*br(j,k) + bi(i,k)*bi(j,k))
              xi = xi + (br(i,k)*bi(j,k) - bi(i,k)*br(j,k))
  260       continue
            br(i,j) = xr
            bi(i,j) = xi
C#endif
  300 continue

      if (.not. lopt) return
      do  400  i = 1, n
       do  400  j = i+1, n
         br(j,i) =  br(i,j)
         bi(j,i) = -bi(i,j)
  400 continue
      end
