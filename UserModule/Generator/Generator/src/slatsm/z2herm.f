      subroutine z2herm(uplo,lds,ns,s)
C- Copy upper (lower) triangle of a matrix to render it hermitian
Ci  uplo   'U' upper case of s is supplied
C     implicit none
      character*1 uplo
      integer lds,ns
      double precision s(2,lds,ns)
      integer i,j

      if (uplo .eq. 'U' .or. uplo .eq. 'u') then
        do  i = 1, ns
          do  j = 1, i
            s(1,i,j) =  s(1,j,i)
            s(2,i,j) = -s(2,j,i)
          enddo
          s(2,i,i) = 0d0
        enddo
      elseif (uplo .eq. 'L' .or. uplo .eq. 'l') then
        do  i = 1, ns
          do  j = 1, i
            s(1,j,i) =  s(1,i,j)
            s(2,j,i) = -s(2,i,j)
          enddo
          s(2,i,i) = 0d0
        enddo
      else
        call rxs('z2herm: bad argument uplo = ',uplo)
      endif
      end
