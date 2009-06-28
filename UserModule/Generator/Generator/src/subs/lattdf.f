      subroutine lattdf(ldist,defgrd,plat,nbas,bas,ngen,gen)
C- Rotates or deforms lattice
C ----------------------------------------------------------------
Ci Inputs
Ci   ldist: 0, no deformations.  For abs(ldist):
Ci          1: defgrd holds rot about spec'd angle
Ci          2, lattice deformed with a general linear transformation
Ci          3, lattice deformed by a shear.
Ci          SIGN ldist <0 => suppress rotation of plat
Ci   defgrd:transformation matrix, whose form is specified by ldist
Ci   nbas  :size of basis
Ci   ngen  :number of generators of the symmetry group
Co Outputs
Cio  plat  :primitive lattice vectors, in units of alat
Cio        :On output, plat is transformed by defgrd
Cio  bas   :basis vectors, in units of alat
Cio        :On output, bas is transformed by defgrd
Cio  gen   :On input, generators of the symmetry group
Cio        :On output, generators are transformed by defgrd
C ----------------------------------------------------------------
C     implicit none
C ... Passed parameters
      integer ldist,nbas,ngen
      double precision defgrd(3,3), plat(3,3), bas(3,1), gen(3,3,1)
C ... Local parameters
      double precision work(3,3),rinv(3,3),det,gold(3,3)
      integer ipr,i,j,ib
      integer obwk
C ... External calls
      external dcopy,defrr,dinv33,dmpy,getpr,makrot,shear

      if (ldist .eq. 0) return
      call getpr(ipr)
      call defrr(obwk,3*nbas)
      call dcopy(9,defgrd,1,work,1)
      if (iabs(ldist) .eq. 1) call makrot(work,defgrd)
      if (ipr .ge. 30 .and. iabs(ldist) .ne. 3) then
        print 333, ldist, ((defgrd(i,j), j=1,3), i=1,3)
  333   format(/' LATTDF:  deformation matrix for mode',i3,':'/
     .    (3f12.7))
      endif

C ... Rotate plat
      if (ldist .eq. 1 .or. ldist .eq. 2) then
        call dcopy(9,plat,1,work,1)
        call dinv33(defgrd,0,rinv,det)
        call dmpy(defgrd,3,1,work,3,1,plat,3,1,3,3,3)
        if (ipr .ge. 30) then
          print 334, ((work(i,j), i=1,3), (plat(i,j), i=1,3),j=1,3)
  334     format(10x,' Lattice vectors:',25x,'Rotated to:'/
     .      (3f12.7,2x,3f12.7))
        endif
      endif
      if (iabs(ldist) .eq. 1 .or. iabs(ldist) .eq. 2) then

        if (ipr .ge. 30 .and. nbas .gt. 0)
     .  print '(10x,''  Basis vectors:'',25x,''Rotated to:'')'
        do  10  ib = 1, nbas
          call dcopy(3,bas(1,ib),1,work,1)
          call dmpy(defgrd,3,1,work,3,1,bas(1,ib),3,1,3,1,3)
          if (ipr .ge. 30) print '(3f12.7,2x,3f12.7)',
     .      (work(i,1), i=1,3), (bas(i,ib), i=1,3)
   10   continue

        if (ipr .ge. 30 .and. ngen .gt. 0)
     .    print '(15x,''Group ops:'',26x,''Rotated to:'')'
        call dinv33(defgrd,0,rinv,det)
        do  20  ib = 1, ngen
          call dcopy(9,gen(1,1,ib),1,gold,1)
          call dmpy(defgrd,3,1,gen(1,1,ib),3,1,work,3,1,3,3,3)
          call dmpy(work,3,1,rinv,3,1,gen(1,1,ib),3,1,3,3,3)
          if (ipr .ge. 30) print '(/(3f12.7,2x,3f12.7))',
     .      ((gold(j,i), i=1,3), (gen(j,i,ib), i=1,3),j=1,3)
   20   continue
      endif
      if (ldist .eq. 3) then
        call shear(nbas,plat,bas,defgrd(1,3),defgrd)
      endif
      end
C      subroutine rotp(rotm,np,p,prot)
CC- Rotates a vector of points by a rotation matrix
CC  Returns prot = rotm*p.  prot may point to the same address space as p
C      implicit none
C      integer np
C      double precision p(3,np),prot(3,np),rotm(3,3),h(3)
C      integer i,j,ip
C
C      do  10  ip = 1, np
C        do  1  i = 1, 3
C        h(i) = 0
C        do  1  j = 1, 3
C    1   h(i) = h(i) + rotm(i,j)*p(j,ip)
C        do  2  i = 1, 3
C    2   prot(i,ip) = h(i)
C   10 continue
C      end
