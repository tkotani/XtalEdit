      subroutine parchv(recrd,recl,mxchr,cex,sep,opts,nchr,ctbl,j)
C- Parses a string for one or more character variable declarations
C ----------------------------------------------------------------
Ci Inputs
Ci   recrd(0:*): string recrd is parsed from j to recl-1
Ci   opts:   0: var declaration of existing variable is supressed
Ci           1: var declaration of existing variable supersedes
Ci        10's digit:
Ci           1  variable's value is substituted for shell environment
Ci              variable of the same name
Ci   mxchr:  maximum size of character table
Ci   j:      parsing starts at char j (origin at 0)
Co Outputs
Co   j:      last character parsed
Cr Remarks
C ----------------------------------------------------------------
C     implicit none
C Passed parameters
      integer recl,nchr,j,mxchr,opts,ctlen
      parameter (ctlen=120)
      character*1 recrd(0:1),ctbl(mxchr,2)*(ctlen),sep*(*),cex*2
C Local parameters
      integer i,k,j0,jr,opt1,opt2
      character ctmp*1,strn*(ctlen)

      opt1 = mod(opts,10)
      opt2 = mod(opts/10,10)

C --- Parse for next declaration ---
    2 call skipbl(recrd,recl,j)
      if (j .ge. recl .or. nchr .ge. mxchr) return
      i = j
      call chrps2(recrd,sep,len(sep),recl,i,k)
      if (i .ge. recl) return
C      print *, (recrd(j0),j0=0,j)
C      print *, (recrd(j0),j0=0,i)
      ctmp = sep(k:k)
      i = i-j
      if (i .gt. ctlen) call fexit(-1,9,'parchv: name too long',0)
      call strcop(strn,recrd(j),i,ctmp,k)
      strn(i+1:i+1) = ' '
      call tokmat(strn,ctbl,nchr,ctlen,' ',i,k,.false.)
C ... Replace existing string definition
      if (i .ge. 0 .and. opt1 .eq. 1) then
        i = i+1
C ... Prior declaration of variable; ignore this declaration
      else if (i .ge. 0 .and. opt1 .eq. 0) then
        j = j+k
        call eostr(recrd,recl,11,' ',j)
C        call skipbl(recrd,recl,j)
C        call skp2bl(recrd,recl,j)
        goto 2
C ... Create new string definition
      else
        i = nchr+1
        ctbl(i,1) = ' '
        call strcop(ctbl(i,1),strn,ctlen,' ',k)
        nchr = i
      endif

C --- Copy variable contents into the table ---
      ctbl(i,2) = ' '
      j = j+k
      call skipbl(recrd,recl,j)
      if (j .ge. recl) return
      j0 = 1
      ctmp = recrd(j)
      if (ctmp .ne. '"') ctmp = ' '
      if (ctmp .eq. '"') j=j+1
      jr = j
      call chrpos(recrd,ctmp,recl,jr)

      call pvfil1(jr,ctlen,j,recrd,cex,nchr,mxchr,ctbl,j0,ctbl(i,2),0)
      if (ctmp .eq. '"') j=j+1
      if (opt2 .eq. 1) call gtenv(ctbl(i,2),ctbl(i,2))
      goto 2

      end
