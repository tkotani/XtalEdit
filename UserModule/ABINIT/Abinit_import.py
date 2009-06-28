import sys
import os
from numpy import *
#from numpy.linalg import *
#from Numeric import *
import string
import re

sys.path.append("./UserModule/Common")
from AtomData import AtomData

def set_cell_information(_sss):
	# take cell size
	cell_line =""
	i = 0
	for item in _sss:
		if (item=='acell'):
			if _sss[i+1][:2]=="3*":
				cell_line = cell_line +"a=" + _sss[i+1][2:]+"\n"
				cell_line = cell_line +"b=" + _sss[i+1][2:]+"\n"
				cell_line = cell_line +"c=" + _sss[i+1][2:]+"\n"
			elif (_sss[i+1][:2]=="2*"):
				cell_line=cell_line + "a=" +  _sss[i+1][2:]+"\n"
				cell_line=cell_line + "b=" +  _sss[i+1][2:]+"\n"
				cell_line=cell_line + "c=" +  _sss[i+2]+"\n"
			elif (_sss[i+2][:2]=="2*"):
				cell_line=cell_line + "a=" + _sss[i+1] +"\n"
				cell_line=cell_line + "b=" + _sss[i+2][2:] + "\n"
				cell_line=cell_line + "c=" + _sss[i+2][2:] + "\n"
			else:
				cell_line = cell_line +"a=" +  _sss[i+1] + "\n"
				cell_line = cell_line +"b=" +  _sss[i+2] + "\n"
				cell_line = cell_line +"c=" +  _sss[i+3] + "\n"
			break
		i = i + 1
	# primitive vector
	prim_line=""
	i = 0
	if((_sss.count('rprim') == 0) and (_sss.count('angdeg')==0)):
		prim_line="PV1="+"a*EX"+"\n"
		prim_line=prim_line+"PV2="+"b*EY" + "\n"
		prim_line=prim_line+"PV3="+"c*EZ" +"\n"
	for item in _sss:
		if(item=='rprim'):
			prim_line = "PV1="+"a*"+_sss[i+1]+"*EX"\
			+"+a*"+_sss[i+2]+"*EY"+"+a*"+_sss[i+3]+"*EZ"+"\n"
			prim_line = prim_line + "PV2="+"b*"+_sss[i+4]+"*EX"\
			+"+b*"+_sss[i+5]+"*EY"+"+b*"+_sss[i+6]+"*EZ"+"\n"
			prim_line = prim_line + "PV3="+"c*"+_sss[i+7]+"*EX"\
			+"+c*"+_sss[i+8]+"*EY"+"+c*"+_sss[i+9]+"*EZ"+"\n"
			break
		if(item=='angdeg'):

			angdeg=[0.0,0.0,0.0]
			if(_sss[i+1][:2]=="3*"):
				angdeg[0]=float(_sss[i+1][2:])
				angdeg[1]=float(_sss[i+1][2:])
				angdeg[2]=float(_sss[i+1][2:])
			else:
				angdeg[0]=float(_sss[i+1])
				angdeg[1]=float(_sss[i+2])
				angdeg[2]=float(_sss[i+3])
			
			tol12=1.0E-12

			if (abs(angdeg[0]-angdeg[1]) < tol12) and \
			(abs(angdeg[1]-angdeg[2])<tol12) and \
			(abs(angdeg[0]-90.0)+abs(angdeg[1]-90.0)+ \
			abs(angdeg[2]-90.0) > tol12):
				cosang = cos(pi * angdeg[0]/180.0)
				a2 = 2.0/3.0 * (1.0 - cosang)
				aa = sqrt(a2)
				cc = sqrt(1.0-a2)
				prim_line = prim_line + "PV1= a*%18.12f \
*EX + a*%18.12f * EY + a*%18.12f * EZ \n" %(aa,0.0,cc)  
				prim_line = prim_line + "PV2= b*%18.12f \
*EX + b*%18.12f * EY + b*%18.12f * EZ \n" %(-0.5*aa,sqrt(3.0)*0.5*aa,cc)
				prim_line = prim_line + "PV3= c*%18.12f \
*EX + c*%18.12f * EY + c*%18.12f * EZ \n" %(-0.5*aa,-sqrt(3.0)*0.5*aa,cc)
			else:
				rprim12=cos(pi*angdeg[2]/180.0)
				rprim22=sin(pi*angdeg[2]/180.0)
				rprim13=cos(pi*angdeg[1]/180.0)
				rprim23=(cos(pi*angdeg[0]/180.0)-rprim12*rprim13)/rprim22
				rprim33=sqrt(1.0-rprim13*rprim13-rprim23*rprim23)
				prim_line = prim_line + "PV1= a*%18.12f \
*EX + a*%18.12f * EY + a*%18.12f * EZ \n" %(1.0,0.0,0.0) 
				prim_line = prim_line + "PV2= b*%18.12f \
*EX + b*%18.12f * EY + b*%18.12f * EZ \n" %(rprim12,rprim22,0.0)
				prim_line = prim_line + "PV3= c*%18.12f \
*EX + c*%18.12f * EY + c*%18.12f * EZ \n" %(rprim13,rprim23,rprim33)
			
		i = i + 1
	return (cell_line+prim_line)

