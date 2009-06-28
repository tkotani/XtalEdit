      subroutine rfalsi(xn,fn,xtol,ftol,dxmn,dxmx,isw,wk,ir)
C- Find root of a function by a modified regular falsi method.
C ----------------------------------------------------------------------
Ci Inputs:
Ci  xn,fn: (point,function) pair; xn is also output; see below
Ci  xtol,ftol: tolerances in x or f.  1s digit of isw determines
Ci         which tolerance is used; see isw, below.
Ci  dxmn:  smallest change in x for which a change in f can be detected.
Ci  dxmx:  maximum allowed extrapolation in x in a single step.  Can
Ci         be either positive or negative, which sets the step direction
Ci         when rfalsi doesn't have enough information to decide internally
Ci         or 1's digit of isw has '4' bit set.
Ci  isw:   compound of one-digit switches.
Ci    Ones digit (imposes contraints on slope at root)
Ci      0: no constraints imposed
Ci      1: require slope >0 at root (pos curvature of antiderivative)
Ci      2: require slope <0 at root (neg curvature of antiderivative)
Ci      4: while root not bracketed, set suggested x = current x + dxmx
Ci    10's digit: controls tolerance for root
Ci      0: convergence when |f| < ftol
Ci      1: convergence when |bracket| < xtol
Ci      2: convergence when |f| < ftol and |bracket| < xtol
Ci      3: convergence when |f| < ftol or |bracket| < xtol
Ci      4  Set this bit if rfalsi is to return, with ir=0 or 4,
Ci         xn corresponding to some xn actually passed and fn closest to
Ci         zero, rather than estimate the root (or minimum).
Co  Co Outputs:
Co  xn:    next suggested x for finding root, OR:
Co         estimate for root if rfalsi returns ir = 0
Co         estimate for extremum if rfalsi returns ir = 4
Co  wk:    work array of length 12.  Should be passed through unaltered
Co         between minimization steps.  wk holds:
Co         1..3  x from prior calls
Co         4..6  f from prior calls
Co         7..9  scaled f
Co         10,11 smallest and largest x passed to rfalsi
Co         12    describes how prior points are reordered.
Co               0 => new x2 = old x1; new x1 = old x0; new x0 = xn.
Co               If nonzero, the following bits mean:
Co               1 (bit 1) => permute points x0,x1
Co               2 (bit 2) => permute points x0,x2
Co               4 (bit 3) => permute points x1,x2
Co  ir:    program flow control.  To start a new line minimization,
Co         set ir to zero.  On exit, rfalsi sets ir to one of the
Co         following.  For ir<0, rfalsi expects a new (xn,fn) pair,
Co         and suggests caller uses the returned value of xn.
Co     >=0: no more function calls expected:
Co       0: function has converged to within tolerance.
Co       1: input fn equals 0.  rfalsi does nothing.
Co       2: nonsensical tolerance or isw.  rfalsi does nothing.
Co       3: input xn equals x1 or x2.  rfalsi does nothing.
Co       4: extremum bracketed with no root.  rfalsi returns
Co          an estimate of the minimum point.
Co      <0: expects new function call, suggesting new point xn:
Co      -1: no information yet: require new point at suggested xn
Co          to improve the estimate of the root.
Co      -2: a root is bracketed and rfalsi is attempting linear
Co          interpolation to improve the estimate of the root.
Co      -3: a root is bracketed and rfalsi is attempting quadratic
Co          interpolation to improve the estimate of the root.
Co      -4: a root has not been bracketed.
Co          rfalsi will suggests xn from a linear extrapolation.
Co      -5: a root has not been bracketed.  rfalsi will try to
Co          guess a new point xmin+dxmx or xmax+dxmx depending
Co          on the sign of dxmx. Here xmin and xmax are the
Co          smallest and largest points passed to rfalsi.
Co      -6: a constraint was not fufilled.  rfalsi will try to
Co          guess a new point either xmin-|dxmx| or xmax+|dxmx|
Co          depending on the information it has.
Cr Remarks:
Cr  If a root is bracketed (some pair of f1*f2 < 0), a root is guaranteed
Cr  for an analytic function.  When not bracketed, rfalsi extrapolates,
Cr  either with a linear extrapolation of prior points or by a fixed
Cr  step size  dxmx  until a root is bracketed or something goes wrong.
C ----------------------------------------------------------------------
C     implicit none
C Passed Parameters
      double precision xtol,ftol,dxmn,dxmx,xn,fn,wk(12)
      integer ir,isw
