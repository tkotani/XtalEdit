# This Python Program Read Output file for ABINIT
import os
import sys
import string 
import re
sys.path.append("./UserModule/Common")

from AtomData import *

def set_cell_information(_sss):
	s=""
	i=0
	acell=[0.0,0.0,0.0]
	for item in _sss:
		if item=="acell":
			s=s+"a="+_sss[i+1] + "\n"
			s=s+"b="+_sss[i+2] + "\n"
			s=s+"c="+_sss[i+3] + "\n"
			acell[0]=_sss[i+1]
			acell[1]=_sss[i+2]
			acell[2]=_sss[i+3]
			break
		i=i+1
	flag=0
	i=0
	for item in _sss:
		if item=="rprim":
			flag = 1
			prim_line = "PV1="+"a*"+_sss[i+1]+"*EX"\
			+"+a*"+_sss[i+2]+"*EY"+"+a*"+_sss[i+3]+"*EZ"+"\n"
			prim_line = prim_line + "PV2="+"b*"+_sss[i+4]+"*EX"\
			+"+b*"+_sss[i+5]+"*EY"+"+b*"+_sss[i+6]+"*EZ"+"\n"
			prim_line = prim_line + "PV3="+"c*"+_sss[i+7]+"*EX"\
			+"+c*"+_sss[i+8]+"*EY"+"+c*"+_sss[i+9]+"*EZ"+"\n"
			s = s + prim_line
			flag = 1
			break
		i=i+1
	
	if not flag:
		prim_line = "PV1=a * EX \nPV2=b * EY \nPV3=c * EZ \n"
		s = s + prim_line
	# this is Default CV1 CV2 CV3
	s = s + "CV1 = PV1\n"
	s = s + "CV2 = PV2\n"
	s = s + "CV3 = PV3\n"
	return s

def set_Site_information(_sss):
	s=""
	i=0
	natom = 0
	ntype = 0
	for item in _sss:
		if item=="natom":
			natom = int(_sss[i+1])
			break
		i=i+1
	i=0
	for item in _sss:
		if (item=="ntype")or(item=="ntypat"):
			ntype = int(_sss[i+1])
		i=i+1
	print "natom=",natom	
	print "ntype=",ntype	
	_type=[]
	_znuc=[]
	for i in range(0,natom):
		_type.append(0)
	for i in range(0,ntype):
		_znuc.append(0)
		
	i=0	
	for item in _sss:
		if (item=="type")or(item=="typat"):
			for i_atom in range(0,natom):
				_type[i_atom]=int(_sss[i+1+i_atom])
			break
		i=i+1
	i=0	
	for item in _sss:
		if (item=="znucl"):
			for i_type in range(0,ntype):
				_znuc[i_type]=float(_sss[i+1+i_type])
			break
		i=i+1
	i=0	
	for item in _sss:
		if item=="xcart":
			for i_atom in range(0,natom):
				s=s+"SITE TYPE="
				znuc = _znuc[_type[i_atom]-1]
				atomname = AtomData[znuc]
				s = s + atomname + ", "
				s=s+"POS="
				x=_sss[i+1+3*i_atom]
				y=_sss[i+2+3*i_atom]
				z=_sss[i+3+3*i_atom]
				s=s+x+"*EX + " + y+"*EY +" +z+"*EZ"+"\n"
			break	
		i=i+1
	for i in range(0,ntype):
		s = s + "TYPE "
		znuc = _znuc[i]
		atomname = AtomData[znuc]
		s = s + atomname + " ATOM=(" + atomname + ":100)"+"\n" 
	return s
def output_result(_sss,fedit):
	s=""
	s="#Result of Abinit Output \n"
	s= s + "\n\n"
	s= s + "#Cell Information \n"
	s= s + "\n"
	s = s + set_cell_information(_sss)
	s = s + "\n\n"
	s = s + "#Site Information \n"
	s = s + "\n"
	s = s + set_Site_information(_sss)
	print s
	fedit.write(s)
	fedit.close()
	return

if __name__=='__main__':
	csyFilePath ="./temp/xxx.csy1"
	fedit = open("./result/EditWindow.dat","wt")
#" outputconf must be input or out"	
	outputconf = ""
	outputconf="out"
#
	file_in = open(csyFilePath,"rt")
	s=""
	lists=[]
	flag = 0
	n_outvars=0
	while 1:
		next = file_in.readline()
		line = string.split(next)
		if not next:
			break
		else:
			for word in line:
				if(word=="-outvars:"):
					if(len(s)!=0):
						lists.append(s)
					s=""
					flag=1
				if re.search('=+',word):
					flag=0
				if flag:
					s = s + "#" + word
	if(len(s)!=0):
		lists.append(s)
		
	noutput = len(lists)
	for i_out  in range(0,noutput):
		_sss = string.split(lists[i_out],"#")
		i=0		
		for item in _sss:
			if(item == "-outvars:"):
				if(outputconf=="in"):
					if(_sss[i+5]=="input"):
						print "Input Variables"
						output_result(_sss,fedit)
				if(outputconf=="out"):
					if(_sss[i+5]=="after"):
						print "After Computation"
						output_result(_sss,fedit)
			i=i+1
	
	file_in.close()