def get_type_and_site(_sss,_type,_site):
	tol_znuc = 1.0E-5
	i = 0
	ntype = 0
	natom = 0
	for item in _sss:
		if((item=='ntype')or(item=='ntypat')):
			ntype = int(_sss[i+1])
			break
		i = i + 1

	for i in range(0,ntype):
		_type.append("")

	i = 0
	
	for item in _sss:
		if((item=='znucl')or (item=='zatnum')):
			for j in range(0,ntype):
				znuc2 = float(_sss[i+1+j])
				znuc = int(znuc2)
				tol_z = abs(znuc-znuc2)
				if(tol_znuc > tol_z):
					name = AtomData[znuc]
				else:
					name = "atom"+str(j)
				_type[j]=name
			break
		i= i + 1
	i = 0
	for item in _sss:
		if(item=='natom'):
			natom = int(_sss[i+1])
			break
		i = i + 1
	for i in range(0,natom):
		_site.append(0)
	i = 0
	for item in _sss:
		if((item=='type')or(item=='typat')):
			for j in range(0,natom):
				_site[j]=int(_sss[i+j+1])
			break
		i = i + 1
def set_site_line(_sss,_type,_site):
	natom = len(_site)
	site_line = ""
	i = 0
	for item in _sss:
		if(item=='xcart'):
			for j in range(natom):
				id_type = _site[j]
				typeName = _type[id_type-1]
				site_line = site_line+"SITE TYPE="+typeName \
				+', ' +'POS='+_sss[i+3*j+1]+ "*EX + "\
				+ _sss[i+3*j+2] +"*EY + "\
				+ _sss[i+3*j+3] +"*EZ" + "\n"
			break 
		if(item=='xred'):
			for j in range(natom):
				id_type = _site[j]
				typeName = _type[id_type-1]
				site_line = site_line+"SITE TYPE="+typeName \
				+','+'POS='+_sss[i+3*j+1]+"*PV1 + "\
				+_sss[i+3*j+2]+"*PV2 + "\
				+_sss[i+3*j+3]+"*PV3" + "\n"
			break
		if(item=='xangst'):
			for j in range(natom):
				id_type = _site[j]
				typeName = _type[id_type-1]
				site_line= site_line+"SITE TYPE="+typeName \
				+', ' +'POS='+_sss[i+3*j+1]+ "*EX + "\
				+ _sss[i+3*j+2] +"*EY + "\
				+ _sss[i+3*j+3] +"*EZ" + "\n"
			break 
		i = i + 1
	site_line = site_line+"CV1=PV1 \n"+"CV2=PV2 \n"+"CV3=PV3\n"
	return site_line
def set_type_line(_sss,_type):
	type_line = ""
	ntype = len(_type)
	for i in range(ntype):
		type_line=type_line +"TYPE " + _type[i] +" "+ \
		"ATOM=" +"(" +_type[i]+ ":100)" \
		+","+"LMX = 2" + "," + "RWS=1.0" +"\n"
	return type_line

