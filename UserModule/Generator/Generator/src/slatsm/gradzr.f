      subroutine gradzr(n,p,hess,xtoll,dxmx,xtol,gtol,grfac,wk,isw,ir)
C- Find zero in gradients of a multivariate function
C ----------------------------------------------------------------------
Ci Inputs
Ci  n:    number of independent variables
Ci  hess: inverse Hessian matrix for Fletcher-Powell and Broyden
Ci  xtoll:x tolerance for line minimizations.  See Remarks.
Ci  dxmx: Maximum step length in any one component of x
Ci        Also, for C.G., initial step length; see Remarks.
Ci        A positive sign of dxmx makes line mins tend 'downhill'
Ci        A negative sign of dxmx makes line mins tend 'uphill'
Ci  xtol: tolerance in x for global minimization.
Ci  gtol: tolerance in gradient for global minimization
Ci  grfac:Extrapolation growth factor for line minimizations.
Ci        Whenever a root is not bracketed, the effective value of dxmx
Ci        is scaled by grfac.
Ci  isw:  compound of one-digit switches.
Ci    1's digit: handles constraints and step directions
Ci       *For the line minimization algorithms, digit is passed through
Ci        to the line min. routine rfalsi (which see).
Ci      0 no constraints imposed
Ci      1 require line min grad >0 at root (minimum for each line min)
Ci      2 require line min grad <0 at root (maximum for each line min)
Ci      4 while root not bracketed, set suggested x = current x + dxmx
Ci       *For the Broyden scheme, the digit is passed through to routine
Ci        brmin; the meaning is somewhat different (see brmin.f)
Ci        See Remarks for some further description.
Ci   10's digit: convergence criteria; see also Remarks.
Ci      0 convergence when <g> < gtol
Ci      1 convergence when <dx> < xtol
Ci      2 convergence when <g> < gtol and <dx> < xtol
Ci      3 convergence when <g> < gtol or <dx> < xtol
Ci        Here, <g> and <dx> are the max component of gradient and change
Ci        in x between iterations
Ci      4 Set this bit to specify a line minimization tolerance in the
Ci        gradient; see Remarks.
Ci  100's digit: governs which minimization  to use:
Ci      0 Congugate gradients, adapted from Numerical Recipes, 10.6.
Ci      1 Fletcher-Powell: M.J.Norgett & R.Fletcher, J.Phys.C3,L190(1972)
Ci      2 Broyden
Ci 1000's digit: Hessian matrix switches
Ci      0  no tests are made for Hessian
Ci      1  If Hessian is not positive definite, it is not updated.
Ci      2  project out parts of Hessian corresponding to negative
Ci         eval (not implemented).
Ci      4  On the second iteration, Hessian is globally scaled
Ci         once a first estimate is known (D. Novikov)
Ci 10000's digit: line-minimization-specific switches.
Ci      1 specifies tolerance for change in line minimization gradient;
Ci        see Remarks.
Cio Inputs/Outputs
Cio ir:   program flow control.  To start a new minimization,
Cio       set ir to zero.  On exit, gradzr sets ir to one of the
Cio       following.  For ir<0, gradzr expects a new set of points
Cio       and gradients at positions p(1..n).
Cio      *For the line minimization schemes F.P. and C.G:
Cio    >=0: no more function calls expected:
Cio      0: gradzr finds function converged to within tolerance
Cio      1: input grad equals 0  gradzr does nothing.
Cio      2: nonsensical tolerance.  gradzr does nothing.
Cio      3: input xn equals x1 or x2.  gradzr does nothing.
Cio      4: line min extremum bracketed but with no root.  gradzr returns
Cio         suggested xn = largest (smallest) of given x so far + dxmx
Cio      5: line minimization failed to bracket root;
Cio         see 100's digit of isw
Cio     <0: expects new function call, suggesting xn:
Cio     -1: no information yet: require new point at suggested xn
Cio         to improve the estimate of the root.
Cio     -2: a root is bracketed and gradzr is attempting linear
Cio         interpolation to improve the estimate of the root.
Cio     -3: a root is bracketed and gradzr is attempting quadratic
Cio         interpolation to improve the estimate of the root.
Cio     -4: a root has not been bracketed or constraints not fufilled.
Cio         gradzr will suggests xn from a linear extrapolation.
Cio     -5: same as -4 above, but gradzr tries xn = current x + dmmx
Cio         is increasing along the step direction.  If ir is set
Cio         to -4 for a new point, gradzr will continue along that
Cio         step direction
Cio     -6: gradzr is having trouble; asks for new point
Cio     -9: Line minimization converged; new line minization sought.
Cio         NB: gradzr is organized so that this need not happen
Cio    -10: ir input -10 works just as input ir=0, but flags that
Cio         the conjugate direction p(nd) is already specified by
Cio         the caller.  Valid only for line minimization schemes.
Cio      *For Broyden (meaning same as in brmin.f but sign has changed)
Cio      0: brmin has converged to specified tolerance
Cio     <0: brmin needs gradients (preferably at the output x)
Cio     >0: like <0, but the Hessian was found to be not positive
Cio         definite, and was not updated.
Cio p:    array of dimension at least 6*n for F.P. and C.G. and
Cio       8*n for Broyden.  If the Hessian eigenvalues are calculated,
Cio       dimensions must be n*(6+n) and n*(11+2n) for F.P. and Broyden
Cio       p(*,nx=1) current position vector. (Input on first call)
Cio                 Internally, p(nx) = p (start of current line min)
Cio       p(*,ng=2) gradient at current point (Input on each call)
Cio      *For line minimization schemes:
Cio       p(*,nd=3) conjugate direction for current line min.
Cio       p(*,n1=4) gradient at the point prior to this one
Cio       p(*,n2=5) gradient at second prior point
Cio       p(*,n0=6) gradient at start of line min (C.G. only)
Cio      *For Broyden, p(*,3...8) are passed as w(*,1..6); see brmin.f
Cio wk    is a work array of dimension 0:27.  It should not be altered
Cio       between succesive calls.  The elements of wk are:
Cio wk(0) = xn is a measure of the shift in coordinates
Cio       between successive function calls.
Cio      *For line minimizations, xn is the amount of direction vector
Cio       that was added to coordinate positions; see Remarks.
Cio      *For Broyden, xn is the largest shift in a component of x
Cio wk(1..12) see rfalsi.
Cio wk(13) gam = gamma for conjugate gradients; cf Numerical Recipes.
Cio wk(14) dxmxl = maximum step length along direction vector
Cio wk(15) dxmxlx = step size that makes shift in largest p(nx)= dxmx
Cio wk(16) dxlast = Largest change in one component of x;
Cio          used as estimate for dx in new C.G. line minimization.
Cio wk(17) xmax = largest value of x along a given line min; used
Cio          when line minimizations have trouble finding a root
Cio          satisifying constraints.
Cio wk(18) lminn = number of line minimizations so far
Cio wk(19) grad0 = (grad.dir-vec) at start of line minimization
Cio wk(20) growl = Current extrapolation growth factor
Cio wk(21..23) x0h,x1h,x2h values of xn in prior iterations
Cio wk(24..26) g0h,g1h,g2h values of grad.dir-vec corresponding to x*h
Cr Remarks
Cr *gradzr attempts to find a a minimum, a maximum,
Cr  or just a zero in the gradient using one of three schemes:
Cr  Broyden, Fletcher-Powell, and congugate gradients.  There are
Cr  strengths and weaknesses in each approach.  The F.P and C.G. proceed
Cr  by successive line minimizations, in which the zero projection of the
Cr  gradient along each direction vector is sought.  In the program,
Cr  p(*,nd) is the direction vector, and p(*,nx) are the coordinates at
Cr  the start of the line minimization.  xn is varied so that the for
Cr  positions p(nx) + xn * p(nd), grad.p(nd) is zero to within a specified
Cr  tolerance, after which the inverse Hessian matrix is updated and new
Cr  conjugate direction is calculated.  The F.P Hessian is explicit; in
Cr  the C.G. case it is implicit.  Having the Hessian is useful
Cr  but can be expensive if there are many variables.  In practice, F.P.
Cr  seems to converge a little faster than C.G..  Broyden is essentially a
Cr  Newton-Raphson scheme for several variables, and the Hessian is
Cr  explicit.  In well conditioned cases, it tends to get to the root more
Cr  rapidly than the line minimization approaches, except that it is more
Cr  sensitive to roundoff errors, which after a few iterations cause it
Cr  to converge more slowly.
Cr
Cr *gradzr works by accepting a new vector x and its gradient g, in
Cr  p(1..n) and p(n+1..2n) respectively.  It returns with a new
Cr  suggested value for p, for which the caller is expected to generate
Cr  g.  (For the line minimization routines, it is more natural for
Cr  gradzr to return a direction vector and the distance along the
Cr  projection vector, but this is not done here to make the calling
Cr  interface as consistent as possible.  The distance xn is returned in
Cr  case the caller wants to change it.)  Variable ir supplies some
Cr  information as to what gradzr is looking for in the next iteration.
Cr
Cr *Convergence tolerances.
Cr  gradzr continues its minimization procedure until it satisfies some
Cr  combination of:
Cr    (the max change in a component of x between iterations) < xtol
Cr    (the max value  of a component of gradient) < gtol
Cr  The 10's digit of isw specifies which combination is selected.
Cr
Cr  For Broyden, the change in x is the change between each function call;
Cr  for the line minimization algorithms C.G. and F.P., it is the change
Cr  between each line minimization.  In this latter case, there is a
Cr  second, independent tolerance for the individual line minimizations,
Cr  xtoll.  There is also a separate convergence criterion for gradient in
Cr  the individual line minimizations, namely the line minimization stops
Cr  when (grad.dir-vec) has dropped to a specified fraction f of its
Cr  starting value.  Turn this option on by adding 40 to isw.  You can
Cr  specify f using i=10000's digit of isw; f=i/20.
Cr  Using i=0 sets f to a default of 0.25.  NB: when no x tolerance is
Cr  specified, the line gradient tolerance is automatically turned on.
Cr
Cr *Initial step lengths for a new line minimization: when the hessian
Cr  is explicit, it specifies the step length.  You may specify a
Cr  maximum step length dxmx, which imposes a maximum value for a change
Cr  in any component of x.  The C.G. uses dxmx to specify the initial
Cr  step size for the first line minimization.  For subsequent line
Cr  mins, the initial step length is taken to be the total change in
Cr  position from the prior line min.
Cr
Cr *gradzr can be used to seek a minimum, a maximum,
Cr  or just a zero in the gradient; see one's digit of isw.
Cr  When a constraint is imposed, caller is strongly advised to
Cr  also set the 4's digit of isw, which will cause rfalsi to continue
Cr  in the same search direction even if the gradient increases.
Cr  Also, if a maximum is sought (isw=2), caller is strongly advised
Cr  to set dxmx negative.  Otherwise, strange behavior may result.
Cr  For now these switches are automatically set internally.
Cr
Cr *recommended values for line minimizations.
Cr  At least in well behaved cases, it is recommended that
Cr  the caller choose an x tolerance for the line minimizations.
Cr  A 'safe' default for the line tolerance xtoll is the same value
Cr  as the global xtol, though gradzr tends to convergence a little
Cr  faster if it is set somewhat larger.
Cr  Also, convergence seems to be aided by changing line minimizations
Cr  when the gradient has dropped by ~0.25 (add 40 to isw).
Cr
Cr *It is usually simpler and more convenient to call gradzr using
Cr  the driver routine drgrzr.
Cr
Cu  Updates
C ----------------------------------------------------------------------
C     implicit none
C Passed Parameters
      integer n,ir,isw
      double precision hess(n,n),p(n,10),xtoll,dxmx,xtol,gtol,wk(0:26),
     .  grfac
