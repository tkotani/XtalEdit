      subroutine slist(lstyle,strlst,slabl,z,nspec,nlist,list)
C- Generates a list of species from a string specification
C ----------------------------------------------------------------
Ci Inputs
Ci   lstyle: style of specification; see Remarks
Ci   strlst:  string specifying list of species
Ci   slabl :list of species labels
Ci   nspec :number of species.
Ci   z     :table nuclear charge by species
Co Outputs
Co   nlist :number of species in list
Co   list  :a list of species satisfying specifications
Cr Remarks
Cr *Syntax of strlst: depends on one of three styles (lstyle)
Cr
Cr *lstyle=1 : a list of integers; see mkilst.f for complete syntax.
Cr             Example: '1,4:6,11' generates a list of five numbers,
Cr             1,4,5,6,11.
Cr
Cr *lstyle=2 : the list is specified according to an expression.
Cr             The expression can involve the species index is and
Cr             atomic number z.  Any species satisfying expression is
Cr             included in the list.  Example:  'is<6&z==14'
Cr
Cr *lstyle=3 : strlst is a list of species by name; entries are
Cr           : separated by commas.  Each entry must be in slabl.
Cu Updates
Cu   13 Sep 01 adapted from clist
C ----------------------------------------------------------------
C     implicit none
C ... Passed parameters
      integer lstyle,nlist,nspec,list(1)
      character*(*) strlst
      character*8 slabl(nspec)
      double precision z(nspec)
C ... Local parameters
      integer iv0,ival,is,i,j,ls,oilst,j1,j2
      logical a2bin,sw
      character alabl*8
C ... Heap
      integer w(1)
      common /w/ w
C ... External calls
      external clrsyv,defi,hunti,ishell,lodsyv,mkils0,mkilst,numsyv,
     .         nwordg,rlse,rxi,rxs,tokmat

      ls = len(strlst)
      nlist = 0
C     call iinit(list,nspec)
      goto (10,20,30) lstyle
      call rxi('slist: bad style',lstyle)
      return

C -- lstyle=1 ---
   10 continue
      call mkils0(strlst,nlist,i)
      call defi(oilst, nlist)
      call mkilst(strlst,nlist,w(oilst))
      if (nlist .eq. 0) return
      call ishell(nlist,w(oilst))
      list(1) = w(oilst)
      j = 1
      do  i = 2, nlist
        if (w(oilst+i-1) .gt. list(j)
     .      .and. w(oilst+i-1) .le. nspec) then
          j = j+1
          list(j) = w(oilst+i-1)
        endif
      enddo
      nlist = j
      call rlse(oilst)
      return

C --- lstyle=2 ---
   20 continue
      call numsyv(iv0)
      nlist = 0
      do  42  is = 1, nspec
        call lodsyv('is',1,dble(is),ival)
        call lodsyv('z',1,z(is),ival)
        i = 0
        if (a2bin(strlst,sw,0,0,strlst(ls:ls),i,ls)) then
          if (sw) then
            nlist = nlist+1
            list(nlist) = is
          endif
C   ... Abort if a2bin can't parse expression
        else
          call rxs('slist: failed to parse',strlst)
        endif
   42 continue
      call clrsyv(iv0)
      return

C --- lstyle=3 ---
   30 continue
      nlist = 0
      j2 = -1
C ... Return here to parses next species
   31 continue
      j1 = j2+2
      call nwordg(strlst,1,', ',1,j1,j2)
      if (j1 .gt. j2) return
      alabl = strlst(j1:j2)
      call tokmat(alabl,slabl,nspec,8,' ',is,i,.false.)
      if (is .eq. -1 .or. is .ge. nspec)
     .  call rxs('slist: failed to parse species list ',strlst)
      is = is+1
      i = 0
      call hunti(list,nlist,is,0,i)
      if (i .ge. nlist .or. list(i+1) .ne. is) then
        nlist = nlist+1
        list(nlist) = is
        call ishell(nlist,list)        
      endif
C     print *, j1,j2,alabl,is,'   ',list(1:nlist)
      goto 31

      end
