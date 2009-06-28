# Microsoft Developer Studio Generated NMAKE File, Based on maksym.dsp
!IF "$(CFG)" == ""
CFG=maksym - Win32 Debug
!MESSAGE No configuration specified. Defaulting to maksym - Win32 Debug.
!ENDIF 

!IF "$(CFG)" != "maksym - Win32 Release" && "$(CFG)" != "maksym - Win32 Debug"
!MESSAGE Invalid configuration "$(CFG)" specified.
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "maksym.mak" CFG="maksym - Win32 Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "maksym - Win32 Release" (based on "Win32 (x86) Console Application")
!MESSAGE "maksym - Win32 Debug" (based on "Win32 (x86) Console Application")
!MESSAGE 
!ERROR An invalid configuration is specified.
!ENDIF 

!IF "$(OS)" == "Windows_NT"
NULL=
!ELSE 
NULL=nul
!ENDIF 

F90=df.exe
RSC=rc.exe

!IF  "$(CFG)" == "maksym - Win32 Release"

OUTDIR=.\Release
INTDIR=.\Release
# Begin Custom Macros
OutDir=.\Release
# End Custom Macros

!IF "$(RECURSE)" == "0" 

ALL : "$(OUTDIR)\maksym.exe" "$(OUTDIR)\maksym.bsc"

!ELSE 

ALL : "$(OUTDIR)\maksym.exe" "$(OUTDIR)\maksym.bsc"

!ENDIF 

CLEAN :
	-@erase "$(INTDIR)\a2bin.obj"
	-@erase "$(INTDIR)\a2bin.sbr"
	-@erase "$(INTDIR)\a2vec.obj"
	-@erase "$(INTDIR)\a2vec.sbr"
	-@erase "$(INTDIR)\addbas.obj"
	-@erase "$(INTDIR)\addbas.sbr"
	-@erase "$(INTDIR)\alloc.obj"
	-@erase "$(INTDIR)\alloc.sbr"
	-@erase "$(INTDIR)\asymop.obj"
	-@erase "$(INTDIR)\asymop.sbr"
	-@erase "$(INTDIR)\avwsr.obj"
	-@erase "$(INTDIR)\avwsr.sbr"
	-@erase "$(INTDIR)\awrite.obj"
	-@erase "$(INTDIR)\awrite.sbr"
	-@erase "$(INTDIR)\bin2a.obj"
	-@erase "$(INTDIR)\bin2a.sbr"
	-@erase "$(INTDIR)\bitand_xxx.obj"
	-@erase "$(INTDIR)\bitand_xxx.sbr"
	-@erase "$(INTDIR)\bitops.obj"
	-@erase "$(INTDIR)\bitops.sbr"
	-@erase "$(INTDIR)\chcase.obj"
	-@erase "$(INTDIR)\chcase.sbr"
	-@erase "$(INTDIR)\cross.obj"
	-@erase "$(INTDIR)\cross.sbr"
	-@erase "$(INTDIR)\dampy.obj"
	-@erase "$(INTDIR)\dampy.sbr"
	-@erase "$(INTDIR)\dasum.obj"
	-@erase "$(INTDIR)\dasum.sbr"
	-@erase "$(INTDIR)\daxpby.obj"
	-@erase "$(INTDIR)\daxpby.sbr"
	-@erase "$(INTDIR)\daxpy.obj"
	-@erase "$(INTDIR)\daxpy.sbr"
	-@erase "$(INTDIR)\dcopy.obj"
	-@erase "$(INTDIR)\dcopy.sbr"
	-@erase "$(INTDIR)\ddot.obj"
	-@erase "$(INTDIR)\ddot.sbr"
	-@erase "$(INTDIR)\derfc.obj"
	-@erase "$(INTDIR)\derfc.sbr"
	-@erase "$(INTDIR)\dgemm.obj"
	-@erase "$(INTDIR)\dgemm.sbr"
	-@erase "$(INTDIR)\dinv33.obj"
	-@erase "$(INTDIR)\dinv33.sbr"
	-@erase "$(INTDIR)\dlmn.obj"
	-@erase "$(INTDIR)\dlmn.sbr"
	-@erase "$(INTDIR)\dmadd.obj"
	-@erase "$(INTDIR)\dmadd.sbr"
	-@erase "$(INTDIR)\dmcpy.obj"
	-@erase "$(INTDIR)\dmcpy.sbr"
	-@erase "$(INTDIR)\dmpy.obj"
	-@erase "$(INTDIR)\dmpy.sbr"
	-@erase "$(INTDIR)\dmpyt.obj"
	-@erase "$(INTDIR)\dmpyt.sbr"
	-@erase "$(INTDIR)\dmsadd.obj"
	-@erase "$(INTDIR)\dmsadd.sbr"
	-@erase "$(INTDIR)\dmscop.obj"
	-@erase "$(INTDIR)\dmscop.sbr"
	-@erase "$(INTDIR)\dnrm2.obj"
	-@erase "$(INTDIR)\dnrm2.sbr"
	-@erase "$(INTDIR)\dpadd.obj"
	-@erase "$(INTDIR)\dpadd.sbr"
	-@erase "$(INTDIR)\dpcopy.obj"
	-@erase "$(INTDIR)\dpcopy.sbr"
	-@erase "$(INTDIR)\dpdump.obj"
	-@erase "$(INTDIR)\dpdump.sbr"
	-@erase "$(INTDIR)\dpscop.obj"
	-@erase "$(INTDIR)\dpscop.sbr"
	-@erase "$(INTDIR)\drr2.obj"
	-@erase "$(INTDIR)\drr2.sbr"
	-@erase "$(INTDIR)\dscal.obj"
	-@erase "$(INTDIR)\dscal.sbr"
	-@erase "$(INTDIR)\dvheap.obj"
	-@erase "$(INTDIR)\dvheap.sbr"
	-@erase "$(INTDIR)\dvshel.obj"
	-@erase "$(INTDIR)\dvshel.sbr"
	-@erase "$(INTDIR)\finits_xxx.obj"
	-@erase "$(INTDIR)\finits_xxx.sbr"
	-@erase "$(INTDIR)\fixpos.obj"
	-@erase "$(INTDIR)\fixpos.sbr"
	-@erase "$(INTDIR)\fopna_xxx.obj"
	-@erase "$(INTDIR)\fopna_xxx.sbr"
	-@erase "$(INTDIR)\gensym.obj"
	-@erase "$(INTDIR)\gensym.sbr"
	-@erase "$(INTDIR)\groupg.obj"
	-@erase "$(INTDIR)\groupg.sbr"
	-@erase "$(INTDIR)\grpfnd.obj"
	-@erase "$(INTDIR)\grpfnd.sbr"
	-@erase "$(INTDIR)\grpgen.obj"
	-@erase "$(INTDIR)\grpgen.sbr"
	-@erase "$(INTDIR)\grpop.obj"
	-@erase "$(INTDIR)\grpop.sbr"
	-@erase "$(INTDIR)\hunti.obj"
	-@erase "$(INTDIR)\hunti.sbr"
	-@erase "$(INTDIR)\i1mach.obj"
	-@erase "$(INTDIR)\i1mach.sbr"
	-@erase "$(INTDIR)\iclbas.obj"
	-@erase "$(INTDIR)\iclbas.sbr"
	-@erase "$(INTDIR)\icopy.obj"
	-@erase "$(INTDIR)\icopy.sbr"
	-@erase "$(INTDIR)\idamax.obj"
	-@erase "$(INTDIR)\idamax.sbr"
	-@erase "$(INTDIR)\ipdump.obj"
	-@erase "$(INTDIR)\ipdump.sbr"
	-@erase "$(INTDIR)\iprint.obj"
	-@erase "$(INTDIR)\iprint.sbr"
	-@erase "$(INTDIR)\isanrg.obj"
	-@erase "$(INTDIR)\isanrg.sbr"
	-@erase "$(INTDIR)\ishell.obj"
	-@erase "$(INTDIR)\ishell.sbr"
	-@erase "$(INTDIR)\isw.obj"
	-@erase "$(INTDIR)\isw.sbr"
	-@erase "$(INTDIR)\ivheap.obj"
	-@erase "$(INTDIR)\ivheap.sbr"
	-@erase "$(INTDIR)\ivshel.obj"
	-@erase "$(INTDIR)\ivshel.sbr"
	-@erase "$(INTDIR)\latlim.obj"
	-@erase "$(INTDIR)\latlim.sbr"
	-@erase "$(INTDIR)\lattdf.obj"
	-@erase "$(INTDIR)\lattdf.sbr"
	-@erase "$(INTDIR)\latvec.obj"
	-@erase "$(INTDIR)\latvec.sbr"
	-@erase "$(INTDIR)\lsame.obj"
	-@erase "$(INTDIR)\lsame.sbr"
	-@erase "$(INTDIR)\makrot.obj"
	-@erase "$(INTDIR)\makrot.sbr"
	-@erase "$(INTDIR)\maksym.obj"
	-@erase "$(INTDIR)\maksym.sbr"
	-@erase "$(INTDIR)\mxint.obj"
	-@erase "$(INTDIR)\mxint.sbr"
	-@erase "$(INTDIR)\nghbor.obj"
	-@erase "$(INTDIR)\nghbor.sbr"
	-@erase "$(INTDIR)\ovlchk.obj"
	-@erase "$(INTDIR)\ovlchk.sbr"
	-@erase "$(INTDIR)\pairc.obj"
	-@erase "$(INTDIR)\pairc.sbr"
	-@erase "$(INTDIR)\parsvc.obj"
	-@erase "$(INTDIR)\parsvc.sbr"
	-@erase "$(INTDIR)\pretty.obj"
	-@erase "$(INTDIR)\pretty.sbr"
	-@erase "$(INTDIR)\psymop.obj"
	-@erase "$(INTDIR)\psymop.sbr"
	-@erase "$(INTDIR)\ran1.obj"
	-@erase "$(INTDIR)\ran1.sbr"
	-@erase "$(INTDIR)\s8tor8.obj"
	-@erase "$(INTDIR)\s8tor8.sbr"
	-@erase "$(INTDIR)\shear.obj"
	-@erase "$(INTDIR)\shear.sbr"
	-@erase "$(INTDIR)\shorbz.obj"
	-@erase "$(INTDIR)\shorbz.sbr"
	-@erase "$(INTDIR)\shorps.obj"
	-@erase "$(INTDIR)\shorps.sbr"
	-@erase "$(INTDIR)\shoshl.obj"
	-@erase "$(INTDIR)\shoshl.sbr"
	-@erase "$(INTDIR)\siteid.obj"
	-@erase "$(INTDIR)\siteid.sbr"
	-@erase "$(INTDIR)\spcgrp.obj"
	-@erase "$(INTDIR)\spcgrp.sbr"
	-@erase "$(INTDIR)\strings.obj"
	-@erase "$(INTDIR)\strings.sbr"
	-@erase "$(INTDIR)\strip.obj"
	-@erase "$(INTDIR)\strip.sbr"
	-@erase "$(INTDIR)\symcry.obj"
	-@erase "$(INTDIR)\symcry.sbr"
	-@erase "$(INTDIR)\symlat.obj"
	-@erase "$(INTDIR)\symlat.sbr"
	-@erase "$(INTDIR)\symtbl.obj"
	-@erase "$(INTDIR)\symtbl.sbr"
	-@erase "$(INTDIR)\symvar.obj"
	-@erase "$(INTDIR)\symvar.sbr"
	-@erase "$(INTDIR)\trysop.obj"
	-@erase "$(INTDIR)\trysop.sbr"
	-@erase "$(INTDIR)\wordg.obj"
	-@erase "$(INTDIR)\wordg.sbr"
	-@erase "$(INTDIR)\words.obj"
	-@erase "$(INTDIR)\words.sbr"
	-@erase "$(INTDIR)\xerbla.obj"
	-@erase "$(INTDIR)\xerbla.sbr"
	-@erase "$(INTDIR)\xlgen.obj"
	-@erase "$(INTDIR)\xlgen.sbr"
	-@erase "$(INTDIR)\ywrm.obj"
	-@erase "$(INTDIR)\ywrm.sbr"
	-@erase "$(OUTDIR)\maksym.bsc"
	-@erase "$(OUTDIR)\maksym.exe"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

