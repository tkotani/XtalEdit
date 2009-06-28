c      subroutine fmain() !This is called from true main in slatsm/fmain.c
c      call maksym()
c      end
      program maksym  !(mode,slabl,ssymgr,sctrl,slat,ssite,sarray)
C- Symmetry tool.
C  Read cryst.in and write cryst.out
C ----------------------------------------------------------------------
Ci
Ci Input file cryst.in
Ci      
Ci     mode = 0 !For given generator, find all the required sites.
Ci                Then find additional symmetry generator. It works even with no generator.
Ci          = 1 !Search site positions for given generator
Ci          = 2 !Check consistency. Use given symmetry generator.
C
C   slabl : species labels
C   ssymgr: string containing symmetry group generators.
C   nsgrp= number of space group operations.
C   npgrp= number of point group operations. 
C   istab= table of site permutations for each group op
c
C   ag   = translation part the group ops
C   symgr= point group (rotation) part of each group op
C
C           oipc:  pointer to class table, pad equiv to double pad
C           oipcp: pointer to class table, pad nequiv to double pad
C ----------------------------------------------------------------------
C     implicit none
      integer mode,nsgrp,npgrp
C Local variables
      logical T,F,cmdopt,a2bin
      integer idest,ig,iprint,igets,isym(10),j1,j2,lgunit,lpgf,nbas,
     .  nbas0,nbasp,nclass,nclasp,nclspp,ngen,ngnmx,usegen,
     .  npadl,npadr,ldist,oclabl,oics,oips,oistab,onrc,onrcp,onrspc,
     .  opos,oipc,oipcp,oiwk,oag,osymgr,opos2,oips2,aginv,iusegen
      parameter (T=.true., F=.false., ngnmx=10)
      character*120 gens,strn*72
      double precision gen(9,ngnmx),plat(3,3),dist(3,3),qlat(3,3),xx,
     .  fptol,avw,avwsr,vol,alat
c
      logical writing,cox
      integer ormax,oz
      double precision rmaxs

      character*8 slabl(100),ssymgr*(200)
      real*8  dclabl(1)
      equivalence (dclabl(1),slabl(1))


C Heap allocation
      integer wksize
      parameter(wksize= 2 000 000)
      integer w(wksize)
C     Next two lines guarantee w is aligned along a d.p. boundary
      double precision ws
      equivalence (ws,w(1))
      common /w/ w
      call wkinit(wksize)  ! semi-dynamic memory allocation
      call wkfast(F)
c     call poppr
c      call poseof(fopn('LOG'))

c--------------------------------------------------------
      ifx=96
      print *,' =============== maksym start ================'
      inquire(file='crystr.out',exist=cox)
      if(cox) open(ifx,file='crystr.out')
      close(ifx,status='delete')

      call pshpr(50)  !if 51, it gives detailed informations...
      open(ifx,file='crystr.in')
      read(ifx,*); read(ifx,*);read(ifx,*);
      read(ifx,*); read(ifx,*);read(ifx,*);
      read(ifx,*)nbas
      do i=1,nbas; read(ifx,*); enddo
      read(ifx,*) nclass
      close(ifx)
      print *,' readin nbas nclass=',nbas,nclass
!      nsite = nbas
      ldist = 0
      call dpzero(dist,9)
      call defrr(oag,   3*48)
      call defrr(osymgr,9*48)
      call defi(oipc,  nbas)
      call defi(oics,  nbas)
      call defi(onrspc,nbas)
      call defi(oips,nbas)
      call defrr(opos,3*nbas)
      call defrr(oz,   nclass)
      call defrr(ormax,nclass)
C ---
      ifx=96
      writing=.false.
      print *,' Readin cryst.in...'
      open(ifx,file='crystr.in')
      call iocrystr(ifx,iusegen,slabl,plat,ssymgr,nbas,nclass,
     &  w(opos),w(oips),w(ormax),rmaxs,alat,writing)
      close(ifx)
c      print *,' goto iocryst xxx'
      if(.not.writing) then
        call iocrystr(6,iusegen,slabl,plat,ssymgr,nbas,nclass,
     &   w(opos),w(oips),w(ormax),rmaxs,alat,.not.writing)
      endif
      usegen=mod(iusegen,100)
      if(iusegen/100==1) call pshpr(51)  !if 51, it gives detailed informations...

c      print *,' end of iocryst'
c      print *
c      call modeinfo(6)
      write(6,"(' now mode setted in cryst.in =',i5)")iusegen
      print *
