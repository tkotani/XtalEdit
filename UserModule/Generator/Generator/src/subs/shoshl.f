      subroutine shoshl(sopts,nbas,bas,plat,mxnbr0,z,dclabl,ipc,ves,
     .  eula,nclass)
C- Print nearest-neighbor shells
C ----------------------------------------------------------------
Ci Inputs
Ci   Everything is input
Ci   sopts: a set of modifiers, with the syntax
Ci          [:v][:r=#][:i[=#]:list]
Ci          :r=# sets range for shells
Ci          :v prints out electrostatic potential
Ci          :i[=style-#]:list  restricts neighbors in shell to list.
Ci                             This must be the last modifier.
Cr  24 Nov 97  changed modifier list
C ----------------------------------------------------------------
C     implicit none
C Passed parameters
      integer nbas,nclass,mxnbr0
      double precision bas(3,1),plat(3,3),dclabl(nclass),ves(1),
     .  eula(1),z(1)
      integer ipc(1)
      character sopts*(*)
C Local parameters
      logical lves,leula,a2bin
      double precision avwsr,avw,range,xx
      integer npr(2),mxnbr,ib,ic,oiax,iclbsj,owk,j,j1,j2,lstyle,
     .  i1mach,scrwid,niax
      parameter (niax=10)
      character*8  dc*1
      parameter (scrwid=120)
C heap:
      integer w(1),nlstc,olstc
      common /w/ w

C --- Parse modifiers ---
      lves  = .false.
      leula = .false.
      lstyle = 1
      range = 5
      nlstc = 0
      if (sopts .ne. ' ') then
C       ls = len(sopts)
        j1 = 1
        dc = sopts(j1:j1)
        j1 = j1+1

C   ... Return here to resume parsing for arguments
   40   continue
        call nwordg(sopts,0,dc//' ',1,j1,j2)

C   ... Parse special arguments
        if (j2 .ge. j1) then
C         print *, sopts(j1:j2)
          if (sopts(j1:j2) .eq. 'v')  then
            lves = .true.

          elseif (sopts(j1:j2) .eq. 'e')  then
            leula = .true.

          elseif (sopts(j1:j1+1) .eq. 'r=') then
            j = 0
            if (.not. a2bin(sopts(j1+2:),range,4,0,' ',j,j2-j1-1))
     .        goto 999
          elseif (sopts(j1:j1) .eq. 'i')  then
            if (sopts(j1+1:j1+1) .eq. '=') then
              j = 0
              if (.not. a2bin(sopts(j1+2:),lstyle,2,0,' ',j,j2-j1-1))
     .        goto 999
            endif
            j1 = j2+2
            call nwordg(sopts,0,dc//' ',1,j1,j2)
            if (j2 .lt. j1) goto 999
            call defi(olstc, nclass)
            call clist(lstyle,sopts(j1:),dclabl,z,nclass,nlstc,
     .        w(olstc))
            call awrit2('%N shoshl: pairs %n:1i',' ',scrwid,i1mach(2),
     .        nlstc,w(olstc))
            goto 42
          else
            goto 999
          endif
          j1 = j2+2
          goto 40
   42     continue
        endif
      endif

C --- Show shells for each class ---
      if (mxnbr0 .eq. 0) then
        mxnbr = 2*range**3
      else
        mxnbr = mxnbr0
      endif
      call defi(oiax,niax*mxnbr)
      call defdr(owk,mxnbr)
      avw = avwsr(plat,1d0,xx,nbas)
c     call pshprt(50)
      do  20  ic = 1, nclass
        ib = iclbsj(ic,ipc,nbas,1)
        call nghbor(nbas,plat,bas,range*avw,range*avw,ib,
     .              mxnbr,npr,w(oiax),w(owk))
        call xxsho(npr(1),nbas,plat,bas,w(oiax),ipc,dclabl,nlstc,
     .    w(olstc),lves,ves,leula,eula,z)
   20 continue
      call rlse(oiax)
      return

  999 call rxs('shoshl: failed to parse ',sopts)
      end
      subroutine xxsho(npr,nbas,plat,bas,iax,ipc,dclabl,nlstc,lstc,lves,
     .  ves,leul,eula,z)
C- Kernel called by shoshl
C  nlstc,lstc:  a list of classes to include as pairs (nlstc>0)
C     implicit none
      logical lves,leul
      integer npr,nbas,niax,ipc(1),nlstc,lstc(nlstc)
      parameter (niax=10)
      integer iax(niax,1)
      double precision plat(3,3),bas(3,1),dclabl(1),ves(1),eula(nbas,3),
     .  z(32)
      integer ih(2,120),scrwid
      parameter (scrwid=120)
      integer i,l,ishell,nshell,j,k,ii,kk,ic,jc,i1,lgunit,awrite,iclbsj,
     .  ib
      double precision dr(3),d,drr2,dshell,fuzz,z1(3),z2(3),alfa,beta,
     .  angle,pi,ddot
      character*8 clabl,outs1*25,outs2*(scrwid),outsv*(scrwid),
     .  outse*(scrwid)

      pi = 4*datan(1d0)
      fuzz = 1d-3
      dshell = 0
      nshell = 0
      ishell = 1
      if (leul) then
        alfa = eula(iax(1,1),1)
        beta = eula(iax(1,1),2)
        z1(1) = dcos(alfa)*dsin(beta)
        z1(2) = dsin(alfa)*dsin(beta)
        z1(3) = dcos(beta)
      endif
      ic = ipc(iax(1,1))
      call r8tos8(dclabl(ic),clabl)
      print 302, clabl, ic, nint(z(ic))
  302 format(/' Shell decomposition for class ',a,
     .        '  class',i4,'  z=',i2/
     .        ' shell   d     nsh csiz  class ...')

      do  10  i = 1, npr
        d = dsqrt(drr2(plat,bas(1,iax(1,i)),bas(1,iax(2,i)),
     .    iax(3,i),iax(4,i),iax(5,i),dr))
C   ... new shell, or close of last shell
        if (dabs(d-dshell) .gt. fuzz .or. i .eq. npr) then
          i1 = i-1
          if (i .eq. npr) i1 = i
          nshell = nshell+1
          write (outs1,301) nshell, dshell, i1+1-ishell, i1
  301     format(i4,f10.6,i4,i5,2x)
          call iinit(ih,2*(i-ishell))
C     ... ii is the number of different classes in this shell
          ii = 0
          do  12  j = ishell, i1
            ic = ipc(iax(2,j))
C       ... See whether already found one of these or if not in list
            kk = 0
            if (nlstc .gt. 0) then
              kk = -1
              do  15  jc = 1, nlstc
                if (lstc(jc) .gt. ic) goto 17
                if (lstc(jc) .eq. ic) kk = 0
   15         continue
   17         continue
            endif
            if (kk .eq. 0) then
              do  14  k = 1, ii
                if (ih(2,k) .ne. ic) goto 14
                kk = k
   14         continue
            endif
C       ... We haven't --- increment ii and add this one
            if (kk .eq. 0) then
              ii = ii+1
              kk = ii
              ih(2,kk) = ic
            endif
C       ... Increment number of occurrences of this species
            ih(1,kk) = ih(1,kk)+1
   12     continue

C     ... Setup for printout
          outs2 = ' '
          outsv = ' '
          outse = ' '
          kk = 0
          do  16  k = 1, ii
            kk = kk+1
            call r8tos8(dclabl(ih(2,k)),clabl)
            l = awrite('%a  %np%i:'//clabl//
     .        '%a%?;n>1;(%i);%j;',outs2,len(outs2),0,
     .        (kk-1)*14,ih(2,k),ih(1,k),ih(1,k),0,0,0,0)
            if (lves) call awrit2('%np%d',outsv,len(outsv),0,
     .        (kk-1)*14,ves(ih(2,k)))
            ib = iclbsj(ih(2,k),ipc,-nbas,1)
            if (leul .and. ib .gt. 0) then
              alfa = eula(ib,1)
              beta = eula(ib,2)
              z2(1) = dcos(alfa)*dsin(beta)
              z2(2) = dsin(alfa)*dsin(beta)
              z2(3) = dcos(beta)
              angle = dacos(max(-1d0,min(1d0,ddot(3,z1,1,z2,1))))
              if (angle .gt. pi) angle = angle - 2*pi
              call awrit2('%np%d',outse,len(outse),0,(kk-1)*14,angle)
            endif
            if (l .gt. scrwid-35) then
              call awrit0(outs1//outs2,' ',-scrwid,lgunit(1))
              if(lves) call awrit0('v%26f'//outsv,' ',-scrwid,lgunit(1))
              if(leul) call awrit0('e%26f'//outse,' ',-scrwid,lgunit(1))
              kk = 0
              outs2 = ' '
              outsv = ' '
            endif
   16     continue
          if (outs2 .ne. ' ') then
            call awrit0(outs1//outs2,' ',-scrwid,lgunit(1))
            if (lves) call awrit0('v%26f'//outsv,' ',-scrwid,lgunit(1))
            if (leul) call awrit0('e%26f'//outse,' ',-scrwid,lgunit(1))
          endif
          outs1 = ' '

          ishell = i
          dshell = d
        endif
   10 continue
      end
       subroutine shoang(sopts,nbas,bas,plat,mxnbr0,slabl,ips)
C- Print bond angles
C ----------------------------------------------------------------
Ci Inputs
Ci   sopts :a set of modifiers, with the syntax
Ci         :  [:r=#][:spec=spec-list][:spec=spec-list]
Ci         :  :r=# sets range for shells
Ci         :  :sites=site-list collects angles only for sites within list
Ci         :  :spec=list       prints angles for bonds connecting to
Ci                             species in list
Ci   bas   :basis vectors, in units of alat
Ci   plat  :primitive lattice vectors, in units of alat
Ci   mxnbr0
Ci   slabl :list of species labels
Ci   ips   :species table: site ib belongs to species ips(ib)
Ci   nbas  :size of basis
Cu Updates
Cu   13 Sep 01 Added options sopts.  Altered argument list.
C ----------------------------------------------------------------
C     implicit none
C ... Passed parameters
      integer nbas,mxnbr0
      double precision bas(3,nbas),plat(3,3),slabl(*)
      integer ips(nbas)
      character sopts*(*)
C ... Local parameters
      double precision avwsr,avw,range,xx,zz
      integer npr(2),mxnbr,ib,nshell,nmxshl,niax,j,j1,j2,
     .  nspec,mxint,oiax,owk,onum,oang,od,nsites,oslist,nbonds,oblist,
     .  ilst,parg,m,iv(10)
      parameter (niax=10)
      character dc*1
C ... Heap
      integer w(1)
      common /w/ w
C ... External calls
      external defdr,defi,nghbor,nwordg,pvang1,pvang2,rlse,rxs

C ... Setup
      range = 2.5d0
      nspec = mxint(nbas,ips)
      nsites = 0
      nbonds = 0
      call defi(oslist,nbas)
      call defi(oblist,nbas)

C ... Switches
      dc = sopts(1:1)
      if (dc .ne. ' ') then
        j2 = 0
C   ... Return here to resume parsing for arguments
   10   continue
        j2 = j2+1
        if (sopts(j2:j2) .eq. dc) goto 10
        j1 = min(len(sopts),j2)
        call nwordg(sopts,0,dc//' ',1,j1,j2)
        if (j2 .ge. j1) then
          if (.false.) then

C         range
          elseif (sopts(j1:j1+1) .eq. 'r=')  then
            m = 0
            j = parg('r=',4,sopts(j1:),m,len(sopts(j1:)),
     .        dc//' ',1,1,iv,range)
            if (j .le. 0) goto 999

C         Site list
          elseif (sopts(j1:j1+4) .eq. 'sites') then
            if (sopts(j1+5:j1+5) .eq. '=') sopts(j1+5:j1+5) = dc
            call baslst(10,sopts(j1+5:),ips,nbas,slabl,zz,0,' ',xx,
     .        nsites,w(oslist))

C         Bond list
          elseif (sopts(j1:j1+4) .eq. 'bonds') then
            if (sopts(j1+5:j1+5) .eq. '=') sopts(j1+5:j1+5) = dc
            call baslst(10,sopts(j1+5:),ips,nbas,slabl,zz,0,' ',xx,
     .        nbonds,w(oblist))
          endif
          goto 10

        endif
      endif

      if (mxnbr0 .eq. 0) then
        mxnbr = 2*range**3
      else
        mxnbr = mxnbr0
      endif
      call defi(oiax,niax*mxnbr)
      call defdr(owk,mxnbr)
      avw = avwsr(plat,1d0,xx,nbas)

C --- For every site in list, generate tables of bond angles ---
      ilst = 0
      do  ib = 1, nbas
        if (nsites .gt. 0) then
          if (w(oslist+ilst) .ne. ib) goto 31
        endif
        ilst = ilst+1

C   ... Get neighbor lists

        call nghbor(nbas,plat,bas,range*avw,range*avw,ib,
     .              mxnbr,npr,w(oiax),w(owk))

C   ... Get shell dimensions 
        call defi(onum,-nspec*npr(1))
        call pvang1(npr(1),nbas,plat,bas,w(oiax),ips,w(onum),nshell,
     .    nmxshl)
        call rlse(onum)
        call defi(onum, -nspec**2*nshell**2)
        call defdr(oang, nspec**2*nshell**2*nmxshl**2)
        call defdr(od,   nshell)

C   ... Print bond angles
        call pvang2(npr(1),nbas,nspec,nshell,nmxshl,plat,bas,w(oiax),
     .    ips,slabl,nbonds,w(oblist),w(onum),w(oang),w(od))
        call rlse(onum)
   31   continue
      enddo
      call rlse(oslist)
      return

  999 call rxs('shoang: failed to parse ',sopts)
      end

      subroutine pvang1(npr,nbas,plat,bas,iax,ips,num,nshell,nmxshl)
C- Help routine for shoang
C ----------------------------------------------------------------------
Ci Inputs
Ci   npr   :number of pairs in neighbor table
Ci   nbas  :size of basis
Ci   plat  :primitive lattice vectors, in units of alat
Ci   bas   :basis vectors, in units of alat
Ci   iax   :neighbor table containing pair information for one site.
Ci         :Table must be sorted by increasing distance from iax(1)
Ci   ips   :species table: site ib belongs to species ips(ib)
Co Outputs
Co   num   :(ishell,is) number of pairs in shell ishell of species is
Co   nshell:number of shells
Co   nmxshl:max value of num
C ----------------------------------------------------------------------
C     implicit none
C ... Passed parameters
      integer npr,nbas,nshell,nmxshl,niax,ips(1),num(npr,1)
      parameter (niax=10)
      integer iax(niax,1)
      double precision plat(3,3),bas(3,1)
C ... Local parameters
      integer i,is
      double precision d,wk(0:3),tol

      tol = 1d-6
C --- Get no. of shells and max no. of atoms in 1 shell and 1 class ---
      nshell = 0
      nmxshl = 0
      d = 0d0
      do  10  i = 2, npr
        is = ips(iax(2,i))
        call dlmn(nbas,plat,bas,iax(1,i),wk)
C       distance changed by more than tol ... new shell
        if (dabs(wk(0)-d) .gt. tol) then
          nshell = nshell + 1
          d = wk(0)
        endif
        num(nshell,is) = num(nshell,is) + 1
        nmxshl = max0(nmxshl,num(nshell,is))
   10 continue

      end

      subroutine pvang2(npr,nbas,nspec,nshell,nmxshl,plat,bas,iax,
     .  ips,slabl,nbonds,blist,num,ang,d)
C- Kernel called by shoang
C ----------------------------------------------------------------------
Ci Inputs
Ci   npr   :number of neighbors connecting site ib=iax(1,1)
Ci   nbas  :size of basis
Ci   nspec :number of species
Ci   nshell:number of shells
Ci   nmxshl:dimensions ang
Ci   plat  :primitive lattice vectors, in units of alat
Ci   bas   :basis vectors, in units of alat
Ci   iax   :neighbor table containing pair information (pairc.f)
Ci   ips   :species table: site ib belongs to species ips(ib)
Ci   slabl :struct containing global strings
Ci   num
Co Outputs
Co   ang   :table of angles
Co   d     :table of distances for each shell
Co   Angles and distances are printed out
Cu Updates
Cu   13 Sep 01 
C ----------------------------------------------------------------------
C     implicit none
C ... Passed parameters
      integer npr,nbas,nspec,nshell,nmxshl,niax,ips(1),
     .  num(nspec,nspec,nshell,nshell),nbonds,blist(nbonds)
      parameter (niax=10)
      integer iax(niax,1)
      character*8 slabl(*)
C ... Local parameters
      double precision plat(3,3),bas(3,1),d(nshell),
     .  ang(nmxshl**2,nspec,nspec,nshell,nshell)
      integer i,j,n,is,js,nsh1,nsh2,nmx2,k
      double precision rdtodg,d1,d2,dp,ddot,wk1(0:3),wk2(0:3)
C ... External calls
      external dlmn,rxx

      nmx2 = nmxshl**2
      rdtodg = 45d0 / datan(1.d0)

C --- Accumulate bond angles by shell and class ---
      nsh1 = 0
      d1 = 0d0
      do  20  i = 2, npr
        is = ips(iax(2,i))
        call dlmn(nbas,plat,bas,iax(1,i),wk1)
        if (dabs(wk1(0)-d1) .gt. 1d-6) then
          nsh1 = nsh1 + 1
          d1 = wk1(0)
          d(nsh1) = d1
        endif
        nsh2 = nsh1
        d2 = d1
        if (nbonds .gt. 0) then
          k = 0
          call hunti(blist,nbonds,iax(2,i),0,k)
          if (k .ge. nbonds) goto 20
          if (blist(k+1) .ne. iax(2,i)) goto 20
        endif
        do  10  j = i+1, npr
          js = ips(iax(2,j))
          call dlmn(nbas,plat,bas,iax(1,j),wk2)
          if (dabs(wk2(0)-d2) .gt. 1d-6) then
            nsh2 = nsh2 + 1
            d2 = wk2(0)
          endif
          if (nbonds .gt. 0) then
            k = 0
            call hunti(blist,nbonds,iax(2,j),0,k)
            if (k .ge. nbonds) goto 10
            if (blist(k+1) .ne. iax(2,j)) goto 10
          endif
          dp = ddot(3,wk1(1),1,wk2(1),1)
          if (dp .gt.  1d0) dp =  1d0
          if (dp .lt. -1d0) dp = -1d0
          if (nsh1 .eq. nsh2 .and. js .lt. is) then
            num(js,is,nsh1,nsh2) = num(js,is,nsh1,nsh2) + 1
            n = num(js,is,nsh1,nsh2)
            ang(n,js,is,nsh1,nsh2) = rdtodg*dacos(dp)
          else
            num(is,js,nsh1,nsh2) = num(is,js,nsh1,nsh2) + 1
            n = num(is,js,nsh1,nsh2)
            ang(n,is,js,nsh1,nsh2) = rdtodg*dacos(dp)
          endif
          call rxx(n .gt. nmx2,'PVANG2: num gt nmx2')
   10   continue
   20 continue
      call rxx(nsh1 .ne. nshell,'PVANG2: nsh1 ne nshell')

C --- Printout ---
      print 400, iax(1,1), slabl(ips(iax(1,1)))
  400 format(/' Bond angles for site',i4,', species ',a/
     .  ' shl1    d1    shl2    d2     cl1      cl2       angle(s) ...')

      do  60  nsh1 = 1, nshell
        do  50  nsh2 = nsh1, nshell
          do  40  is = 1, nspec
            do  30  js = 1, nspec
              n = num(is,js,nsh1,nsh2)
              if (n .ne. 0) then
                print 401, nsh1, d(nsh1), nsh2, d(nsh2), slabl(is),
     .            slabl(js), (ang(i,is,js,nsh1,nsh2), i = 1, n)
              endif
   30       continue
   40     continue
   50   continue
   60 continue

  401 format(2(1x,i3,1x,f9.6),1x,2(1x,a8),20(4(1x,f7.2):/47x))

      end