F90_PROJ=/browser:"Release/" /include:"$(INTDIR)\\" /compile_only /nologo\
 /warn:nofileopt /module:"Release/" /object:"Release/" 
F90_OBJS=.\Release/
BSC32=bscmake.exe
BSC32_FLAGS=/nologo /o"$(OUTDIR)\maksym.bsc" 
BSC32_SBRS= \
	"$(INTDIR)\a2bin.sbr" \
	"$(INTDIR)\a2vec.sbr" \
	"$(INTDIR)\addbas.sbr" \
	"$(INTDIR)\alloc.sbr" \
	"$(INTDIR)\asymop.sbr" \
	"$(INTDIR)\avwsr.sbr" \
	"$(INTDIR)\awrite.sbr" \
	"$(INTDIR)\bin2a.sbr" \
	"$(INTDIR)\bitand_xxx.sbr" \
	"$(INTDIR)\bitops.sbr" \
	"$(INTDIR)\chcase.sbr" \
	"$(INTDIR)\cross.sbr" \
	"$(INTDIR)\dampy.sbr" \
	"$(INTDIR)\dasum.sbr" \
	"$(INTDIR)\daxpby.sbr" \
	"$(INTDIR)\daxpy.sbr" \
	"$(INTDIR)\dcopy.sbr" \
	"$(INTDIR)\ddot.sbr" \
	"$(INTDIR)\derfc.sbr" \
	"$(INTDIR)\dgemm.sbr" \
	"$(INTDIR)\dinv33.sbr" \
	"$(INTDIR)\dlmn.sbr" \
	"$(INTDIR)\dmadd.sbr" \
	"$(INTDIR)\dmcpy.sbr" \
	"$(INTDIR)\dmpy.sbr" \
	"$(INTDIR)\dmpyt.sbr" \
	"$(INTDIR)\dmsadd.sbr" \
	"$(INTDIR)\dmscop.sbr" \
	"$(INTDIR)\dnrm2.sbr" \
	"$(INTDIR)\dpadd.sbr" \
	"$(INTDIR)\dpcopy.sbr" \
	"$(INTDIR)\dpdump.sbr" \
	"$(INTDIR)\dpscop.sbr" \
	"$(INTDIR)\drr2.sbr" \
	"$(INTDIR)\dscal.sbr" \
	"$(INTDIR)\dvheap.sbr" \
	"$(INTDIR)\dvshel.sbr" \
	"$(INTDIR)\finits_xxx.sbr" \
	"$(INTDIR)\fixpos.sbr" \
	"$(INTDIR)\fopna_xxx.sbr" \
	"$(INTDIR)\gensym.sbr" \
	"$(INTDIR)\groupg.sbr" \
	"$(INTDIR)\grpfnd.sbr" \
	"$(INTDIR)\grpgen.sbr" \
	"$(INTDIR)\grpop.sbr" \
	"$(INTDIR)\hunti.sbr" \
	"$(INTDIR)\i1mach.sbr" \
	"$(INTDIR)\iclbas.sbr" \
	"$(INTDIR)\icopy.sbr" \
	"$(INTDIR)\idamax.sbr" \
	"$(INTDIR)\ipdump.sbr" \
	"$(INTDIR)\iprint.sbr" \
	"$(INTDIR)\isanrg.sbr" \
	"$(INTDIR)\ishell.sbr" \
	"$(INTDIR)\isw.sbr" \
	"$(INTDIR)\ivheap.sbr" \
	"$(INTDIR)\ivshel.sbr" \
	"$(INTDIR)\latlim.sbr" \
	"$(INTDIR)\lattdf.sbr" \
	"$(INTDIR)\latvec.sbr" \
	"$(INTDIR)\lsame.sbr" \
	"$(INTDIR)\makrot.sbr" \
	"$(INTDIR)\maksym.sbr" \
	"$(INTDIR)\mxint.sbr" \
	"$(INTDIR)\nghbor.sbr" \
	"$(INTDIR)\ovlchk.sbr" \
	"$(INTDIR)\pairc.sbr" \
	"$(INTDIR)\parsvc.sbr" \
	"$(INTDIR)\pretty.sbr" \
	"$(INTDIR)\psymop.sbr" \
	"$(INTDIR)\ran1.sbr" \
	"$(INTDIR)\s8tor8.sbr" \
	"$(INTDIR)\shear.sbr" \
	"$(INTDIR)\shorbz.sbr" \
	"$(INTDIR)\shorps.sbr" \
	"$(INTDIR)\shoshl.sbr" \
	"$(INTDIR)\siteid.sbr" \
	"$(INTDIR)\spcgrp.sbr" \
	"$(INTDIR)\strings.sbr" \
	"$(INTDIR)\strip.sbr" \
	"$(INTDIR)\symcry.sbr" \
	"$(INTDIR)\symlat.sbr" \
	"$(INTDIR)\symtbl.sbr" \
	"$(INTDIR)\symvar.sbr" \
	"$(INTDIR)\trysop.sbr" \
	"$(INTDIR)\wordg.sbr" \
	"$(INTDIR)\words.sbr" \
	"$(INTDIR)\xerbla.sbr" \
	"$(INTDIR)\xlgen.sbr" \
	"$(INTDIR)\ywrm.sbr"

