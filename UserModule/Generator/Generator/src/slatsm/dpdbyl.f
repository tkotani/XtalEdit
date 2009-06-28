      subroutine dpdbyl(a,nr,nlm,nlm0,nsp,lbin,ifi)
C- Dumps or reads an array given as a(nr,nlm,nsp).
C ----------------------------------------------------------------------
Ci Inputs
Ci   nr    :number of radial mesh points
Ci   nlm   :number of components to be i/o from file.
Ci         :If nlm is greater than nlm0,
Ci         :higher components are read and discarded.
Ci   nlm0  :the array second dimension
Ci   nsp   :2 for spin-polarized case, otherwise 1
Ci   lbin  :T file I/O in binary mode
Ci         :F file I/O in ascii mode
Ci   ifi   :file logical unit, but >0 for read, <0 for write
Cio Inputs/Outputs
Cio   a    :array a(1..nr,1..nlm,1..nsp) is read or written to file
Cr Remarks
Cu Updates
Cu   27 Apr 01 Added lbin switch
C ----------------------------------------------------------------------
C     implicit none
      logical lbin
      integer nr,nlm,nlm0,nsp,ifi
      double precision a(nr,nlm0,nsp)
      integer jfi,isp,ilm,i,nlmx
      double precision xx

C --- Output ---
      if (ifi .lt. 0) then
        jfi = -ifi
        do  10  isp = 1, nsp
          do  12  ilm = 1, nlm
            if (lbin) then
              write(jfi) (a(i,ilm,isp),i=1,nr)
            else
              call dfdump(a(1,ilm,isp),nr,-jfi)
            endif
   12     continue
   10   continue
        return
      endif
        
C --- Input ---
      jfi = ifi
      nlmx = min0(nlm,nlm0)
      
C ... loop over spins
      do  20  isp = 1, nsp

C ...   read the desired components        
        do  22  ilm = 1, nlmx
          if (lbin) then
            read(jfi) (a(i,ilm,isp), i=1,nr)
          else
            call dfdump(a(1,ilm,isp),nr,jfi)
          endif
   22   continue

C ...   read and discard higher components in file
        do  24  ilm = nlmx+1,nlm
          if (lbin) then
            read(jfi) (xx, i=1,nr)
          else
            read(jfi,*) (xx, i=1,nr)
          endif
   24   continue

C ...   zero out unset components in array
        do  26  ilm = nlmx+1,nlm0
          call dpzero(a(1,ilm,isp),nr)
   26   continue
        
   20 continue

      end
          
        
