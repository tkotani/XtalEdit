# Microsoft Developer Studio Project File - Name="maksym" - Package Owner=<4>
# Microsoft Developer Studio Generated Build File, Format Version 5.00
# ** DO NOT EDIT **

# TARGTYPE "Win32 (x86) Console Application" 0x0103

CFG=maksym - Win32 Debug
!MESSAGE This is not a valid makefile. To build this project using NMAKE,
!MESSAGE use the Export Makefile command and run
!MESSAGE 
!MESSAGE NMAKE /f "maksym.mak".
!MESSAGE 
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

# Begin Project
# PROP Scc_ProjName ""
# PROP Scc_LocalPath ""
F90=df.exe
RSC=rc.exe

!IF  "$(CFG)" == "maksym - Win32 Release"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 0
# PROP BASE Output_Dir "Release"
# PROP BASE Intermediate_Dir "Release"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 0
# PROP Output_Dir "Release"
# PROP Intermediate_Dir "Release"
# PROP Target_Dir ""
# ADD BASE F90 /include:"Release/" /compile_only /nologo /warn:nofileopt
# ADD F90 /browser /include:"Release/" /compile_only /nologo /warn:nofileopt
# ADD BASE RSC /l 0x411 /d "NDEBUG"
# ADD RSC /l 0x411 /d "NDEBUG"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LINK32=link.exe
# ADD BASE LINK32 kernel32.lib /nologo /subsystem:console /machine:I386
# ADD LINK32 kernel32.lib /nologo /subsystem:console /machine:I386

!ELSEIF  "$(CFG)" == "maksym - Win32 Debug"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 1
# PROP BASE Output_Dir "Debug"
# PROP BASE Intermediate_Dir "Debug"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 1
# PROP Output_Dir "Debug"
# PROP Intermediate_Dir "Debug"
# PROP Ignore_Export_Lib 0
# PROP Target_Dir ""
# ADD BASE F90 /include:"Debug/" /compile_only /nologo /debug:full /optimize:0 /warn:nofileopt
# ADD F90 /include:"Debug/" /compile_only /nologo /debug:full /optimize:0 /warn:nofileopt
# SUBTRACT F90 /warn:noalignments
# ADD BASE RSC /l 0x411 /d "_DEBUG"
# ADD RSC /l 0x411 /d "_DEBUG"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LINK32=link.exe
# ADD BASE LINK32 kernel32.lib /nologo /subsystem:console /debug /machine:I386 /pdbtype:sept
# ADD LINK32 kernel32.lib /nologo /subsystem:console /debug /machine:I386 /pdbtype:sept

!ENDIF 

# Begin Target

# Name "maksym - Win32 Release"
# Name "maksym - Win32 Debug"
# Begin Group "src"

# PROP Default_Filter ""
# Begin Group "slatsm"

# PROP Default_Filter ""
# Begin Source File

SOURCE=.\slatsm\a2bin.f
# End Source File
# Begin Source File

SOURCE=.\slatsm\a2vec.f
# End Source File
# Begin Source File

SOURCE=.\slatsm\alloc.f
# End Source File
# Begin Source File

SOURCE=.\slatsm\awrite.f
# End Source File
# Begin Source File

SOURCE=.\slatsm\bin2a.f
# End Source File
# Begin Source File

SOURCE=.\slatsm\bitops.f
# End Source File
# Begin Source File

SOURCE=.\slatsm\chcase.f
# End Source File
# Begin Source File

SOURCE=.\slatsm\cross.f
# End Source File
# Begin Source File

SOURCE=.\slatsm\dampy.f
# End Source File
# Begin Source File

SOURCE=.\slatsm\dasum.f
# End Source File
# Begin Source File

SOURCE=.\slatsm\daxpby.f
# End Source File
# Begin Source File

SOURCE=.\slatsm\daxpy.f
# End Source File
# Begin Source File

SOURCE=.\slatsm\dcopy.f
# End Source File
# Begin Source File

SOURCE=.\slatsm\ddot.f
# End Source File
# Begin Source File

SOURCE=.\slatsm\derfc.f
# End Source File
# Begin Source File

SOURCE=.\slatsm\dgemm.f
# End Source File
# Begin Source File

SOURCE=.\slatsm\dinv33.f
# End Source File
# Begin Source File

SOURCE=.\slatsm\dmadd.f
# End Source File
# Begin Source File

SOURCE=.\slatsm\dmcpy.f
# End Source File
# Begin Source File

SOURCE=.\slatsm\dmpy.f
# End Source File
# Begin Source File

SOURCE=.\slatsm\dmpyt.f
# End Source File
# Begin Source File

SOURCE=.\slatsm\dmsadd.f
# End Source File
# Begin Source File

SOURCE=.\slatsm\dmscop.f
# End Source File
# Begin Source File

SOURCE=.\slatsm\dnrm2.f
# End Source File
# Begin Source File

SOURCE=.\slatsm\dpadd.f
# End Source File
# Begin Source File

SOURCE=.\slatsm\dpcopy.f
# End Source File
# Begin Source File

SOURCE=.\slatsm\dpdump.f
# End Source File
# Begin Source File

