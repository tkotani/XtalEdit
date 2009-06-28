      subroutine ovlchk(nbas,nbasp,pos,alat,rmax,rmt,dclabl,
     .  ips,mode,plat,fovl,volsph)
C- Check volume and sphere overlaps
C ----------------------------------------------------------------
Ci Inputs
Ci   nbas,nbasp,dclabl,ips,alat,plat,pos
Ci   mode   same as mode, in pairc.f
Ci   rmax,rmt (see remarks)
Co Outputs
Co   fovl, a function of the positive overlaps, for now set to
Co         sum (ovl)^6
Cr Remarks
Cr   Checks overlaps for both rmax and rmt.
Cr   rmt(1) <= 0 switches off part with rmt.
C ----------------------------------------------------------------
C     implicit none
C Passed parameters
      integer nbas,nbasp
      double precision plat(3,3),pos(3,nbasp),rmax(1),rmt(1),
     .  alat,fovl,volsph,dclabl(1)
      integer ips(1),mode(3)
C Local parameters
      double precision dd(3),dd1,dd2,sumrs,summt,ovlprs,ovlpmt,
     .  ctrs,ctmt,ddot,dlat(3),xx,avwsr,vol
C     double precision qlat(3,3)
      integer ibas,jbas,ic,jc,kc,m,ipr,i1mach,m1,m2,m3,isw,lgunit,stdo
      character*80 a, ch*1
      logical lterse,cmdopt,lrmt
      character*8 clabl,clablj

      call getpr(ipr)
      lrmt = rmt(1) .gt. 0
      stdo = lgunit(1)

C --- Determine which linear combination of plat is shortest ---
      dd1 = 9d9
      call dpzero(dlat,3)
      do  10  m1 = 1, 3
      do  10  m2 = 1, 3
      do  10  m3 = 1, 3
        if (mode(m1)*mode(m2)*mode(m3) .eq. 0) goto 10
        do  12  ic = -1, 1
        do  12  jc = -1, 1
        do  12  kc = -1, 1
          call dpcopy(plat(1,m1),dd,1,3,dble(ic))
          call dpadd(dd,plat(1,m2),1,3,dble(jc))
          call dpadd(dd,plat(1,m3),1,3,dble(kc))
          dd2 = ddot(3,dd,1,dd,1)
          if (dd1 .gt. dd2 .and. dd2 .gt. 1d-6) then
            call dpcopy(dd,dlat,1,3,1d0)
            dd1 = dd2
          endif
   12   continue
   10 continue

      if (ipr .ge. 10)
     .  call awrit1('%N   Site    Class%12fRmax%?;n;%8fRmt ;;'//
     .  '%16fPosition',' ',80,i1mach(2),isw(lrmt))
      volsph = 0d0
      do  20  ibas = 1, nbasp
        ic = ips(ibas)
        if (ipr .le. 10) goto 20
        if (ibas .eq. nbas+1) write(stdo,'(''  ... Padding basis'')')
        call r8tos8(dclabl(ic),clabl)
        if (dclabl(1) .eq. 0d0) call awrit1('%x%,4i',clabl,8,0,ic)
        if (lrmt) then
          write(stdo,450) ibas,ic,clabl,rmax(ic),rmt(ic),
     .      (pos(m,ibas),m=1,3)
  450     format(i5,3x,i4,2x,a8,2f12.6,3f11.5)
        else
          write(stdo,351) ibas,ic,clabl,rmax(ic),(pos(m,ibas),m=1,3)
  351     format(i5,3x,i4,2x,a8,f12.6,3f11.6)
        endif
   20 if (ibas .le. nbas) volsph = volsph + 4.188790205d0*rmax(ic)**3
   21 xx = avwsr(plat,alat,vol,nbas)
      if (ipr .ge. 10)
     .  call awrit3('%N Cell volume= %1,5;5d   Sum of sphere volumes='//
     .  ' %1,5;5d (%1;5d)',' ',80,i1mach(2),vol,volsph,volsph/vol)

