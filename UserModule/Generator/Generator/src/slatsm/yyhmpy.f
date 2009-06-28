C#define BLAS3
      subroutine yyhmpy(ta,tb,n,l,a,b,lc,c)
C- Complex matrix multiply, result assumed hermetian
C ----------------------------------------------------------------
Ci Inputs:
Ci   ta,tb: follow BLAS3 conventions
Ci   n,l: dimension of c and length of vector product
Ci   lc:  true: lower triangle copied into upper triangle
Co Outputs:
Co   c
Cr Remarks:
Cr   Adapted from zhmpy, alternatively can call zampy in block form
Cm Memory
Cm   zampy call requires 2*nrow*l double precision words.
C ----------------------------------------------------------------
C     implicit none
C Passed parameters
      character*1 ta,tb
      logical lc
      integer n,l
      double precision a(1), b(1), c(n,1)
C Local variables
      integer nrow,owk,ir,ic,nr,nc,ns,n2
      logical ca,cb,tra,trb
C#ifdef BLAS3
      parameter (nrow=48)
      integer w(1)
      common /w/ w
C#elseC
C      integer la,lb,nra,nrb
C#endif

      ca = ta.eq.'c' .or. ta.eq.'C'
      cb = tb.eq.'c' .or. tb.eq.'C'
      tra = ca .or. ta .eq. 't' .or. ta .eq. 'T'
      trb = cb .or. tb .eq. 't' .or. tb .eq. 'T'

C#ifdef BLAS3
      n2 = n**2
      ns = n*l
      call defdr(owk,nrow*l*2)
      do  10  ir = 1, n, nrow
        nr = min(n-ir+1,nrow)
        nc = nr+ir-1
        if (tra) then
          call xyhmpy(nr,l,ns,a(1+(ir-1)*l),ca,w(owk))
          call zampy(w(owk),nr,1,l*nr,b,l,1,ns,c(ir,1),n,1,n2,nr,nc,l)
        else
          call zampy(a(ir),n,1,ns,b,l,1,ns,c(ir,1),n,1,n2,nr,nc,l)
        endif
   10 continue

      if (.not. lc) return
      do  12  ir = 1, n
        do  12  ic = ir+1, n
          c(ir,ic)    =  c(ic,ir)
          c(ir+n2,ic) = -c(ic+n2,ir)
   12   continue

C#elseC
C      la = n
C      nra = 1
C      if (tra) then
C        nra = l
C        la = 1
C      endif
C      lb = l
C      nrb = 1
C      if (trb) then
C        nrb = n
C        lb = 1
C      endif
C      if (ca) call dscal(n*l,-1d0,a(1+n*l),1)
C      if (cb) call dscal(n*l,-1d0,b(1+n*l),1)
C      call zhmpy(a,la,nra,n*l,b,lb,nrb,n*l,c,n,lc,l)
C      if (ca) call dscal(n*l,-1d0,a(1+n*l),1)
C      if (cb) call dscal(n*l,-1d0,b(1+n*l),1)
C#endif

      end
C#ifdef BLAS3
      subroutine xyhmpy(nr,l,ns,a,ca,w)
C Kernel called by yyhmpy
C     implicit none
      integer nr,l,ns
      double precision w(nr,l,2),a(l,1)
      integer j
      logical ca

      call dpzero(w(1,1,2),nr*l)
      do  10  j = 1, nr
        call dcopy(l,a(1,j),1,   w(j,1,1),nr)
        call dcopy(l,a(1+ns,j),1,w(j,1,2),nr)
   10 continue
      if (ca) call dscal(nr*l,-1d0,w(1,1,2),1)

C      call zprm('(5f15.10)',w,nr,l)
      end
C#endif
