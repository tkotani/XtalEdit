#!/usr/bin/python
################################################################################
## Add Class Module ############################################################
import sys
import os
import os.path
import string
#from LinearAlgebra import *
#from Numeric import *
from numpy import *
from numpy.linalg import *
sys.path.append("./UserModule/Common")
sys.path.append("./UserModule/UDF")
from Converter import Converter
from RemoveTaggedSection import RemoveTaggedSection

def setDefPart():
# this is def part of UDF	
	text="\\begin{header}\n \\begin{def}\n \
EngineType:string;\n EngineVersion:string;\n IOType:string;\n \
ProjectName:string;\n Comment:string;\n \\end{def} \n "
	text=text +"\\begin{data}\n \
	EngineType:\"CSYDATA\" \n \
	EngineVersion:\"Proto0\" \n \
	IOType:\"IN or OUT\" \n \
	ProjectName:\"XtalEdit\" \n \
	Comment:\"This is UDF Def file for CSY formatted file\" \n"
	text= text +"\\end{data}\n\\end{header} \n\\begin{def} \n \
	class Vector3d:{x:double,y:double,z:double}; \n \
	class Type:{ \n\t\tName:string,\n\t\tLMX:double,\n\t\tRWS:double,\n\
\t}; \n \
	class Site:{\n\t\ttypename:string,\n\t\tcoord:Vector3d \n\t}; \n \
	class PV:{ \n\t\tPv1:Vector3d,\n\t\tPV2:Vector3d,\n\t\tPV3:Vector3d\n\t};\n\tCSYSystem:{ \n\t\tprimvec:PV\n\t\ttypes[]:Type\n\t\tsites[]:Site\n\t} \n\\end{def}\n"
	return text
def setDataPV(_pv1,_pv2,_pv3):
	text=""
	text=text+"{\n"
	text=text+"{"+str(_pv1[0])+","+str(_pv1[1])+","+str(_pv1[2])+"}\n"
	text=text+"{"+str(_pv2[0])+","+str(_pv2[1])+","+str(_pv2[2])+"}\n"
	text=text+"{"+str(_pv3[0])+","+str(_pv3[1])+","+str(_pv3[2])+"}\n"
	text=text+"}\n"
	return text
def setSite(_site,_type):
	text="[\n"
	natom = len(_site)
	for i in range(natom):
		type_name = _site[i]["TYPE"]
		temp = "{"
		temp=temp+"\""+type_name+"\""
		x=_site[i]["PosData"][0]
		y=_site[i]["PosData"][1]
		z=_site[i]["PosData"][2]
		temp = temp + "{"+str(x)+","+str(y)+","+str(z)+"}"
		temp = temp +"}\n"
		text = text + temp	
	text=text+"]\n"
	return text	
def setType(_site,_type):
	text="[\n"
	ntype=len(_type)
	for type_name in _type.keys():
		temp = "{"+"\""+type_name+"\""+","
		temp = temp + _type[type_name]["LMX"]+","
		temp = temp + _type[type_name]["RWS"]+"}"+"\n"
		text = text + temp
	text=text+"]\n"
	return text	
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

	Matlist	=Type.keys()
	result =""
	if (len(Matlist)==0):
		result = " Type is not defined"
		flog.write(result)
		exit(1)
	err=''
	result = result + setDefPart()
	result = result + "\\begin{data}\nCSYSystem:{\n"
	# then we write data for PV
	result = result + setDataPV(PV1,PV2,PV3)
	result = result + setType(Site,Type)
	# then we write site for the csy system
	result = result + setSite(Site,Type)
	result = result + "}\n\\end{data}\n"
	flog.write(result)

