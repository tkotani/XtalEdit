      subroutine xlgen(plat,rmax,nvmax,opts,mode,nv,vecs)
C- Generate a list of lattice vectors, subject to constraints
C ----------------------------------------------------------------
Ci Inputs
Ci   plat:primitive lattice vectors
Ci   rmax: largest radius for vector?
Ci   nvmax: maximum number of vectors allowed
Ci   opts: 1s digit:
Ci         1 add +/- any plat(j) to all other lattice vectors
Ci           found if plat(j) not in original list. (Ewald sums)
Ci         10s digit:
Ci         1 sort lattice vectors by increasing length
Ci         2 return nv only (or upper limit if 1s digit of opts is 1)
Ci         100s digit:
Ci         1 return in vecs the multiples of plat(j) that 
Ci           make up the lattice vector
Ci   mode  vector of length 3 governing shifts along selected axes.
Ci         0 suppresses shifts along plat(j)
Ci         1 same as 0
Ci         2 shifts to minimize length of pos
Co Outputs
Co   nv,vecs
C ----------------------------------------------------------------
C     implicit none
C Passed parameters
      integer nvmax,opts,mode(3)
      double precision plat(3,3),vecs(3,1),rmax
C Local parameters
      double precision rmax2,v2,vj(3)
      integer i,j,k,imx(3),nv,m,ivck(3),iprint,oiwk,owk,lgunit,iv,jv
      integer w(1)
      common /w/ w

C --- Setup ---
      call latlim(plat,rmax,imx(1),imx(2),imx(3))
      do  10  i = 1, 3
C   ... Switches flagging whether this plat in lattice vectors
        ivck(i) = 0
        if (mod(opts,10) .eq. 1) ivck(i) = 1
        imx(i) = max(imx(i),1)
        if (mode(i) .eq. 0) then
          imx(i) = 0
          ivck(i) = 0
        endif
   10 continue
      rmax2 = rmax*rmax
      nv = 0

C --- Loop over all triples, paring out those within rmax ---
      do  20  i = -imx(1), imx(1)
      do  20  j = -imx(2), imx(2)
      do  20  k = -imx(3), imx(3)
        v2 = 0
        do  21  m = 1, 3
          vj(m) = i*plat(m,1) + j*plat(m,2) + k*plat(m,3)
          v2 = v2 + vj(m)**2
   21   continue

C   --- A lattice vector found ---
        if (v2 .gt. rmax2) goto 20

C   ... Flag any plat in this vec as being present
        if (iabs(i) + iabs(j) + iabs(k) .eq. 1) then
          if (i .eq. 1) ivck(1) = 0
          if (j .eq. 1) ivck(2) = 0
          if (k .eq. 1) ivck(3) = 0
        endif

C   ... Increment nv and copy to vec(nv)
        nv = nv+1
        if (nv .gt. nvmax .and. mod(opts/10,10) .ne. 2) 
     .    call fexit(-1,111,' xlgen: too many vectors, n=%i',nv)
        if (mod(opts/10,10) .eq. 2) then
        elseif (mod(opts/100,10) .eq. 1) then
          vecs(1,nv) = i
          vecs(2,nv) = j
          vecs(3,nv) = k
        else
          vecs(1,nv) = vj(1)
          vecs(2,nv) = vj(2)
          vecs(3,nv) = vj(3)
        endif
   20 continue

C --- Add plat if ivck ne 0 ---
      if (ivck(1)+ivck(2)+ivck(3) .ne. 0) then
      if (mod(opts/10,10) .eq. 2) then
        nv = 3*nv
      else
        if (iprint() .ge. 20) print 333, ivck
  333   format(/' xlgen: added missing plat: ivck=',3i2)
        if (3*nv .gt. nvmax)
     .    call fexit(-1,111,' xlgen: too many vectors, n=%i',3*nv)
        if (ivck(1)+ivck(2)+ivck(3) .ne. 1)
     .    call rx('lgen: more than 1 missing plat')
        do  31  m = 1, 3
          v2 = ivck(1)*plat(m,1)+ivck(2)*plat(m,2)+ivck(3)*plat(m,3)
          if (mod(opts/100,10) .eq. 1) v2 = ivck(m)
          call dcopy(nv,vecs(m,1),3,vecs(m,nv+1),3)
          call dcopy(nv,vecs(m,1),3,vecs(m,2*nv+1),3)
          call daxpy(nv, 1d0,v2,0,vecs(m,nv+1),3)
          call daxpy(nv,-1d0,v2,0,vecs(m,2*nv+1),3)
   31   continue
        nv = 3*nv

