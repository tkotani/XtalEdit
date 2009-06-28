      subroutine atsev(ic,nc,ves,nl,nsp,qnu,sevat,sevs)
C- Accumulates atom contribution to sumev and shift q*V(rmax)
C     implicit none
      integer ic,nc(0:1),nl,nsp,i
      double precision ves(0:1),qnu(3,nl*nsp,0:1),sevat,sevs(2),q

      q = 0
      do  10  i = 1, nl*nsp
   10 q = q + qnu(1,i,ic)
      sevs(1) = sevs(1) + sevat*nc(ic)
      sevs(2) = sevs(2) + q*ves(ic)*nc(ic)

      end


      