C Local Variables
      integer i1mach,ic,ipr,i,itol,ir0,lqua,ic4,scrwid,awrite
      parameter (scrwid=80)
      character*(scrwid) outs
      double precision f2x,xtl,x0,f0,f0x,x1,f1,x2,f2,f1x,xmin,xmax,
     .  x(0:2),f(0:2),fx(0:2),dum,dx2,dx1,df2,df1,fpp,fp,den,dirdx
      equivalence (x0,x(0)),(x1,x(1)),(x2,x(2))
      equivalence (f0,f(0)),(f1,f(1)),(f2,f(2))
      equivalence (f0x,fx(0)),(f1x,fx(1)),(f2x,fx(2))
      logical ltmp,cnvgx,cnvgf,lextr,root1,root2,cst1,cst2

C ... Recover local variables from work array
      if (ir .eq. 0) call dpzero(wk,11)
      call dcopy(3,wk(1),1,x,1)
      call dcopy(3,wk(4),1,f,1)
      call dcopy(3,wk(7),1,fx,1)
      xmin = wk(10)
      xmax = wk(11)
C ... Point-independent setup
      wk(12) = 0
      ir0 = ir
      call getpr(ipr)
      ic = mod(mod(isw,10),4)
      ic4 = mod(isw,10) - ic
      itol = mod(isw/10,4)
      if (ic .eq. 2) ic = -1
      xtl = max(xtol,dxmn)
      if (ipr .gt. 40 .and. ir .eq. 0)
     .  call awrit8('  rfalsi: new start%?#n#  (c)##'//
     .  '%?#n# xtol=%1;3g#%j#%?#n==2# and##%-1j%?#n==3# or##'//
     .  '%?#n# ftol=%1;3g#%j#  dxmn=%1;3g  dxmx=%1;3g',
     .  ' ',scrwid,i1mach(2),ic,itol,xtl,itol,itol-1,ftol,dxmn,dxmx)
      if (ftol .le. 0 .and. itol .eq. 0 .or.
     .    xtl .le. 0 .and. itol .eq. 1 .or.
     .    (ftol .le. 0 .or. xtl .le. 0) .and. itol .eq. 2 .or.
     .    (ftol .le. 0 .and. xtl .le. 0) .and. itol .eq. 3 .or.
     .    mod(mod(isw,10),4) .eq. 3) then
        ir = 2
        goto 999
      endif

C --- Treat next point ---
   10 continue
C      call awrit3('  rfalsi (ir=%i)  xn=%1,8;8d  fn=%1;4g',
C     .  ' ',scrwid,i1mach(2),ir,xn,fn)

      lqua = 0
      do  12  i = 1, 0, -1
      fx(i+1) = fx(i)
      f(i+1) = f(i)
   12 x(i+1) = x(i)
      fx(0) = fn
      f(0) = fn
      x(0) = xn
      if (ir .eq. -1) then
        x2 = x1
        f2 = f1
      endif

C ... Special treatments
      if (fn .eq. 0) then
        ir = 1
        goto 999
      elseif (ir .eq. 0) then
        ir = -1
        xmin = xn
        xmax = xn
        xn = x0+dxmx
        goto 998
      elseif (x1 .eq. xn .or. x2 .eq. xn) then
        ir = 3
        goto 999
      elseif (ir .gt.  0) then
        goto 999
      endif

      xmin = min(xmin,xn)
      xmax = max(xmax,xn)

C ... T if root bracketed, with constraint satisfied
      cst1  = iabs(ic) .ne. 1 .or. (f1-fn)*(x1-xn)*ic .gt. 0
      cst2 =  iabs(ic) .ne. 1 .or. (f2-fn)*(x2-xn)*ic .gt. 0
