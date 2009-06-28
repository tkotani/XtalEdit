      subroutine brentm(ax,bx,cx,fa,fb,fc,f,minmax,tol,eps,itmax,ir)
C- Finds an extremum or root of a function of one variable
C ----------------------------------------------------------------------
Ci Inputs:
Ci
Co Outputs:
Co   ir: number of iterations (itmax+1 if ir reaches itmax)
Co       -1 if function call failed.
Co   bx: position of extremum or root, ax,cx bracket extremum
Co   fb,fa,fc: corresponding function values
Cr Remarks
C ----------------------------------------------------------------------
C     implicit none
      integer minmax,ir,itmax,iter
      double precision ax,bx,cx,fa,fb,fc,f,eps,tol
      external f

      ir = 0
      call mnbrak(ax,bx,cx,fa,fb,fc,f,9d9,minmax,itmax,iter,ir)
      if (ir .lt. 0) return
      ir = iter
      if (iter .eq. itmax) then
        print *, 'BRENTM: iter exceeds itmax=', itmax,' ... exiting'
        ir = itmax+1
        return
      endif
      call brent(ax,bx,cx,fa,fb,fc,f,minmax,tol,eps,itmax-iter,ir)
      if (ir .lt. 0) return
      ir = ir+iter
      end

      subroutine mnbrk2(a,x,fx,f,iter,ir)
C- Called by mnbrak
C ----------------------------------------------------------------------
Ci Inputs:
Ci   a
Co Outputs:
Co   fx = f(x)
Co   if ir = -1, a copied into x
Cr Remarks
C ----------------------------------------------------------------------
C     implicit none
C Passed Parameters
      integer ir,iter,iprint
      double precision a,x,fx,f
      external f

      fx = f(a,1,ir)
      iter = iter+1
      if (ir .eq. -1) x = a
      if (iprint() .ge. 30) print 333, (ir.ne.-1),a,fx
  333 format(' MNBRAK:  found=',l1,'   x,f=',2f14.8)
      end
      SUBROUTINE MNBRAK(AX,BX,CX,FA,FB,FC,F,GLIMIT,MAXMIN,itmax,iter,IR)
C Given a function F and distinct initial points AX and CX, search
C attempt to bracket a minimum (MAXMIN=1) or a maximum (MAXMIN=-1),
C (uses minimum(-f(x)) is maximum(f(x)))
C or whatever extremum is in the direction of a root (MAXMIN=0).
C MAXMIN=0 is a special case that is used to help bracket a root.
C GLIMIT marks maximum range of search
C Adapted from p281 of 'Numerical Recipes'

C Returns:
C     ir=-# of iterations if CX falls outside brackets first, OR
C   case MAXMIN 1 or -1:
C     ir= # of iterations req'd to bracket extremum, OR
C   case MAXMIN 0:
C     ir= # of iterations req'd to bracket extremum or root

C     implicit none
      double precision gold,delmax,tiny
      PARAMETER (GOLD=1.61803398874990d0, DELMAX=10.d0, TINY=1.d-20)
      double precision AX,BX,CX,FA,FB,FC,F
      double precision DUM,Q,R,U,FU,ULIM
      INTEGER MAXMIN,LOCMXN,IR,itmax,iter
      double precision XLOW,XHIGH,GLIMIT
      external f
      iter = 0
      bx = cx

C A local copy of MAXMIN since MAXMIN needs to be preserved
      LOCMXN = MAXMIN
      IF ((LOCMXN .GT. 1) .OR. (LOCMXN .LT. -1)) LOCMXN = 1

C These are bounds delimiting the range of the search
      XLOW  = (BX+AX)/2 + (BX-AX)*GLIMIT
      XHIGH = (BX+AX)/2 - (BX-AX)*GLIMIT
      IF (XHIGH .LT. XLOW) THEN
        DUM = XHIGH
        XHIGH = XLOW
        XLOW = DUM
      ENDIF

      IR=0
