      subroutine pmblk(nblk,ipm,ioffo,ioffn,lds,src,mode,alfa,nlma,ldd,
     .  dst,nmax)
C- Permutes subblocks of an array and adds into a new array
C ----------------------------------------------------------------------
Ci Inputs
Ci   nblk  :number of blocks to permute
Ci   ipm   :permutation of subblocks to take from src or dst
Ci   ioffo :sequence markers to start of subblocks to asrc.  End of
Ci          subblock implied by start of next subblock.  ioffo should be
Ci          always increasing, with dimension 1+nblk, the last entry
Ci          marking end of last subblock.
Ci   ioffn :same as ioffo, but for dst.
Ci   lds   :leading dimension of src
Ci   src   :source matrix
Ci   mode:  one's digit: 1, make ioffo offsets relative to ioffo(1)
Ci          ten's digit: 1, make ioffn offsets relative to ioffn(1)
Ci          100's digit: 0, no permutation of indices
Ci                       1, permute sequence of subblocks in src by ipm
Ci                       2, permute sequence of subblocks in dst by ipm
Ci         1000's digit: 1, add into new array, not copy
Ci                       2, scale dst(*,j) by alfa(j)
Ci                       3, both 1 and 2
Ci                       4  add 4 to permute rows for each nlma columns
Ci                       8  subblocks in both rows and cols (see Remarks)
Ci                       9  like 8, but add into dst.
Ci   alfa  :scale src by alfa, if mode set
Ci   nlma  :number of rows for which to permute columns
Ci          (not used only if 1000s digit of mode is 8)
Ci   ldd   :leading dimension of dst
Co Outputs
Co   dst   :permutation of src
Co   nmax  :largest column addressed in dst
Cr Remarks
Cr   By default pmblk permutes columns around, doing the permutation for
Cr   each of nlma rows.  if mode 1000's digit >=8, pmblk permutes
Cr   both columns and rows.
Cr   If size of destination subblock smaller than source, truncate.
Cr   If instead larger, accumulate only smaller size.
Cu Updates
C ----------------------------------------------------------------
C     implicit none
      integer nblk,lds,ldd,nlma,mode,ioffn(nblk),ioffo(nblk),
     .  ipm(nblk),nmax
      double precision dst(ldd,1),src(lds,1),alfa(1)
      integer ilma,ib,iofo,ilm,iofn,nlm1,ipn,ipo,offo0,offn0,
     . nn,moded(4),jb,jofo,jlm,jofn,nlm2,jbn,jbo

      moded(1) = mod(mode,10)
      moded(2) = mod(mode/10,10)
      moded(3) = mod(mode/100,10)
      moded(4) = mod(mode/1000,10)

C     if (moded(3).ne.0) call awrit2('pm ipm  %n,3i',' ',80,6,nblk,ipm)
C     call awrit2('pm iofo %n,3i',' ',80,6,nblk+1,ioffo)
C     call awrit2('pm iofn %n,3i',' ',80,6,nblk+1,ioffn)

      offn0 = 0
      offo0 = 0
      if (moded(1) .eq. 1) offo0 = ioffo(1)
      if (moded(2) .eq. 1) offn0 = ioffn(1)
      nmax = -1
      if (moded(4) .le. 7) then
        do  10  ib = 1, nblk
          ipo = ib
          if (moded(3) .eq. 1) ipo = ipm(ib)
          ipn = ib
          if (moded(3) .ge. 2) ipn = ipm(ib)
          nn = ioffn(ipn+1)-ioffn(ipn)
          nlm1 = min(nn,ioffo(ipo+1)-ioffo(ipo))
          iofn = ioffn(ipn) - offn0
          iofo = ioffo(ipo) - offo0
          if (moded(4) .eq. 0) then
            do  20  ilm = 1, nlm1
            do  20  ilma = 1, nlma
   20       dst(ilma,ilm+iofn) = src(ilma,ilm+iofo)
          elseif (moded(4) .eq. 1) then
            do  25  ilm = 1, nlm1
            do  25  ilma = 1, nlma
   25       dst(ilma,ilm+iofn) = dst(ilma,ilm+iofn)
     .                         + src(ilma,ilm+iofo)
          elseif (moded(4) .eq. 2) then
            do  30  ilm = 1, nlm1
            do  30  ilma = 1, nlma
   30       dst(ilma,ilm+iofn) = src(ilma,ilm+iofo)*alfa(ilm+iofn)
          elseif (moded(4) .eq. 3) then
            do  35  ilm = 1, nlm1
            do  35  ilma = 1, nlma
   35       dst(ilma,ilm+iofn) = dst(ilma,ilm+iofn)
     .                         + src(ilma,ilm+iofo)*alfa(ilm+iofn)
          elseif (moded(4) .eq. 4) then
            do  40  ilma = 1, nlma
            do  40  ilm = 1, nlm1
   40       dst(ilm+iofn,ilma) = src(ilm+iofo,ilma)
          elseif (moded(4) .eq. 5) then
            do  45  ilma = 1, nlma
            do  45  ilm = 1, nlm1
   45       dst(ilm+iofn,ilma) = dst(ilm+iofn,ilma)
     .                         + src(ilm+iofo,ilma)
          elseif (moded(4) .eq. 6) then
            do  50  ilma = 1, nlma
            do  50  ilm = 1, nlm1
   50       dst(ilm+iofn,ilma) = src(ilm+iofo,ilma)*alfa(ilm+iofn)
          else
            do  55  ilma = 1, nlma
            do  55  ilm = 1, nlm1
   55       dst(ilm+iofn,ilma) = dst(ilm+iofn,ilma)
     .                         + src(ilm+iofo,ilma)*alfa(ilm+iofn)
          endif
          nmax = max(nn+iofn,nmax)
   10   continue
      else
        do  100  ib = 1, nblk
          ipo = ib
          if (moded(3) .eq. 1) ipo = ipm(ib)
          ipn = ib
          if (moded(3) .ge. 2) ipn = ipm(ib)
          nn = ioffn(ipn+1)-ioffn(ipn)
          nlm1 = min(nn,ioffo(ipo+1)-ioffo(ipo))
          iofn = ioffn(ipn) - offn0
          iofo = ioffo(ipo) - offo0
          do  110  jb = 1, nblk
            jbo = jb
            if (moded(3) .eq. 1) jbo = ipm(jb)
            jbn = jb
            if (moded(3) .ge. 2) jbn = ipm(jb)
            nlm2 = min(ioffn(jbn+1)-ioffn(jbn),ioffo(jbo+1)-ioffo(jbo))
            jofn = ioffn(jbn) - offn0
            jofo = ioffo(jbo) - offo0
            if (moded(4) .eq. 8) then
              do  120  jlm = 1, nlm2
              do  120  ilm = 1, nlm1
  120         dst(ilm+iofn,jlm+jofn) = src(ilm+iofo,jlm+jofo)
            else
              do  125  jlm = 1, nlm2
              do  125  ilm = 1, nlm1
  125         dst(ilm+iofn,jlm+jofn) = dst(ilm+iofn,jlm+jofn) +
     .                                 src(ilm+iofo,jlm+jofo)
            endif
  110     continue
          nmax = max(nn+iofn,nmax)
  100   continue
      endif
      end
