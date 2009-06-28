C#define F90
      subroutine zgeevs( BALANC, JOBVL, JOBVR, SENSE, N, A, LDA, W, VL,
     .                   LDVL, VR, LDVR, ABNRM, INFO )
C- Eigenvalues, eigenvectors of a complex nonsymmetric matrix A
C  This is a driver for LAPACK zgeevx, with the following arguments
C  allocated internally: ILO,IHI,SCALE,RCONDE,RCONDV,RWORK,WORK.
C  The remaining arguments are as in zgeevx, which see for description.
C
Cu Updates
Cu   04 Mar 02 Zero out work to avoid bug in DEC cxml library
C     implicit none
*     .. Scalar Arguments ..
      CHARACTER          BALANC, JOBVL, JOBVR, SENSE
      INTEGER            INFO, LDA, LDVL, LDVR, N
      DOUBLE PRECISION   ABNRM
*     ..
*     .. Array Arguments ..
C      COMPLEX*16         A( LDA, * ), VL( LDVL, * ), VR( LDVR, * ),
C     $                   W( * )
      DOUBLE PRECISION    A(2, LDA, * ), VL(2, LDVL, * ),
     .                    VR(2, LDVR, * ), W(2, * )


      INTEGER LWORK,ILO,IHI
C#ifdef AUTO-ARRAY | F90
      DOUBLE PRECISION SCALE(N),RCONDE(N),RCONDV(N),RWORK(2*N),
     .                 WORK(2,2*N*N+2*N)

      call tcn('zgeevs')
      LWORK = 2*N*N+2*N
      call dpzero(work,2*lwork)
      CALL ZGEEVX( BALANC, JOBVL, JOBVR, SENSE, N, A, LDA, W, VL,
     .             LDVL, VR, LDVR, ILO, IHI, SCALE, ABNRM, RCONDE,
     .             RCONDV, WORK, LWORK, RWORK, INFO )

      call tcx('zgeevs')
C#elseC
C      integer oscale,orcnde,orcndv,orwork,owork
CC ... Heap
C      integer ww(1)
C      common /w/ ww
C
C      call tcn('zgeevs')
C      call defrr(oscale,n)
C      call defrr(orcnde,n)
C      call defrr(orcndv,n)
C      call defrr(orwork,2*n)
C      lwork = 2*n*n+2*n
CC     Initialize to zero to avoid bug in dec cxml library
C      call defcc(owork,-lwork)
C
C      CALL ZGEEVX( BALANC, JOBVL, JOBVR, SENSE, N, A, LDA, W, VL,
C     .  LDVL, VR, LDVR, ILO, IHI, ww(oSCALE), ABNRM, ww(oRCNDE),
C     .  ww(oRCNDV), ww(oWORK), LWORK, ww(oRWORK), INFO )
C
C      call rlse(oscale)
C      call tcx('zgeevs')
C#endif

      END
