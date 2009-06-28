      subroutine finits(job,fcn,fcargs,iarg)
C- Machine and compiler-dependent inits for standard FORTRAN startup
C ----------------------------------------------------------------
Ci Inputs
Ci   job:  0, no command-line arguments; 
Ci         1, no switches (extens only);
Ci         2, [-vnam=val ...] [-pr#] [switches] extens;
Ci         3, call fcn for switches first
Ci   fcn,fcargs:  see Remarks
Co Outputs
Co   iarg: argument to extens, if found (0 if not)
Cr Remarks
Cr   finits parses command line arguments, ignoring args that
Cr   begin with "-", to find file extension.  When job=1,
Cr   switches -vnum are taken to be variable defs.
Cr   Calling prog can set own switches through external
Cr   fcn(iarg,fcargs).  fcn should return iarg as last arg parsed.
C ----------------------------------------------------------------
C     implicit none
C Passed parameters      
      integer job,iarg
      double precision fcargs(1)
      external fcn
C#ifdefC unix
C      logical lsequ,lext
C      integer i,fext,nargc,n,it(5),iv(5),a2vec
C      character strn*256
C      character*7 extns
C#endif

      call initqu(.false.)

C --- For Lahey F77L, open standard output as list-directed ---
C#ifdefC F77LAHEY
C      open(unit=*,carriage control='LIST')
C#endif

C --- Handle floating point exceptions in the IBM VM environment ---
C#ifdefC IBM_VM
C      call errset(208,999,-1)
C#endif

C --- Command line arguments and extension ---
      if (job .eq. 0) return
      iarg = 0
      if (job .eq. 3) call fcn(fcargs,iarg)
      lext = .false.
   10 iarg = iarg+1
      if (nargc() .gt. iarg) then
        call getarf(iarg,strn)
        extns = strn
        if (job .ge. 2) then
C     ... -pr encountered ... set verbosity
          if (lsequ(strn,'-pr',2,' ',n)) then
            i = 3
            n = a2vec(strn,len(strn),i,2,', ',2,2,5,it,iv)
            do  12  i = 1, n
   12       call sprt(i-1,iv(i))
          endif
C     ... v encountered ... parse variables
          if (lsequ(strn,'-v',2,' ',n)) then
            i = 2
            call parsyv(strn,len(strn),999,0,i)
C           call shosyv(0,0,0,i1mach(2))
          endif
        endif
        if (lsequ(strn,'-',1,' ',n)) goto 10
        if (.not. lext) then
          i = fext('.'//extns)
          lext = .true.
          goto 10
        endif
      endif
      iarg = iarg-1
      end

      subroutine fexit(retval,iopt,strng,args)
C- Machine and compiler-dependent program termination
C ----------------------------------------------------------------------
Ci Inputs
Ci   retval:  return value passed to operating system
Ci   iopt decomposed into 3 one-digit numbers.
Ci   digit
Ci     1:  0: do not print string on exit; 
Ci         9: print strng as Exit(retval): 'strng'
Ci      else: exit, using strn as a format statement and args a vector
Ci            of  c  double precision arguments
Ci    10:   0: do not print cpu time, else do
Ci   100:   0: do not print work array usage, else do
Co Outputs
Cr Remarks
C ----------------------------------------------------------------------
C     implicit none
C Passed parameters 
      integer retval,iopt
      character*(*) strng
      double precision args(1),arg2(1),arg3(1)
C Local parameters 
      integer fopn,fhndl,iprint,i,i2,getdig,i1mach,scrwid
      parameter (scrwid=80)
      double precision cpusec,tnew
      character*1 timeu
      character*256 strn, datim*26, hostname*20
      logical isopen

      goto 5
      entry fexit3(retval,iopt,strng,args,arg2,arg3)
      entry fexit2(retval,iopt,strng,args,arg2)

    5 continue
      i = getdig(iopt,0,10)
      if (i .ne. 0) then
        if (i .eq. 9) then
          strn = ' Exit %i '//strng
          call awrit1(strn,' ',scrwid,i1mach(2),retval)
C          print 345, retval, strng(1:min(len(strng),scrwid-9))
C  345     format(' Exit',i3,' ',a)
        else
          call awrit3(strng,strn,-scrwid,i1mach(2),args,arg2,arg3)
C         strn = strng
C         print strn, retval, (args(j), j=1,i)
        endif
      endif

      i = getdig(iopt,1,10)
      if (i .ne. 0 .and. iprint() .ge. 10 .and. cpusec() .ne. 0) then
        timeu = 's'
        tnew = cpusec()
        if (tnew .gt. 3600) then
          timeu = 'm'
          tnew = tnew/60
          if (tnew .gt. 200) then
            timeu = 'h'
            tnew = tnew/60
          endif
        endif

        datim = ' '
C#ifdefC SGI
C        call fdate(datim)
C#else
        call ftime(datim)
C#endif
        hostname = ' '
        call gtenv('HOST',hostname)
        call word(hostname,1,i,i2)
        i2 = max(i,i2)
        write(i1mach(2),10) tnew,timeu,datim,hostname(i:i2)
        if (fhndl('LOG') .ge. 0)  then
          if (isopen(fhndl('LOG'),.false.))
     .    write (fhndl('LOG'),10) tnew,timeu,datim,hostname(i:i2)
   10     format(' CPU time:', f9.3,a1,5x,a26,' on ',a)
        endif
      endif

      if (fhndl('TMP') .ge. 0) call dfclos(fopn('TMP'))
      if (getdig(iopt,2,10) .gt. 0) call wkinfo

C   11 call tclev(hostname,i)
C      if (i .ge. 0) then
C        call tcx(hostname)
C        goto 11
C      endif
      call tcprt(i1mach(2))

C#ifndef IBM_VM
      call closea
C#endif
C#ifdefC unix 
C      call cexit(retval,1)
C#endif
      stop
      end
      subroutine rx(string)
C- Error exit
C     implicit none
      character*(*) string

      call fexit(-1,119,string,0d0)
      end
      subroutine rx0(string)
C- Normal exit
C     implicit none
      character*(*) string

      call fexit(0,119,string,0d0)
      end
      subroutine rx1(string,arg)
C- Error exit, with a single argument
C     implicit none
      character*(*) string
      double precision arg
      character*120 outs
      outs = '%N Exit -1 '//string
      call fexit(-1,111,outs,arg)
      end
      subroutine rxi(string,arg)
C- Error exit, with a single integer at end
C     implicit none
      character*(*) string
      double precision arg
      character*120 outs
      outs = '%N Exit -1 '//string//' %i'
      call fexit(-1,111,outs,arg)
      end

      subroutine rxs(string,msg)
C- Error exit with extra string message
C     implicit none
      character*(*) string,msg
      character*120 outs
      integer i
      outs = string // msg
      call skpblb(outs,len(outs),i)
      call rx(outs(1:i+1))
      end
      subroutine rxs2(string,msg,msg2)
C- Error exit with extra string messages
C     implicit none
      character*(*) string,msg,msg2
      character*120 outs
      integer i
      outs = string // msg // msg2
      call skpblb(outs,len(outs),i)
      call rx(outs(1:i+1))
      end
      subroutine rxs4(string,msg,msg2,msg3,msg4)
C- Error exit with extra string messages
C     implicit none
      character*(*) string,msg,msg2,msg3,msg4
      character*120 outs
      integer i
      outs = string // msg // msg2 // msg3 // msg4
      call skpblb(outs,len(outs),i)
      call rx(outs(1:i+1))
      end
      subroutine rxx(test,string)
C- Test for error exit
C     implicit none
      logical test
      character*(*) string

      if (test) call rx(string)
      end

C#ifndef unix
      subroutine ftimex(datim)
      character*(*) datim
      datim = ' '
      end
C#endif
CC tests finits and fexit
C      subroutine fmain
CC      implicit none
C      integer iarg
C      double precision arg1(10)
C      external cmdarg
C
C      call finits(3,cmdarg,arg1,iarg)
CC     call fexit (-1,111,' Test fexit, one argument:%2:2;6d',arg1)
C      call fexit2(-1,111,' Test fexit, two args:%2:2;6d : %i',arg1,987)
C      end
C      subroutine cmdarg(cmargs,iarg)
CC- Command line arguments special to lmtoft
CC ----------------------------------------------------------------
CCi Inputs
CCi   cmargs(1,2): exi (if -e)
CCi         (3):   lmxf for getoro (i.e. n in -gn)
CCo Outputs
CCi   iarg
CCr Remarks
CC ----------------------------------------------------------------
CC      implicit none
CC Passed parameters
C      integer iarg
C      double precision cmargs(3)
CC Local variables
C      logical lsequ,a2bin
C      character strn*40
C      integer i,n,nargc
C
CC --- Command line arguments and extension ---
C      iarg = 0
C   10 iarg = iarg+1
C      if (nargc() .gt. iarg) then
C        call getarf(iarg,strn)
C        i = 2
C        if (lsequ(strn,'-v',i,' ',n)) call parsyv(strn,40,999,0,i)
C        if (lsequ(strn,'-e',i,' ',n)) then
C          iarg = iarg+2
C          if (nargc() .le. iarg) goto 99
C          call getarf(iarg-1,strn)
C          i = 0
C          if (.not. a2bin(strn,cmargs,4,0,' ',i,-1)) goto 99
C          call getarf(iarg,strn)
C          i = 0
C          if (.not. a2bin(strn,cmargs,4,1,' ',i,-1)) goto 99
C        endif
C        if (lsequ(strn,'-g',i,' ',n)) then
C          if (strn(3:3) .ne. ' ') then
C            i = 2
C            if (.not. a2bin(strn,cmargs,4,2,' ',i,-1)) goto 99
C          endif
C        endif
C        if (lsequ(strn,'-',1,' ',n)) goto 10
C      endif
C      iarg = iarg-1
C      return
C   99 call rx('error parsing switches')
C      end
