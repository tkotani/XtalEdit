      logical function aiosop(alabl,sop,nl,lmax,nsp,ifi)
C- File I/O for spin-orbit coupling parameters.
C ----------------------------------------------------------------
Ci Inputs/Outputs
Ci   alabl,nl,lmax,nsp
Ci   ifi:  logical unit: positive for read, negative for write
Cio  sop:  spin-orbit couplinng parameters
Cr Remarks
Cr   sop for is zero; sop dimensioned (1...lmx,nsp,nsp,3)
C ----------------------------------------------------------------
C     implicit none
C Passed parameters
      character*8 alabl
      integer nl,lmax,nsp,ifi
      double precision sop(nl-1,nsp,nsp,3)
C Local parameters
      integer l,is1,is2,j,k,lmx,nl2,nsp2,ipr
      logical scat,pars1v
      character s*72

      aiosop = .false.
      call getpr(ipr)
      if (ifi .gt. 0) then
C   ... return unless file has SO category
        if (.not. scat(ifi,'SO:',':',.true.)) return
C   ... read nl and nsp ... abort if missing
        backspace ifi
        read(ifi,'(a72)') s
        if (.not. pars1v(s,len(s),'nl=','=',2,nl2)) goto 18
        if (nl .ne. nl2 .and. ipr .ge. 10)
     .    print *, 'aiosop (warning) mismatch in nl, class '//alabl
        if (.not. pars1v(s,len(s),'nsp=','=',2,nsp2)) goto 18
        if (nsp .ne. nsp2 .and. ipr .ge. 10)
     .    print *, 'aiosop (warning) mismatch in nsp, class '//alabl
        read(ifi,'(a72)') s
        call dpzero(sop,(nl-1)*nsp*nsp*3)
        lmx = min(nl,nl2)-1
C   ... read SO parms
        do  10  l = 1, lmx
          do  11  is2 = 1, min(nsp,nsp2)
          do  11  is1 = 1, min(nsp,nsp2)
   11     read(ifi,*) k,k,k,(sop(l,is1,is2,j), j=1,3)
          if (nsp2 .lt. nsp) then
            do  12  is2 = 1, nsp
            do  12  is1 = 1, nsp
   12       sop(l,is1,is2,j) = sop(l,1,1,j)
          endif
   10   continue
        aiosop = .true.
        return
   18   continue
        print *, 'aiosop: (input skipped) bad syntax, class '//alabl
      else
        write(-ifi,21) alabl, nl, nsp
        do  20  l = 1, lmax
        do  20  is2 = 1, nsp
        do  20  is1 = 1, nsp
          write(-ifi,333) l,is1,is2,(sop(l,is1,is2,j), j=1,3)
  333     format(i4,2i3,3f15.10)
   20   continue
        aiosop = .true.
      endif

   21 format('SO: ',a4,'  nl=',i1,'  nsp=',i1/
     .  '   l is js',7x,'phi phi',12x,'phi phidot',9x,'phidot phidot')
      end
