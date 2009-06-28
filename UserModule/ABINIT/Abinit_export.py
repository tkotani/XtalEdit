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
sys.path.append("./UserModule/Abinit")
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
	
def set_acell_rprim_line(PV1,PV2,PV3):
	a = sqrt(PV1[0] * PV1[0] + PV1[1]*PV1[1] + PV1[2]*PV1[2])
	b = sqrt(PV2[0] * PV2[0] + PV2[1]*PV2[1] + PV2[2]*PV2[2])
	c = sqrt(PV3[0] * PV3[0] + PV3[1]*PV3[1] + PV3[2]*PV3[2])
	rprim_line="#Definition of the unit cell\n"
	rprim_line=rprim_line+"acell %18.10f %18.10f %18.10f\n" %(a,b,c)
# for setting primitive vector--- for older Abinit
	rprim_line= rprim_line +"%6s%18.12f %18.12f %18.12f\n%6c%18.12f %18.12f %18.12f\n%6c%18.12f %18.12f %18.12f\n"  % \
	("rprim ",PV1[0]/a,PV1[1]/a,PV1[2]/a," ",
	 PV2[0]/b,PV2[1]/b,PV2[2]/b, " ",
	 PV3[0]/c,PV3[1]/c,PV3[2]/c)
	return rprim_line

def set_znucl_line(_type,_type_name):
	znucline = "znucl "
	# _type_name = {"Ga":1,"La":2} key is type name and value is 
	# index of this type
	index = 1
	for typName in _type.keys():
		if _type[typName].has_key("znucl"):
			znuc = str(_type[typName]["znucl"])+" "
			_type_name[typName]=index
			index = index + 1
		else:
			znuclist = _type[typName]["ATOM"].keys()
			# we only take first components of (La:0.9)(Sr:0.1)
			znuc = znuclist[0]
			_type_name[typName]=index
			index = index + 1
		znucline = znucline+str(znuc)+" "
	znucline = znucline +"\n"
	return znucline

def set_znucl_line2(_type,_abinit_type):
	# if you distinguish the atom type by the znuc
	# _abinit_type = [[["Ga"],31],[["La"],57],[["O1" "O2"],8]]
	znucline = "znucl "
	znuc = 0
	for typName in _type.keys():
		if _type[typName].has_key("znucl"):
			znuc = str(_type[typName]["znucl"])+" "
		else:
			znuclist = _type[typName]["ATOM"].keys()
			# we only take first components of (La:0.9)(Sr:0.1)
			znuc = znuclist[0]
		flag = 0
		for i in range(len(_abinit_type)):
			if (znuc == _abinit_type[i][1]):
				_abinit_type[i][0].append(typName)
				flag = 1
				break
		if (flag == 0):
			_abinit_type.append([[typName],znuc])
	for i in range(len(_abinit_type)):
		znucline = znucline + str(_abinit_type[i][1]) + " "
	znucline = znucline +"\n"
	return znucline

def set_type_index_line(_site,_name_index):
	type_line = "typat "
	for i in range(len(_site)):
		typename = _site[i]["TYPE"]
		type_line = type_line + str(_name_index[typename]) + " "
	type_line = type_line + "\n"
	return type_line

def set_position_line(_site):
	pos_line = "xcart \n"
	for i in range(len(_site)):
		x = _site[i]["PosData"][0]
		y = _site[i]["PosData"][1]
		z = _site[i]["PosData"][2] 
		pos_line = pos_line + "%18.12f %18.12f %18.12f \n" %(x,y,z)
	pos_line = pos_line + "\n"
	return pos_line

def set_default_parameter():
	default_line = "tsmear 0.04 \n"
	default_line = default_line + "kptopt 1\n"	
	default_line = default_line + "ngkpt 20 20 20 \n"
	default_line = default_line + "ecut 20 \n"
	default_line = default_line + "nstep 10 \n"
	default_line = default_line + "toldfe 1.0d-6 \n"
	return default_line

def Concsolve(atomconc):
	s = ""
	for key in atomconc.keys():
		s = s+"(%d:%s)" % (key, atomconc[key])

	atomconc = s
	atomconc = string.replace(atomconc,'(',' ')
	atomconc = string.split(atomconc+' end',')')[:-1]
	ncom =len(atomconc)
	comp=['None']*ncom
	conc=['None']*ncom
	for ic in range(ncom):
		comp[ic],conc[ic] = string.split(string.strip(atomconc[ic]),':')
		conc[ic]=string.atof(conc[ic])
#		print '%s %6.2f ' % (comp[ic], conc[ic]) 
	l_max=3
	return comp, conc,l_max,ncom

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
	enginekey='ABINIT'
	Matlist	=	Type.keys()
	result =""
	if (len(Matlist)==0):
		result = " Type is not defined"
		flog.write(result)
		exit(1)
	err=''
# first we set unit cell information
	result = set_acell_rprim_line(PV1,PV2,PV3)
#	abinit_type =[]
#	result = result + set_znucl_line2(Type,abinit_type)
#	result = result + "ntype %4d \n" %(len(abinit_type))
	name_index = {}
	result = result + "ntypat %4d \n" %(TypeNum)
	result = result + set_znucl_line(Type,name_index)
	print name_index
# then we set natom line
	result = result + "natom %4d \n" %(SiteNum)
# then we set type index
	result = result + set_type_index_line(Site,name_index)
# then we write atom positions
	result = result + set_position_line(Site)
# here we try to write value and keywords  from the section file 
	try:
		section = "./temp/ABINIT.sec"
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
		result = result + set_default_parameter()
	flog.write(result)