def make_Abinit_section(_wtext):
	# first we remove \n and replace $ for a mark
	# we assume _wtext is already splitted by \n.
	_sss=""
	for iline in _wtext:
		if(string.find(iline,'#')==0): continue
		_sss = _sss+" " + iline+" $"
	_sss = string.split(_sss)
	# remove acell section
	i=0
	for item in _sss:
		if (item=='acell'):
			index = find_not_Sharp_Index(i+1,_sss)
			if (_sss[index][:2]=="3*"):
				_sss = remove_list_Except_Sharp(i,2,_sss)
			else:
				_sss = remove_list_Except_Sharp(i,4,_sss)
			break
		i=i+1
	# then remove rprim or angdeg section
	i= 0
	for item in _sss:
		if(item=='rprim'):
			_sss = remove_list_Except_Sharp(i,10,_sss)
			break
		if(item=='angdeg'):
			index = find_not_Sharp_Index(i+1,_sss)
			if(_sss[index][:2]=="3*"):
				_sss = remove_list_Except_Sharp(i,2,_sss)
			else:
				_sss = remove_list_Except_Sharp(i,4,_sss)
			break
		i=i+1
	# remove ntype
 	i=0
	ntype = 0
	for item in _sss:
		if((item=='ntype') or (item=='ntypat')):
			index = find_not_Sharp_Index(i+1,_sss)
			ntype = int(_sss[index])
			_sss = remove_list_Except_Sharp(i,2,_sss)

			break
		i=i+1

	# remove znucl or zatnum
	i = 0
	for item in _sss:
		if((item=='znucl')or(item=='zatnum')):
			_sss = remove_list_Except_Sharp(i,ntype+1,_sss)
			break
		i= i + 1
	# remove natom
	i = 0
	natom = 0
	for item in _sss:
		if(item=='natom'):
			index = find_not_Sharp_Index(i+1,_sss)
			natom = int(_sss[index])
			_sss = remove_list_Except_Sharp(i,2,_sss)
			break
		i = i + 1
	# remove type 	
	i = 0
	for item in _sss:
		if((item=='type')or(item=='typat')):
			_sss = remove_list_Except_Sharp(i,natom+1,_sss)
			break
		i = i + 1	
	# remove xcart or xred or xangst part	
	i=0	
	for item in _sss:
		if(item=='xcart'):
			_sss = remove_list_Except_Sharp(i,3*natom+1,_sss)
			break 
		if(item=='xred'):
			_sss = remove_list_Except_Sharp(i,3*natom+1,_sss)
			break
		if(item=='xangst'):
			_sss = remove_list_Except_Sharp(i,3*natom+1,_sss)
			break 
		i = i + 1
	# replace mark "$" by "\n"
	i=0
	for item in _sss:
		if (item=="$"):
			_sss[i]="\n"
		i=i+1
	# make <ABINIT> section
	text = ""
	for item in _sss:
		text = text + " " + item

	return text

def find_not_Sharp_Index(i_start,_sss):
# this function find first not $ item's index  from _sss[i_start]
	nlen = len(_sss)
	if (nlen < i_start):
		print "Error size of list is inconsistent!"
		
	index = i_start
	for item in _sss[i_start:]:
		if (item != "$"):
			break
		else:
			index = index + 1
	return index

def remove_list_Except_Sharp(i_start,ncount,_sss):
# this function remove list ncount member from i_start 
# except "$"

	bw = _sss[i_start:]
	bw2 = ["$"]
	count = 0
	num_sharp = 0
	i=0
	for item in bw:
		if(item=="$"):
			num_sharp = num_sharp + 1
		else:
			count = count + 1
			if (count == ncount):
				break
			
	if (num_sharp > 0):
		del bw[0:ncount+num_sharp+1]
		bw = bw2 + bw
	else:	
		del bw[0:ncount+1]
		
			
	if(i_start==0):
		_sss = bw
	else:	
		fw  = _sss[0:i_start]
		_sss = fw + bw
		
	return _sss
			
def set_ABINIT_section(_wtext):
# remove acell , rprim, xcard, ntype,natom section from the
# input file and then input ABINIT section.
	text = "<ABINIT>" + "\n"
	text = text + make_Abinit_section(_wtext)
	text = text + "\n" + "</ABINIT>"
	return text
#############################################################
## Main Routinue ############################################
if __name__ == '__main__':
	### 1. User set CSY File PATH
	csyFilePath = "./temp/xxx.csy1"
	
	fedit  = open("./result/EditWindow.dat","wt")

	enginekey='ABINIT'
	print ' ===== start Abinit_import ======'
	fr=open(csyFilePath,"rt")
	wtext = fr.read()
	result = ""
	site=[]
	type=[]
	wtext = string.split(wtext, "\n")
	sss=''
	for iline in wtext:
		if(string.find(iline,'#')==0): continue
		if(string.find(iline,'#')>0):
			iline=iline[:string.find(iline,'#')]
		sss = sss+iline+'\n'
	sss = string.split(sss)
	ixx=0
# for cell part
	result = result + "\n"
	result = result + set_cell_information(sss)
# we get type information
	get_type_and_site(sss,type,site)
	result = result + "\n"
	result=result + set_site_line(sss,type,site)
	result = result + "\n"
	result=result + set_type_line(sss,type)
	# set <ABINIT>-</ABINIT> section
	result=result + set_ABINIT_section(wtext)
	
	fedit.write(result)
	fedit.close()