C --- Check sphere overlaps ---
      fovl = 0
      lterse = cmdopt('-terse',6,0,a) .or. cmdopt('--terse',7,0,a)
      if (lrmt       .and. ipr .gt. 10) write(stdo,453)
      if (.not. lrmt .and. ipr .gt. 10) write(stdo,463)
      do  30  ibas = 1, nbasp
        ic = ips(ibas)
        if (ipr .ge. 10) then
          call r8tos8(dclabl(ic),clabl)
          if (dclabl(1) .eq. 0d0) call awrit1('%x%,4i',clabl,8,0,ic)
        endif
        do  30  jbas = ibas, nbasp
        jc = ips(jbas)
        if (ipr .ge. 10) then
          call r8tos8(dclabl(jc),clablj)
          if (dclabl(1) .eq. 0d0) call awrit1('%x%,4i',clablj,8,0,jc)
        endif
        if (ibas .eq. jbas) then
          if (ddot(3,dlat,1,dlat,1) .eq. 0) goto 30
          call dcopy(3,dlat,1,dd,1)
        else
          do  33  m = 1, 3
   33     dd(m) = pos(m,jbas) - pos(m,ibas)
          dd1 = dsqrt(dd(1)**2 + dd(2)**2 + dd(3)**2)
          call shorps(1,plat,mode,dd,dd)
          dd2 = dsqrt(dd(1)**2 + dd(2)**2 + dd(3)**2)
          if (dd2 .gt. dd1+1d-9) call rx('bug in ovlchk')
C ...     test against shorbz
C         call mkqlat(plat,qlat,xx)
C         call shorbz(dd,dd,plat,qlat)
C         print *, dd2,dsqrt(dd(1)**2 + dd(2)**2 + dd(3)**2)
        endif
        do  34  m = 1, 3
   34   dd(m) = dd(m)*alat
        dd1 = dsqrt(dd(1)**2 + dd(2)**2 + dd(3)**2)
        sumrs = rmax(ic) + rmax(jc)
        ovlprs = sumrs - dd1
        if (dd1 .lt. 1d-6) then
          write(stdo,451) ibas,jbas,clabl,clablj,dd,dd1
          call rx('ovlchk: positions coincide')
        endif
        ctrs = nint(1000*ovlprs/dd1)/10d0
        if (lrmt) then
          summt = rmt(ic) + rmt(jc)
          ovlpmt = summt - dd1
          ctmt = nint(1000*ovlpmt/dd1)/10d0
        endif
        fovl = fovl + max(ovlprs/dd1,0d0)**6
        if ((lterse .or. ipr .le. 40) .and. ctrs .le. -10
     .    .or. ipr .le. 10) goto 30
        ch = ' '
        if (ovlprs .ge. 0d0) ch='*'
        if (lrmt .and. .false.) then
          write(stdo,451) ibas,jbas,clabl,clablj,dd,dd1,
     .      sumrs,ovlprs,ctrs,summt,ovlpmt,ctmt,ch
  451    format(2i3,2x,a4,1x,a4,3f6.2,2f7.2,f7.2,f5.1,f7.2,f7.2,f5.1,a1)
        else
          write(stdo,461) ibas,jbas,clabl,clablj,dd,dd1,
     .      sumrs,ovlprs,ctrs,ch
  461     format(2i3,2x,a8,a8,3f7.3,2f7.3,f7.2,f6.1,a1)
        endif
  453   format(/' ib jb',2x,'cl1     cl2',7x,' Pos(jb)-Pos(ib)',
     .   7x,'Dist   sumrs   Ovlp   %  summt   Ovlp   %')
  463   format(/' ib jb',2x,'cl1     cl2',8x,'Pos(jb)-Pos(ib)',
     .   6x,'Dist  sumrs   Ovlp    %')
   30 continue

C      if (ipr .gt. 0)
C     .  call awrit1('%N ovlchk: fovl= %;6g',' ',80,i1mach(2),fovl)

      end