C ... if only 1 cst satisfied, x0 must be in the middle
      if ((cst1 .neqv. cst2) .and. (x0-x1)*(x0-x2) .gt. 0) then
        if (cst1 .and. abs(x0-x2) .lt. abs(x0-x1)) cst1 = .false.
        if (cst2 .and. abs(x0-x2) .gt. abs(x0-x1)) cst2 = .false.
      endif
      root1 = fn*f1 .lt. 0 .and. cst1
      root2 = fn*f2 .lt. 0 .and. cst2
C ... Swap x1,x2 if (x0,x2) a closer fit
      if ((.not. root1 .and. abs(f0) .lt. abs(f1) .or. root2)
     .  .and. abs(x1-x0) .gt. abs(x2-x0) .or.
     .  .not. root1 .and. root2 .or. .not. cst1 .and. cst2) then
        dum = x2
        x2 = x1
        x1 = dum
        dum = f2
        f2 = f1
        f1 = dum
        dum = f2x
        f2x = f1x
        f1x = dum
        ltmp = cst1
        cst1 = cst2
        cst2 = ltmp
        wk(12) = 4
      endif

C ... Make first and second derivatives from three points, if available
      dx2 = x2-x0
      dx1 = x1-x0
      df2 = f2-f0
      df1 = f1-f0
      den = dx1*(dx1-dx2)*dx2
      fpp = 0
      if (den .ne. 0) then
        fp = -((-(df2*dx1**2) + df1*dx2**2)/den)
        fpp = (2*(df1*dx2-df2*dx1))/den
      endif

C ... T if local extremum bracketed
      lextr = (f0-f1)*(x0-x1)*(f1-f2)*(x1-x2) .lt. 0 .and. fpp*f1 .ge. 0
      if (lextr .and. .not. (root1 .or. root2) .and. ipr .ge. 30) then
        print *, ' rfalsi: local extremum bracketed without root:'
        call awrit6('  x0,x1,x2 = %1;6g %1;6g %1;6g  f0,f1,f2 = '//
     .    '%1;6g %1;6g %1;6g',' ',scrwid,i1mach(2),x0,x1,x2,f0,f1,f2)
      endif

C --- CASE I: root bracketed with possible constraint satisfied ---
      if (root1 .or. root2) then

C   ... Linear estimate for xn
        xn = (f1x*x0-f0*x1)/(f1x-f0)

C ... If conditions allow, improve estimate for x.  Conditions:
C     a sufficiently distinct third point exists; f1<=f1x*2;
C     corrected slope of same sign; new x still within bracket.
        if (dabs(x2-x0) .gt. dxmn .and.
     .      dabs(x2-x1) .gt. dxmn .and. abs(f1) .le. abs(f1x*2)) then

          if (fp*df1/dx1 .gt. 0) then
C       ... Estimate for quadratic correction
            dum = x0 - f0/fp - (f0**2*fpp)/(2*fp**3)
            if (dum .gt. min(x0,x1) .and.  dum .lt. max(x0,x1)) then
              lqua = 2
              xn = dum
C       ... Estimate for linear term, with improved slope
            else
              dum = x0 - f0/fp
              if (dum .gt. min(x0,x1) .and.  dum .lt. max(x0,x1)) then
                lqua = 1
                xn = dum
              endif
            endif
          endif
        endif
C   ... Artificially reduce f1 to avoid ill-conditioned cases
        if (min(dabs(xn-x0),dabs(xn-x1)) .lt. .1d0*dabs(x0-x1))f1x=f1x/2

C   ... Ask for another point, or if set ir if converged to within tol
        ir = -2
        if (lqua .ne. 0) ir = -3
        cnvgx = abs(x1-x0) .le. xtol
        if (wk(12) .eq. 4) cnvgx = abs(x2-x0) .lt. xtol
        cnvgf = abs(fn) .le. ftol
        if (itol .eq. 0 .and. cnvgf .or. itol .eq. 1 .and. cnvgx .or.
     .      itol .eq. 2 .and. (cnvgf .and. cnvgx) .or.
     .      itol .eq. 3 .and. (cnvgf .or. cnvgx)) ir = 0

C --- CASE III: root not found, step prescribed ---
      elseif (ic4 .eq. 4) then
        goto 80

C --- CASE IV: both constraints violated ---
C     Use whatever info we have to try xmin-|dxmx| or xmax+|dxmx|
C                                            *
C            Illustration for ic=1:        -----------------  ic=1
C            Slope the wrong sign.               *
C                                                       *
      elseif (ic .ne. 0 .and. .not. (cst1 .or. cst2)) then
