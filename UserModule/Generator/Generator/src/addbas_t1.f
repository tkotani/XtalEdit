      subroutine addbas(tol,bas,clabl,ips,nbas,ngrp,plat,qlat,g,ag,ieq)
C- Adds the missing basis atoms to get the right symmetry
C ----------------------------------------------------------------------
Ci Inputs:
Ci   clabl :name of the different inequivalent atom
Ci   ips:the jth atom belongs to spec ips(j)
Ci   ngrp  :number of group operations
Ci   qlat  :primitive translation vectors in reciprocal space
Ci   g     :symmetry operation matrix
Ci   symops:symmetry operation symbol
Ci   ag    :symmetry operation vector (dimensionless)
Ci   ieq: work array integer nbas**2
Cio Inputs/Output:
Cio  bas   :basis vectors (dimensionless)
Cio         on output list has been completed by the new positions
Cio  nbas  :number of atoms in the basis
Cr Remarks:
Cr For each atom, the symmetry-related positions are generated.
Cr If this position is empty a new atom is added.
Cr At the end, a check is made to ensure that
Cr atoms of different speces do not occupy the same positions.
Cr
c---------------------------
Cr Takao added plat as input... all bas can be shortoned...
Cr  
C ----------------------------------------------------------------------
C     implicit none
C Passed parameters:
      integer ips(*),nbas,ngrp
      double precision qlat(3,3),bas(3,*),g(9,*),ag(3,*),tol,plat(3,*)
      character*8 clabl(*)
      integer ieq(nbas,nbas),ix
C Local parameters:
      integer i,isop,ipr,lgunit,nbasnw,ibas,jbas,ic,jc,m,novlp,stdo
      double precision bast(3),dbas(3),tol1,bast0(3)
      logical latvec
      character*50 sg
C External calls:
      external  daxpy,dcopy,dmpy,errmsg,iprint,lgunit
C Intrinsic functions:
      intrinsic  idnint

      tol1 = tol
      if (tol .eq. 0) tol1 = 1d-5
      stdo = lgunit(1)

C --- If no atom of same spec at the rotated site, add it ---
      call getpr(ipr)
      nbasnw = nbas
      do  10  ibas = 1, nbas
        do  20  isop = 2, ngrp
          ic = ips(ibas)
          call dmpy(g(1,isop),3,1,bas(1,ibas),3,1,bast,3,1,3,1,3)
          call daxpy(3,1.d0,ag(1,isop),1,bast,1)
          do  30  jbas = 1, nbasnw
            jc = ips(jbas)
            if (ic .eq. jc) then
              do  32  m = 1, 3
   32         dbas(m) = bast(m)-bas(m,jbas)
              if (latvec(1,tol1,qlat,dbas)) goto 22
            endif
   30     continue
          nbasnw = nbasnw+1
          if (ipr .ge. 50) then
            if (nbasnw .eq. nbas+1) write(stdo,304)
            call asymop(g(1,isop),ag(1,isop),' ',sg)
            call skpblb(sg,len(sg),i)
            write(stdo,303) clabl(ic),ibas,nbasnw,sg(1:i+1)
          endif
          ips(nbasnw) = ic
          call dcopy(3,bast,1,bas(1,nbasnw),1)
   22     continue
   20   continue
   10 continue

C --- shortest atomic positions...
c takao it doe not work...
      do  ibas = 1, nbasnw
         call shorbz(bas(1,ibas),bas(1,ibas),plat,qlat)
      enddo 

C --- Printout ---
      if (nbasnw .gt. nbas) then
        if (ipr .ge. 10) then
          call awrit2('%N ADDBAS: The basis was enlarged from %i'//
     .      ' to %i sites%N         The additional sites are: %N',
     .      ' ',120,stdo,nbas,nbasnw)
          write(stdo,301) (clabl(ips(ibas)),(bas(i,ibas),i=1,3),
     .                  ibas=nbas+1,nbasnw)
          write(stdo,'(a)') ' '
        endif
        nbas = nbasnw
      else
        if (ipr .gt. 40) write(stdo,
     .   '('' ADDBAS: basis is already complete --- no sites added'')')
      endif

C --- Error whether atoms are sitting on same position ---
      novlp = 0
ctakao
      call iinit(ieq,nbas*nbas)
      do  40  ibas = 1, nbas
        ic = ips(ibas)
ccctakao
        do  50  jbas = 1, nbas
           if(ibas.eq.jbas) goto 50
cccc        do  50  jbas = 1, ibas-1 
          jc = ips(jbas)
          do  52  m = 1, 3
   52     dbas(m) = bas(m,ibas)-bas(m,jbas)
          if (latvec(1,tol1,qlat,dbas)) then
Ctakao
            ieq(ibas,jbas)=1
c            write(stdo,400) ibas,clabl(ic),(bas(m,ibas),m=1,3),
c     .                   jbas,clabl(jc),(bas(m,jbas),m=1,3)
            novlp = novlp+1
          endif
   50   continue
   40 continue

Ctakao
      do 60 ibas = 1, nbas
        ix=0
      do 60 jbas = ibas+1,nbas
        if( ieq(jbas,ibas) .eq. 1) then
         ic = ips(ibas)
         jc = ips(jbas)
         if(ix.eq.0) then 
          write(stdo,401) ibas,clabl(ic),(bas(m,ibas),m=1,3),
     &                    jbas,clabl(jc),(bas(m,jbas),m=1,3)
         else
          write(stdo,402) 
     &                   jbas,clabl(jc),(bas(m,jbas),m=1,3)
         endif
         ix=1 
         call iinit(ieq(1,jbas),nbas)
        endif
 60   continue

      if (novlp .gt. 0) call fexit(-1,111,' Exit -1 ADDBAS: '//
     .  'basis has %i overlapping site(s)',novlp)

301   format(8x,'ATOM=',a4,1x,'POS=',3f12.7)
303   format(10x,a4,2x,i3,2x,'-> ',i3,3x,5x,a)
304   format(/' ADDBAS: Spec   Atom  New_atom     Operation'/9x,35('-'))
400   format(/' ADDBAS: atom ',i3,', SPEC ',a4,' POS=',3f9.5, 
     .       /'     and atom ',i3,', SPEC ',a4,' POS=',3f9.5,
     .       /'     are at the same positions. '/)
401   format(/' ADDBAS: atom ',i3,', SPEC ',a4,' POS=',3f9.5, 
     .       /'     and atom ',i3,', SPEC ',a4,' POS=',3f9.5,
     .        '     are at the same positions. ')
402   format(
     .        '     and atom ',i3,', SPEC ',a4,' POS=',3f9.5,
     .        '     are at the same positions. ')
      end