"$(OUTDIR)\maksym.bsc" : "$(OUTDIR)" $(BSC32_SBRS)
    $(BSC32) @<<
  $(BSC32_FLAGS) $(BSC32_SBRS)
<<

LINK32=link.exe
LINK32_FLAGS=kernel32.lib /nologo /subsystem:console /incremental:no\
 /pdb:"$(OUTDIR)\maksym.pdb" /machine:I386 /out:"$(OUTDIR)\maksym.exe" 
LINK32_OBJS= \
	"$(INTDIR)\a2bin.obj" \
	"$(INTDIR)\a2vec.obj" \
	"$(INTDIR)\addbas.obj" \
	"$(INTDIR)\alloc.obj" \
	"$(INTDIR)\asymop.obj" \
	"$(INTDIR)\avwsr.obj" \
	"$(INTDIR)\awrite.obj" \
	"$(INTDIR)\bin2a.obj" \
	"$(INTDIR)\bitand_xxx.obj" \
	"$(INTDIR)\bitops.obj" \
	"$(INTDIR)\chcase.obj" \
	"$(INTDIR)\cross.obj" \
	"$(INTDIR)\dampy.obj" \
	"$(INTDIR)\dasum.obj" \
	"$(INTDIR)\daxpby.obj" \
	"$(INTDIR)\daxpy.obj" \
	"$(INTDIR)\dcopy.obj" \
	"$(INTDIR)\ddot.obj" \
	"$(INTDIR)\derfc.obj" \
	"$(INTDIR)\dgemm.obj" \
	"$(INTDIR)\dinv33.obj" \
	"$(INTDIR)\dlmn.obj" \
	"$(INTDIR)\dmadd.obj" \
	"$(INTDIR)\dmcpy.obj" \
	"$(INTDIR)\dmpy.obj" \
	"$(INTDIR)\dmpyt.obj" \
	"$(INTDIR)\dmsadd.obj" \
	"$(INTDIR)\dmscop.obj" \
	"$(INTDIR)\dnrm2.obj" \
	"$(INTDIR)\dpadd.obj" \
	"$(INTDIR)\dpcopy.obj" \
	"$(INTDIR)\dpdump.obj" \
	"$(INTDIR)\dpscop.obj" \
	"$(INTDIR)\drr2.obj" \
	"$(INTDIR)\dscal.obj" \
	"$(INTDIR)\dvheap.obj" \
	"$(INTDIR)\dvshel.obj" \
	"$(INTDIR)\finits_xxx.obj" \
	"$(INTDIR)\fixpos.obj" \
	"$(INTDIR)\fopna_xxx.obj" \
	"$(INTDIR)\gensym.obj" \
	"$(INTDIR)\groupg.obj" \
	"$(INTDIR)\grpfnd.obj" \
	"$(INTDIR)\grpgen.obj" \
	"$(INTDIR)\grpop.obj" \
	"$(INTDIR)\hunti.obj" \
	"$(INTDIR)\i1mach.obj" \
	"$(INTDIR)\iclbas.obj" \
	"$(INTDIR)\icopy.obj" \
	"$(INTDIR)\idamax.obj" \
	"$(INTDIR)\ipdump.obj" \
	"$(INTDIR)\iprint.obj" \
	"$(INTDIR)\isanrg.obj" \
	"$(INTDIR)\ishell.obj" \
	"$(INTDIR)\isw.obj" \
	"$(INTDIR)\ivheap.obj" \
	"$(INTDIR)\ivshel.obj" \
	"$(INTDIR)\latlim.obj" \
	"$(INTDIR)\lattdf.obj" \
	"$(INTDIR)\latvec.obj" \
	"$(INTDIR)\lsame.obj" \
	"$(INTDIR)\makrot.obj" \
	"$(INTDIR)\maksym.obj" \
	"$(INTDIR)\mxint.obj" \
	"$(INTDIR)\nghbor.obj" \
	"$(INTDIR)\ovlchk.obj" \
	"$(INTDIR)\pairc.obj" \
	"$(INTDIR)\parsvc.obj" \
	"$(INTDIR)\pretty.obj" \
	"$(INTDIR)\psymop.obj" \
	"$(INTDIR)\ran1.obj" \
	"$(INTDIR)\s8tor8.obj" \
	"$(INTDIR)\shear.obj" \
	"$(INTDIR)\shorbz.obj" \
	"$(INTDIR)\shorps.obj" \
	"$(INTDIR)\shoshl.obj" \
	"$(INTDIR)\siteid.obj" \
	"$(INTDIR)\spcgrp.obj" \
	"$(INTDIR)\strings.obj" \
	"$(INTDIR)\strip.obj" \
	"$(INTDIR)\symcry.obj" \
	"$(INTDIR)\symlat.obj" \
	"$(INTDIR)\symtbl.obj" \
	"$(INTDIR)\symvar.obj" \
	"$(INTDIR)\trysop.obj" \
	"$(INTDIR)\wordg.obj" \
	"$(INTDIR)\words.obj" \
	"$(INTDIR)\xerbla.obj" \
	"$(INTDIR)\xlgen.obj" \
	"$(INTDIR)\ywrm.obj"

"$(OUTDIR)\maksym.exe" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ELSEIF  "$(CFG)" == "maksym - Win32 Debug"

OUTDIR=.\Debug
INTDIR=.\Debug
# Begin Custom Macros
OutDir=.\Debug
# End Custom Macros

!IF "$(RECURSE)" == "0" 

ALL : "$(OUTDIR)\maksym.exe" "$(OUTDIR)\DF50.PDB"

!ELSE 

ALL : "$(OUTDIR)\maksym.exe" "$(OUTDIR)\DF50.PDB"

!ENDIF 

