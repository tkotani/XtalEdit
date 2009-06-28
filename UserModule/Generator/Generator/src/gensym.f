      subroutine gensym(slabl,gens,usegen,lcar,lfix,fptol,lsmall,nbas,
     .  nspec,ngen,gen,plat,ldist,dist,bas,ips,nrspec,ng,g,ag,nwgens,
     .  isym,oistab)
C- Generate the space group
C ----------------------------------------------------------------------
Ci Inputs:
Ci   slabl: name of the different species.
Ci   gens:  a list of generators, in symbolic representation
Ci          NB: this list is not required; see Remarks.
Ci   usegen:0 Extra basis atoms are added as needed to guarantee
Ci            the group operations created from gens are valid.
Ci          1 Also, find any additional group operations for
Ci            this basis.
Ci          2 Do neither 0 nor 1.
Ci   lcar:  T express ag in cartesian coordinates
Ci          F express atomic positions in units of platcv
Ci   lfix:  T: do not rotate or shift lattice
Ci   fptol: >0:Adjust positions slightly, rendering them as exactly
Ci          possible consistent with the symmetry group.  Any sites
Ci          within a lattice vector of tol are considered to be
Ci          at the same point.
Ci   nspec: number of classes, atoms in same class are symmetry-related
Ci   plat:  primitive lattice vectors (scaled by alat)
Ci   ldist: lattice deformation matrix key; see lattdf
Ci   dist:  lattice deformation matrix; see lattdf
Cio Inputs/Outputs (altered only if usegen=F)
Cio  nbas:  On input, number of atoms in the basis
Cio         On output nbas may be enlarged, depending symops and usegen
Cio  bas:   basis vectors
Cio         On output bas may be enlarged, depending symops and usegen
Cio  ips:   the jth atom belongs to spec ips(j)
Cio         On output ips may be enlarged, depending symops and usegen
Co Outputs:
Co   w(oistab): site ib is transformed into istab(ib,ig) by operation ig
Co   g:     symmetry operation matrix (assumed dimensioned >=ngmx)
Co   ag:    symmetry operation vector (assumed dimensioned >=ngmx)
Co   ... The following are generated if usegen=F
Co   isym:  numbers characterizing the symmetry of lattice and crystal
Co          isym(1) produces index for underlying lattice (see symlat)
Co   lsmall:if T: a smaller unit cell can be found
Co   nrspec:number of atoms in the ith class
Co   ng:    number of group operations
Co   ngen:  number of symmetry generators
Cr Remarks:
Cr   gensym generates the space group, using the following prescription:
Cr     1.  Any generators supplied from input gens
Cr         are checked for consistency with the underlying lattice.
Cr     2.  The space group is made from these generators.
Cr     3.  if usegen<2, missing basis atoms are added to make
Cr         the basis consistent with the supplied symmetry.
Cr     4.  nrspec is created
Cr     ... Unless usegen is 0, nothing more is done
Cr     5.  The point group of the underlying lattice without the
Cr         basis is generated.
Cr     6.  The full space group is generated from the point group
Cr     7.  A set of generators for this group is created
Cr   This program was adapted from the Stuttgart ASA version lmto-46.
Cu Updates
Cu   03 Nov 01 Shortened argument list, eliminating duplicate bas,ips
C ----------------------------------------------------------------------
C     implicit none
C Passed parameters:
      integer isym(*),nbas,nspec,ngen,oistab,       !istab(nbas,1),
     .        ng,nrspec(nspec),usegen,ldist,ips(nbas)
      double precision plat(9,*),g(9,*),ag(3,*),dist(3,3),bas(3,nbas),
     .  fptol
      character*8  slabl(*), gens*(*), nwgens*(*)
      logical lcar,lfix
C Local parameters:
      integer i,ibas,ic,iprint,owk,ngnmx,igen,ngmx,mxint,owork
      double precision qlat(3,3),vol,platt(9)
      logical lsmall,latvec
      parameter(ngnmx=10,ngmx=48)
      double precision gen(9,ngnmx),agen(3,ngnmx)
C heap:
      integer w(1)
      common /w/ w
C External calls:
      external  addbas,dcopy,defdr,defi,dinv33,
     .          icopy,iprint,rlse,spcgrp,
     .          symcry,symlat
      write(6,"(' GENSYM:')")

      call rxx(.not. lcar, 'gensym not implemented lcar')
      call rxx(lfix,  'gensym not implemented lfix')
      call rxx(lsmall,'gensym not implemented lsmall')

C --- Reciprocal lattice vectors ---
      call dinv33(plat,1,qlat,vol)

C --- Symmetry group as given by input generators ---
      call psymop(gens,plat,gen,agen,ngen)

C ... Rotate the generators
      call pshpr(iprint()-11)
      call lattdf(-ldist,dist,plat,0,w,ngen,gen)
      call poppr
      do  10  igen = 1, ngen
        call grpprd(gen(1,igen),plat,platt)
C       call dmpy(gen(1,igen),3,1,plat,3,1,platt,3,1,3,3,3)
        if (.not. latvec(3,1d-5,qlat,platt))
     .    call fexit(-1,111,' Exit -1 GENSYM: '//
     .    'generator %i imcompatible with underlying lattice',igen)
   10 continue
      call sgroup(gen,agen,ngen,g,ag,ng,ngmx,qlat)

C --- Add new atoms to the basis according to symmetry ---
      if (usegen .lt. 2) then
        call defi(owork,nbas**2) 
        call addbas(fptol,bas,slabl,ips,nbas,ng,plat,qlat,g,ag,w(owork))
        call rlse(owork)
      endif

C ... Make nrspec ... i should be nspec
      i = mxint(nbas,ips)
      if (i .ne. nspec)
     .  call awrit2(' GENSYM (warning) %i species supplied but only '//
     .  '%i spec used ...%N%8fpossible errors in class data',' ',120,6,
     .  nspec,i)
      nspec = i
      call iinit(nrspec,nspec)
      do  22  ibas = 1, nbas
        ic = ips(ibas)
        nrspec(ic) = nrspec(ic)+1
   22 continue

C --- check if unit cell is the smallest possible one (not implemented)
C      call chkcel(alat,bas,csym,ips,isym,lsmall,nbas,nspec,
C     .            nrspec,plat,qlat)

C --- Complete the space group ---
      nwgens = gens
      call defi (oistab, nbas*48)
      if (usegen == 0) then
C   ... Symmetry of lattice without basis
        call symlat(plat,ng,g,isym(1))
C   ... Symmetry of lattice with basis
        call defdr(owk,    3*nbas)
        call symcry(fptol,bas,w(owk),ips,nbas,nspec,nrspec,
     .              ng,plat,qlat,g,ag,w(oistab))
        call rlse(owk)
C       ngen = 0
        nwgens = ' '
        call groupg(ng,g,ag,plat,ngen,gen,agen,nwgens)
      else
        call symtbl(0,fptol,nbas,ips,bas,g,ag,ng,qlat,w(oistab))
      endif

C --- Adjust basis to conform with symops to numerical precision ---
      if (fptol .gt. 0) then
        call fixpos(bas,nbas,fptol,ng,plat,g,ag,w(oistab))
      endif
      end


c        call defdr(owk,    49*nbas)
c        call symtbl(0,fptol,nbas,ips,bas,g,ag,ng,qlat,w(owk))
c        print *,'istab xxx=',istab(1:nbas,1:ng)