C   ... Find and eliminate any replicas ---
        call defi(oiwk,nv)
        call dvshel(3,nv,vecs,w(oiwk),1)
*       call awrit2('%n:1i',' ',80,6,nv,w(oiwk))
        k = 0
C   ... Mark any replicas by iwk(i) -> -iwk(i)
        do  32  i = nv-1, 1, -1
          iv = w(oiwk+i) + 1
          jv = w(oiwk+i-1) + 1
          v2 = (vecs(1,iv)-vecs(1,jv))**2 +
     .         (vecs(2,iv)-vecs(2,jv))**2 + 
     .         (vecs(3,iv)-vecs(3,jv))**2
          if (v2 .lt. 1d-10) w(oiwk+i) = -iv
   32   continue
C   ... Make a sorted list of replicas (any of iwk < 0)
        call ishell(nv,w(oiwk))
C   ... For each replica, put lastmost vec into replica's place
        k = nv
        do  34  i = 0, nv-1
          iv = -w(oiwk+i)
          if (iv .le. 0) goto 35
          call dpcopy(vecs(1,k),vecs(1,iv),1,3,1d0)
          k = k-1
   34   continue
   35   continue
        nv = k
        call rlse(oiwk)
      endif
      endif

      if (mod(opts/10,10) .eq. 2) return

C --- Sort vectors by increasing length ---      
      if (mod(opts/10,10) .eq. 1) then
        call defi(oiwk,nv)
        call dvshel(3,nv,vecs,w(oiwk),11)
*       call awrit2('%n:1i',' ',80,6,nv,w(oiwk))
        call defi(owk,nv*3)
        call dvperm(3,nv,vecs,w(owk),w(oiwk),.true.)
        call rlse(oiwk)
      endif

C --- Printout ---
      if (iprint() .le. 70) return
      call awrit5(' xlgen: opts=%i  mode=%3:1i  rmax=%;4d  plat='//
     .  '%9:1;4d  nv=%i',' ',80,lgunit(1),opts,mode,rmax,plat,nv)
      if (iprint() .lt. 110) return
      print 345
  345 format('  iv',6x,'px',8x,'py',8x,'pz',8x,'l')
      do  40  i = 1, nv
        v2 = vecs(1,i)**2 + vecs(2,i)**2 + vecs(3,i)**2
        print 346, i, (vecs(m,i), m=1,3), dsqrt(v2)
  346   format(i4,3f10.4,f10.3)
   40 continue
      end
C      subroutine fmain
C
C      implicit none
C      integer wksize,nvmx,nv,opts,mode(3),ovecs
C      double precision plat(9),rmax
C      parameter(wksize=500000)
C      integer w(wksize)
C      common /w/ w
C
C      data plat /.5d0,.5d0,0d0, .5d0,-.5d0,0d0, 0d0,2d0,2d0/
C
C
C      call wkinit(wksize)
C      nvmx = 500
C      rmax = 2
C
C      mode(1) = 0
C      mode(2) = 2
C      mode(3) = 2
C      opts = 0
C      call initqu(.true.)
C      call query('opts=?',2,opts)
C      call defrr(ovecs,3*nvmx)
C      call lgen(plat,rmax,nv,nvmx,w(ovecs))
C      print *, 'old lgen found nv=', nv
C      print *, 'call xlgen, opt=',opts
C      call xlgen(plat,rmax,nvmx,opts,mode,nv,w(ovecs))
C      end
