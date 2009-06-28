      subroutine shear(nbas,bas,tau,alpha,eps)
C- Apply a pure strain to lattice and basis vectors
C-----------------------------------------------------------------------
Ci Inputs 
Ci  nbas,bas,tau,alpha*eps(1-6): Voigt tensor strains
Ci Outputs
Ci  bas and tau overwritten
C-----------------------------------------------------------------------
C     implicit none
C Passed
      integer nbas
      double precision bas(3,3),tau(3,nbas),eps(6),alpha
C Local
      integer i,j,ind(2,21),n,iprint,nbmx
      parameter (nbmx = 256)
      double precision s(3,3),b(3,3),x(21),t(3,nbmx),det,e(6)
      if (dabs(alpha) .lt. 1d-8) return
      if (nbas .gt. nbmx) call fexit(-1,9,'Increase nbmx in SHEAR',0)
      call dcopy(6,eps,1,e,1)
      call dscal(6,alpha,e,1)
      call xxxes(e,s,det)
      if (iprint() .ge. 40) then
        write (*,10) bas
        write (*,20)
        write (*,30) ((tau(i,j),i=1,3),j=1,nbas)
        write (*,40) s
      endif
      call dmpy(s,3,1,bas,3,1,b,3,1,3,3,3)
      call dcopy(9,b,1,bas,1)
      call dmpy(s,3,1,tau,3,1,t,3,1,3,nbas,3)
      call dcopy(3*nbas,t,1,tau,1)
      if (iprint() .ge. 40) then
        write (*,10) bas
        write (*,20)
        write (*,30) ((tau(i,j),i=1,3),j=1,nbas)
      endif
      call xxxse(s,e)
      call dscal(6,1d0/alpha,e,1)
      n = 0
      do  1  i = 1, 6
        call xxxadd(i,i,n,e,ind,x)
    1 continue
      do  2  i = 1, 5
      do  2  j = i+1, 6
        call xxxadd(i,j,n,e,ind,x)
    2 continue
      if (n .eq. 0 .or. iprint() .lt. 30) return
      write (*,50) alpha
      write (*,60) ((ind(i,j),i=1,2),j=1,n)
      write (*,70) (x(i),i=1,n)
      write (*,80) det-1
   10 format ('SHEAR: Lattice vectors:'/3(8x,3f10.6/))
   20 format ('       Basis atoms:')
   30 format (8x,3f10.6)
   40 format ('       Lattice and basis sheared by'/3(8x,3f10.6/))
   50 format ('SHEAR: This job, distortion is alpha = ',f10.6/
     .   7x,'In the second derivative of E/vol w.r.t alpha '/
     .   7x,'the following elastic constant entries are non-zero'/
     .   7x,'with coefficients x_ij as shown. W''''=sum_ij x_ij c_ij')
   60 format (6(5x,2i1,5x))
   70 format (6f12.6)
   80 format (7x/'Volume dilatation :  ',f10.6//)
      end
      subroutine xxxes(e,s,det)
C Make deformation tensor
      double precision e(6),s(3,3),det
      s(1,1) = 1 + e(1)
      s(2,2) = 1 + e(2)
      s(3,3) = 1 + e(3)
      s(1,2) = e(6)
      s(2,1) = e(6)
      s(1,3) = e(5)
      s(3,1) = e(5)
      s(2,3) = e(4)
      s(3,2) = e(4)
      det=s(1,1)*s(2,2)*s(3,3)+s(1,2)*s(2,3)*s(3,1)
     .   +s(1,3)*s(2,1)*s(3,2)-s(1,3)*s(2,2)*s(3,1)
     .   -s(1,2)*s(2,1)*s(3,3)-s(1,1)*s(2,3)*s(3,2)
      end
      subroutine xxxse(s,e)
C Make engineering strains
      double precision s(3,3),e(6)
      integer i
      do  1  i = 1, 3
        e(i) = s(i,i) - 1d0
    1 continue
      e(4) = 2*s(2,3)
      e(5) = 2*s(1,3)
      e(6) = 2*s(1,2)
      end
      subroutine xxxadd(i,j,n,e,ind,x)
C Add to list of non-zero elastic constant coefficients
C     implicit none
      integer i,j,n,ind(2,21)
      double precision e(6),x(21),xx
      xx = e(i)*e(j)
      if (i .ne. j) xx = 2*xx
      if (dabs(xx) .gt. 1d-8) then
        n = n+1
        ind(1,n) = i
        ind(2,n) = j
        x(n) = xx
      endif
      end  