C Local Variables
      logical ltmp,cnvgx,cnvgf
      integer i,j,i1mach,bitand,ipr,npr,lminn,isw0,isw1,isw2,isw3,isw4,
     .  isw31,idamax,iswl,itol,iswb
      integer nx,ng,nd,n1,n2,n0,nhs,chkhss
      double precision gg,dgg,gam,ddot,dasum,x0h,x1h,x2h,res,evtol,
     .  evmin,dxmxl,dxmxlx,xtll,dxmn,xmax,gfn,grad0,g0h,g1h,
     .  g2h,dxm,growl,gammax,xh(0:2),gh(0:2),xn,
     .  gd1,gd2,dg,alpha,r,s,gll
      equivalence (xh(0),x0h), (xh(1),x1h), (xh(2),x2h)
      equivalence (gh(0),g0h), (gh(1),g1h), (gh(2),g2h)
      parameter (nx=1,ng=2,nd=3,n1=4,n2=5,n0=6,nhs=n2+5, evtol=1d-10)
      double precision gwg,q,dxlast,pgrada,dum
      integer scrwid
      parameter (scrwid=80)
      character*(100) outs

C --- Iteration independent setup ---
      if (ir .eq. 0) call dpzero(wk,27)
      xn =     wk(0)
      gam =    wk(13)
      dxmxl =  wk(14)
      dxmxlx = wk(15)
      dxlast = wk(16)
      xmax   = wk(17)
      lminn  = wk(18)
      grad0  = wk(19)
      growl  = wk(20)
      call dcopy(3,wk(21),1,xh,1)
      call dcopy(3,wk(24),1,gh,1)
      call getpr(ipr)
      npr = min(n,6)
      isw0  = mod(isw,10)
      isw1  = mod(isw/10,10)
      isw2  = mod(isw/100,10)
      isw3  = mod(isw/1000,10)
      isw31 = mod(isw3,4)
      isw4  = mod(isw/10000,10)
C ... These lines impose sanity for conditions described in Remarks
      if (mod(isw0,4) .ne. 0) isw0 = mod(isw0,4) + 4
      dxm = dxmx
      j = mod(isw0,4)
      if (dxmx.gt.0 .and. j.eq.2 .or. dxmx.lt.0 .and. j.eq.1)
     .  dxm = -dxmx

    1 continue
C ... If the gradient is zero, nothing to calculate.
      gg = abs(p(idamax(n,p(1,ng),1),ng))
      if (gg .eq. 0) then
        ir = 0
        goto 999
      endif

C --- First iteration ---
      if (ir .eq. 0 .or. (ir .eq. -10 .and. isw2 .le. 1)) then
C   ... This the largest dx from the last iteration
C       For first line min, set it so largest dx is dxm
        dxlast = dxm
C   ... Number of line minimizations
        if (ir .eq. 0) lminn = 0
C   ... Congugate gradients gamma (see Numerical Recipes)
        gam = 0
C   ... Size of initial gradient (and direction) vector
        j = mod(isw0,4)
        ltmp = j .eq. isw0 .or.
     .    dxm.gt.0 .and. j.eq.2 .or. dxm.lt.0 .and. j.eq.1
        if (ipr .ge. 30 .or. ipr .ge. 20 .and. ltmp) then
          itol = mod(isw1,4)
          call awrit7(' gradzr: begin %?#n# xtol=%1;3g#%j#'
     .      //'%?#n==2# and##%-1j%?#n==3# or##%-1j'
     .      //'%?#n<>1# gtol=%1;3g#%j#'
     .      //'%?#n==0|n>=4#  gtll=%1;3g#%j#'
     .      //'  dxmx=%1;3g',outs,
     .      scrwid,0,itol,xtol,itol,gtol,
     .      isw1,pgrada(isw1,isw4),dxm)
          call awrit2('%a  '//
     .      '%?#n==0#C.G.##%-1j'//
     .      '%?#n==1#F.P.##%-1j'//
     .      '%?#n==2#Broy##'//
     .      '  isw=%i',outs,scrwid,-i1mach(2),isw2,isw)
