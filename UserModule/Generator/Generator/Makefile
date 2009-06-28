# This is makefile for csym

# compaq tru64
#FC = f90
#FFLAGS =

# Linux Pentium. intel fortran
#FC = ifc
#FFLAGS = -tpp7 

FC =g77
FFLAGS = -w

LK = $(FC)
LKFLAGS1 =  
LKFLAGS2 = 


#----------------------------------------------
SUBS   = ./src/subs/
SLATSM = ./src/slatsm/
SRC0    = ./src/

# --- Make rules ---
.f.o:
	$(FC) $(FFLAGS) $*.f -c -o $*.o
#	etags $*.f -o $(tags)`echo $*.f| sed 's/..\///' | sed 's/\//-/g'`.tags

#.c.o:
#	$(CC) $(CFLAGS) $*.c -c -o $*.o

SRC = $(SRC0)maksym.o  $(SRC0)gensym.o  $(SRC0)groupg.o  \
      $(SRC0)shoshl.o  $(SRC0)finits_xxx.o $(SRC0)fopna_xxx.o \
      $(SRC0)bitand_xxx.o $(SRC0)addbas_t1.o  \
	$(SUBS)avwsr.o  \
	$(SUBS)symtbl.o  \
	$(SUBS)ovlchk.o \
	$(SUBS)shear.o  \
	$(SUBS)trysop.o  \
	$(SUBS)shortn.o  \
	$(SUBS)shorbz.o  \
	$(SUBS)shorps.o  \
	$(SUBS)siteid.o  \
	$(SUBS)xlgen.o  \
	$(SUBS)nghbor.o  \
	$(SUBS)dlmn.o  \
	$(SUBS)drr2.o  \
	$(SUBS)fixpos.o  \
	$(SUBS)grpfnd.o  \
	$(SUBS)grpgen.o  \
	$(SUBS)grpop.o  \
	$(SUBS)iclbas.o  \
	$(SUBS)latlim.o  \
	$(SUBS)lattdf.o  \
	$(SUBS)latvec.o  \
	$(SUBS)makrot.o  \
	$(SUBS)pairc.o  \
	$(SUBS)psymop.o  \
	$(SUBS)spcgrp.o  \
	$(SUBS)symcry.o  \
	$(SUBS)symlat.o  \
	$(SUBS)asymop.o  \
	$(SLATSM)a2bin.o \
	$(SLATSM)a2bina.o \
	$(SLATSM)a2vec.o \
	$(SLATSM)alloc.o \
	$(SLATSM)awrite.o \
	$(SLATSM)bin2a.o \
	$(SLATSM)bitops.o \
	$(SLATSM)chcase.o \
	$(SLATSM)cross.o \
	$(SLATSM)dampy.o \
	$(SLATSM)dasum.o \
	$(SLATSM)daxpby.o \
	$(SLATSM)daxpy.o \
	$(SLATSM)dcopy.o \
	$(SLATSM)ddot.o \
	$(SLATSM)derfc.o \
	$(SLATSM)dgemm.o \
	$(SLATSM)dinv33.o \
	$(SLATSM)dmadd.o \
	$(SLATSM)dmcpy.o \
	$(SLATSM)dmpy.o \
	$(SLATSM)dmpyt.o \
	$(SLATSM)dmsadd.o \
	$(SLATSM)dmscop.o \
	$(SLATSM)dnrm2.o \
	$(SLATSM)dpadd.o \
	$(SLATSM)dpcopy.o \
	$(SLATSM)dpdump.o \
	$(SLATSM)dpscop.o \
	$(SLATSM)dscal.o \
	$(SLATSM)dvheap.o \
	$(SLATSM)dvshel.o \
	$(SLATSM)hunti.o \
	$(SLATSM)i1mach.o \
	$(SLATSM)ichksm.o \
	$(SLATSM)icopy.o \
	$(SLATSM)idamax.o \
	$(SLATSM)ipdump.o \
	$(SLATSM)iprint.o \
	$(SLATSM)isanrg.o \
	$(SLATSM)ishell.o \
	$(SLATSM)isum.o \
	$(SLATSM)isw.o \
	$(SLATSM)ivheap.o \
	$(SLATSM)ivshel.o \
	$(SLATSM)lsame.o \
	$(SLATSM)mxint.o \
	$(SLATSM)parsvc.o \
	$(SLATSM)pretty.o \
	$(SLATSM)ran1.o \
	$(SLATSM)strings.o \
	$(SLATSM)strip.o \
	$(SLATSM)s8tor8.o \
	$(SLATSM)symvar.o \
	$(SLATSM)wordg.o \
	$(SLATSM)words.o \
	$(SLATSM)xerbla.o \
	$(SLATSM)ywrm.o \


csym:	$(SRC)
	$(LK) $(LKFLAGS1) $(SRC) $(LKFLAGS2) -o $@