CLEAN :
	-@erase "$(INTDIR)\a2bin.obj"
	-@erase "$(INTDIR)\a2vec.obj"
	-@erase "$(INTDIR)\addbas.obj"
	-@erase "$(INTDIR)\alloc.obj"
	-@erase "$(INTDIR)\asymop.obj"
	-@erase "$(INTDIR)\avwsr.obj"
	-@erase "$(INTDIR)\awrite.obj"
	-@erase "$(INTDIR)\bin2a.obj"
	-@erase "$(INTDIR)\bitand_xxx.obj"
	-@erase "$(INTDIR)\bitops.obj"
	-@erase "$(INTDIR)\chcase.obj"
	-@erase "$(INTDIR)\cross.obj"
	-@erase "$(INTDIR)\dampy.obj"
	-@erase "$(INTDIR)\dasum.obj"
	-@erase "$(INTDIR)\daxpby.obj"
	-@erase "$(INTDIR)\daxpy.obj"
	-@erase "$(INTDIR)\dcopy.obj"
	-@erase "$(INTDIR)\ddot.obj"
	-@erase "$(INTDIR)\derfc.obj"
	-@erase "$(INTDIR)\DF50.PDB"
	-@erase "$(INTDIR)\dgemm.obj"
	-@erase "$(INTDIR)\dinv33.obj"
	-@erase "$(INTDIR)\dlmn.obj"
	-@erase "$(INTDIR)\dmadd.obj"
	-@erase "$(INTDIR)\dmcpy.obj"
	-@erase "$(INTDIR)\dmpy.obj"
	-@erase "$(INTDIR)\dmpyt.obj"
	-@erase "$(INTDIR)\dmsadd.obj"
	-@erase "$(INTDIR)\dmscop.obj"
	-@erase "$(INTDIR)\dnrm2.obj"
	-@erase "$(INTDIR)\dpadd.obj"
	-@erase "$(INTDIR)\dpcopy.obj"
	-@erase "$(INTDIR)\dpdump.obj"
	-@erase "$(INTDIR)\dpscop.obj"
	-@erase "$(INTDIR)\drr2.obj"
	-@erase "$(INTDIR)\dscal.obj"
	-@erase "$(INTDIR)\dvheap.obj"
	-@erase "$(INTDIR)\dvshel.obj"
	-@erase "$(INTDIR)\finits_xxx.obj"
	-@erase "$(INTDIR)\fixpos.obj"
	-@erase "$(INTDIR)\fopna_xxx.obj"
	-@erase "$(INTDIR)\gensym.obj"
	-@erase "$(INTDIR)\groupg.obj"
	-@erase "$(INTDIR)\grpfnd.obj"
	-@erase "$(INTDIR)\grpgen.obj"
	-@erase "$(INTDIR)\grpop.obj"
	-@erase "$(INTDIR)\hunti.obj"
	-@erase "$(INTDIR)\i1mach.obj"
	-@erase "$(INTDIR)\iclbas.obj"
	-@erase "$(INTDIR)\icopy.obj"
	-@erase "$(INTDIR)\idamax.obj"
	-@erase "$(INTDIR)\ipdump.obj"
	-@erase "$(INTDIR)\iprint.obj"
	-@erase "$(INTDIR)\isanrg.obj"
	-@erase "$(INTDIR)\ishell.obj"
	-@erase "$(INTDIR)\isw.obj"
	-@erase "$(INTDIR)\ivheap.obj"
	-@erase "$(INTDIR)\ivshel.obj"
	-@erase "$(INTDIR)\latlim.obj"
	-@erase "$(INTDIR)\lattdf.obj"
	-@erase "$(INTDIR)\latvec.obj"
	-@erase "$(INTDIR)\lsame.obj"
	-@erase "$(INTDIR)\makrot.obj"
	-@erase "$(INTDIR)\maksym.obj"
	-@erase "$(INTDIR)\mxint.obj"
	-@erase "$(INTDIR)\nghbor.obj"
	-@erase "$(INTDIR)\ovlchk.obj"
	-@erase "$(INTDIR)\pairc.obj"
	-@erase "$(INTDIR)\parsvc.obj"
	-@erase "$(INTDIR)\pretty.obj"
	-@erase "$(INTDIR)\psymop.obj"
	-@erase "$(INTDIR)\ran1.obj"
	-@erase "$(INTDIR)\s8tor8.obj"
	-@erase "$(INTDIR)\shear.obj"
	-@erase "$(INTDIR)\shorbz.obj"
	-@erase "$(INTDIR)\shorps.obj"
	-@erase "$(INTDIR)\shoshl.obj"
	-@erase "$(INTDIR)\siteid.obj"
	-@erase "$(INTDIR)\spcgrp.obj"
	-@erase "$(INTDIR)\strings.obj"
	-@erase "$(INTDIR)\strip.obj"
	-@erase "$(INTDIR)\symcry.obj"
	-@erase "$(INTDIR)\symlat.obj"
	-@erase "$(INTDIR)\symtbl.obj"
	-@erase "$(INTDIR)\symvar.obj"
	-@erase "$(INTDIR)\trysop.obj"
	-@erase "$(INTDIR)\wordg.obj"
	-@erase "$(INTDIR)\words.obj"
	-@erase "$(INTDIR)\xerbla.obj"
	-@erase "$(INTDIR)\xlgen.obj"
	-@erase "$(INTDIR)\ywrm.obj"
	-@erase "$(OUTDIR)\maksym.exe"
	-@erase "$(OUTDIR)\maksym.ilk"
	-@erase "$(OUTDIR)\maksym.pdb"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

F90_PROJ=/include:"$(INTDIR)\\" /compile_only /nologo /debug:full /optimize:0\
 /warn:nofileopt /module:"Debug/" /object:"Debug/" /pdbfile:"Debug/DF50.PDB" 
F90_OBJS=.\Debug/
BSC32=bscmake.exe
BSC32_FLAGS=/nologo /o"$(OUTDIR)\maksym.bsc" 
BSC32_SBRS= \
	
LINK32=link.exe
LINK32_FLAGS=kernel32.lib /nologo /subsystem:console /incremental:yes\
 /pdb:"$(OUTDIR)\maksym.pdb" /debug /machine:I386 /out:"$(OUTDIR)\maksym.exe"\
 /pdbtype:sept 
LINK32_OBJS= \
	"$(INTDIR)\a2bin.obj" \
	"$(INTDIR)\a2vec.obj" \
	"$(INTDIR)\addbas.obj" \
	"$(INTDIR)\alloc.obj" \
	"$(INTDIR)\asymop.obj" \
	"$(INTDIR)\avwsr.obj" \
	"$(INTDIR)\awrite.obj" \
	"$(INTDIR)\bin2a.obj" \
	"$(INTDIR)\bitand_xxx.obj" \
	"$(INTDIR)\bitops.obj" \
	"$(INTDIR)\chcase.obj" \
	"$(INTDIR)\cross.obj" \
	"$(INTDIR)\dampy.obj" \
	"$(INTDIR)\dasum.obj" \
	"$(INTDIR)\daxpby.obj" \
	"$(INTDIR)\daxpy.obj" \
	"$(INTDIR)\dcopy.obj" \
	"$(INTDIR)\ddot.obj" \
	"$(INTDIR)\derfc.obj" \
	"$(INTDIR)\dgemm.obj" \
	"$(INTDIR)\dinv33.obj" \
	"$(INTDIR)\dlmn.obj" \
	"$(INTDIR)\dmadd.obj" \
	"$(INTDIR)\dmcpy.obj" \
	"$(INTDIR)\dmpy.obj" \
	"$(INTDIR)\dmpyt.obj" \
	"$(INTDIR)\dmsadd.obj" \
	"$(INTDIR)\dmscop.obj" \
	"$(INTDIR)\dnrm2.obj" \
	"$(INTDIR)\dpadd.obj" \
	"$(INTDIR)\dpcopy.obj" \
	"$(INTDIR)\dpdump.obj" \
	"$(INTDIR)\dpscop.obj" \
	"$(INTDIR)\drr2.obj" \
	"$(INTDIR)\dscal.obj" \
	"$(INTDIR)\dvheap.obj" \
	"$(INTDIR)\dvshel.obj" \
	"$(INTDIR)\finits_xxx.obj" \
	"$(INTDIR)\fixpos.obj" \
	"$(INTDIR)\fopna_xxx.obj" \
	"$(INTDIR)\gensym.obj" \
	"$(INTDIR)\groupg.obj" \
	"$(INTDIR)\grpfnd.obj" \
	"$(INTDIR)\grpgen.obj" \
	"$(INTDIR)\grpop.obj" \
	"$(INTDIR)\hunti.obj" \
	"$(INTDIR)\i1mach.obj" \
	"$(INTDIR)\iclbas.obj" \
	"$(INTDIR)\icopy.obj" \
	"$(INTDIR)\idamax.obj" \
	"$(INTDIR)\ipdump.obj" \
	"$(INTDIR)\iprint.obj" \
	"$(INTDIR)\isanrg.obj" \
	"$(INTDIR)\ishell.obj" \
	"$(INTDIR)\isw.obj" \
	"$(INTDIR)\ivheap.obj" \
	"$(INTDIR)\ivshel.obj" \
	"$(INTDIR)\latlim.obj" \
	"$(INTDIR)\lattdf.obj" \
	"$(INTDIR)\latvec.obj" \
	"$(INTDIR)\lsame.obj" \
	"$(INTDIR)\makrot.obj" \
	"$(INTDIR)\maksym.obj" \
	"$(INTDIR)\mxint.obj" \
	"$(INTDIR)\nghbor.obj" \
	"$(INTDIR)\ovlchk.obj" \
	"$(INTDIR)\pairc.obj" \
	"$(INTDIR)\parsvc.obj" \
	"$(INTDIR)\pretty.obj" \
	"$(INTDIR)\psymop.obj" \
	"$(INTDIR)\ran1.obj" \
	"$(INTDIR)\s8tor8.obj" \
	"$(INTDIR)\shear.obj" \
	"$(INTDIR)\shorbz.obj" \
	"$(INTDIR)\shorps.obj" \
	"$(INTDIR)\shoshl.obj" \
	"$(INTDIR)\siteid.obj" \
	"$(INTDIR)\spcgrp.obj" \
	"$(INTDIR)\strings.obj" \
	"$(INTDIR)\strip.obj" \
	"$(INTDIR)\symcry.obj" \
	"$(INTDIR)\symlat.obj" \
	"$(INTDIR)\symtbl.obj" \
	"$(INTDIR)\symvar.obj" \
	"$(INTDIR)\trysop.obj" \
	"$(INTDIR)\wordg.obj" \
	"$(INTDIR)\words.obj" \
	"$(INTDIR)\xerbla.obj" \
	"$(INTDIR)\xlgen.obj" \
	"$(INTDIR)\ywrm.obj"