C     ... Sanity checks
C          if (j .eq. isw0)
C     .    call awrit0(' gradzr (warning) seek extremum but 4''s'
C     .      //' bit of isw is not set',' ',scrwid,i1mach(2))
C          if (dxm.gt.0 .and. j.eq.2 .or. dxm.lt.0 .and. j.eq.1)
C     .    call awrit0(' gradzr (warning) seek extremum but dxmx'//
C     .      ' is of the wrong sign',' ',scrwid,i1mach(2))
          if (bitand(isw1,1) .eq. 0 .and. gtol .eq. 0) ir = 2
          if (bitand(isw1+3,2) .eq. 0 .and. xtol .eq. 0) ir = 2
          if (xtol .le. 0 .and. gtol .le. 0) ir = 2
          if (ir .eq. 2) goto 999
        endif
      endif

C --- Broyden minimization ---
      if (isw2 .eq. 2) then
        ir = -ir
        iswb = isw0 + 10*bitand(isw1,3) + 1000*isw3
        call brmin(n,p,p(1,ng),iswb,ipr,dxmx,xtol,gtol,dum,p(1,nd),xn,
     .    hess,ir)
        ir = -ir
        goto 999
      endif

C ... Jump if to continue with current line minimization
      if (ir .ge. -6 .and. ir .le. -1) then
C   ... Undo direction vector added to position vector
        if (ir .lt. 0) call daxpy(n,-xn,p(1,nd),1,p(1,nx),1)
        goto 20
      endif

C --- New line minimization ---
      lminn = lminn+1
C ... Congugate gradients
      if (isw2 .eq. 0) then
        gg = ddot(n,p(1,ng),1,p(1,ng),1)
        if (gam .eq. 0 .and. ir .ne. -10) call dpzero(p(1,nd),n)
        dgg = ddot(n,p(1,ng),1,p(1,nd),1)
        res = gam*dgg-gg
        gammax = 2
        if (res .gt. 0) then
          if (ipr .gt. 30) call awrit1(' gradzr encountered g.h = %;4g'
     .      //'  ... set gam to zero',' ',scrwid,i1mach(2),res)
          gam = 0
        elseif (gam .gt. gammax) then
          if (ipr .gt. 30) call awrit2(' gradzr cap gam = %;4g'//
     .      ' to max gam = %;4g',' ',scrwid,i1mach(2),gam,gammax)
          gam = gammax
        endif
        call dpcopy(p(1,ng),p(1,n0),1,n,-1d0)
        if (ir .eq. -10) then
          ir = 0
        else
          do  10  j = 1, n
   10     p(j,nd) = p(j,n0) + gam*p(j,nd)
        endif
        dxmxl = sign(dxlast/p(idamax(n,p(1,nd),1),nd),dxm)
C ... Fletcher-Powell
      elseif (isw2 .eq. 1) then
C       If starting Hessian is zero, set to unity.
        if (dasum(n*n,hess,1) .eq. 0) call dcopy(n,1d0,0,hess,n+1)
C       F.P doesn't use p(n0), but save for compatibility with C. G.
        call dpcopy(p(1,ng),p(1,n0),1,n,-1d0)
C       New positions generated from inverse Hessian matrix
        if (ir .eq. -10) then
          ir = 0
        else
          do  6  i = 1, n
            p(i,nd) = 0
            do  8  j = 1, n
    8       p(i,nd) = p(i,nd) - hess(i,j)*p(j,ng)
    6     continue
          dxmxl = 1
        endif
      else
        call rxi('gradzr not ready for isw2=',isw2)
      endif

C ... This is the 'best guess' for step size, new line min.
      dxmxl = dxmxl*min(1d0,dabs(dxm/(dxmxl*p(idamax(n,p(1,nd),1),nd))))
C ... Step size that makes shift in largest component = dxmx:
      dxmxlx = sign(dxmx/p(idamax(n,p(1,nd),1),nd),dxm)
C ... Initial extrapolation growth factor
      growl = 1
C ... (grad.dir-vec) at start of line minimization
      grad0 = ddot(n,p(1,ng),1,p(1,nd),1)
      if (ir .eq. -9 .or. ir .eq. 0) then
        ir = 0
        xn = 0d0
      endif
      xmax = 0d0
      x1h = -9d9
      x2h = -9d9
C ... Printout of current p,g,h
      if (ipr .gt. 30) then
        gg = ddot(n,p(1,ng),1,p(1,ng),1)
        dgg = ddot(n,p(1,ng),1,p(1,nd),1)
        res = dsqrt(ddot(n,p(1,ng),1,p(1,ng),1))
        call awrit4(' gradzr new line %i:  g.h=%;4g'
     .  //'  g.(h-g)=%;4g  |grad|=%1;3g  ',' ',
     .    scrwid,i1mach(2),lminn,dgg,dgg+gg,res)
      endif
      if (ipr .ge. 40) then
        call awrit2('  p=%n:;10F',' ',scrwid,i1mach(2),npr,p(1,nx))
        call awrit2('  g=%n:;10F',' ',scrwid,i1mach(2),npr,p(1,ng))
        call awrit2('  h=%n:;10F',' ',scrwid,i1mach(2),npr,p(1,nd))
      endif

C --- Continue current line minimization ---
   20 continue
      xmax = max(xmax,xn)
      x0h = xn
      gfn = ddot(n,p(1,ng),1,p(1,nd),1)
      g0h = dsqrt(ddot(n,p(1,ng),1,p(1,ng),1))
C ... Special check to see if g < line g tol
      if (dabs(gfn/grad0) .lt. pgrada(isw1,isw4)) then
        ir = 0
C ... Otherwise, call rfalsi to check for convergence and/or new xn
      else
C       Requires rfalsi to return xn on an existing point when ir=0
        iswl = isw0 + 40
C       Also suppress rfalsi using gtol; we do that above
        if (mod(isw1,4) .ne. 0) iswl = iswl + 10
C       Tolerance should be less than and distinct from dxmx
        xtll = min(xtoll/dabs(p(idamax(n,p(1,nd),1),nd)),
     .             abs(dxmxl*growl*.999999d0))
C       Minimimum step size should be less than, distinct from tolerance
        dxmn=xtll/2
        gll = abs(gfn/10)
        call pshpr(ipr-10)
        call rfalsi(xn,gfn,xtll,gll,dxmn,dxmxl*growl,iswl,wk(1),ir)
        call poppr
C   ... On the second call, reset dxmx to maximum allowed
        if (mod(iswl,10) .eq. 0 .and. ir .eq. -1) dxmxl = dxmxlx
C   ... rfalsi wants to extrapolate
        if (ir .ge. -6 .and. ir .le. -4) then
C     ... This accelerates linear extrapolation
         if (ir .eq. -4) xn = x0h + (xn-x0h)*growl
          growl = growl * grfac
C        elseif (ir .eq. -1) then
C          growl = grfac
        else
          growl = 1
        endif
C   ... Swap points in the same way rfalsi swapped them.
        if (nint(wk(12)) .ge. 4) then
          call dswap(n,p(1,n1),1,p(1,n2),1)
          call dswap(1,xh(1),1,xh(2),1)
          call dswap(1,gh(1),1,gh(2),1)
        endif
        if (mod(nint(wk(12)),4) .ge. 2) then
          call dswap(n,p(1,ng),1,p(1,n2),1)
          call dswap(1,xh(0),1,xh(2),1)
          call dswap(1,gh(0),1,gh(2),1)
        endif
        if (mod(nint(wk(12)),2) .ge. 1) then
          call dswap(n,p(1,ng),1,p(1,n1),1)
          call dswap(1,xh(0),1,xh(1),1)
          call dswap(1,gh(0),1,gh(1),1)
        endif
      endif
C ... Handle special case ir=0, xn=0
      if (ir .eq. 0 .and. xn .eq. 0) then
        ir = -2
        xn = (wk(5)*wk(1)-wk(4)*wk(2))/(wk(5)-wk(4))
      endif

C ... Case line minimization not converged
      if (ir .lt. 0) then

C   ... After clean, replace xh with wk.  for now:
        if (x0h .ne. wk(1) .or. x1h .ne. wk(2) .and. x1h .ne. -9d9
     .    .or. x2h .ne. wk(3) .and. x2h .ne. -9d9) then
          print *, x0h,wk(1)
          print *, x1h,wk(2)
          print *, x2h,wk(3)
          call rx('bug in gradzr or rfalsi')
        endif

C   ... preserve gradient for last two points
        x2h = x1h
        g2h = g1h
        call dcopy(n,p(1,n1),1,p(1,n2),1)
        x1h = x0h
        g1h = g0h
        call dcopy(n,p(1,ng),1,p(1,n1),1)

      elseif (ir .eq. 4) then
        xn = xmax + dxmxl
        call awrit1('%x gradzr: found extremum without root:'//
     .    '  attempt new xn=%1;4g',' ',scrwid,i1mach(2),xn)
        ir = -5
        goto 991

      elseif (ir .ne. 0) then
        call awrit2(' gradzr (abort) line %i encountered ir=%i from'//
     .    ' rfalsi',outs,scrwid,i1mach(2),lminn,ir)
        goto 991

C --- Line minimization has converged ---
      else
C       Sanity check
        if (xn .ne. x0h) call rx('bug in gradzr')
        if (isw2 .eq. 0) then
C     ... Make gam for this line
          gg = 0d0
          dgg = 0d0
          do  21  j = 1, n
            gg = gg + p(j,n0)**2
C           Use the following line for Fletcher-Reeves:
C           dggfp = dgg + p(j,ng)**2
C           or the following line for Polak-Ribiere:
            dgg = dgg + (p(j,ng)+p(j,n0))*p(j,ng)
   21     continue
          if (gg .eq. 0d0) then
          else
            gam = dgg/gg
C           gamfp = dggfp/gg
          endif
        elseif (isw2 .eq. 1) then

C         Local copy of the original Hessian
          if (isw31 .ne. 0) call dcopy(n*n,hess,1,p(1,nhs),1)

C     ... Update inverse of Hessian
          alpha = x0h - x1h
          gd2 = ddot(n,p(1,ng),1,p(1,nd),1)
          gd1 = ddot(n,p(1,n1),1,p(1,nd),1)
          dg = alpha * (gd2 - gd1)
          gwg = 0
          do  33  i = 1, n
            p(i,n2) = 0
            do  32  j = 1, n
   32       p(i,n2) = p(i,n2) + hess(i,j) * (p(j,ng) - p(j,n1))
            gwg = gwg + (p(i,ng) - p(i,n1)) * p(i,n2)
   33     continue
          q = 1 + gwg/dg
          gd1 = 0
          do  36  i = 1, n
            r = - alpha*p(i,nd)/dg
            s = (-p(i,n2) + q * alpha*p(i,nd))/dg
            do  35  j = 1, n
   35       hess(i,j) = hess(i,j) + r * p(j,n2) + s * alpha*p(j,nd)
   36     continue

C     ... Check that Hessian is positive definite
          if (isw31 .ne. 0) then
C           Keep a local copy of hessian, since dsev1 destroys it.
            call dcopy(n*n,hess,1,p(1,nhs+n),1)
            j =chkhss(p(1,nhs+n),n,p(1,n2),evtol,isw31,p(1,nhs),p(1,n1))
            evmin = p(1,n1)
            if (j .gt. 0 .and. (isw31 .eq. 1)) then
              call dcopy(n*n,p(1,nhs),1,hess,1)
              ir = -ir
            elseif (j .gt. 0) then
            endif
          endif

        endif
C  ...  Update position vector
        call daxpy(n,xn,p(1,nd),1,p(1,nx),1)
C       Largest change in component of x; used in new C.G. line min.
        dxlast = xn*p(idamax(n,p(1,nd),1),nd)
C       Residual of gradient at new position and printout
        res = dsqrt(ddot(n,p(1,ng),1,p(1,ng),1))
        if (ipr .ge. 30) then
          call awrit8('%x gradzr cvg line %i:'//
     .      '%?#n==0#  gam=%1;3g#%j#  x=%1;8d'//
     .      '  |g.h|=%1;3g  dxmax=%1;3g'//
     .      '%?#n#  evmin=%1;2g#%j#',outs,
     .      scrwid,i1mach(2),lminn,isw2,gam,xn,gfn,dxlast,isw31,evmin)
        endif
C       These are the x and grad convergence criteria
        cnvgx = abs(dxlast) .lt. xtol
        cnvgf = abs(res) .lt. gtol
        ir = -9
        itol = mod(isw1,4)
C   ... This block executes when gradzr has converged
        if (res .eq. 0 .or.
     .      itol .eq. 0 .and. cnvgf .or. itol .eq. 1 .and. cnvgx .or.
     .      itol .eq. 2 .and. (cnvgf .and. cnvgx) .or.
     .      itol .eq. 3 .and. (cnvgf .or. cnvgx)) then
          ir = 0
          if (ipr .ge. 20) then
            call awrit4('%x gradzr converged to dxmax=%1;3g, '//
     .        'gmax=%1;3g, |grad|=%1;3g in %i line min',' ',scrwid,
     .        i1mach(2),dxlast,p(idamax(n,p(1,ng),1),ng),res,lminn)
            if (ipr .ge. 30) then
            call awrit2('  p=%n:;10F',' ',scrwid,i1mach(2),npr,p(1,nx))
            call awrit2('  g=%n:;10F',' ',scrwid,i1mach(2),npr,p(1,ng))
            endif
          endif
        endif
      endif

C --- Cleanup ---
  991 continue
C     Add direction vector to position vector
      if (ir .ge. -6 .and. ir .le. -1)
     .  call daxpy(n,xn,p(1,nd),1,p(1,nx),1)
      if (ir .eq. -9) goto 1

C --- Restore local variables needed to preserve; exit
  999 continue
      wk(0) =  xn
      wk(13) = gam
      wk(14) = dxmxl
      wk(15) = dxmxlx
      wk(16) = dxlast
      wk(17) = xmax
      wk(18) = lminn
      wk(19) = grad0
      wk(20) = growl
      call dcopy(3,xh,1,wk(21),1)
      call dcopy(3,gh,1,wk(24),1)
      end
      subroutine drgrzr(n,pnew,gnew,p,hess,xtoll,dxmx,xtol,gtol,grfac,
     .  wk,copt,isw,ir)
C- Driver routine for gradzr
C ----------------------------------------------------------------------
Ci Inputs
Ci   n      :size of vector; see gradzr
Ci   pnew   :new positions for which gradient was obtained
Ci   gnew   :gradient corresponding to new positions
Ci  The following inputs are passed directly through to gradzr.
Ci  See that routine for further description.
Ci   hess   :inverse Hessian matrix for Fletcher-Powell and Broyden
Ci   xtoll  :x tolerance for line minimizations.  See gradzr
Ci   dxmx   :Maximum step length in any one component of x.
Ci   xtol   :tolerance in x for global minimization.
Ci   gtol   :tolerance in gradient for global minimization
Ci   grfac  :Extrapolation growth factor for line minimizations.
Ci   copt   :character string for a convenient specification of special
Ci           options.  drgrzr converts the following strings in copt
Ci           into the corresponding switches in isw.  These may be
Ci           strung together, separated by spaces.  isw is altered
Ci           only when input ir=0.
Ci             'def' Set default isw
Ci             'cg'  congugate gradients
Ci             'fp'  Fletcher-Powell
Ci             'br'  Broyden
Ci             'min' specify minimization
Ci             'max' specify maximization
Ci           Options are read left-to-right, so when incompatible
Ci           switches are set, the last takes precedence.
Ci   isw    :compound of one-digit switches.  It will be altered
Ci           if copt is set.
Co Inputs/Outputs
Cio  ir     :flow control passed to gradzr.
Cio          To start a new minimization, set ir to zero.
Cio          On exit, gradzr sets ir to a value as described in gradzr.
Cio          A return of ir=0 => convergence achieved to prescribed tol
Cio          A return of ir>0 => gradzr had trouble and is aborting.
Cio  p      :position and work array for input to gradzr.
Cio          Array is dimensioned at least 6*n for F.P. and C.G. and 8*n
Cio          for Broyden.  If the Hessian eigenvalues are calculated,
Cio          it increases to n*(6+n) and n*(11+2n) for F.P. and Broyden.
Cio          p should remain untouched between successive calls
Cio          drgrzr replaces p(*,nx):replaced by pnew and
Cio          p(*,nd) changed to p(nd) = xn * (h(xn)-h(xn=0))
Cio          NB: input ir=0 => p(nd) not defined and not changed
Cio  wk     :work array passed for input to gradzr.
Cio         :wk should remain untouched between successive calls
Cr Remarks
Cr   This is a driver routine for gradzr, taking as input positions
Cr   and gradients, and internally updating the gradzr matrix p.
Cr   For line minimizations, it also resets the conjugate direction
Cr   vector h = p(1,nd) in the event the positions passed to drgrzr
Cr   do not correspond to those kept by p.
Cu Updates
C ----------------------------------------------------------------------
C     implicit none
C ... Passed parameters
      character*(*) copt
      integer n,ir,isw
      double precision pnew(n),gnew(n)
      double precision hess(n,n),p(n,10),xtoll,dxmx,xtol,gtol,wk(0:26),
     .  grfac
C Local variables
      integer idx,nx,ng,nd,n0,idamax,iprint,lgunit,j1,j2,getdig
      double precision dhmax,hold,hmax,tol,xn
      parameter (nx=1,ng=2,nd=3,n0=6,tol=1d-4)

C --- Set switches based on copt ---
      if (ir .eq. 0 .and. copt .ne. ' ') then
        j1 = 1
   10   continue
        call nword(copt,1,j1,j2)
        if (j2 .ge. j1) then
        if (copt(j1:j2) .eq. 'cg') then
          isw = isw + 100*(0-getdig(isw,2,10))
        elseif (copt(j1:j2) .eq. 'fp') then
          isw = isw + 100*(1-getdig(isw,2,10))
        elseif (copt(j1:j2) .eq. 'br') then
          isw = isw + 100*(2-getdig(isw,2,10))
        elseif (copt(j1:j2) .eq. 'def') then
          isw = 40
        elseif (copt(j1:j2) .eq. 'min') then
          isw = isw + 1*(1-mod(getdig(isw,0,10),4))
        elseif (copt(j1:j2) .eq. 'max') then
          isw = isw + 1*(2-mod(getdig(isw,0,10),4))
        else
          call rxs2('drgrzr:  bad option, "',copt(j1:j2),'"')
        endif
        j1 = j2+1
        goto 10
        endif
      endif

      xn = wk(0)
C ... hnew = hold + 1/xn (pnew - pold)
      if (ir .ne. 0 .and. xn .ne. 0d0) then
        idx = idamax(n,p(1,nd),1)
        hmax = abs(p(idx,nd))
C       This destroys p(nx) but it isn't needed anymore
        call daxpy(n,-1d0,pnew,1,p(1,nx),1)
        idx = idamax(n,p(1,nx),1)
        dhmax = abs(p(idx,nx)/xn)
        hold = abs(p(idx,nd))
        call daxpy(n,-1d0/xn,p(1,nx),1,p(1,nd),1)
C   ... Change in direction exceeds tolerance; reset ir
        if (dhmax .gt. tol*hmax) then
          if (iprint() .ge. 30) call awrit2(' gradzr: reset conjugate'//
     .      ' direction.  dhmax = %1,3;3g  hold = %1,3;3g',' ',80,
     .      lgunit(1),dhmax,hold)

C     ... For ir=-10, need p(nx) = p(xn=0), p(ng) = -p(n0)
          call dcopy(n,pnew,1,p(1,nx),1)
          call daxpy(n,-xn,p(1,nd),1,p(1,nx),1)
          call dpcopy(p(1,n0),p(1,ng),1,n,-1d0)

C     ... Call gradzr to reset C.G. or F.P. for new line min
          ir = -10
          call gradzr(n,p,hess,xtoll,dxmx,xtol,gtol,grfac,wk,isw,ir)
          wk(0) = xn

        endif
      endif

C ... Set p(nx) to pnew and p(ng) to gnew
      call dcopy(n,pnew,1,p(1,nx),1)
      call dcopy(n,gnew,1,p(1,ng),1)

C ... Call gradzr for next step in minimization
      call gradzr(n,p,hess,xtoll,dxmx,xtol,gtol,grfac,wk,isw,ir)

      end
      double precision function pgrada(isw1,isw4)
C- Line minimization gradient tolerance
C     implicit none
      integer isw1,isw4
      double precision gtll

      gtll = 0
C          requested   req'd when xtol not used
      if (isw1 .ge. 4 .or. mod(isw1,4) .eq. 0) then
        gtll = dble(isw4)/20
C       If zero, use a default value
        if (gtll .eq. 0) gtll = .25d0
      endif

      pgrada = gtll

      end
C#ifdefC TEST
C      subroutine hessmp(nelt,ido,ncofn,icofn,cofn,grad,rotm,gradr)
CC- Maps gradient to change its sign along a fixed direction
CC ----------------------------------------------------------------------
CCi Inputs
CCi   nelt  :number of elements in vector
CCi   ido   :tells hessmp what to make.
CCi          1s digit
CCi           1 make rotm grad or rotm^-1 grad depending on 1s digit
CCi           2 make rotm^-1 grad
CCi          >2 make rotm^-1 (-1)'' rotm grad
CCi          10s digit
CCi           1 make rotm
CCi          >1 make rotm^-1
CCi  ncofn  :number of nonzero elements in normal direction
CCi  icofn  :index to a nonzero element of the normal direction
CCi  cofn   :coefficients of normal direction corresponding to icofn
CCi  grad   :gradient in unrotated coordinates
CCo Outputs
CCo   gradr :gradient in rotated coordinates
CCo          Only calculated if 1s digit of ido is nonzero
CCo   rotm  :full similarity transformation matrix rotm, or inverse
CCo          Only calculated if 10s digit of ido is nonzero
CCr Remarks
CCr   The ido=2 case can be done analytically:
CCr   gradr_i = sum_j grad_j delta_ij - n_i n_j
CCr   but we leave it the way it is for testing.
CCd Debugging
CCd  To generate grad (rotm^-1 (-1)'' rotm), specify grad,rotm,i,n
CCd  mc -vn=10 -vi=4 grad -t rotm -i -x -1:n -1:1
CCd     -s-2 -sub 2-i,n-i+1,2-i,n-i+1 -+ -x rotm -x -t
CCu Updates
CC ----------------------------------------------------------------------
CC      implicit none
CC ... Passed parameters
C      integer nelt,ncofn,icofn(ncofn)
C      double precision cofn(ncofn),grad(nelt)
C      double precision rotm(nelt,nelt),gradr(nelt)
CC ... Local parameters
C      integer i,ivm,idamax,ido,ido0,ido1,iv,jv,j,iivm
C
C      ido0 = mod(ido,10)
C      ido1 = mod(ido/10,10)
C      if (ido0 .eq. 0 .and. ido1 .eq. 0) return
C      ivm = idamax(ncofn,cofn,1)
C      iivm = icofn(ivm)
C
CC --- gradr <- grad rotm^-1: loop over all nonzero pairs ---
C      if (ido0 .eq. 1) then
CC   ... Contribution gradr(i) = sum_j delta_ij grad_j
C        call dcopy(nelt,grad,1,gradr,1)
C        do  10  iv = 1, ncofn
C          i = icofn(iv)
CC     ... gradr(ivm) += grad(i) n_iv
C          gradr(iivm) = gradr(iivm) + grad(i) * cofn(iv)
CC     ... gradr(i) -= grad(ivm) n_i /n_ivm
C          gradr(i) = gradr(i) - cofn(iv)/cofn(ivm)*grad(iivm)
C   10   continue
C      endif
C
CC ... Brute force making of grad rotm^-1 (-1) rotm
CC     replace 'if (ido0 .eq. 1) then' above with:
CC             if (ido0 .eq. 1 .or. ido0 .gt. 2)
CC     and 'if (ido0 .eq. 2)' below with ... .ge.
CC      if (ido0 .eq. 3) then
CC        call dcopy(nelt,gradr,1,grad,1)
CC        grad(iivm) = -grad(iivm)
CC      endif
C
CC --- gradr <- grad rotm : loop over all nonzero pairs ---
C      if (ido0 .eq. 2) then
CC   ... Contribution gradr(i) = sum_j delta_ij grad_j
C        call dcopy(nelt,grad,1,gradr,1)
C        gradr(iivm) = 0
C        do  20  iv = 1, ncofn
C          i = icofn(iv)
CC     ... gradr(i) += grad(ivm) (n_iv + n_ivm n_iv)
C          gradr(i) = gradr(i) +
C     .               grad(iivm) * (cofn(iv) + cofn(ivm)*cofn(iv))
CC     ... gradr(i) -= sum_j sum n_i n_j grad_j
C          do  24  jv = 1, ncofn
C            j = icofn(jv)
C            gradr(i) = gradr(i) - grad(j) * cofn(iv)*cofn(jv)
C   24     continue
C   20   continue
C      endif
C
CC --- gradr <- grad rotm^-1 (-1)' rotm ---
C      if (ido0 .eq. 3) then
C        call dcopy(nelt,grad,1,gradr,1)
C        do  30  iv = 1, ncofn
C          i = icofn(iv)
CC     ... gradr(i) -= 2 grad_j sum_j sum n_i n_j
C          do  34  jv = 1, ncofn
C            j = icofn(jv)
C            gradr(i) = gradr(i) - grad(j) * 2 * cofn(iv)*cofn(jv)
C   34     continue
C   30   continue
C      endif
C
CC --- Make rotm or rotm^-1: loop over all nonzero pairs ---
C      if (ido1 .ne. 0) then
C        call dpzero(rotm,nelt**2)
C        do  80  i = 1, nelt
C          rotm(i,i) = 1
C   80   continue
CC   ... Normal vector goes into row with largest projection
C        i = icofn(ivm)
C        do  82  jv = 1, ncofn
C          j = icofn(jv)
C          if (ido1 .eq. 1) rotm(i,j) = cofn(jv)
C          if (ido1 .ne. 1) rotm(j,i) = cofn(jv)
C   82   continue
C        j = icofn(ivm)
C        do  84  iv = 1, ncofn
C          i = icofn(iv)
C          if (iv .eq. ivm) goto 84
C          if (ido1 .eq. 1) then
C            do  86  jv = 1, ncofn
C              j = icofn(jv)
C              rotm(i,j) = rotm(i,j) - cofn(iv)*cofn(jv)
C   86       continue
C          else
C            rotm(j,i) = - cofn(iv)/cofn(ivm)
C          endif
C   84   continue
CC       call prmx('rotm',rotm,nelt,nelt,nelt)
C      endif
C      end
C
C      subroutine suhsmp(nbas,nd,iprm,wk,ipr,veclst,nvclst,icofn,cofn)
CC- Unpacks normal direction into standard form
CC ----------------------------------------------------------------------
CCi Inputs
CCi   nbas : size of basis
CCi     nd : number of dimensions (2 for xy, 3 for xyz)
CCi   iprm : integer work array of length nvclst, used to sort veclst
CCi     wk : work array of length 3*nvclst, used to sort veclst
CCi    ipr : verbosity
CCi veclst : a list of parameters describing normal matrix:
CCi          veclst(1,..) = basis atom
CCi          veclst(2,..) = 1,2 or 3 for x,y,z
CCi          veclst(3,..) = weight for this direction
CCi nvclst : number of members in veclst
CCo Outputs
CCo  icofn : list of nonzero coefficients for normal direction
CCo  cofn  : coefficients corresponding to icofn
CCo nvclst : number of nonzero elements, and size of icofn,cofn
CCr Remarks
CCu Updates
CC ----------------------------------------------------------------------
CC      implicit none
CC ... Passed parameters
C      integer nbas,nvclst,nd,icofn(nvclst),iprm(nvclst)
C      double precision veclst(3,nvclst),cofn(nvclst),wt,wk(3,nvclst)
CC ... Local parameters
C      integer ib,ix,i,ipr,ixb,iv,lo,ncofn,cofi,ivm,idamax
C      double precision ddot,cofib(5)
C
CC ... Sort vecs
C      call dvheap(3,nvclst,veclst,iprm,0d0,1)
C      call dvprm(3,nvclst,veclst,wk,iprm,.true.)
C
CC ... Copy veclst to (icofn,cofn) format
C      ncofn = 0
C      do  10  i = 1, nvclst
C        if (veclst(3,i) .eq. 0) goto 10
C        ncofn = ncofn+1
C        ib = veclst(1,i)
C        ix = veclst(2,i)
C        ixb = ix + nd*(ib-1)
C        if (ib .gt. nbas .or. ix .gt. nd) call fexit2(-1,1,' Exit -1 '//
C     .    'SUHSMP: index out of bounds: ib=%i  ix=%i',ib,ix)
C        icofn(ncofn) = ixb
C        cofn(ncofn) = veclst(3,i)
C   10 continue
C
C      if (ncofn .eq. 0) goto 30
C      wt = ddot(ncofn,cofn,1,cofn,1)
C      call dscal(ncofn,1/dsqrt(wt),cofn,1)
C      ivm = idamax(ncofn,cofn,1)
C
C      if (ipr .ge. 30 .and. ncofn .gt. 0) then
C        print 334, ivm
C  334   format (' suhsmp:  normal vector for negative Hessian.  ',
C     .    'Max projection:  element',i4/
C     .    1x,' ib  elt      x           y         z')
C        lo = 0
C        iv = 0
C        call iinit(cofi,nd)
C   20   iv = iv+1
C          ixb = icofn(iv)
C          ib = (ixb-1)/nd + 1
C          ix = ixb - nd*(ib-1)
C          if (ib .ne. lo) then
C            if (lo .ne. 0) print  333, lo, cofi, (cofib(i), i=1,nd)
C            lo = ib
C            cofi = ixb
C            call dpzero(cofib,nd)
C          endif
C          cofib(ix) = cofn(iv)
C          if (iv .lt. ncofn) goto 20
C          print  333, ib, cofi, (cofib(i), i=1,nd)
C  333     format(2i4,3f12.8)
C
C      endif
C   30 continue
C      nvclst = ncofn
C      end
C      double precision function f1dim(n,x,p,ir)
CC- Generic function call for projection grad f in a specified direction
CC  for subroutine gradzr.
CCi p(1..n) pos'n vec; 2n+1..3n direction vec
CCo p(1..2n): grad f(posn-vec + x * direction-vec)
CCo p(5n+1..6n): (posn-vec + x * direction-vec)
CCo f1dim: grad f(posn-vec + x * direction-vec) . (unit direction-vec)
CCr This routine expects an eternal subroutine dfunc, which returns
CCr the gradient of a function at a point p.
CC      implicit none
C      double precision x
C      integer j,ir,n
C      double precision p(12),ddot,func,xx
C
C      integer jj
C      save jj
C      data jj /0/
C
CC ... Return total number of function calls if n is 0
C      if (n .eq. 0) then
C        f1dim = jj
C        return
C      endif
C      if (n .lt. 0) then
C        jj = 0
C        return
C      endif
C
C      jj = jj+1
CC     print *, jj
C
CC ... (posn-vec + x * direction-vec)
CC      do  10  j = 1, n
CC   10 p(5*n+j) = p(j) + x*0*p(2*n+j)
C
CC ... Gradient (posn-vec + 0 * direction-vec) and inner product
C      call dfunc(p,xx,p(n+1))
C      f1dim = xx
C      end
CC ... For testing gradzr ...
C      double precision FUNCTION FUNC(X)
CC      implicit none
CC#ifdef PROB0
C      integer natom
C      parameter (natom=19)
C      double precision df(2*natom),x(2*natom),xx
C      double precision normal(2*natom)
C      call g2(natom,x(1),xx,df)
C      func = xx
CC#elseifC PROB1
CC      double precision x(3),bessj0,bessj1,xx
CC      xx=1.0d0-BESSJ0(X(1)-0.5d0)*BESSJ0(X(2)-0.5d0)*
CC     .  BESSJ0(X(3)-1d0)
CC      func = -xx
CC#endif
CC      print 333,  x, xx
CC  333 format('x=',3f14.10, ' f=',f12.6)
C      END
C
C      subroutine dfunc(x,f,df)
CC      implicit none
C      integer nmax
C      double precision x(3),df(3),bessj0,bessj1,func
C      double precision f1,f2,f3,f1x,f1y,f1z,f2x,f2y,f2z,f3x,f3y,f3z,f
CC#ifdef PROB0
C      integer natom
C      natom = 19
C      call g2(natom,x(1),f,df)
CC#elseifC PROB1
CC      df(1)=-bessj1(x(1)-0.5d0)*bessj0(x(2)-0.5d0)*bessj0(x(3)-1.0d0)
CC      df(2)=-bessj0(x(1)-0.5d0)*bessj1(x(2)-0.5d0)*bessj0(x(3)-1.0d0)
CC      df(3)=-bessj0(x(1)-0.5d0)*bessj0(x(2)-0.5d0)*bessj1(x(3)-1.0d0)
CC      f = FUNC(X)
CC      return
CC#elseifC PROB2 | PROB3
CC      f1  = -cos(x(1)*x(2))
CC      f1x = x(2)*sin(x(1)*x(2))
CC      f1y = x(1)*sin(x(1)*x(2))
CC      f1z = 0
CC      f2  = sin(x(1)+2*x(3))**2
CC      f2x = 2*sin(x(1)+2*x(3))*cos(x(1)+2*x(3))
CC      f2y = 0
CC      f2z = 2*f2x
CC      f3  = cos(x(1))*cos(6*x(2))*cos(x(3))
CC      f3x =-sin(x(1))*cos(6*x(2))*cos(x(3))
CC      f3y =-6*cos(x(1))*sin(6*x(2))*cos(x(3))
CC      f3z =-cos(x(1))*cos(6*x(2))*sin(x(3))
CC      f   = (f1+f2)*f3
CC      df(1) = (f1x+f2x)*f3 + (f1+f2)*f3x
CC      df(2) = (f1y+f2y)*f3 + (f1+f2)*f3y
CC      df(3) = (f1z+f2z)*f3 + (f1+f2)*f3z
Cc      f = FUNC(X)
CC#elseifC PROB4
CC      f1 = -.1d0
CC      f = x(1)**2 + 2*x(2)**2 + 3*x(3)**2 + f1*x(1)*x(2)*x(3)
CC      df(1) = 2*x(1) + f1*x(2)*x(3)
CC      df(2) = 4*x(2) + f1*x(1)*x(3)
CC      df(3) = 6*x(3) + f1*x(1)*x(2)
CC      f = FUNC(X)
CC#endif
C      end
C
C      double precision function bessj0(x)
CC      implicit none
C      double precision x,xx,ax,z
C      double precision y,p1,p2,p3,p4,p5,q1,q2,q3,q4,q5,r1,r2,r3,
C     .  r4,r5,r6,s1,s2,s3,s4,s5,s6
C      data p1,p2,p3,p4,p5/1.d0,-.1098628627d-2,.2734510407d-4,
C     .  -.2073370639d-5,.2093887211d-6/,
C     .  q1,q2,q3,q4,q5/-.1562499995d-1,
C     .  .1430488765d-3,-.6911147651d-5,.7621095161d-6,-.934945152d-7/
C      data r1,r2,r3,r4,r5,r6/57568490574.d0,-13362590354.d0,
C     .  651619640.7d0,
C     .  -11214424.18d0,77392.33017d0,-184.9052456d0/,
C     .  s1,s2,s3,s4,s5,s6/57568490411.d0,1029532985.d0,
C     .  9494680.718d0,59272.64853d0,267.8532712d0,1.d0/
C      if(dabs(x).lt.8.d0)then
C        y=x**2
C        bessj0=(r1+y*(r2+y*(r3+y*(r4+y*(r5+y*r6)))))
C     .    /(s1+y*(s2+y*(s3+y*(s4+y*(s5+y*s6)))))
C      else
C        ax=dabs(x)
C        z=8.d0/ax
C        y=z**2
C        xx=ax-.785398164d0
C        bessj0=dsqrt(.636619772d0/ax)*(dcos(xx)*(p1+y*(p2+y*(p3+y*(p4+y
C     .    *p5))))-z*dsin(xx)*(q1+y*(q2+y*(q3+y*(q4+y*q5)))))
C      endif
C      end
C      double precision function bessj1(x)
CC      implicit none
C      double precision x,xx,ax,z
C      double precision y,p1,p2,p3,p4,p5,q1,q2,q3,q4,q5,r1,r2,r3,r4,
C     .  r5,r6,s1,s2,s3,s4,s5,s6
C      data r1,r2,r3,r4,r5,r6/72362614232.d0,-7895059235.d0,242396853.1d0
C     .,
C     .    -2972611.439d0,15704.48260d0,-30.16036606d0/,
C     .    s1,s2,s3,s4,s5,s6/144725228442.d0,2300535178.d0,
C     .    18583304.74d0,99447.43394d0,376.9991397d0,1.d0/
C      data p1,p2,p3,p4,p5/1.d0,.183105d-2,-.3516396496d-4,.2457520174d-5
C     .,
C     .    -.240337019d-6/, q1,q2,q3,q4,q5/.04687499995d0,-.2002690873d-3
C     .,
C     .    .8449199096d-5,-.88228987d-6,.105787412d-6/
C      if(dabs(x).lt.8.d0)then
C        y=x**2
C        bessj1=x*(r1+y*(r2+y*(r3+y*(r4+y*(r5+y*r6)))))
C     .      /(s1+y*(s2+y*(s3+y*(s4+y*(s5+y*s6)))))
C      else
C        ax=dabs(x)
C        z=8.d0/ax
C        y=z**2
C        xx=ax-2.356194491d0
C        bessj1=dsqrt(.636619772d0/ax)*(dcos(xx)*(p1+y*(p2+y*(p3+y*(p4+y
C     .      *p5))))-z*dsin(xx)*(q1+y*(q2+y*(q3+y*(q4+y*q5)))))
C     .      *dsign(1.d0,x)
C      endif
C      end
C      subroutine prm(lbin,icast,ifi,fmt,s,nr,nc)
CC- writes complex matrix to file ifi
CCr lbin: writes in binary mode
CC      implicit none
C      integer lbin,icast,nr,nc,ifi
C      character*(*) fmt, fmt0*20
C      double precision s(nr,nc,2)
C
C      fmt0 = '(9f15.10)'
C      if (fmt .ne. ' ') fmt0 = fmt
C
C      call ywrm(lbin,' ',icast,ifi,fmt0,s,nr*nc,nr,nr,nc)
C      if (ifi .ne. 6) close(ifi)
C      end
C      subroutine fmain
CC      implicit none
C      integer ndim,iter,k,ir,isw,i,j,ifi,ifl,fopna
C      double precision gtol,pio2,f1dim
C      double precision angl
CC#ifdef PROB0
C      parameter(ndim=2*19,pio2=1.5707963d0)
C      double precision f(ndim)
C      integer ietype
C      double precision rcut,amu,azero
CC#elseifC PROB1 | PROB2
CC      parameter(ndim=3,pio2=1.5707963d0)
CC#elseifC PROBN
CC      parameter(ndim=2*19,pio2=1.5707963d0)
CC      double precision f(ndim)
CC#endif
C      integer nvclst,owk,oiwk,nlin,nlinmx
C      double precision hess(ndim,ndim),p(ndim*(11+2*ndim)),dxmx,xtol,xx,
C     .  xn,veclst(3,5),wk(0:26),dx
C      real ran1
C      equivalence (wk(0),xn)
C      external f1dim
CC ... for mstmin
C      double precision w2(ndim,ndim),g1(ndim),g2(ndim),del(ndim),
C     .  wrk(ndim),pos(ndim),psav(ndim),cofn(ndim),
C     .  alpha1,alpha2,gd1,alphau,alphal,alpha,xtoll,ddot
C      integer icom,iprint,nit,nsrch,i1mach,rdm,icofn(ndim),nitm
C      character*80 outs
C      logical cmdopt
C      integer w(10000)
C      common /w/ w
C
CC ... for suhsmp
C      call pshpr(0)
C      call wkinit(10000)
C      call poppr
C
CC ... for mstmin
C      call pshpr(51)
C      call dpzero(w2,ndim**2)
C      call dcopy(ndim,1d0,0,w2,ndim+1)
C      call finits(2,0,0,i)
C      xtoll = 1d-6
C      xtol = 1d-4
C      gtol = 1d-4
C      xn = 0
C      nitm = 200
C      nlin = 0
C      nlinmx = 0
C
CC ... The following tests suhsmp,hessmp
CC      veclst(1,1) = 1
CC      veclst(2,1) = 1
CC      veclst(3,1) = .20d0/2
CC      veclst(1,2) = 2
CC      veclst(2,2) = 2
CC      veclst(3,2) = 1d0/2
CC      veclst(1,1+2) = 3
CC      veclst(2,1+2) = 1
CC      veclst(3,1+2) = .31d0/2
CC      veclst(1,2+2) = 3
CC      veclst(2,2+2) = 2
CC      veclst(3,2+2) = .32d0/2
CC      nvclst = 4
CC      call defrr(owk, 3*nvclst)
CC      call defi(oiwk,nvclst)
CC      call suhsmp(5,2,w(oiwk),w(owk),30,veclst,nvclst,icofn,cofn)
CC      call ran1in(10)
CC      do  88 i = 1, 5*2
CC   88 p(i+ndim) = 4*ran1() - 2
CC      call prmx('grad',p(1+ndim),5*2,5*2,1)
CC      i = 10+1
CC      call hessmp(5*2,i,nvclst,icofn,cofn,p(1+ndim),w2,wrk)
CC      call prmx('grad rotm^-1',wrk,5*2,5*2,1)
CC      i = 2
CC      call hessmp(5*2,i,nvclst,icofn,cofn,p(1+ndim),w2,wrk)
CC      call prmx('grad rotm',wrk,5*2,5*2,1)
CC      i = 3
CC      call hessmp(5*2,i,nvclst,icofn,cofn,p(1+ndim),w2,wrk)
CC      call prmx('rotm^-1 (-1) rotm grad',wrk,5*2,5*2,1)
CC      stop
C
CC#ifndefC PROB0 | PROBN
CC      do 11 k=0,4
CCC      do 11 k=2,2
CC        print *
CC        angl = pio2*k/4.0d0
CC#endif
CC#ifdef PROB0
C        if (cmdopt('-hessmp',7,0,outs)) then
CC   ... The following sets up normal direction
C        veclst(1,1) = 8
C        veclst(2,1) = 1
C        veclst(3,1) = 1
C        veclst(1,2) = 8
C        veclst(2,2) = 2
C        veclst(3,2) = 2
C        nvclst = 2
C        call defrr(owk, 3*nvclst)
C        call defi(oiwk,nvclst)
C        call suhsmp(ndim/2,2,w(oiwk),w(owk),30,veclst,nvclst,icofn,cofn)
C        endif
CC .... the following reads x-y pairs from file in.dat
C        ifi = fopna('in',-1,0)
C        if (rdm(ifi,10000,ndim,' ',p(1),ndim/2,2) .lt. 0)
C     .    call rx('failed to read from file in.dat')
C        call fkset(1,1,1,ietype,rcut,amu,azero)
CC#elseifC PROBN
CC        stop 'read in array'
CC#elseifC PROB1
CC        print '(/'' minimize J0(x-.5)J0(y-.5)J0(z-1)''/)'
CC        dxmx = .5d0
CC        p(1)=2.0d0*dcos(angl)
CC        p(2)=2.0d0*dsin(angl)
CC        p(3)=0.0d0
CC#elseifC PROB2
CCc .... the following finds a minimum of trig fn at 1.08,.605,.237
CC        print '(/''prob2: trig fun (3 vars), min= 1.08,.605,.237''/)'
CC        dxmx = .3
CC        p(1) = .5d0
CC        p(2) = .5d0
CC        p(3) = .3d0
CC#elseifC PROB3 | PROB4
CCc .... or at zero
CC        dxmx = .3
CC        p(1) = .3d0
CC        p(2) = .3d0
CC        p(3) = .3d0
CC#elseifC PROB4
CCc .... or at zero
CC        xtol = 1d-6
CC        gtol = 1d-6
CC        dxmx = .3
CC        p(1) = .3d0
CC        p(2) = .3d0
CC        p(3) = .3d0
CC#endif
C        ir = 0
C        isw = 0001
C        call dpzero(hess,ndim**2)
CC#ifdef PROB0
C        isw = 55
C        dxmx = .1d0
C        xtol = .01d0
C        gtol = 1d-3
C        call pshpr(70)
CC#endif
CC#ifdefC PROBN
CC        isw = 15
CC        dxmx = .01d0
CC        xtol = .005d0
CC        gtol = 0d0
CC        call pshpr(70)
CC#endif
C        xtoll = xtol
C        call getsyv('sw',xx,i)
C        if (i .gt. 0) isw = nint(xx)
C        call getsyv('xtol',xx,i)
C        if (i .gt. 0) xtol = xx
C        call getsyv('gtol',xx,i)
C        if (i .gt. 0) gtol = xx
C        call getsyv('xtoll',xx,i)
C        if (i .gt. 0) xtoll = xx
C        call getsyv('maxit',xx,i)
C        if (i .gt. 0) nitm = xx
C        call getsyv('mxlin',xx,i)
C        if (i .gt. 0) nlinmx = xx
C        call getsyv('dxmx',xx,i)
C        if (i .gt. 0) dxmx = xx
C        ifl = fopna('log',-1,0)
C        call dfclos(ifl)
C        ifl = fopna('log',-1,0)
C        if (cmdopt('-rdhess',7,0,outs)) then
C          print *, 'reading hessian matrix from hssn.dat'
C          ifi = fopna('hssn',-1,0)
C          i = rdm(ifi,0,ndim**2,' ',hess,ndim,ndim)
C          if (i .lt. 0) call rx('failed to read file')
C          call fclose(ifi)
C        endif
CC ...   for mstmin
CC        iter = 0
CC        call dcopy(ndim,p(1),1,pos,1)
CC        call dfunc(pos,xx,p(2*ndim+1))
CC        call awrit4('   f1dim: xn=%,8;8d fn=%,8;8d g=%n:1,8;8d',' ',
CC     .    80,i1mach(2),xn,xx,ndim,p(2*ndim+1))
CC        call dpzero(del,ndim)
CC        icom = 0
CC   15   continue
CC        iter = iter+1
CC        call dcopy(ndim,p(2*ndim+1),1,p(ndim+1),1)
CC        call daxpy(ndim,alpha,del,1,pos,1)
CC        call dfunc(pos,xx,p(2*ndim+1))
CC        call awrit4('   f1dim: xn=%,8;8d fn=%,8;8d g=%n:1,8;8d',' ',
CC     .    80,i1mach(2),xn,xx,ndim,p(2*ndim+1))
CC        call awrit2('  p=%n:;10F',' ',80,i1mach(2),ndim,pos)
CC        call awrit2('  g=%n:;10F',' ',80,i1mach(2),ndim,p(2*ndim+1))
CC        call mstmin(ndim,w2,p(ndim+1),p(2*ndim+1),del,wrk,dxmx,xtol,
CC     .    alpha,0d0,icom,gd1,alpha1,alpha2,alphau,alphal,nsrch,6)
CC        call awrit5(' done mstmin:  nit = %i  nsrch = %i alpha = %d'//
CC     .    '  icom = %i  grad=%1;4g',' ',80,i1mach(2),iter,nsrch,alpha,
CC     .    icom,dsqrt(ddot(ndim,p(2*ndim+1),1,p(2*ndim+1),1)))
CC        if (icom .ne. 1) goto 15
CC        call awrit2('  p=%n:;10F',' ',80,i1mach(2),ndim,pos)
CC        call awrit2('  g=%n:;10F',' ',80,i1mach(2),ndim,p(2*ndim+1))
CC        call rx('done')
C
CC ...   for gradzr
CC#ifdefC PROBN
CC        call dfdump(f,ndim,ifi)
CC        call dpcopy(f,p(ndim+1),1,ndim,-1d0)
CC#else
C        ir = 0
C        xx = f1dim(ndim,0d0,p,ir)
CC#endif
C        iter = 0
C   10   continue
CC        call awrit4('   f1dim: xn=%,8;8d fn=%,8;8d g=%n:1,8;8d',' ',
CC     .    80,i1mach(2),xn,xx,ndim,p(ndim+1))
C        call awrit4('f xn=%,8;8d fn=%,8;8d g=%n:1,8;8d',' ',
C     .    80,ifl,xn,xx,ndim,p(ndim+1))
CC        call awrit2('  p=%n:;10F',' ',80,i1mach(2),ndim,p(0*ndim+1))
CC        call awrit2('  g=%n:;10F',' ',80,i1mach(2),ndim,p(ndim+1))
C        iter = iter+1
C
C        if (cmdopt('-hessmp',7,0,outs)) then
C          call hessmp(ndim,3,nvclst,icofn,cofn,p(1+ndim),w,wrk)
C          i = 100
C          call awrit2('  p=%n:;10F',' ',i,i1mach(2),10,p(0*ndim+10))
C          call awrit2('  g=%n:;10F',' ',i,i1mach(2),10,p(ndim+10))
C          call awrit2(' rg=%n:;10F',' ',i,i1mach(2),10,wrk(10))
C          call dcopy(ndim,wrk,1,p(ndim+1),1)
C        endif
C
C        call gradzr(ndim,p,hess,xtoll,dxmx,xtol,gtol,1.2d0,wk,isw,ir)
C        if (ir .lt. 0) then
C          if (iter .gt. nitm) then
C            print *, 'convergence failed after', nitm,' iterations'
C            goto 20
C          endif
C          if (mod(isw/100,10) .lt. 2 .and. ir .eq. -1) then
C            nlin = nlin+1
C            if (nlin .gt. nlinmx .and. nlinmx .ne. 0) then
C              nlin = 0
C              ir = 0
C              call dpzero(hess,ndim**2)
C            endif
C          endif
C          if (ir .eq. -9 .or. ir .eq. 0) xn = 0
CC#ifdefC PROBN
CC          call dcopy(ndim,pos,1,psav,1)
CCC          do  19  i = 1, ndim
CCC   19     print 356, i, (p(i) + xn*p(2*ndim+i)),
CCC     .        psav(i), (p(i) + xn*p(2*ndim+i))-psav(i)
CCC  356     format(i4,3f11.5)
CCC          pause
CC          read(ifi,'(a1)',err=99,end=99)
CC          read(ifi,'(a1)',err=99,end=99)
CC          backspace ifi
CC          call dfdump(pos,ndim,ifi)
CC          do  18  i = 1, ndim
CC   18     if (dabs(pos(i) - (p(i) + xn*p(2*ndim+i))) .gt. 1d-12)
CC     .      call rx('file''s position does not match gradzr''s request')
CC          call dfdump(f,ndim,ifi)
CC          call dpcopy(f,p(ndim+1),1,ndim,-1d0)
CC          goto 10
CC   99     call rx('no more points')
CC#else
C          xx = f1dim(ndim,xn,p,ir)
C          goto 10
CC#endif
C        endif
C   20   print '('' test finished in'',i3,'' function calls, ir='',i3)',
C     .    iter,ir
C        xx = f1dim(ndim,xn,p,ir)
C        call awrit4(' f1dim: xn=%,8;8d fn=%,8;8d g=%n:1,8;8d',' ',
C     .    80,i1mach(2),xn,xx,ndim,p(ndim+1))
CC#ifdef PROB0
C        ifi = fopna('out',-1,0)
C        call dcopy(ndim/2,p(1),2,p(ndim+1),1)
C        call dcopy(ndim/2,p(2),2,p(ndim+ndim/2+1),1)
C        call ywrm(0,' ',1,ifi,'(2f15.8)',p(ndim+1),ndim,
C     .    ndim/2,ndim/2,2)
C        call fclose(ifi)
C        print *, 'wrote pos to file out.dat'
C        if (mod(isw/100,10) .eq. 1 .or. mod(isw/100,10) .eq. 2) then
C           ifi = fopna('hssn',-1,0)
C           call ywrm(0,' ',11,ifi,'(5f15.10)',hess,ndim*ndim,ndim,ndim,
C     .       ndim)
C          call fclose(ifi)
C          print *, 'wrote hessian to file to file hssn.dat'
C        endif
CC#endif
C
CC   ... Make true hessian
C        dx = 1d-4
C        do  60  j = 1, ndim
C          p(j) = p(j) + dx/2
C          xx = f1dim(ndim,xn,p,ir)
C          call dcopy(ndim,p(ndim+1),1,wrk,1)
C          p(j) = p(j) - dx
C          xx = f1dim(ndim,xn,p,ir)
C          p(j) = p(j) + dx/2
C          do  62  i = 1, ndim
C   62     hess(i,j) = (wrk(i) - p(ndim+i))/dx
C   60   continue
C         ifi = fopna('thssn',-1,0)
C         call ywrm(0,' ',11,ifi,'(5f15.10)',hess,ndim*ndim,ndim,ndim,
C     .     ndim)
C        call fclose(ifi)
C        print *, 'wrote true hessian to file to file thssn.dat'
CC#ifndef PROB1
C       call cexit(1,1)
CC#endif
C   11 continue
C      end
C#endif