C Compute initial points:
      call mnbrk2(ax,bx,fa,f,iter,ir)
      if (iter .eq. itmax .or. ir .eq. -1) return
      call mnbrk2(bx,bx,fb,f,iter,ir)
      if (iter .eq. itmax .or. ir .eq. -1) return
      CX = BX
      FC = FB
C Handle case LOCMXN=0:  search for extremum in direction of root
      IF (LOCMXN .EQ. 0) THEN
C Exit if FA and FC box root; else seek max if FA<0 or min if FA>0
        IF (dSIGN(FA,FA) .NE. dSIGN(FA,FC)) RETURN
        LOCMXN=1
        IF (FA .LT. 0) LOCMXN = -1
      ENDIF
      BX = AX + (CX-AX)/GOLD
      call mnbrk2(bx,bx,fb,f,iter,ir)
      if (iter .eq. itmax .or. ir .eq. -1) return

      FA = FA * LOCMXN
      FB = FB * LOCMXN
      FC = FC * LOCMXN

      IF (FC .GT. FA) THEN
        DUM=AX
        AX=CX
        CX=DUM
        DUM=FC
        FC=FA
        FA=DUM
      ENDIF

C Start of loop that continues until a minimum is bracketed
C or until bx falls outside range (XLOW,XHIGH)
C BX is always between AX and CX
1     CONTINUE
C      write(*,*) 'mnbrak ',ax,bx,cx,LOCMXN
C      write(*,*) 'mnbrak ',fa,fb,fc
C      pause

C check to see if search is outside bounds
      IF ((CX .GT. XHIGH) .OR. (CX .LT. XLOW)) THEN
        RETURN
      ENDIF

C check to see if convergence
      IF ( (FB .GE. FC) .AND.
     .     ( (MAXMIN .NE. 0) .OR.
     .       ( (dSIGN(FB,FB) .EQ. dSIGN(FB,FC)) .AND.
     .         (dSIGN(FB,FB) .EQ. dSIGN(FB,FA)))))   THEN
        R = (BX-AX)*(FB-FC)
        Q = (BX-CX)*(FB-FA)
C U is parabolic extrapolation to minimum
        U =BX-((BX-CX)*Q-(BX-AX)*R)/(2*dSIGN(dMAX1(dABS(Q-R),TINY),Q-R))
        ULIM=BX + DELMAX*(CX-BX)
C       write(*,*) 'u, ulim are ',u,ulim
C parabolic fit to minimum falls between BX and CX:
        IF ((BX-U)*(U-CX) .GT. 0.d0) THEN
C         write(*,*) 'U between BX and CX'
          call mnbrk2(u,bx,fu,f,iter,ir)
          if (iter .eq. itmax .or. ir .eq. -1) return
          FU = LOCMXN * FU
C if a minimum is found between BX and CX:
          IF (FU .LT. FC) THEN
            AX=BX
            FA=FB
            BX=U
            FB=FU
            GOTO 1
C if a minimum is found between U and AX
          ELSE IF (FU .GT. FB) THEN
            CX=U
            FC=FU
            GOTO 1
          ENDIF
C parabolic fit did no good.  Use default magnification
          U=CX+GOLD*(CX-BX)
          call mnbrk2(u,bx,fu,f,iter,ir)
          if (iter .eq. itmax .or. ir .eq. -1) return
          FU=LOCMXN * FU
C
C parabolic fit is between AX and BX:
        ELSE IF ((AX-U)*(U-BX) .GT. 0.d0) THEN
          call mnbrk2(u,bx,fu,f,iter,ir)
          if (iter .eq. itmax .or. ir .eq. -1) return
          fu = locmxn * fu
C         write(*,*) 'U between AX and BX ',FU
C if a minimum is found between AX and BX:
          IF (FU .LT. FB) THEN
            CX=BX
            FC=FB
            BX=U
            FB=FU
            GOTO 1
          ENDIF