"$(OUTDIR)\maksym.exe" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ENDIF 

.for{$(F90_OBJS)}.obj:
   $(F90) $(F90_PROJ) $<  

.f{$(F90_OBJS)}.obj:
   $(F90) $(F90_PROJ) $<  

.f90{$(F90_OBJS)}.obj:
   $(F90) $(F90_PROJ) $<  

.fpp{$(F90_OBJS)}.obj:
   $(F90) $(F90_PROJ) $<  


!IF "$(CFG)" == "maksym - Win32 Release" || "$(CFG)" == "maksym - Win32 Debug"
SOURCE=.\slatsm\a2bin.f

!IF  "$(CFG)" == "maksym - Win32 Release"


"$(INTDIR)\a2bin.obj"	"$(INTDIR)\a2bin.sbr" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ELSEIF  "$(CFG)" == "maksym - Win32 Debug"


"$(INTDIR)\a2bin.obj" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ENDIF 

SOURCE=.\slatsm\a2vec.f

!IF  "$(CFG)" == "maksym - Win32 Release"


"$(INTDIR)\a2vec.obj"	"$(INTDIR)\a2vec.sbr" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ELSEIF  "$(CFG)" == "maksym - Win32 Debug"


"$(INTDIR)\a2vec.obj" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ENDIF 

SOURCE=.\slatsm\alloc.f

!IF  "$(CFG)" == "maksym - Win32 Release"


"$(INTDIR)\alloc.obj"	"$(INTDIR)\alloc.sbr" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ELSEIF  "$(CFG)" == "maksym - Win32 Debug"


"$(INTDIR)\alloc.obj" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ENDIF 

SOURCE=.\slatsm\awrite.f

!IF  "$(CFG)" == "maksym - Win32 Release"


"$(INTDIR)\awrite.obj"	"$(INTDIR)\awrite.sbr" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ELSEIF  "$(CFG)" == "maksym - Win32 Debug"


"$(INTDIR)\awrite.obj" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ENDIF 

SOURCE=.\slatsm\bin2a.f

!IF  "$(CFG)" == "maksym - Win32 Release"


"$(INTDIR)\bin2a.obj"	"$(INTDIR)\bin2a.sbr" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ELSEIF  "$(CFG)" == "maksym - Win32 Debug"


"$(INTDIR)\bin2a.obj" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ENDIF 

SOURCE=.\slatsm\bitops.f

!IF  "$(CFG)" == "maksym - Win32 Release"


"$(INTDIR)\bitops.obj"	"$(INTDIR)\bitops.sbr" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ELSEIF  "$(CFG)" == "maksym - Win32 Debug"


"$(INTDIR)\bitops.obj" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ENDIF 

SOURCE=.\slatsm\chcase.f

!IF  "$(CFG)" == "maksym - Win32 Release"


"$(INTDIR)\chcase.obj"	"$(INTDIR)\chcase.sbr" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ELSEIF  "$(CFG)" == "maksym - Win32 Debug"


"$(INTDIR)\chcase.obj" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ENDIF 

SOURCE=.\slatsm\cross.f

!IF  "$(CFG)" == "maksym - Win32 Release"


"$(INTDIR)\cross.obj"	"$(INTDIR)\cross.sbr" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ELSEIF  "$(CFG)" == "maksym - Win32 Debug"


"$(INTDIR)\cross.obj" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ENDIF 

SOURCE=.\slatsm\dampy.f

!IF  "$(CFG)" == "maksym - Win32 Release"


"$(INTDIR)\dampy.obj"	"$(INTDIR)\dampy.sbr" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ELSEIF  "$(CFG)" == "maksym - Win32 Debug"


"$(INTDIR)\dampy.obj" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ENDIF 

SOURCE=.\slatsm\dasum.f

!IF  "$(CFG)" == "maksym - Win32 Release"


"$(INTDIR)\dasum.obj"	"$(INTDIR)\dasum.sbr" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ELSEIF  "$(CFG)" == "maksym - Win32 Debug"


"$(INTDIR)\dasum.obj" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ENDIF 

SOURCE=.\slatsm\daxpby.f

!IF  "$(CFG)" == "maksym - Win32 Release"


"$(INTDIR)\daxpby.obj"	"$(INTDIR)\daxpby.sbr" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ELSEIF  "$(CFG)" == "maksym - Win32 Debug"


"$(INTDIR)\daxpby.obj" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ENDIF 

SOURCE=.\slatsm\daxpy.f

!IF  "$(CFG)" == "maksym - Win32 Release"


"$(INTDIR)\daxpy.obj"	"$(INTDIR)\daxpy.sbr" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ELSEIF  "$(CFG)" == "maksym - Win32 Debug"


"$(INTDIR)\daxpy.obj" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ENDIF 

SOURCE=.\slatsm\dcopy.f

!IF  "$(CFG)" == "maksym - Win32 Release"


"$(INTDIR)\dcopy.obj"	"$(INTDIR)\dcopy.sbr" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ELSEIF  "$(CFG)" == "maksym - Win32 Debug"


"$(INTDIR)\dcopy.obj" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ENDIF 

SOURCE=.\slatsm\ddot.f

!IF  "$(CFG)" == "maksym - Win32 Release"


"$(INTDIR)\ddot.obj"	"$(INTDIR)\ddot.sbr" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ELSEIF  "$(CFG)" == "maksym - Win32 Debug"


"$(INTDIR)\ddot.obj" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ENDIF 

SOURCE=.\slatsm\derfc.f

!IF  "$(CFG)" == "maksym - Win32 Release"


"$(INTDIR)\derfc.obj"	"$(INTDIR)\derfc.sbr" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ELSEIF  "$(CFG)" == "maksym - Win32 Debug"


"$(INTDIR)\derfc.obj" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ENDIF 

SOURCE=.\slatsm\dgemm.f

!IF  "$(CFG)" == "maksym - Win32 Release"


"$(INTDIR)\dgemm.obj"	"$(INTDIR)\dgemm.sbr" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ELSEIF  "$(CFG)" == "maksym - Win32 Debug"


"$(INTDIR)\dgemm.obj" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ENDIF 

SOURCE=.\slatsm\dinv33.f

!IF  "$(CFG)" == "maksym - Win32 Release"


"$(INTDIR)\dinv33.obj"	"$(INTDIR)\dinv33.sbr" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ELSEIF  "$(CFG)" == "maksym - Win32 Debug"


"$(INTDIR)\dinv33.obj" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ENDIF 

SOURCE=.\slatsm\dmadd.f

!IF  "$(CFG)" == "maksym - Win32 Release"


"$(INTDIR)\dmadd.obj"	"$(INTDIR)\dmadd.sbr" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ELSEIF  "$(CFG)" == "maksym - Win32 Debug"


"$(INTDIR)\dmadd.obj" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ENDIF 

SOURCE=.\slatsm\dmcpy.f

!IF  "$(CFG)" == "maksym - Win32 Release"


"$(INTDIR)\dmcpy.obj"	"$(INTDIR)\dmcpy.sbr" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ELSEIF  "$(CFG)" == "maksym - Win32 Debug"


"$(INTDIR)\dmcpy.obj" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ENDIF 

SOURCE=.\slatsm\dmpy.f