cccccccccccccccccccccccccccccccccccccccccccc
c      print *, 'end of iocryst';  call rmtshow(nclass,w(ormax))
cccccccccccccccccccccccccccccccccccccccccccc

C --- Extract commands from input string; copy rest to gens
      call words(ssymgr,ngen)
      j1 = 1
      idest = 1
c      usegen = 0 !Find additional symmetry operation.
c      usegen = 1 !Use given symmetry operation
c      usegen = 2 !Search atomic positions for given generator
      gens = ' '
      do  10  ig = 1, ngen
        call word(ssymgr,ig,j1,j2)
c        if (ssymgr(j1:j2) .eq. 'find') then
c          usegen = 0
c        else
         call strncp(gens,ssymgr,idest,j1,j2-j1+2)
         idest = idest+j2-j1+2
c        endif
   10 continue
cccccccccccccccccccccccccccccccccccccccccccc
c      print *, 'end of strncp'; call rmtshow(nclass,w(ormax))
cccccccccccccccccccccccccccccccccccccccccccc

C --- Generate space group ---
      nbas0 = nbas
      fptol = 0d0
c      if (cmdopt('--fixpos',8,0,strn)) then
c        j1 = 8+1
c        if (strn(9:9) .ne. ':' .or.
c     .    .not. a2bin(strn,fptol,4,0,' ',j1,len(strn))) fptol = 1d-5
c      else
c        fptol = 0
c      endif

C ... When generating the group the basis may become enlarged ... 
C     copy larger files relevant arrays to larger workspace
c      call defi (oistab,49*nbas)

      call defi (oips2, 48*nbas)
      call defdr(opos2, 3*48*nbas)
cccccccccccccccccccccccccccccccccccccccccccc
c      print *, 'go icopy'; call rmtshow(nclass,w(ormax))
cccccccccccccccccccccccccccccccccccccccccccc
      call icopy(nbas,  w(oips),1,w(oips2),1)
      call dcopy(3*nbas,w(opos),1,w(opos2),1)

! Note nbas can be enlarge!
      call gensym(slabl,gens,usegen,T,F,fptol,F,nbas,nclass,ngen,gen,
     .  plat,ldist,dist,w(opos2),w(oips2),w(onrspc),nsgrp,w(osymgr),
     .  w(oag),ssymgr,isym,oistab) !size of w(oistab) can change because nbas can be enlarged

c      if (nbas .gt. nbas0) call rxs('gensym: the basis was enlarged.',
c     .  ' Check group operations.')
c      if (fptol .ne. 0) call dpcopy(w(opos2),w(opos),1,3*nbas,1d0)

C --- pair information
c      print *, 'go showpairs'
c      call rmtshow(nclass,w(ormax))
c      print *, 'goto showpairs111 ',rmaxs,alat,plat
c      print *, 'goto showpairs222 ',slabl(1:nclass)

      write(6,*)
      call showpairs(nbas,alat,plat,rmaxs,w(opos2), dclabl, !slabl,
     &     w(oips2),
     &   nclass,slabl,w(ormax) )

C ---
      ifx=96
      writing=.true.
      print *,' Writing cryst.out...'
      open(ifx,file='crystr.out')
      call iocrystr(ifx,iusegen,slabl,plat,ssymgr,nbas,nclass,
     &  w(opos2),w(oips2),w(ormax),rmaxs,alat,writing)
      close(ifx)
      print *,' =============== maksym end =================='
      stop ' OK! end of maksym: '
      end

      subroutine diset(z,a,n)
      real*8 z(n),a
      do i=1,n
        z(i)=a
      enddo
      end
      subroutine iiset(ix,k,n)
      integer ix(n)
      do i=1,n
        ix(i)=k
      enddo
      end

      subroutine showpairs(nbas,alat,plat,rmaxs,pos, dclabl,
     &   ipc,nclass,slabl,rmax )
C- Show informations of atomic neighbor pairs.
C --------------------------------------------------------------
C all arguments are inputs.
C
Cr      We assume ips==ipc class=spec
C --------------------------------------------------------------
      implicit none
      character*120 outs
      integer idummy,ontab,oiax,mxcsiz,i,j,nbas,nbasp,ipc(nbas),
     &  nclass,stdo,mxnbr,ip,nttab,iprint,modep(3),i1mach
      real*8 pos(1),plat(1), xv(10),alat,rmaxs,rmax(nclass)
     & ,qvw,qlat(9),xx,avw,fovmx
      character*8 slabl(1)
      real*8 z(nclass),vol,avwsr, dclabl(1)
C ... Heap
c      integer w(1)
c      common /w/ w
C ===============================================================
      write(6,"(' SHOWPAIRS:')")
