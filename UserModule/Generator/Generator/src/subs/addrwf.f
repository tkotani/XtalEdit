      subroutine addrwf(mode,z,l,v,nr,rofi,rwgt,evadd,ev,fac,gadd,g,s)
C- Add constant * radial wave function to another radial wave function
C ----------------------------------------------------------------------
Ci Inputs
Ci  mode   :0 use both large and small components of radial w.f.
Ci         :1 use both large component of radial w.f. only
Ci   z     :nuclear charge
Ci         :(used only to compute overlap s, mode=0)
Ci   l     :l-quantum number
Ci   v     :spherical potential, without nuclear part
Ci         :(used only to compute overlap s, mode=0)
Ci   nr    :number of radial mesh points
Ci   rofi  :radial mesh points
Ci   rwgt  :radial mesh weights for numerical integration
Ci   ev    :eigenvalue of input wave function g
Ci         :(used only to compute overlap s, mode=0)
Ci   evadd :eigenvalue of wave function gadd
Ci         :(used only to compute overlap s, mode=0)
Ci   fac   :Add fac*gadd into g
Ci   gadd  :See fac
Co Inputs/Outputs
Co   g     :g is overwritten by g + fac*g
Co   s     :overlap between gadd and new g
Cr Remarks
Cr   Input g and gadd are assumed to be solutions of the Schrodinger
Cr   equation with eigenvalues ev and evadd.  (For the scalar
Cr   relativistic case, the inner product depends slightly
Cr   on z,v, and eigenvalue)
Cu Updates
Cu   14 Feb 02 New routine
C ----------------------------------------------------------------------
C     implicit none
C ... Passed parameters
      integer l,nr,mode
      double precision fac,z,rofi(nr),rwgt(nr),v(nr),ev,evadd,
     .  gadd(nr,2),g(nr,2),s
C ... Local parameters
      integer ir
      double precision cc,vi,fllp1,gf11,gf22,gf12,r,tmc
      common /cc/ cc

      fllp1 = l*(l+1)
      s = 0

      if (mode .eq. 0) then
      do  ir = 2, nr
        r = rofi(ir)

        g(ir,1) = g(ir,1) + fac*gadd(ir,1)
        g(ir,2) = g(ir,2) + fac*gadd(ir,2)

C       Rest of the loop computes overlap between new g and gadd
        vi = v(ir) - 2d0*z/r
        tmc = cc - (vi-ev)/cc
        gf11 = 1d0 + fllp1/(tmc*r)**2
        tmc = cc - (vi-evadd)/cc
        gf22 = 1d0 + fllp1/(tmc*r)**2
        gf12 = (gf11 + gf22)/2

        s = s + rwgt(ir)*(gf12*g(ir,1)*gadd(ir,1) + g(ir,2)*gadd(ir,2))

      enddo
      else
      do  ir = 2, nr
        r = rofi(ir)
        g(ir,1) = g(ir,1) + fac*gadd(ir,1)
        s = s + rwgt(ir)*g(ir,1)*gadd(ir,1)
      enddo
      endif

      end

      subroutine wf2lo(l,nr,rofi,rwgt,phi,dphi,phip,dphip,phz,dphz,g0,
     .  g1,gz)
C- Add a linear combination of two w.f. to a 3rd to make a local orbital
C ----------------------------------------------------------------------
Ci Inputs
Ci   l     :l quantum number
Ci   nr    :number of radial mesh points
Ci   rofi  :radial mesh points
Ci   rwgt  :radial mesh weights
Ci   g0    :1st radial w.f. to which to orthogonalize gz
Ci   g1    :2nd radial w.f. to which to orthogonalize gz
Ci   phi   :1st wave function at rmax, i.e. r*g0
Ci   dphi  :radial derivative of r*g0
Ci   phip  :2nd wave function at rmax, i.e. r*g1
Ci   dphip :radial derivative of r*g1
Ci   phz   :3rd wave function at rmax, i.e. r*gz
Ci   dphz  :radial derivative of r*gz
Cio Inputs/Outputs
Cio  gz    :on input, radial w.f.
Cio        :on output, gz is overwritten by
Cio        :(gz - alpha g0 - beta g1) so that value and slope
Cio        :of the result are zero at rmt
Cu Updates
Cu   06 Mar 02 New routine
C ----------------------------------------------------------------------
C     implicit none
C ... Passed parameters
      integer l,nr
      double precision rofi(nr),rwgt(nr)
      double precision phi,dphip,dphi,phip,phz,dphz
      double precision g0(nr,2),g1(nr,2),gz(nr,2)
C ... Local parameters
      double precision det,au,bu,as,bs,fac,x,xx

      det = phi*dphip - dphi*phip
      au = dphip/det
      bu = -dphi/det
      as = -phip/det
      bs = phi/det
      fac = phz*au + dphz*as
      x = 0
      call addrwf(1,x,l,x,nr,rofi,rwgt,x,x,-fac,g0(1,2),gz(1,2),xx)
      call addrwf(1,x,l,x,nr,rofi,rwgt,x,x,-fac,g0,gz,xx)

      fac = phz*bu + dphz*bs
      call addrwf(1,x,l,x,nr,rofi,rwgt,x,x,-fac,g1(1,2),gz(1,2),xx)
      call addrwf(1,x,l,x,nr,rofi,rwgt,x,x,-fac,g1,gz,xx)

