      subroutine dvheap(m,n,vecs,iprm,tol,opts)
C- Heapsort array of double-precision vectors
C ----------------------------------------------------------------
Ci Inputs
Ci   m     :length of each vector
Ci   n     :number of vectors to be sorted
Ci   vecs  :the array vectors, dimensioned (m,n)
Ci   tol   :numbers differing by less than tol are treated as equal.
Ci   opts  :ones digit
Ci           0 vecs returned sorted.
Ci             NB: in this case, vecs must be dimensioned 2*m*n.
Ci           1 vecs is unchanged; only iprm is returned.
Ci          tens digit
Ci           0 vecs sorted
Ci           1 vecs sorted by increasing length
Ci
Co Outputs
Co   iprm  :a permutation table that sorts array 'vecs'
Co   vecs  : may be changed, depending on opts
C ----------------------------------------------------------------
C     implicit none
      integer m,n,iprm(n),opts
      double precision vecs(m,n),tol
      double precision di,dl
      integer l,ir,irra,i,j,mm
      logical norm

      do  2  ir = 1, n
    2 iprm(ir) = ir
      if (n .le. 1) return
      norm = mod(opts/10,10) .ne. 0
      l = n/2+1
      ir = n

C --- For each l = n/2+1, 1, -1 do ---
   10 continue
C ... "Hiring phase"
      if (l .gt. 1) then
        l = l-1
        irra = iprm(l)
C ... "Retirement-and-promotion phase"
      else
        irra = iprm(ir)
        iprm(ir) = iprm(1)
*       call awrit3('ir%i: %n:1i',' ',180,6,ir,n,iprm)
        ir = ir-1
        if (ir .eq. 1) then
          iprm(1) = irra
*         call awrit2('exit %n:1i',' ',180,6,n,iprm)
          goto 100
        endif
      endif

      i = l
      j = l+l

C --- Do while j .le. ir ---
   20 if (j .le. ir) then

C   ... Increment j if vecs(iprm(j+1)) > vecs(iprm(j))
        if (j .lt. ir) then
          if (norm) then
            di = 0d0
            dl = 0d0
            do  24  mm = 1, m
            dl = dl + vecs(mm,iprm(j))**2
   24       di = di + vecs(mm,iprm(j+1))**2
            dl = dsqrt(dl)
            di = dsqrt(di)
            if (abs(di-dl) .gt. tol) then
              if (di-dl .gt. tol) j = j+1
            endif
          else
            do  26  mm = 1, m
            if (abs(vecs(mm,iprm(j+1))-vecs(mm,iprm(j))) .le. tol)
     .          goto 26
            if (vecs(mm,iprm(j+1))-vecs(mm,iprm(j)) .gt. tol) j = j+1
            goto 28
   26       continue
   28       continue
          endif
        endif

C   ... Demote rra to its level
        if (norm) then
          di = 0d0
          dl = 0d0
          do  34  mm = 1, m
          dl = dl + vecs(mm,irra)**2
   34     di = di + vecs(mm,iprm(j))**2
          dl = dsqrt(dl)
          di = dsqrt(di)
          if (di-dl .gt. tol) then
            iprm(i) = iprm(j)
*           call awrit4('%i,%i: %n:1i',' ',180,6,i,j,n,iprm)
            i = j
            j = j+j
C     ... This is rra's level; set j to terminate the sift-down
          else
            j = ir+1
          endif
        else
          do  36  mm = 1, m
C     ...   Skip over equal elements
            if (abs(vecs(mm,iprm(j))-vecs(mm,irra)) .le. tol) goto 36
            if (vecs(mm,iprm(j))-vecs(mm,irra) .gt. tol) then
              iprm(i) = iprm(j)
*             call awrit4('%i,%i: %n:1i',' ',180,6,i,j,n,iprm)
              i = j
              j = j+j
C     ... This is rra's level; set j to terminate the sift-down
            else
              j = ir+1
            endif
            goto 38
   36     continue
C     ... Case rra = vec(iprm(j))
          j = ir+1
   38     continue
        endif
        go to 20
      endif
C ... Put rra into its slot
      iprm(i) = irra
*     call awrit3('%i: %n:1i',' ',180,6,i,n,iprm)
      go to 10

C --- Sort vecs ---
  100 continue
      if (mod(opts,10) .eq. 0)
     .  call dvprm(m,n,vecs,vecs(1,n+1),iprm,.true.)

      end
      subroutine dvprm(m,n,vecs,wk,iprm,lopt)
C- Permute an array of double precision vectors according to iprm
C ----------------------------------------------------------------
Ci Inputs
Ci   m     :length of each vector
Ci   n     :number of vectors to be sorted
Ci   vecs  :the array vectors, dimensioned (m,n)
Ci   iprm  :a permutation table by which array vecs is reordered
Ci   lopt  :if T, copy wk back to vecs.
Ci Inputs/Outputs
Co   wk    :returns vecs in permuted order
Co   vecs  :wk may be copied back into vecs, depending on lopt.
C ----------------------------------------------------------------
C     implicit none
      integer m,n,iprm(n)
      logical lopt
      double precision vecs(m,n),wk(m,n)
      integer i,j,k

      do  10  i = 1, n
        k = iprm(i)
        do  12  j = 1, m
   12   wk(j,i) = vecs(j,k)
   10 continue
      if (lopt) call dpcopy(wk,vecs,1,n*m,1d0)
      end