SOURCE=.\slatsm\dpscop.f
# End Source File
# Begin Source File

SOURCE=.\slatsm\dscal.f
# End Source File
# Begin Source File

SOURCE=.\slatsm\dvheap.f
# End Source File
# Begin Source File

SOURCE=.\slatsm\dvshel.f
# End Source File
# Begin Source File

SOURCE=.\slatsm\hunti.f
# End Source File
# Begin Source File

SOURCE=.\slatsm\i1mach.f
# End Source File
# Begin Source File

SOURCE=.\slatsm\icopy.f
# End Source File
# Begin Source File

SOURCE=.\slatsm\idamax.f
# End Source File
# Begin Source File

SOURCE=.\slatsm\ipdump.f
# End Source File
# Begin Source File

SOURCE=.\slatsm\iprint.f
# End Source File
# Begin Source File

SOURCE=.\slatsm\isanrg.f
# End Source File
# Begin Source File

SOURCE=.\slatsm\ishell.f
# End Source File
# Begin Source File

SOURCE=.\slatsm\isw.f
# End Source File
# Begin Source File

SOURCE=.\slatsm\ivheap.f
# End Source File
# Begin Source File

SOURCE=.\slatsm\ivshel.f
# End Source File
# Begin Source File

SOURCE=.\slatsm\lsame.f
# End Source File
# Begin Source File

SOURCE=.\slatsm\mxint.f
# End Source File
# Begin Source File

SOURCE=.\slatsm\parsvc.f
# End Source File
# Begin Source File

SOURCE=.\slatsm\pretty.f
# End Source File
# Begin Source File

SOURCE=.\slatsm\ran1.f
# End Source File
# Begin Source File

SOURCE=.\slatsm\s8tor8.f
# End Source File
# Begin Source File

SOURCE=.\slatsm\strings.f
# End Source File
# Begin Source File

SOURCE=.\slatsm\strip.f
# End Source File
# Begin Source File

SOURCE=.\slatsm\symvar.f
# End Source File
# Begin Source File

SOURCE=.\slatsm\wordg.f
# End Source File
# Begin Source File

SOURCE=.\slatsm\words.f
# End Source File
# Begin Source File

SOURCE=.\slatsm\xerbla.f
# End Source File
# Begin Source File

SOURCE=.\slatsm\ywrm.f
# End Source File
# End Group
# Begin Group "subs"

# PROP Default_Filter ""
# Begin Source File

SOURCE=.\subs\addbas.f
# End Source File
# Begin Source File

SOURCE=.\subs\asymop.f
# End Source File
# Begin Source File

SOURCE=.\subs\avwsr.f
# End Source File
# Begin Source File

SOURCE=.\subs\dlmn.f
# End Source File
# Begin Source File

SOURCE=.\subs\drr2.f
# End Source File
# Begin Source File

SOURCE=.\subs\fixpos.f
# End Source File
# Begin Source File

SOURCE=.\subs\grpfnd.f
# End Source File
# Begin Source File

SOURCE=.\subs\grpgen.f
# End Source File
# Begin Source File

SOURCE=.\subs\grpop.f
# End Source File
# Begin Source File

SOURCE=.\subs\iclbas.f
# End Source File
# Begin Source File

SOURCE=.\subs\latlim.f
# End Source File
# Begin Source File

SOURCE=.\subs\lattdf.f
# End Source File
# Begin Source File

SOURCE=.\subs\latvec.f
# End Source File
# Begin Source File

SOURCE=.\subs\makrot.f
# End Source File
# Begin Source File

SOURCE=.\subs\nghbor.f
# End Source File
# Begin Source File

SOURCE=.\subs\ovlchk.f
# End Source File
# Begin Source File

SOURCE=.\subs\pairc.f
# End Source File
# Begin Source File

SOURCE=.\subs\psymop.f
# End Source File
# Begin Source File

SOURCE=.\subs\shear.f
# End Source File
# Begin Source File

SOURCE=.\subs\shorbz.f
# End Source File
# Begin Source File

SOURCE=.\subs\shorps.f
# End Source File
# Begin Source File

SOURCE=.\subs\siteid.f
# End Source File
# Begin Source File

SOURCE=.\subs\spcgrp.f
# End Source File
# Begin Source File

SOURCE=.\subs\symcry.f
# End Source File
# Begin Source File

SOURCE=.\subs\symlat.f
# End Source File
# Begin Source File

SOURCE=.\subs\symtbl.f
# End Source File
# Begin Source File

SOURCE=.\subs\trysop.f
# End Source File
# Begin Source File

SOURCE=.\subs\xlgen.f
# End Source File
# End Group
# End Group
# Begin Source File

SOURCE=.\bitand_xxx.f
# End Source File
# Begin Source File

SOURCE=.\finits_xxx.f
# End Source File
# Begin Source File

SOURCE=.\fopna_xxx.f
# End Source File
# Begin Source File

SOURCE=.\gensym.f
# End Source File
# Begin Source File

SOURCE=.\groupg.f
# End Source File
# Begin Source File

SOURCE=.\maksym.f
# End Source File
# Begin Source File

SOURCE=.\shoshl.f
# End Source File
# End Target
# End Project
