import sys
import os
from Numeric import *
import string
sys.path.append("./UserModule/Common")
from AtomData import AtomData

def set_cell_information(_sss):
	line =""
	i = 0
	print _sss
	for item in _sss:
		if(item=="<Atoms.UnitVectors"):
			pv1x=float(_sss[i+1])
			pv1y=float(_sss[i+2])
			pv1z=float(_sss[i+3])
			pv2x=float(_sss[i+4])
			pv2y=float(_sss[i+5])
			pv2z=float(_sss[i+6])
			pv3x=float(_sss[i+7])
			pv3y=float(_sss[i+8])
			pv3z=float(_sss[i+9])
			a = sqrt(pv1x*pv1x + pv1y*pv1y + pv1z*pv1z)
			b = sqrt(pv2x*pv2x + pv2y*pv2y + pv2z*pv2z)
			c = sqrt(pv3x*pv3x + pv3y*pv3y + pv3z*pv3z)
			line = line + "a=" + str(a) + "\n"
			line = line + "b=" + str(b) + "\n"
			line = line + "c=" + str(c) + "\n"
			line = line + "PV1="+_sss[i+1]+"*EX+"\
			+_sss[i+2]+"*EY+"+_sss[i+3]+"*EZ"+"\n"
			line = line + "PV2="+_sss[i+4]+"*EX+"\
			+_sss[i+5]+"*EY+"+_sss[i+6]+"*EZ"+"\n"
			line = line + "PV3="+_sss[i+7]+"*EX+"\
			+_sss[i+8]+"*EY+"+_sss[i+9]+"*EZ"+"\n"
			break
		i=i+1	
	return line
def set_site_line2(_sss,wtext):
	line =""
	Unit =""
	natom = 0
	i = 0
	for item in _sss:
		if(item =="Atoms.Number"):
			natom = int(_sss[i+1])
			break
		i=i+1
	i = 0
	for item in _sss:
		if(item =="Atoms.SpeciesAndCoordinate.Unit"):
			if(_sss[i+1] =="Ang"):
				Unit ="Ang"
			elif(_sss[i+1]=="FRAC"):
				Unit ="FRAC"
			else:
				Unit="AU"
			break
		i=i+1	
	i=0
	for iline in wtext:
		words = string.split(iline)
		print words
		if((len(words) > 0)and(words[0]=="<Atoms.SpeciesAndCoordinates")):
			for iatom in range(0,natom):
				text = string.split(wtext[i+1+iatom])
				typeName = text[1]
				if((Unit=="Ang") or (Unit=="AU")):	
					line = line + "SITE TYPE=" +typeName \
					+','+ 'POS='+text[2]+"*EX+"\
					+text[3]+"*EY +"\
					+text[4]+"*EZ" +"\n"
				else:
					line = line + "SITE TYPE=" +typeName \
					+','+ 'POS='+text[2]+"*PV1+"\
					+text[3]+"*PV2 +"\
					+text[4]+"*PV3" +"\n"
			break
		i=i+1			
	return line
def set_site_line(_sss):
	line =""
	i =0
	natom = 0
	for item in _sss:
		if(item=="Atoms.Number"):
			natom = int(_sss[i+1])
			break
		i=i+1
	i=0
	for item in _sss:
		if(item=="<Atoms.SpeciesAndCoordinates"):
			for i_atom in range(0,natom):
				typeName = _sss[i+1+i_atom*5+1]
				line = line + "SITE TYPE=" +typeName \
				+','+ 'POS='+_sss[i+1+i_atom*5+2]+"*EX+"\
				+_sss[i+1+i_atom*5+3]+"*EY +"\
				+_sss[i+1+i_atom*5+4]+"*EZ" +"\n"
			break
		i=i+1
	return line
def set_type_line(_sss):
	line =""
	i=0
	ntype = 0
	for item in _sss:
		if(item=="Species.Number"):
			ntype = int(_sss[i+1])
		i=i+1
	i=0	
	for item in _sss:
		if(item=="<Definition.of.Atomic.Species"):
			for i_type in range(0,ntype):
				typeName = _sss[i+1+i_type*3]
				cline =check_type(typeName) 
				line = line + cline
		i=i+1
	return line
def check_type(_key):
	sym="???"
	for z in range(104):
		if (len(AtomData[z])!=2):
			continue
		if string.find(_key,AtomData[z])!= -1:
			sym = AtomData[z]
			break
		if sym=="???":
			for z in range(104):
				if (len(AtomData[z])==2):
					continue
				if string.find(_key,AtomData[z])!= -1:
					sym = AtomData[z]
					break
	line = "TYPE %s ATOM= (%s:1.0) \n" %(_key,sym)
	return line
#############################################################
## Main Routinue ############################################
if __name__ == '__main__':
	### 1. User set CSY File PATH
	csyFilePath = "./temp/xxx.csy1"
	
	flog  = open("./result/EditWindow.dat","wt")

	enginekey='OpenMX'
	print ' ===== start OpenMX_import ======'
	fr=open(csyFilePath,"rt")
	wtext = fr.read()
	result = ""
	site=[]
	type=[]
	wtext = string.split(wtext, "\n")
	sss=''
	for iline in wtext:
		if(string.find(iline,'#')==0): continue
		sss = sss+iline+'\n'
	sss = string.split(sss)
	print sss
	ixx=0
# for cell part
	result = result + "\n"
	result = result + set_cell_information(sss)
	
	result = result + "CV1=PV1 \n"
	result = result + "CV2=PV2 \n"
	result = result + "CV3=PV3 \n"
	
	result = result + set_site_line2(sss,wtext)
	result = result + set_type_line(sss)
# we get type information
	flog.write(result)

