      subroutine splcls(nosplt,bas,nbas,ng,istab,nspec,slabl,nclass,ipc,
     .  ics,nrclas)
C- Splits species into classes
C ----------------------------------------------------------------------
Ci Inputs:
Ci   nosplt:   T copy class and species 
Ci   bas,nbas: dimensionless basis vectors, and number
Ci   nspec:    number of species
Ci   ipc:      on input, site j belongs to species ipc(j)
Ci   slabl:    on input, slabl is species label
Ci   ng:       number of group operations
Ci   istab:    site istab(i,ig) is transformed into site i by grp op ig
Co  Outputs:
Co   slabl:    class labels
Co   ipc:      on output, site j belongs to class ipc(j)
Ci   ics:      class i belongs to species ics(i)
Co   nclass:   number of classes
Co   nrclas:   number of classes per each species
C ----------------------------------------------------------------------
C     implicit none
C Passed parameters:
      logical nosplt
      integer nbas,nspec,nclass,ng,istab(nbas,ng),ipc(nbas),
     .  ics(nspec),nrclas(nspec)
      double precision bas(3,*)
      character*8 slabl(*)
C Local parameters:
      integer ib,ic,icn,iclbsj,ig,jb,m,i,is,lgunit,ipr,idx
      logical lyetno
      character*80 outs,clabl*8

      call getpr(ipr)
      call icopy(nspec,1,0,nrclas,1)
      nclass = nspec
      do  5  i = 1, nspec
    5 ics(i) = i

      if (nosplt) then
      else
C --- For each species, split to make equivalent classes ---
      ic = 1
   10 if (ic .le. nclass) then
        is = ics(ic)
        ib = iclbsj(ic,ipc,-nbas,1)
        if (ib .lt. 0) goto 11
        lyetno = .true.
C   ... For each basis atom in this class, do
        do  20  jb = 1, nbas
         if (ipc(jb) .eq. ic) then
C      ... For equiv. classes, there must be a g mapping jb->jb
           do  22  ig = 1, ng
   22      if (istab(ib,ig) .eq. jb) goto 20
C      ... There wasn't one
           if (ipr .ge. 70) then
             write(*,400) slabl(is),ib,(bas(m,ib),m = 1,3),
     .                              jb,(bas(m,jb),m = 1,3)
           endif
C      ... If the classes haven't been split yet, do so
           if (lyetno) then
             nclass = nclass+1
             icn  =  nclass
             ics(icn) = is
             nrclas(is) = nrclas(is)+1
             lyetno = .false.
           endif
           icn  =  nclass
           ipc(jb)=  icn
         endif
   20   continue
   11   ic = ic + 1
        goto 10
      endif
      endif

C --- Printout ---
      if (nclass .eq. nspec .or. ipr .lt. 20) return
      call awrit2('%N SPLCLS:  %i species split into %i classes'//
     . '%N Species  Class      Sites...',' ',80,lgunit(1),nspec,nclass)
      if (ipr .le. 30) return
      do  40  is = 1, nspec
        if (nrclas(is) .eq. 1 .and. ipr .lt. 40) goto 40
        outs = ' '//slabl(is)
        do  42  idx = 1, nbas
          ic = iclbsj(is,ics,-nclass,idx)
          if (ic .gt. 0) then
            call clabel(slabl,is,idx,clabl)
*           print *, slabl(is),clabl,ic
            outs = ' '
            if (idx .eq. 1) outs = ' '//slabl(is)
            call awrit1('%(n>9?9:10)p%i:'//clabl,outs,80,0,ic)
            do  44  ib = 1, nbas
              if (ipc(ib) .eq. ic)
     .          call awrit1('%a%(p>20?p:20)p %i',outs,80,0,ib)
   44       continue
            call awrit0(outs,' ',-80,lgunit(1))
          else
            goto 43
          endif
   42   continue
   43   continue
   40  continue

  400 format(' SPLCLS: species: ',a,'has inequivalent positions:'/
     .       '  IB: ',i3,',  POS=',3f10.5/
     .       '  JB: ',i3,',  POS=',3f10.5)

      end
