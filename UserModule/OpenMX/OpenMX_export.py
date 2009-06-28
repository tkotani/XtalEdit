#!/usr/bin/python
################################################################################
## Add Class Module ############################################################
import sys
import os
import os.path
import string
from numpy import *
from numpy.linalg import *
#from LinearAlgebra import *
#from Numeric import *
sys.path.append("./UserModule/Common")
sys.path.append("./UserModule/OpenMX")
from AtomData import AtomData
from Converter import Converter
from RemoveTaggedSection import RemoveTaggedSection

def ConvertTagSec(s,seckey):
# For convert Tag Section with CLASS keyword.
	if string.find(s,"TYPE")>=0:	# KeyWord: Class
		n	= string.count(s, ",")
		st	= string.split(s)
								#	remove keyword TYPE
		Eq	= string.split(string.join(st[2:]),",")	#
		ClassName	=	st[1]
		outdata = ""
		for i in range(n+1):
			EqP = string.split(Eq[i],"=")
			data = string.replace(string.strip(EqP[1])," ","','")
			outdata	=	"Type['%s']['%s%s']='%s'" % (ClassName,string.strip(EqP[0]),seckey,data)

	else:
		outdata=s
	
	return outdata

def setSpeciesNumber(_type):
	line = "# \n"
	line = line + "# Definition of AtomSpecies \n"
	line = line + "# \n"
	n_species = len(_type.keys())
	line = "Species.Number  " + str(n_species) + "\n"
	line =line + "<Definition.of.Atomic.Species \n"
	for typName in  _type.keys():
		line = line + typName + "\n"
	line = line + "Definition.of. Atomic.Species>\n"	
	return line
def setAtomsNumber(_sites):
	line ="# \n"
	line =line + "# Atom \n"
	line =line + "# \n"
	n_atom = len(_sites)
	line =line +  "Atoms.Number " + str(n_atom) + "\n"

	line = line + "Atoms.SpeciesAndCoordinates.Unit  Ang #Ang Au FRAC \n"

	line = line + "<Atoms.SpeciesAndCoordinates \n"
	for i in range(n_atom):
		x = _sites[i]["PosData"][0]
		y = _sites[i]["PosData"][1]
		z = _sites[i]["PosData"][2]
		line =line +"%2d%5s %20.8f %20.8f %20.8f\n"\
		%(i+1,_sites[i]['TYPE'],x,y,z)
	line = line + "Atoms.SpeciesAndCoordinates> \n"
	return line
def setUnitVectors(Pv1,Pv2,Pv3,_unit = "Ang"):
	line = "Atoms.UnitVectors.Unit " + _unit + "\n"
	line = line + "<Atoms.UnitVectors \n"
	x = Pv1[0]
	y = Pv1[1]
	z = Pv1[2]
	line = line + "%20.8f %20.8f %20.8f \n" %(x,y,z)
	x = Pv2[0]
	y = Pv2[1]
	z = Pv2[2]
	line = line + "%20.10f %20.10f %20.10f \n" %(x,y,z)
	x = Pv3[0]
	y = Pv3[1]
	z = Pv3[2]
	line = line + "%20.10f %20.10f %20.10f \n" %(x,y,z)
	line = line + "Atoms.UnitVectors>\n"
	return line
def set_default_parameter():
	line = ""
	line = line +"scf.XcType   LDA  #LDA LSDA-CA LSDA-PW GGA-PBE \n"
	line = line + "scf.SpinPolarization   off #On Off Nc \n"
	line = line +"# scf.energycutoff is the cutoff enrgy specifies \n"
	line = line +"# used in the calculation of matrix elements \n"
	line = line +"# associated with difference charge Coulomb potential \n"
	line = line +"# and exchange-correlation potential and the solution \n"
	line = line +"# of the Poisson's equation using FFT \n"
	line = line +"scf.energycutoff   150 \n"
	line = line +"scf.maxIter   100 \n"
	line = line +"scf.EigenvalueSolver  Band #DC GDC Cluster Band \n"
	line = line +"scf.Kgrid   4 4 4 \n"
	line = line +"scf.Mixing.Type  rmm-diis #Simple RMM-Diis Gr-Pulay Kerker Rmm-Diisk\n"
	line = line +"scf.Init.Mixing.Weight  0.2 #mixing weight first used \n"
	line = line +"scf.Min.Mixing.Weight   0.001 #lower limit of mixing weight in the simple and Kerker method \n"
	line = line +"scf.Max.Mixing.Weight  0.4 #upper limit of mixing weight in in the simpler and Kerker method \n"
	line = line +"scf.Mixing.History   6 \n"
	line = line +"scf.Mixing.StartPulay 6 \n"
	line = line +"\n"
	line = line +"scf.criterion   1.0e-7 #given by Hatree \n"
	line = line +"\n"
	line = line +"# \n"
	line = line +"# Orbital Optimization \n"
	line = line +"# \n"
	line = line + "orbitalOpt.Method   off #Off Unrestrected Restricted \n"
	line = line + "orbitalOpt.InitCoes   Symmetrical  #Symmetrical  Free \n"
	line = line + "orbitalOpt.initPrefactor  0.1 \n"
	line = line + "orbitalOpt.scf.maxIter    15  \n"
	line = line + "orbitalOpt.MD.maxIter     5   \n"
	line = line + "orbitalOpt.criterion    1.0e-4 \n"
	line = line + "\n"
	line = line +"scf.system.charge   0 \n"
	line = line +"\n"
	line = line +"scf.SpinOrbit.Coupling   OFF #ON  OFF \n"
	line = line +"\n"
	line = line + "# DOS part \n"
	line = line + "Dos.fileout  on \n"
	line = line + "Dos.Erange   -20.0  20.0 \n"
	line = line + "Dos.Kgrid    8 8 8 \n"
	return line
#############################################################
## Main Routinue ############################################
if __name__ == '__main__':
	
	### 1. User set CSY File PATH
	csyFilePath = "./temp/xxx.csy1"
	
	### 2. Create Conveter Object
	A = Converter(csyFilePath)
	exec A.script
	## Here we get Csy Information

	flog  = open("./result/ResultWindow.dat","wt")	
	enginekey='OpenMX'
	Matlist	=	Type.keys()
	result =""
	if (len(Matlist)==0):
		result = " Type is not defined"
		flog.write(result)
		exit(1)
	err=''
	
	result = result + setSpeciesNumber(Type)

	result = result + setAtomsNumber(Site)

	result = result + setUnitVectors(PV1,PV2,PV3)
	
	try:
		section = "./temp/OpenMX.sec"
		fr=open(section,"rt")
		result = result+'# readin<'+enginekey + '>section \n'
		wtext = string.split(fr.read(),"\n")
		for nline in range(len(wtext)):
			s = wtext[nline]
			# remove comment parts
			if string.find(s,"#")>=0:
				s=s[:string.find(s,"#")]
			result = result + s +"\n"
		fr.close()
		os.remove(section)
	except:
		pass
		result = result + set_default_parameter()
	flog.write(result)