!IF  "$(CFG)" == "maksym - Win32 Release"


"$(INTDIR)\dmpy.obj"	"$(INTDIR)\dmpy.sbr" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ELSEIF  "$(CFG)" == "maksym - Win32 Debug"


"$(INTDIR)\dmpy.obj" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ENDIF 

SOURCE=.\slatsm\dmpyt.f

!IF  "$(CFG)" == "maksym - Win32 Release"


"$(INTDIR)\dmpyt.obj"	"$(INTDIR)\dmpyt.sbr" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ELSEIF  "$(CFG)" == "maksym - Win32 Debug"


"$(INTDIR)\dmpyt.obj" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ENDIF 

SOURCE=.\slatsm\dmsadd.f

!IF  "$(CFG)" == "maksym - Win32 Release"


"$(INTDIR)\dmsadd.obj"	"$(INTDIR)\dmsadd.sbr" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ELSEIF  "$(CFG)" == "maksym - Win32 Debug"


"$(INTDIR)\dmsadd.obj" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ENDIF 

SOURCE=.\slatsm\dmscop.f

!IF  "$(CFG)" == "maksym - Win32 Release"


"$(INTDIR)\dmscop.obj"	"$(INTDIR)\dmscop.sbr" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ELSEIF  "$(CFG)" == "maksym - Win32 Debug"


"$(INTDIR)\dmscop.obj" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ENDIF 

SOURCE=.\slatsm\dnrm2.f

!IF  "$(CFG)" == "maksym - Win32 Release"


"$(INTDIR)\dnrm2.obj"	"$(INTDIR)\dnrm2.sbr" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ELSEIF  "$(CFG)" == "maksym - Win32 Debug"


"$(INTDIR)\dnrm2.obj" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ENDIF 

SOURCE=.\slatsm\dpadd.f

!IF  "$(CFG)" == "maksym - Win32 Release"


"$(INTDIR)\dpadd.obj"	"$(INTDIR)\dpadd.sbr" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ELSEIF  "$(CFG)" == "maksym - Win32 Debug"


"$(INTDIR)\dpadd.obj" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ENDIF 

SOURCE=.\slatsm\dpcopy.f

!IF  "$(CFG)" == "maksym - Win32 Release"


"$(INTDIR)\dpcopy.obj"	"$(INTDIR)\dpcopy.sbr" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ELSEIF  "$(CFG)" == "maksym - Win32 Debug"


"$(INTDIR)\dpcopy.obj" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ENDIF 

SOURCE=.\slatsm\dpdump.f

!IF  "$(CFG)" == "maksym - Win32 Release"


"$(INTDIR)\dpdump.obj"	"$(INTDIR)\dpdump.sbr" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ELSEIF  "$(CFG)" == "maksym - Win32 Debug"


"$(INTDIR)\dpdump.obj" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ENDIF 

SOURCE=.\slatsm\dpscop.f

!IF  "$(CFG)" == "maksym - Win32 Release"


"$(INTDIR)\dpscop.obj"	"$(INTDIR)\dpscop.sbr" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ELSEIF  "$(CFG)" == "maksym - Win32 Debug"


"$(INTDIR)\dpscop.obj" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ENDIF 

SOURCE=.\slatsm\dscal.f

!IF  "$(CFG)" == "maksym - Win32 Release"


"$(INTDIR)\dscal.obj"	"$(INTDIR)\dscal.sbr" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ELSEIF  "$(CFG)" == "maksym - Win32 Debug"


"$(INTDIR)\dscal.obj" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ENDIF 

SOURCE=.\slatsm\dvheap.f

!IF  "$(CFG)" == "maksym - Win32 Release"


"$(INTDIR)\dvheap.obj"	"$(INTDIR)\dvheap.sbr" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ELSEIF  "$(CFG)" == "maksym - Win32 Debug"


"$(INTDIR)\dvheap.obj" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ENDIF 

SOURCE=.\slatsm\dvshel.f

!IF  "$(CFG)" == "maksym - Win32 Release"


"$(INTDIR)\dvshel.obj"	"$(INTDIR)\dvshel.sbr" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ELSEIF  "$(CFG)" == "maksym - Win32 Debug"


"$(INTDIR)\dvshel.obj" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ENDIF 

SOURCE=.\slatsm\hunti.f

!IF  "$(CFG)" == "maksym - Win32 Release"


"$(INTDIR)\hunti.obj"	"$(INTDIR)\hunti.sbr" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ELSEIF  "$(CFG)" == "maksym - Win32 Debug"


"$(INTDIR)\hunti.obj" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ENDIF 

SOURCE=.\slatsm\i1mach.f

!IF  "$(CFG)" == "maksym - Win32 Release"


"$(INTDIR)\i1mach.obj"	"$(INTDIR)\i1mach.sbr" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ELSEIF  "$(CFG)" == "maksym - Win32 Debug"


"$(INTDIR)\i1mach.obj" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ENDIF 

SOURCE=.\slatsm\icopy.f

!IF  "$(CFG)" == "maksym - Win32 Release"


"$(INTDIR)\icopy.obj"	"$(INTDIR)\icopy.sbr" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ELSEIF  "$(CFG)" == "maksym - Win32 Debug"


"$(INTDIR)\icopy.obj" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ENDIF 

SOURCE=.\slatsm\idamax.f

!IF  "$(CFG)" == "maksym - Win32 Release"


"$(INTDIR)\idamax.obj"	"$(INTDIR)\idamax.sbr" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ELSEIF  "$(CFG)" == "maksym - Win32 Debug"


"$(INTDIR)\idamax.obj" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ENDIF 

SOURCE=.\slatsm\ipdump.f

!IF  "$(CFG)" == "maksym - Win32 Release"


"$(INTDIR)\ipdump.obj"	"$(INTDIR)\ipdump.sbr" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ELSEIF  "$(CFG)" == "maksym - Win32 Debug"


"$(INTDIR)\ipdump.obj" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ENDIF 

SOURCE=.\slatsm\iprint.f

!IF  "$(CFG)" == "maksym - Win32 Release"


"$(INTDIR)\iprint.obj"	"$(INTDIR)\iprint.sbr" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ELSEIF  "$(CFG)" == "maksym - Win32 Debug"


"$(INTDIR)\iprint.obj" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ENDIF 

SOURCE=.\slatsm\isanrg.f

!IF  "$(CFG)" == "maksym - Win32 Release"


"$(INTDIR)\isanrg.obj"	"$(INTDIR)\isanrg.sbr" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ELSEIF  "$(CFG)" == "maksym - Win32 Debug"


"$(INTDIR)\isanrg.obj" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ENDIF 

SOURCE=.\slatsm\ishell.f

!IF  "$(CFG)" == "maksym - Win32 Release"


"$(INTDIR)\ishell.obj"	"$(INTDIR)\ishell.sbr" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ELSEIF  "$(CFG)" == "maksym - Win32 Debug"


"$(INTDIR)\ishell.obj" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ENDIF 

SOURCE=.\slatsm\isw.f

!IF  "$(CFG)" == "maksym - Win32 Release"


"$(INTDIR)\isw.obj"	"$(INTDIR)\isw.sbr" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ELSEIF  "$(CFG)" == "maksym - Win32 Debug"


"$(INTDIR)\isw.obj" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ENDIF 

SOURCE=.\slatsm\ivheap.f

!IF  "$(CFG)" == "maksym - Win32 Release"


"$(INTDIR)\ivheap.obj"	"$(INTDIR)\ivheap.sbr" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ELSEIF  "$(CFG)" == "maksym - Win32 Debug"


"$(INTDIR)\ivheap.obj" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ENDIF 

SOURCE=.\slatsm\ivshel.f

!IF  "$(CFG)" == "maksym - Win32 Release"


"$(INTDIR)\ivshel.obj"	"$(INTDIR)\ivshel.sbr" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ELSEIF  "$(CFG)" == "maksym - Win32 Debug"


"$(INTDIR)\ivshel.obj" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ENDIF 

SOURCE=.\slatsm\lsame.f

!IF  "$(CFG)" == "maksym - Win32 Release"


"$(INTDIR)\lsame.obj"	"$(INTDIR)\lsame.sbr" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ELSEIF  "$(CFG)" == "maksym - Win32 Debug"


