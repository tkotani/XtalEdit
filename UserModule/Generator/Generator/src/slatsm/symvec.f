      subroutine addsvv(nam,nelt,ival)
C- Add a symbolic vector to list
C ----------------------------------------------------------------
Ci Inputs
Ci   nam:  name of variable
Ci   nelt: number of elements of the vector
Co Outputs
Co   ival  index to which variable is declared or accessed
Cr Remarks
Cr   addsvv  adds a symbolic name and value to the internal table,
Cr           and allocates memory for the vector.
Cr   lodsvv  sets a range of elements of a vector associated with
Cr           a name or an index, depending on iopt.
Cr           iopt=0: index associated with name
Cr           iopt=1: name associated with index
Cr   getsvv  gets a range of elements of a vector associated with
Cr           a name or an index, depending on iopt.
Cr   sizsvv  returns the length of a vector associated with
Cr           a name or an index, depending on iopt.
Cr   numsvv  returns the number of variables now declared
Cr   watsvv  returns name associated with index
Cr   This implementation works only with fortran compilers allowing
Cr   pointers.
C ----------------------------------------------------------------
C     implicit none
C Passed parameters
      character*(*) nam
      double precision vec(1)
      integer ival,first,last,nelt,nvar,ifi,iopt
C Local parameters
      integer mxnam,namlen
      parameter (mxnam=24,namlen=16)
      character*(namlen) symnam(mxnam), tmpnam
      integer symptr(mxnam),size(mxnam)
      integer nnam,i,io,i1,i2,i2x
C#ifdefC POINTER
C      pointer (iarr, arr)
C#endif
      double precision arr(20),arr2(20)
      save symnam, symptr, size, nnam
      data nnam /0/

C --- Start of addsvv ---
      nnam = nnam+1
      if (nnam .gt. mxnam) call rx('addsvv: too many names')
      symnam(nnam) = nam
C#ifdefC unix
C      call locase(symnam(nnam))
C#endif
      ival = nnam
      call faloc(iarr,4,nelt)
      symptr(nnam) = iarr
      size(nnam) = nelt
      return

C --- lodsvv, getsvv ---
      entry lodsvv(nam,ival,iopt,i1,i2,vec)

      io = -1
      goto  10

      entry getsvv(nam,ival,iopt,i1,i2,vec)

      io = 1
      goto  10

      entry sizsvv(nam,ival,iopt,i1)

      io = -2
      goto  10

C --- lodsvv, getsvv ---
      entry numsvv(nvar)
      nvar = nnam
      return

C --- watsvv ---
      entry watsvv(nam,ival)
      nam = ' '
      if (ival .le. nnam) nam = symnam(ival)
      return

C --- Print out table ---
      entry shosvv(first,last,ifi)
      write(ifi,332)
  332 format('  Vec       Name            Size   Val[1..n]')
      do  60  i = max(first,1), min(last,nnam)
      iarr = symptr(i)
   60 write(ifi,333) i, symnam(i), size(i), arr(1), arr(size(i))
  333 format(i4, 4x, a20, i4, 2g14.5)
      return

C --- Find an index associated with a name ---
   10 continue
C ... If iopt=0, find the index associated with this name
      if (iopt .eq. 0) then
        ival = 0
C#ifndef POINTER
        return
C#endif
        tmpnam = nam
C#ifdefC unix
C        call locase(tmpnam)
C#endif
      do  16  i = 1, nnam
        if (tmpnam .ne. symnam(i)) goto 16
        ival = i
        goto 20
   16 continue
      endif

C --- Set/Retrieve portions of an array[index], depending on io ---
   20 continue
      if (io .eq. 0) return
      if (io .eq. -2) then
        i1 = size(ival)
        return
      endif

C ... Return unless ival in range
      if (ival .le. 0 .or. ival .gt. nnam) return
      iarr = symptr(ival)
      i2x = min(i2,size(ival))
      if (i2x .lt. i1) return
      if (io .eq. -1) call dpscop(vec,arr,i2x-i1+1,1,i1,1d0)
      if (io .eq.  1) call dpscop(arr,vec,i2x-i1+1,i1,1,1d0)
      return

      end
      subroutine parsvv(recrd,recl,indx,mxelt,i1,ip)
C- Parses a string for one or more elements of a vector variable
C     implicit none
C Passed parameters
      integer recl,ip,mxelt,indx,i1
      character recrd*(100)
C Local parameters
      double precision res
      integer nelt,i,k,ix,a2vec

      nelt = 0
      do  33  i = 1, 999
        call skipbl(recrd,recl,ip)
        if (ip .ge. recl .or. nelt .ge. mxelt) goto 99
        k = a2vec(recrd,recl,ip,4,' ',1,1,1,ix,res)
        if (k .eq. -1) return
        call lodsvv(' ',indx,1,i1+nelt,i1+nelt,res)
        nelt = nelt+k
   33 continue

   99 continue
      end