C parabolic fit did no good.  Use default magnification
          U=CX+GOLD*(CX-BX)
          call mnbrk2(u,bx,fu,f,iter,ir)
          if (iter .eq. itmax .or. ir .eq. -1) return
          fu = locmxn * fu
C
C parabolic fit is between CX and allowed limit
        ELSE IF ((CX-U)*(U-ULIM) .GT. 0.d0) THEN
C       write(*,*) 'U between CX and allowed limit'
          call mnbrk2(u,bx,fu,f,iter,ir)
          if (iter .eq. itmax .or. ir .eq. -1) return
          fu = locmxn * fu
          IF (FU .LT. FC) THEN
            BX=CX
            CX=U
            U=CX+GOLD*(CX-BX)
            FB=FC
            FC=FU
            call mnbrk2(u,bx,fu,f,iter,ir)
            if (iter .eq. itmax .or. ir .eq. -1) return
            fu = locmxn * fu
          ENDIF

C Limit parabolic U to maximum allowed value
        ELSE IF ((U-ULIM)*(ULIM-CX) .GE. 0.d0) THEN
C      write(*,*) 'Limit parabolic U to maximum allowed value'
          U=ULIM
          call mnbrk2(u,bx,fu,f,iter,ir)
          if (iter .eq. itmax .or. ir .eq. -1) return
          fu = locmxn * fu

C Reject parabolic U; use default magnification
        ELSE
C      write(*,*) 'Use default magnification'
          U=CX+GOLD*(CX-BX)
          call mnbrk2(u,bx,fu,f,iter,ir)
          if (iter .eq. itmax .or. ir .eq. -1) return
          fu = locmxn * fu
        ENDIF

C Eliminate oldest point and continue
        AX=BX
        BX=CX
        CX=U
        FA=FB
        FB=FC
        FC=FU
        GOTO 1
      ENDIF
      FA = LOCMXN * FA
      FB = LOCMXN * FB
      FC = LOCMXN * FC
      RETURN
      END
      subroutine brent(ax,bx,cx,fa,fb,fc,f,maxmin,tol,eps,itmax,ir)
C- Locate a bracketed extremum or root
C ----------------------------------------------------------------------
Ci Inputs:
Ci   eps:  precision in x to which differences in f can be resolved
Ci   tol:  precision to which x is sought
Co Outputs:
Co   BX, AX, CX, estimated extremum and two points bracketing it
Co   FB, FA, FC, corresponding function values
Co   ir= # of function calls used to find min or root.
Co   ir=-1 means function call failed.
Co   ir=-2 means number of iterations exceeded itmax
Cr Remarks
Cr  Given a function F and distinct initial points AX BX and CX
Cr  with associated FA,FB and FC that bracket an extremum, locate
Cr  the extremum of function F within an error of approximately TOL.
Cr  It is necessary that an extremum be bracketed, ie that FB>FC and FA
Cr  (search for a maximum) or FB<FC and FA (search for a minimum)
Cr  This subroutine should only be called when an extremum is actually
Cr  bracketed; it is intended as a utility as part of BRENTM.
Cr  MAXMIN is a switch (used also by BRENTM and MNBRAK) that is used
Cr  to help find roots (crossing of the X axis) while searching for
Cr  an extremum.  When MAXMIN is zero, the routine will exit if
Cr  a zero crossing is found regardless of whether the algorithm has
Cr  converged to a root.
Cr  EPS is approximately machine precision times a number
Cr  representative of the scale of the X coordinate, estimated by B-A
Cr  Adapted from p281 of 'Numerical Recipes'
C ----------------------------------------------------------------------
C     implicit none
      integer maxmin,itmax,ir
      double precision ax,bx,cx,fa,fb,fc,f,tol,eps
      double precision a,b,v,w,x,e,fx,fv,fw,p,q,r,d,xm,tol1,tol2,u,
     .  fu,etemp,cgold
      parameter (cgold=1.d0-0.61803398874990d0)
      integer iter,iprint,maxit
      external f