"$(INTDIR)\lsame.obj" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ENDIF 

SOURCE=.\slatsm\mxint.f

!IF  "$(CFG)" == "maksym - Win32 Release"


"$(INTDIR)\mxint.obj"	"$(INTDIR)\mxint.sbr" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ELSEIF  "$(CFG)" == "maksym - Win32 Debug"


"$(INTDIR)\mxint.obj" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ENDIF 

SOURCE=.\slatsm\parsvc.f

!IF  "$(CFG)" == "maksym - Win32 Release"


"$(INTDIR)\parsvc.obj"	"$(INTDIR)\parsvc.sbr" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ELSEIF  "$(CFG)" == "maksym - Win32 Debug"


"$(INTDIR)\parsvc.obj" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ENDIF 

SOURCE=.\slatsm\pretty.f

!IF  "$(CFG)" == "maksym - Win32 Release"


"$(INTDIR)\pretty.obj"	"$(INTDIR)\pretty.sbr" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ELSEIF  "$(CFG)" == "maksym - Win32 Debug"


"$(INTDIR)\pretty.obj" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ENDIF 

SOURCE=.\slatsm\ran1.f

!IF  "$(CFG)" == "maksym - Win32 Release"


"$(INTDIR)\ran1.obj"	"$(INTDIR)\ran1.sbr" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ELSEIF  "$(CFG)" == "maksym - Win32 Debug"


"$(INTDIR)\ran1.obj" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ENDIF 

SOURCE=.\slatsm\s8tor8.f

!IF  "$(CFG)" == "maksym - Win32 Release"


"$(INTDIR)\s8tor8.obj"	"$(INTDIR)\s8tor8.sbr" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ELSEIF  "$(CFG)" == "maksym - Win32 Debug"


"$(INTDIR)\s8tor8.obj" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ENDIF 

SOURCE=.\slatsm\strings.f

!IF  "$(CFG)" == "maksym - Win32 Release"


"$(INTDIR)\strings.obj"	"$(INTDIR)\strings.sbr" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ELSEIF  "$(CFG)" == "maksym - Win32 Debug"


"$(INTDIR)\strings.obj" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ENDIF 

SOURCE=.\slatsm\strip.f

!IF  "$(CFG)" == "maksym - Win32 Release"


"$(INTDIR)\strip.obj"	"$(INTDIR)\strip.sbr" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ELSEIF  "$(CFG)" == "maksym - Win32 Debug"


"$(INTDIR)\strip.obj" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ENDIF 

SOURCE=.\slatsm\symvar.f

!IF  "$(CFG)" == "maksym - Win32 Release"


"$(INTDIR)\symvar.obj"	"$(INTDIR)\symvar.sbr" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ELSEIF  "$(CFG)" == "maksym - Win32 Debug"


"$(INTDIR)\symvar.obj" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ENDIF 

SOURCE=.\slatsm\wordg.f

!IF  "$(CFG)" == "maksym - Win32 Release"


"$(INTDIR)\wordg.obj"	"$(INTDIR)\wordg.sbr" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ELSEIF  "$(CFG)" == "maksym - Win32 Debug"


"$(INTDIR)\wordg.obj" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ENDIF 

SOURCE=.\slatsm\words.f

!IF  "$(CFG)" == "maksym - Win32 Release"


"$(INTDIR)\words.obj"	"$(INTDIR)\words.sbr" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ELSEIF  "$(CFG)" == "maksym - Win32 Debug"


"$(INTDIR)\words.obj" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ENDIF 

SOURCE=.\slatsm\xerbla.f

!IF  "$(CFG)" == "maksym - Win32 Release"


"$(INTDIR)\xerbla.obj"	"$(INTDIR)\xerbla.sbr" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ELSEIF  "$(CFG)" == "maksym - Win32 Debug"


"$(INTDIR)\xerbla.obj" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ENDIF 

SOURCE=.\slatsm\ywrm.f

!IF  "$(CFG)" == "maksym - Win32 Release"


"$(INTDIR)\ywrm.obj"	"$(INTDIR)\ywrm.sbr" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ELSEIF  "$(CFG)" == "maksym - Win32 Debug"


"$(INTDIR)\ywrm.obj" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ENDIF 

SOURCE=.\subs\addbas.f

!IF  "$(CFG)" == "maksym - Win32 Release"


"$(INTDIR)\addbas.obj"	"$(INTDIR)\addbas.sbr" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ELSEIF  "$(CFG)" == "maksym - Win32 Debug"


"$(INTDIR)\addbas.obj" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ENDIF 

SOURCE=.\subs\asymop.f

!IF  "$(CFG)" == "maksym - Win32 Release"


"$(INTDIR)\asymop.obj"	"$(INTDIR)\asymop.sbr" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ELSEIF  "$(CFG)" == "maksym - Win32 Debug"


"$(INTDIR)\asymop.obj" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ENDIF 

SOURCE=.\subs\avwsr.f

!IF  "$(CFG)" == "maksym - Win32 Release"


"$(INTDIR)\avwsr.obj"	"$(INTDIR)\avwsr.sbr" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ELSEIF  "$(CFG)" == "maksym - Win32 Debug"


"$(INTDIR)\avwsr.obj" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ENDIF 

SOURCE=.\subs\dlmn.f

!IF  "$(CFG)" == "maksym - Win32 Release"


"$(INTDIR)\dlmn.obj"	"$(INTDIR)\dlmn.sbr" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ELSEIF  "$(CFG)" == "maksym - Win32 Debug"


"$(INTDIR)\dlmn.obj" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ENDIF 

SOURCE=.\subs\drr2.f

!IF  "$(CFG)" == "maksym - Win32 Release"


"$(INTDIR)\drr2.obj"	"$(INTDIR)\drr2.sbr" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ELSEIF  "$(CFG)" == "maksym - Win32 Debug"


"$(INTDIR)\drr2.obj" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ENDIF 

SOURCE=.\subs\fixpos.f

!IF  "$(CFG)" == "maksym - Win32 Release"


"$(INTDIR)\fixpos.obj"	"$(INTDIR)\fixpos.sbr" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ELSEIF  "$(CFG)" == "maksym - Win32 Debug"


"$(INTDIR)\fixpos.obj" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ENDIF 

SOURCE=.\subs\grpfnd.f

!IF  "$(CFG)" == "maksym - Win32 Release"


"$(INTDIR)\grpfnd.obj"	"$(INTDIR)\grpfnd.sbr" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ELSEIF  "$(CFG)" == "maksym - Win32 Debug"


"$(INTDIR)\grpfnd.obj" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ENDIF 

SOURCE=.\subs\grpgen.f

!IF  "$(CFG)" == "maksym - Win32 Release"


"$(INTDIR)\grpgen.obj"	"$(INTDIR)\grpgen.sbr" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ELSEIF  "$(CFG)" == "maksym - Win32 Debug"


"$(INTDIR)\grpgen.obj" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ENDIF 

SOURCE=.\subs\grpop.f

!IF  "$(CFG)" == "maksym - Win32 Release"


"$(INTDIR)\grpop.obj"	"$(INTDIR)\grpop.sbr" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ELSEIF  "$(CFG)" == "maksym - Win32 Debug"


"$(INTDIR)\grpop.obj" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ENDIF 

SOURCE=.\subs\iclbas.f

!IF  "$(CFG)" == "maksym - Win32 Release"


"$(INTDIR)\iclbas.obj"	"$(INTDIR)\iclbas.sbr" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ELSEIF  "$(CFG)" == "maksym - Win32 Debug"


"$(INTDIR)\iclbas.obj" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ENDIF 

SOURCE=.\subs\latlim.f

!IF  "$(CFG)" == "maksym - Win32 Release"


"$(INTDIR)\latlim.obj"	"$(INTDIR)\latlim.sbr" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ELSEIF  "$(CFG)" == "maksym - Win32 Debug"


"$(INTDIR)\latlim.obj" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ENDIF 

SOURCE=.\subs\lattdf.f

!IF  "$(CFG)" == "maksym - Win32 Release"


"$(INTDIR)\lattdf.obj"	"$(INTDIR)\lattdf.sbr" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ELSEIF  "$(CFG)" == "maksym - Win32 Debug"


"$(INTDIR)\lattdf.obj" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ENDIF 