c      print *,' ipc=', ipc(1:nbas)

c      print *,' ipc=', rmax(1:nclass) !ipc(1:nbas)

c,  ipc(1:nbas)
c
c      z = 1
      call  diset(z,1d0,nclass)
      i = 3
      j = -1
      mxcsiz = 0
      stdo   = 6
      nbasp = nbas
c      modep = 2
      call iiset(modep,2,3)
      mxnbr = 0
      outs  = ' '
      avw= avwsr(plat,alat,vol,nbas)

      if (iprint()>50) then
       write(6,"('  showpairs: rmaxs=',f13.5)") rmaxs
       write(6,"('  Change rmaxs in maksym(or in iocrystr when you',
     &  ' wants to change range searching for neighor pairs.')")
c      print *,' rmax=',rmax(1:nclass)
c      print *,' ij mxcsiz nbas nbasp=',i,j,mxcsiz,nbas,nbasp,rmaxs,avw
c    
C ... Get neighbor table iax for each atom in the cluster
      call pshpr(iprint()-20)
      call pairs(nbas,nbasp,alat,plat,rmaxs*avw/2,pos,
     .  -1,i,j,idummy,nttab,ontab,oiax,mxcsiz)
      call poppr
      endif

c      print *, ' end of pairs nbas nbasp',nbas,nbasp
c      print *,' end of pairs rmax=',rmax(1:nclass)

C --- Show neighbors by shell ---
      outs = ' '
      j = 8                !      if (cmdopt('--shell',j-1,0,outs)) then
      if (iprint()>50) then
        call shoshl(outs(j:),nbas,pos,plat,mxnbr,z,dclabl,
     .    ipc,idummy,idummy,nclass)
      endif

C --- Show angles between neighbors ---
      j = 9          !  if (cmdopt('--angles',j-1,0,outs)) then
      if (iprint()>50) then
        call shoang(outs(j:),nbas,pos,plat,mxnbr,slabl,ipc)
      endif

C ... Write positions in Cartesian coordinates and as multiples plat
      write(stdo,357)
  357 format(/' site spec',8x,'pos (Cartesian coordinates)',9x,
     .  'pos (multiples of plat)')
      call dinv33(plat,1,qlat,xx)
      do  i = 1, nbas
        call dpscop(pos,xv,3,3*i-2,1,1d0)
        call dgemm('T','N',3,1,3,1d0,qlat,3,xv,3,0d0,xv(4),3)
ccccccccccccccccccccc
c      print *,'xxxxxxxxxxxxxxxxxx aaa3'
cccccccccccccccccccc
        ip = ipc(i) !ival(w(oips),i)
ccccccccccccccccccccc
c      print *,'xxxxxxxxxxxxxxxxxx'
cccccccccccccccccccc
        print 345, i, slabl(ip), (xv(j),j=1,3), (xv(3+j),j=1,3)
  345   format(i4,2x,a8,f10.6,2f11.6,1x,3f11.6)
      enddo

C --- Print overlaps, optionally minimize wrt spec'd sites ---
      outs = ' '
      j = 1
c      print *,' goto ovmin xx', nclass,modep
c      print *,' goto ovmin xx', rmax(1:nclass), ipc(1:nclass)
c      print *,' goto ovmin xx', alat, plat(1:9)
c      print *, ' goto ovmin nbas nbasp',nbas,nbasp
c      call ovmin(outs(6:),nbas,nbasp,alat,plat,rmax,rmax,
c     .  dclabl,ipc,modep,z,ontab,oiax,pos,j)

      call ovlchk(nbas,nbasp,pos,alat,rmax,0d0,
     .  dclabl,ipc,modep,plat,fovmx,xx)
      write(6,*)
      end


c====================================================================
      subroutine iocrystr(ifx,usegen,slabl,plat,ssymgr,nbas,nclass
     & ,bas,ips,rmax,rmaxs,alat,writing)
C- Readin and Write cryst.in cryst.out
      implicit none
      character*8 slabl(1),ssymgr*(*)
      character*200 aaa
      integer nbas,ips(nbas),ibas,usegen,nclass,ifx,i,ic
     &  ,ifxx,j1,j2,ix
      double precision bas(3,nbas),plat(3,3),rmax(*),rmaxs,alat
      logical writing,form1

      form1=.false.
      rmaxs=3d0 ! Fixed. This is just used to make neighbor pair map 
                ! only shown in verbose mode.