C   ... If have second derivative, choose dir to ameloriate constraint
        if (fpp*ic .ne. 0) then
          dirdx = sign(1d0,fpp*ic)
C   ... Otherwise, choose dir to reduce the gradient
        else
          dirdx = sign(1d0,df1*dx1*ic)
        endif
        if (dirdx .le. 0) xn = xmin - abs(dxmx)
        if (dirdx .ge. 0) xn = xmax + abs(dxmx)
        ir = -6
        goto 998

C --- CASE II: extremum bracketed without a root ---
C                *                                      *
C      *                  handle left case          *
C           *             excluding right case                 *
C     ------------------                          -----------------
      elseif (lextr .and. fpp*f1 .ge. 0) then
C    ... This is one possibility: return minimum point.
C        xn = x0 - fp/fpp
C        ir = 4
C   ... This one returns a more distant point
        if (abs(xn-xmin) .le. abs(xn-xmax)) then
          xn = xmax + abs(dxmx)
        else
          xn = xmin - abs(dxmx)
        endif
        ir = -6
        goto 998

C --- CASE V: no root bracketed: try linear extrapolation ---
      else
        if (f0 .eq. f1) goto 80
        xn = x0 - f0*(x1-x0)/(f1-f0)
        if (xn .lt. min(x0,x1) .and. dabs(xn-min(x0,x1)) .lt. dxmn)
     .    xn = min(x0,x1) - dxmn
        if (xn .gt. max(x0,x1) .and. dabs(xn-max(x0,x1)) .lt. dxmn)
     .    xn = max(x0,x1) + dxmn
C   ... do not allow step lengths exceeding dxmx
        xn = max(min(x0,x1)-abs(dxmx),xn)
        xn = min(max(x0,x1)+abs(dxmx),xn)
C   ... But if inside range already seen, try a new point outside
        if (xn .gt. xmin .and. xn .lt. xmax) goto 80
        ir = -4
      endif
C --- End of cases ---

C ... Convergence achieved or extremum bracketed with no root:
C     Force xn on a prior point if 4's bit in 10's digit set.
      if ((ir .eq. 0 .or. ir .eq. 4) .and. mod(isw/10,10).gt.itol) then
C   ... Look for smallest f: if not x0, swap with x0
        do  74  i = 2, 1, -1
          if (ir0 .eq. -1 .and. i .eq. 2) goto 74
          if (abs(f(i)) .lt. abs(f(0))) then
            call dswap(1,x(i),1,x,1)
            call dswap(1,f(i),1,f,1)
            call dswap(1,fx(i),1,fx,1)
            wk(12) = wk(12) + i
          endif
   74   continue
        xn = x0
      endif
      if (ir .eq. 4) goto 999
      goto 998

C ... Exit ir=-5: suggest new point = max (min) given x +(-) abs(dxmx)
   80 continue
      ir = -5
      if (dxmx .lt. 0) xn = xmin - abs(dxmx)
      if (dxmx .gt. 0) xn = xmax + abs(dxmx)

C ... Get a new point
  998 continue
      if (ir0 .eq. 0 .and. ipr .gt. 30) then
        call awrit2('  rfalsi ir=%,2i: seek xn=%1,8;8g',' ',
     .    scrwid,i1mach(2),ir,xn)
      elseif (ipr .gt. 30 .or. ipr .ge. 30 .and. ir .ge. 0) then
        i = awrite('%x  rfalsi ir=%,2i x1=%1;4g f1=%1;4g x2=%1;4g'//
     .    ' f2=%1;4g: %?#n#seek#est#',outs,scrwid,0,
     .    ir,x0,f0,x1,f1,ir,i,i)
        i = min(12,scrwid-3-i)
        call awrit2('%a x=%;nF',outs,scrwid,-i1mach(2),
     .    i,xn)
      endif

C ... Exit: save data
  999 continue
      wk(10) = xmin
      wk(11) = xmax
      call dcopy(3,x,1,wk(1),1)
      call dcopy(3,f,1,wk(4),1)
      call dcopy(3,fx,1,wk(7),1)

      end