SOURCE=.\subs\latvec.f

!IF  "$(CFG)" == "maksym - Win32 Release"


"$(INTDIR)\latvec.obj"	"$(INTDIR)\latvec.sbr" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ELSEIF  "$(CFG)" == "maksym - Win32 Debug"


"$(INTDIR)\latvec.obj" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ENDIF 

SOURCE=.\subs\makrot.f

!IF  "$(CFG)" == "maksym - Win32 Release"


"$(INTDIR)\makrot.obj"	"$(INTDIR)\makrot.sbr" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ELSEIF  "$(CFG)" == "maksym - Win32 Debug"


"$(INTDIR)\makrot.obj" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ENDIF 

SOURCE=.\subs\nghbor.f

!IF  "$(CFG)" == "maksym - Win32 Release"


"$(INTDIR)\nghbor.obj"	"$(INTDIR)\nghbor.sbr" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ELSEIF  "$(CFG)" == "maksym - Win32 Debug"


"$(INTDIR)\nghbor.obj" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ENDIF 

SOURCE=.\subs\ovlchk.f

!IF  "$(CFG)" == "maksym - Win32 Release"


"$(INTDIR)\ovlchk.obj"	"$(INTDIR)\ovlchk.sbr" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ELSEIF  "$(CFG)" == "maksym - Win32 Debug"


"$(INTDIR)\ovlchk.obj" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ENDIF 

SOURCE=.\subs\pairc.f

!IF  "$(CFG)" == "maksym - Win32 Release"


"$(INTDIR)\pairc.obj"	"$(INTDIR)\pairc.sbr" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ELSEIF  "$(CFG)" == "maksym - Win32 Debug"


"$(INTDIR)\pairc.obj" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ENDIF 

SOURCE=.\subs\psymop.f

!IF  "$(CFG)" == "maksym - Win32 Release"


"$(INTDIR)\psymop.obj"	"$(INTDIR)\psymop.sbr" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ELSEIF  "$(CFG)" == "maksym - Win32 Debug"


"$(INTDIR)\psymop.obj" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ENDIF 

SOURCE=.\subs\shear.f

!IF  "$(CFG)" == "maksym - Win32 Release"


"$(INTDIR)\shear.obj"	"$(INTDIR)\shear.sbr" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ELSEIF  "$(CFG)" == "maksym - Win32 Debug"


"$(INTDIR)\shear.obj" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ENDIF 

SOURCE=.\subs\shorbz.f

!IF  "$(CFG)" == "maksym - Win32 Release"


"$(INTDIR)\shorbz.obj"	"$(INTDIR)\shorbz.sbr" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ELSEIF  "$(CFG)" == "maksym - Win32 Debug"


"$(INTDIR)\shorbz.obj" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ENDIF 

SOURCE=.\subs\shorps.f

!IF  "$(CFG)" == "maksym - Win32 Release"


"$(INTDIR)\shorps.obj"	"$(INTDIR)\shorps.sbr" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ELSEIF  "$(CFG)" == "maksym - Win32 Debug"


"$(INTDIR)\shorps.obj" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ENDIF 

SOURCE=.\subs\siteid.f

!IF  "$(CFG)" == "maksym - Win32 Release"


"$(INTDIR)\siteid.obj"	"$(INTDIR)\siteid.sbr" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ELSEIF  "$(CFG)" == "maksym - Win32 Debug"


"$(INTDIR)\siteid.obj" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ENDIF 

SOURCE=.\subs\spcgrp.f

!IF  "$(CFG)" == "maksym - Win32 Release"


"$(INTDIR)\spcgrp.obj"	"$(INTDIR)\spcgrp.sbr" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ELSEIF  "$(CFG)" == "maksym - Win32 Debug"


"$(INTDIR)\spcgrp.obj" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ENDIF 

SOURCE=.\subs\symcry.f

!IF  "$(CFG)" == "maksym - Win32 Release"


"$(INTDIR)\symcry.obj"	"$(INTDIR)\symcry.sbr" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ELSEIF  "$(CFG)" == "maksym - Win32 Debug"


"$(INTDIR)\symcry.obj" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ENDIF 

SOURCE=.\subs\symlat.f

!IF  "$(CFG)" == "maksym - Win32 Release"


"$(INTDIR)\symlat.obj"	"$(INTDIR)\symlat.sbr" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ELSEIF  "$(CFG)" == "maksym - Win32 Debug"


"$(INTDIR)\symlat.obj" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ENDIF 

SOURCE=.\subs\symtbl.f

!IF  "$(CFG)" == "maksym - Win32 Release"


"$(INTDIR)\symtbl.obj"	"$(INTDIR)\symtbl.sbr" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ELSEIF  "$(CFG)" == "maksym - Win32 Debug"


"$(INTDIR)\symtbl.obj" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ENDIF 

SOURCE=.\subs\trysop.f

!IF  "$(CFG)" == "maksym - Win32 Release"


"$(INTDIR)\trysop.obj"	"$(INTDIR)\trysop.sbr" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ELSEIF  "$(CFG)" == "maksym - Win32 Debug"


"$(INTDIR)\trysop.obj" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ENDIF 

SOURCE=.\subs\xlgen.f

!IF  "$(CFG)" == "maksym - Win32 Release"


"$(INTDIR)\xlgen.obj"	"$(INTDIR)\xlgen.sbr" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ELSEIF  "$(CFG)" == "maksym - Win32 Debug"


"$(INTDIR)\xlgen.obj" : $(SOURCE) "$(INTDIR)"
	$(F90) $(F90_PROJ) $(SOURCE)


!ENDIF 

SOURCE=.\bitand_xxx.f

!IF  "$(CFG)" == "maksym - Win32 Release"


"$(INTDIR)\bitand_xxx.obj"	"$(INTDIR)\bitand_xxx.sbr" : $(SOURCE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "maksym - Win32 Debug"


"$(INTDIR)\bitand_xxx.obj" : $(SOURCE) "$(INTDIR)"


!ENDIF 

SOURCE=.\finits_xxx.f

!IF  "$(CFG)" == "maksym - Win32 Release"


"$(INTDIR)\finits_xxx.obj"	"$(INTDIR)\finits_xxx.sbr" : $(SOURCE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "maksym - Win32 Debug"


"$(INTDIR)\finits_xxx.obj" : $(SOURCE) "$(INTDIR)"


!ENDIF 

SOURCE=.\fopna_xxx.f

!IF  "$(CFG)" == "maksym - Win32 Release"


"$(INTDIR)\fopna_xxx.obj"	"$(INTDIR)\fopna_xxx.sbr" : $(SOURCE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "maksym - Win32 Debug"


"$(INTDIR)\fopna_xxx.obj" : $(SOURCE) "$(INTDIR)"


!ENDIF 

SOURCE=.\gensym.f

!IF  "$(CFG)" == "maksym - Win32 Release"


"$(INTDIR)\gensym.obj"	"$(INTDIR)\gensym.sbr" : $(SOURCE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "maksym - Win32 Debug"


"$(INTDIR)\gensym.obj" : $(SOURCE) "$(INTDIR)"


!ENDIF 

SOURCE=.\groupg.f

!IF  "$(CFG)" == "maksym - Win32 Release"


"$(INTDIR)\groupg.obj"	"$(INTDIR)\groupg.sbr" : $(SOURCE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "maksym - Win32 Debug"


"$(INTDIR)\groupg.obj" : $(SOURCE) "$(INTDIR)"


!ENDIF 

SOURCE=.\maksym.f

!IF  "$(CFG)" == "maksym - Win32 Release"


"$(INTDIR)\maksym.obj"	"$(INTDIR)\maksym.sbr" : $(SOURCE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "maksym - Win32 Debug"


"$(INTDIR)\maksym.obj" : $(SOURCE) "$(INTDIR)"


!ENDIF 

SOURCE=.\shoshl.f

!IF  "$(CFG)" == "maksym - Win32 Release"


"$(INTDIR)\shoshl.obj"	"$(INTDIR)\shoshl.sbr" : $(SOURCE) "$(INTDIR)"


!ELSEIF  "$(CFG)" == "maksym - Win32 Debug"


"$(INTDIR)\shoshl.obj" : $(SOURCE) "$(INTDIR)"


!ENDIF 


!ENDIF 