c
c     write(ifx,"(' ',i9,'                    !usegen')")usegen
      if(writing) then
       write(ifx,"(i6,
     & '  !mode switch for computation. Next line is generators')")
     &  usegen
          call word(ssymgr,1,j1,j2)
       call wordtcut(ssymgr,j2)
c       print *,' j1=',j1
       write(ifx,"('       ',a)") ssymgr(j1:j2)

c--------------------------
       if(form1) then
c        write(ifx,"(' ',2f15.5, ' !alat rmaxs')")alat,rmaxs
        write(ifx,"(' ',f15.5, ' !alat ')")alat
        write(ifx,"(' ',3f15.5, '  !prvec1 ')") (plat(ix,1),ix=1,3)
        write(ifx,"(' ',3f15.5, '  !prvec2 ')") (plat(ix,2),ix=1,3)
        write(ifx,"(' ',3f15.5, '  !prvec3 ')") (plat(ix,3),ix=1,3)
        write(ifx,"(i6,'  !nbas. Number of sites.')") nbas
        do ibas=1,nbas
        write(ifx,"(' ',3f15.5,i5,' !bas site_type for site=',i5 )") 
     &        (bas(ix,ibas),ix=1,3),ips(ibas),ibas
        enddo
        write(ifx,"(i6,'  !ntyp Number of inequivalent site')") nclass
        do ic=1,nclass
          aaa = slabl(ic)
          call word(aaa,1,j1,j2)
          write(ifx,"('   ',a,' ',f15.5, '  ! Name for site_type=',i5)")
     &    aaa(j1:j2),rmax(ic),ic
        enddo
       else
c        write(ifx,"(' ',2f25.15, ' !alat rmaxs')")alat,rmaxs
        write(ifx,"(' ',f25.15, ' !alat ')")alat
        write(ifx,"(' ',3f25.15, '  !prvec1 ')") (plat(ix,1),ix=1,3)
        write(ifx,"(' ',3f25.15, '  !prvec2 ')") (plat(ix,2),ix=1,3)
        write(ifx,"(' ',3f25.15, '  !prvec3 ')") (plat(ix,3),ix=1,3)
        write(ifx,"(i6,'  !nbas ')") nbas
        do ibas=1,nbas
        write(ifx,"(' ',3f25.15,i5,' !bas site_type for site',i5 )") 
     &        (bas(ix,ibas),ix=1,3),ips(ibas),ibas
        enddo
        write(ifx,"(i6,'  ! ntyp ')") nclass
        do ic=1,nclass
          aaa = slabl(ic)
          call word(aaa,1,j1,j2)
          write(ifx,"('        ',a,' ',f15.5
     &    , '  ! Name for site_type',i5)")
     &    aaa(j1:j2),rmax(ic),ic
        enddo
       endif 
c---------------
       call modeinfo(ifx)
      else
       read(ifx,*) usegen
       read(ifx,"(a)") ssymgr
       read(ifx,*)alat         !,rmaxs
       read(ifx,*) (plat(ix,1),ix=1,3)
       read(ifx,*) (plat(ix,2),ix=1,3)
       read(ifx,*) (plat(ix,3),ix=1,3)
       read(ifx,*) nbas
       do ibas=1,nbas
        read(ifx,*) (bas(ix,ibas),ix=1,3),ips(ibas)
       enddo
       read(ifx,*) nclass
       do ic=1,nclass
        read(ifx,*)slabl(ic),rmax(ic)
       enddo
      endif
      end

      subroutine rmtshow(nclass,rmax)
      real*8 rmax(1)
      do ic=1,nclass
       write(6,*)' rmax=',rmax(ic)
      enddo
      end

      subroutine modeinfo(ifx)
       write(ifx,"(a)")
     & "#-------------------------------------------------------"
       write(ifx,"(a)")
     & " mode = 0 !Search site positions for given generator."
       write(ifx,"(a)")
     & "          !Then find additional symmetry generator."
       write(ifx,"(a)")
     & "          !You can start from no given generators "
       write(ifx,"(a)")
     & "      = 1 !Search site positions for given generator."
       write(ifx,"(a)")
     & "      = 2 !Check consistency. Use given symmetry generator."
       end

      subroutine wordtcut(str,j1)
C- Count blanks of str at tail
C ----------------------------------------------------------------------
Ci Inputs
Ci   str   :string
Co Outputs
Co   j1    :str(1:j1) is meaningful becasue str(j1+1:) are blank.
C ----------------------------------------------------------------------
      character*(*) str
      integer iw,j1
      do i = len(str),1,-1
        if(str(i:i) /= ' ') then
          j1 = i
          goto 90
        endif
      enddo
      j1=0
 90   continue
      end
















