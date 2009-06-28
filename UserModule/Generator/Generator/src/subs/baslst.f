      subroutine baslst(iopt,slst,ips,nbas,slabl,z,nopt,optlst,optarg,
     .  nlist,list)
C- Generates a list of sites from a string specification
C ----------------------------------------------------------------
Ci Inputs
Ci   iopt  :1s digit
Ci         : 1  print out list
Ci         :10s digit
Ci         : 0, do not sort list
Ci         : 1, sort list, paring duplicates
Ci   slst  :string bearing information for list
Ci   ips   :species table: site ib belongs to species ips(ib)
Ci   nbas  :size of basis
Ci   z     :Table of nuclear charges by species
Ci     ... baslst is designed to convert switches (substring of slst)
Ci         into numbers; not implemented
Ci   nopt  :number of special modifiers
Ci   optlst:string of nopt tokens for modifiers
Co Outputs
Co   nlist :number of elements in list
Co   list  :list of sites
Co   optarg:numbers possibly generated from optional switches
Cr Remarks
Cu Updates
Cu   13 Sep 01 Supersedes old optget.
C ----------------------------------------------------------------------
C     implicit none
C ... Passed parameters
      integer iopt,nbas,ips(1),nlist,list(1),nopt
      character slst*(*),optlst(nopt)*(*)
      character*8 slabl(*)
      double precision z(1),optarg(1)
C ... Local parameters
      integer i,j,j1,j2,ls,m,lstyle,k1,k2,
     .  iv,parg,olist,nlists,mxint,nspec,ib,is,iclbsj
      character dc*1
      integer lgunit
C ... Heap
      integer w(1)
      common /w/ w
C ... External calls
      external awrit2,defi,ishell,mkilst,nwordg,rxs,slist,word

      nlist = 0
      if (slst .eq. ' ') return
      ls = len(slst)
      j1 = 1
      dc = slst(j1:j1)
      j1 = j1+1

C ... Return here to resume parsing for arguments
   40 continue
      call nwordg(slst,0,dc//' ',1,j1,j2)

C ... Parse special arguments (not implemented)
      if (slst(j2+1:j2+1) .ne. ' ')  then
        do  8  i = 1, nopt
          call word(optlst(i),1,k1,k2)
          m = j1-1
          j = parg(optlst(i)(k1:k2),4,slst,m,ls,dc,1,1,iv,optarg(i))
    8   continue
      endif

C --- Parse style for specifiying sites list ---
      lstyle = 0
      m = j1-1
      i = parg('style=',2,slst,m,ls,dc,1,1,iv,lstyle)
      if (i .gt. 0) then
        j1 = m+2
        call nwordg(slst,0,dc//' ',1,j1,j2)
      endif

C --- List of sites ---
      if (lstyle .gt. 0) then
        nspec = mxint(nbas,ips)
        call defi(olist, nspec)
        call slist(lstyle,slst(j1:j2),slabl,z,nspec,nlists,w(olist))
        nlist = 0
        do  i = 1, nlists
          is = w(olist+i-1)
          do  j = 1, nbas
            ib = iclbsj(is,ips,-nbas,j)
            if (ib .ge. 0) then
              nlist = nlist+1
              list(nlist) = ib
            endif
          enddo
        enddo

      elseif (slst(j1:j1+1) .eq. 'z ' .or.
     .        slst(j1:j1+1) .eq. 'Z ') then
        nlist = 0
        do  10  ib = 1, nbas
          is = ips(ib)
          if (z(is) .eq. 0) then
            nlist = nlist+1
            list(nlist) = ib
          endif
   10   continue

      else
        j = j1
        call nwordg(slst,0,dc//' ',1,j,j2)
        call mkilst(slst(j1:j2),nlist,list)
        if (nlist .lt. 0)
     .    call rxs('baslst: failed to parse site list ',slst(j1:))
        if (nlist .eq. 0 .or. mod(iopt/10,10) .eq. 0) goto 99
        call ishell(nlist,list)
        j = 1
        do  16  i = 2, nlist
          if (list(i) .gt. list(j) .and. list(i) .le. nbas) then
            j = j+1
            list(j) = list(i)
          endif
   16   continue
        nlist = j
      endif

   99 if (mod(iopt,10) .eq. 0) return
      call awrit2(' baslst: %n:1i',slst,255,lgunit(1),nlist,list)
      end