C ... Return with error if root not bracketed
      if ((fa-fb)*maxmin .lt. 0 .or. (fc-fb)*maxmin .lt. 0 .or.
     .  (ax-bx)*(bx-cx) .lt. 0) call rx('BRENT: root not bracketed')

      maxit = itmax
      if (maxit .le. 0) maxit=99999

C ... A and B are replicas of AX and BX, in ascending order
      a  = dmin1(ax,cx)
      b  = dmax1(ax,cx)
      x  = bx
      fx = fb
      if (fa .lt. fc) then
        v  = cx
        fv = fc
        w  = ax
        fw = fa
      else
        v  = ax
        fv = fa
        w  = cx
        fw = fc
      endif
      if (ax .gt. cx) then
        fb = fa
        fa = fc
      else
        fb = fc
      endif

C ... D is the distance moved on the last step.
      d = 2*(b-a)
C ... E is the distance moved on the step before last.
      e = d

C --- Start of main loop ---
      do  11  iter = 1, maxit
        xm = (a+b)/2
        tol1 = tol*dabs(x) + eps
        tol2 = 2*tol1
C ...   Quit if done
        if ( (dabs(x-xm) .le. (tol2-(b-a)/2)) .or.
     .       (maxmin .eq. 0  .and.  dsign(fa,fa) .ne. dsign(fa,fx))
     .     ) goto 3

        if (dabs(e) .gt. tol1) then
          r = (x-w)*(fx-fv)
          q = (x-v)*(fx-fw)
          p = (x-v)*q - (x-w)*r
          q = 2*(q-r)
          if (q .gt. 0) p = -p
          q = dabs(q)
          etemp = e
          e = d
c ... Check for the acceptability of a parabolic fit:
          if (dabs(p) .ge. dabs(q*etemp/2) .or.
     .        p .le. q*(a-x) .or. p .ge. q*(b-x)) goto 1
C ... Fit is ok ...  take a parabolic step
          d = p/q
          u = x+d
          if (u-a .lt. tol2  .or.  b-u .lt. tol2) d = dsign(tol1,xm-x)
          goto 2
        endif
C ... Parabolic step not ok ... take golden-secs step in larger segment
    1   continue
        e = b-x
        if (x .ge. xm) e = a-x
        d = cgold*e
C ... Now D is computed from parabolic fit or golden sections step
    2   continue
        if (dabs(d) .gt. tol1) then
          u = x+d
        else
          u = x+dsign(tol1,d)
        endif
C ... Function evauation for this iteration: quit if ir returns -1
        fu = maxmin*f(u,1,ir)
        if (iprint() .ge. 30) print 333, (ir.ne.-1),u,fu/maxmin
  333   format(' BRENT:   found=',l1,'   x,f=',2f14.8)
        if (ir .eq. -1) then
          bx = u
          return
        endif
C ... Decide what to do with function evaluation
        if (fu .lt. fx) then
          if (u .ge. x) then
            a = x
            fa= fx
          else
            b = x
            fb= fx
          endif
          v  = w
          fv = fw
          w  = x
          fw = fx
          x  = u
          fx = fu
        else
          if (u .lt. x) then
            a = u
            fa= fu
          else
            b = u
            fb =fu
          endif
          if (fu .le. fw  .or.  w .eq. x) then
            v  = w
            fv = fw
            w  = u
            fw = fu
          else if (fu .le. fv  .or.  v .eq. x  .or.  v .eq. w) then
            v  = u
            fv = fu
          endif
        endif
        ir = iter
   11 continue
      ir = maxit+1
    3 continue
      ax = a
      cx = b
      bx = x
      fa = maxmin*fa
      fc = maxmin*fb
      fb = maxmin*fx
      end
