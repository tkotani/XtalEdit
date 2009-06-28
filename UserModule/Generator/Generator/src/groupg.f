      subroutine groupg(ng,g,ag,plat,ngen,gen,agen,gens)
C- Finds a set of generators for the symmetry group
C ----------------------------------------------------------------------
Ci Inputs:
Ci   plat  :primitive translation vectors in real space
Ci   qlat  :primitive translation vectors in reciprocal space
Ci   g:symmetry operation symbol
Ci   ng:number of symmetry operations as supplied by the generators
Co Outputs:
Co   gen,ngen:generators, and number needed to produce g
Cr Remarks:
Cr   The smallest set of generators is sought.
Cr   This subroutine performs the inverse function of sgroup.
C ----------------------------------------------------------------------
C     implicit none
C Passed parameters:
      integer ngen,ng
      double precision plat(3,3),vecx(3)
      double precision gen(9,*),agen(3,*),g(9,*),ag(3,*)
      character*(*) gens
C Local parameters:
      character*500 sg,sgx,sg1,sout,sout2
      double precision gloc(3,3,48),agloc(3,48),qlat(9),xx,vec(3)
      integer imax,isop,ngloc,nglocx,ngmax,iprint,lgunit,ngen0
      integer i1,i2,j1,j2

      real*8 vec1(3)
C --- Starting number of group ops ---
      call mkqlat(plat,qlat,xx)
      call pshprt(0)
      ngen0 = ngen
      call sgroup(gen,agen,ngen,gloc,agloc,nglocx,48,qlat)

   10 continue
C --- Do until enough generators added to make whole group ---
      if (nglocx .lt. ng) then
C   ... Run through all symops, choosing whichever adds the most ops
        imax = 0
        ngmax = 0
        do  12  isop = 1, ng
          call dcopy(9,g(1,isop),1,gen(1,ngen+1),1)
          call dcopy(3,ag(1,isop),1,agen(1,ngen+1),1)
          call sgroup(gen,agen,ngen+1,gloc,agloc,ngloc,48,qlat)
          if (ngloc .gt. ngmax) then
            imax = isop
            ngmax = ngloc
            nglocx = ngloc
          endif
   12   continue
        ngen = ngen+1
        call dcopy(9,g(1,imax),1,gen(1,ngen),1)
        call dcopy(3,ag(1,imax),1,agen(1,ngen),1)
        goto 10
      endif

      call poppr

C --- Printout ---
        ifx=98
        open(ifx,file="SYMOP.out")

c      if (iprint() .ge. 20)  then
        if (ngen0 .eq. 0) then
          print *, 'GROUPG: the following '//
     .    'are sufficient to generate the space group:'
        else
          call awrit2(' GROUPG: %i generator(s) were added to '
     .      //'complete the group%?#n#:',' ',80,lgunit(1),ngen-ngen0,
     .      ngen-ngen0)
        endif
        sout = ' '
        sout2 = ' '
        do  20  isop = 1, ngen
          call asymop(gen(1,isop),agen(1,isop),':',sg)
          call awrit0('%a '//sg,sout(9:),len(sout)-9,0)
          call dcopy(3,agen(1,isop),1,vec,1)
          call dgemm('N','N',1,3,3,1d0,agen(1,isop),1,qlat,3,0d0,vec,1)
          call asymop(gen(1,isop),vec,'::',sg1)
          call word(sg1,1,i1,i2)
          call shorbz(vec,vec,plat,qlat)
          call asymop(gen(1,isop),vec,'::',sg)
          call word(sg,1,j1,j2)
          if (i2-i1 .lt. j2-j1) sg = sg1
          call awrit0('%a '//sg,sout2(9:),len(sout2)-9,0)
   20   continue
c        if (ngen .gt. ngen0) then
c          call awrit0('%a',sout,len(sout),-lgunit(1))
          call awrit0('%a',sout2,len(sout2),-lgunit(1))
          call awrit0('%a',sout2,len(sout2),-ifx)
c        endif
        gens = sout2
c      endif
c
c      if (iprint() .ge. 20)  then
c        write(ifx,"('# lines are symbols ',
c     &   ' g(1:3,1) g(1:3,2) g(1:3,3) v(1:3)')") 

       write(6,*)'GROUPG: All space-group operations with point groups.' 
     &  //' See SYMOP.out:'
c        sout = ' '
        write(ifx,'(" ==============================",
     &        "=============================")')
        write(ifx,'(i5," operations! r_new= g r + ag "
     &  ," ! r and r_new are in Cartesian.")') ng
        do ix=1,ng,3
          sout2 = ' '
        do  33  isop = ix,min(ix+2,ng)
c          call asymop(g(1,isop),ag(1,isop),':',sg)
c          call awrit0('%a '//sg,sout(9:),len(sout)-9,0)
          call dcopy(3,ag(1,isop),1,vec,1)
          call dgemm('N','N',1,3,3,1d0,ag(1,isop),1,qlat,3,0d0,vec,1)
          call asymop(g(1,isop),vec,'::',sg1)
c          vec1 = vec
          call dcopy(3,vec,1,vec1,1)
          call word(sg1,1,i1,i2)
          call shorbz(vec,vec,plat,qlat)
          call asymop(g(1,isop),vec,'::',sg)
          call word(sg,1,j1,j2)
          if (i2-i1 .lt. j2-j1) then
            sg = sg1
c            vec= vec1
          call dcopy(3,vec1,1,vec,1)
          endif
c          vecx = matmul(plat,vec)  !Takao Dec.20. 2002
          call matm3(plat,vec,vecx) !for g77
c
          call asymop(g(1,isop),vecx,':',sgx)
          call wrtsymop(ifx,g(1,isop),vecx,sg,sgx)
          call awrit0('%a '//sg,sout2(9:),len(sout2)-9,0)
   33   continue
        call awrit0('%a',sout2,len(sout2),-lgunit(1))
        enddo
        close(ifx)
      end

      subroutine wrtsymop(ifx,g,vecx,sg,sgx)
      character*(*)  sg,sgx
      real*8 g(3,3),vecx(3)
      call setzero(g,9)
      call setzero(vecx,3)
      sumx = vecx(1)**2 + vecx(2)**2 + vecx(3)**2
      if(sumx.ne.0d0) then
        call word(sg,1,i1,i2)
        call word(sgx,1,i1x,i2x)
        write(ifx,"(' ',a,' = ',a)")sg(i1:i2),sgx(i1x:i2x)
      else  
        call word(sg,1,i1,i2)
        write(ifx,"(' ',a)")sg(i1:i2)
      endif

      write(ifx,"(3d24.15,'  !g(:,1)')") (g(ix,1),ix=1,3)
      write(ifx,"(3d24.15,'  !g(:,2)')") (g(ix,2),ix=1,3)
      write(ifx,"(3d24.15,'  !g(:,3)')") (g(ix,3),ix=1,3)
      write(ifx,"(3d24.15,'  !ag(:) ')") (vecx(ix),ix=1,3)
      write(ifx,*)
      end
      subroutine setzero(g,n)
      real*8 g(*)
      do i=1,n
        if(abs(g(i))<1d-8) g(i)=0d0
      enddo
      end
      subroutine matm3(a,v,w)
      implicit none
      integer ix,iy
      double precision a(3,3),v(3),w(3)
      do ix=1,3
        w(ix)=0
      do iy=1,3
        w(ix)=w(ix) + a(ix,iy)*v(iy)
      enddo
      enddo
      end