C     call prrmsh('local orbital',rofi,gz,nr,nr,2)

      end


      subroutine ortrwf(mode,z,l,v,nr,rofi,rwgt,e0,e1,ez,g0,g1,gz,D)
C- Orthogonalize a radial wave function gz to a pair of other functions
C ----------------------------------------------------------------------
Ci Inputs
Ci   mode  :1s digit
Ci         :0 do not change gz, but return scaling factor D that would
Ci         :  normalize gz after orthogonalization to (g0,g1)
Ci         :1 orthonormalize gz.
Ci         :  NB: this routine assumes g0 and g1 are orthogonal
Ci         :2 orthonormalize g0,g1; do not change gz or compute D
Ci         :10s digit
Ci         :0 use both large and small components of radial w.f.
Ci         :1 use large component of radial w.f. only.
Ci            In this case, z,v,e0,e1,ez are not used
Ci   z     :nuclear charge
Ci   l     :l quantum number
Ci   v     :spherical potential (atomsr.f)
Ci   nr    :number of radial mesh points
Ci   rofi  :radial mesh points
Ci   rwgt  :radial mesh weights
Ci   e0    :energy eigenvalue of g0
Ci   e1    :energy eigenvalue of g1
Ci   ez    :energy eigenvalue of gz
Ci   g0    :1st radial w.f. to which to orthogonalize gz
Ci   g1    :2nd radial w.f. to which to orthogonalize gz
Ci   gz    :radial w.f. to orthogonalize
Ci   D     :scaling factor that normalizes the orthogonalized gz
Co Outputs
Cl Local variables
Cl         :
Cr Remarks
Cr
Cb Bug
Cb   for 1s digit mode=1, this routine assumes g0 and g1 are orthogonal
Cu Updates
Cu   06 Mar 02 New routine
C ----------------------------------------------------------------------
C     implicit none
C ... Passed parameters
      integer mode,l,nr
      double precision z,v(nr),rofi(nr),rwgt(nr),e0,e1,ez,D
      double precision g0(2*nr),g1(2*nr),gz(2*nr)
C ... Local parameters
      integer mode0,mode1
      double precision s00,s01,s11,s0z,s1z,szz,xxx,s01hat,s11hat,s1zhat

      mode0 = mod(mode,10)
      mode1 = mod(mode/10,10)

      if (mode0 .eq. 2) then
        call addrwf(mode1,z,l,v,nr,rofi,rwgt,e0,e0,0d0,g0,g0,s00)
        call dscal(2*nr,1/sqrt(s00),g0,1)
        call addrwf(mode1,z,l,v,nr,rofi,rwgt,e0,e1,0d0,g0,g1,s01)
        call daxpy(2*nr,-s01,g0,1,g1,1)
        call addrwf(mode1,z,l,v,nr,rofi,rwgt,e1,e1,0d0,g1,g1,s11)
        call dscal(2*nr,1/sqrt(s11),g1,1)

C       Check
C       call addrwf(mode1,z,l,v,nr,rofi,rwgt,e0,e0,0d0,g0,g0,s00)
C       call addrwf(mode1,z,l,v,nr,rofi,rwgt,e0,e1,0d0,g0,g1,s01)
C       call addrwf(mode1,z,l,v,nr,rofi,rwgt,e1,e1,0d0,g1,g1,s11)
        return
      endif

      call addrwf(mode1,z,l,v,nr,rofi,rwgt,e0,e0,0d0,g0,g0,s00)
      call addrwf(mode1,z,l,v,nr,rofi,rwgt,e1,e1,0d0,g1,g1,s11)
      call addrwf(mode1,z,l,v,nr,rofi,rwgt,e0,e1,0d0,g0,g1,s01)
      call addrwf(mode1,z,l,v,nr,rofi,rwgt,ez,ez,0d0,gz,gz,szz)
      call addrwf(mode1,z,l,v,nr,rofi,rwgt,e0,ez,0d0,g0,gz,s0z)
      call addrwf(mode1,z,l,v,nr,rofi,rwgt,e1,ez,0d0,g1,gz,s1z)

      s01hat = s01/sqrt(s00)
      s11hat = s11 - s01hat**2
      s1zhat = s1z - s01*s0z/s00

C     Scaling factor that normalizes the orthogonalized gz
C     D = sqrt(szz - s0z**2/s00 - s1z**2/s11)
      D = sqrt(szz - s0z**2/s00 - s1zhat**2/s11hat)

      if (mode0 .eq. 0) return

C     Orthogonalize
      call addrwf(mode1,z,l,v,nr,rofi,rwgt,e0,ez,-s0z/s00,g0,gz,xxx)
      call addrwf(mode1,z,l,v,nr,rofi,rwgt,e0,ez,-s1z/s11,g1,gz,xxx)
C     Normalize
      call dscal(nr*2,1/D,gz,1)

C     check
C     call addrwf(mode1,z,l,v,nr,rofi,rwgt,e0,ez,0d0,g0,gz,xxx)
C     call addrwf(mode1,z,l,v,nr,rofi,rwgt,e0,ez,0d0,g1,gz,xxx)
C     call addrwf(mode1,z,l,v,nr,rofi,rwgt,ez,ez,0d0,gz,gz,xxx)
C     print '('' Normalization of gz is now 1 + '',1pe10.3)', xxx-1
C     pause

C     check normalization from file
C     mc -qr out.ext -e2 x1 'x2*x2' -av:nr,1 rmax -int 0 rmax
C     call prrmsh('gz',rofi,gz,nr,nr,1)

      end
