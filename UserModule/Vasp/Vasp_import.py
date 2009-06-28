import sys
import os
from numpy import *
import string
import re

sys.path.append("./UserModule/Common")
from AtomData import AtomData

def set_type_information(_fr):
	line=""
	line_fr=string.split(_fr.readline())

	natom=0
	ntype=0
	for item in line_fr:
		ntype=ntype+1
		natom = natom + int(item)

	type_num=[0]*ntype

	it=0
	for item in line_fr:
		type_num[it]=int(item)
		it=it+1
	
	for it in range(ntype):
		type_name="type"+str(it)
		line = line + "TYPE %s  ATOM=(%s:1.0)\n" %(type_name,type_name)
		
	return line,natom,ntype,type_num

def set_site_information(ntype,type_num,natom,_fr):
	line=""
	for it in range(ntype):
		typeName="type"+str(it)
		num = type_num[it]
		for ia in range(num):
			line_fr = string.split(_fr.readline())
			line=line+"SITE TYPE="+typeName+","+" POS="\
			+line_fr[0]+"*PV1+ "+line_fr[1]+"*PV2+ "\
			+line_fr[2]+"*PV3"+"\n"	
	
	return line
def set_site_information2(ntype,type_num,natom,_fr):
	line=""
	directxxx=string.split(_fr.readline())
	print 'test xxx0 this suppport Direct only yet...', directxxx
	for it in range(ntype):
		#print 'test xxx1 it=',it
		typeName="type"+str(it)
		num = type_num[it]
		print typeName,num
		for ia in range(num):
			#print 'test xxx2 ia=',ia
			line_fr = string.split(_fr.readline())
			#print 'test xxx3 line_fr=',line_fr
			#continue
			line=line+"SITE TYPE="+typeName+","+" POS="\
			+line_fr[0]+"*a*EX+ "+line_fr[1]+"*a*EY+ "\
			+line_fr[2]+"*a*EZ"+"\n"
	print 'test xxx4 line=',line
	return line

def set_cell_information(_fr):
	line=""
	line=line + "a="
	line_fr1=_fr.readline()
	# read scale factor
	line=line + line_fr1 + "\n"
	# read primitive cell
	line_fr2=string.split(_fr.readline())
	line=line+"PV1="+" a*"+line_fr2[0] + "*EX+"\
	+" a*"+line_fr2[1]+"*EY+"+" a*"+line_fr2[2]+"*EZ\n"

	line_fr3=string.split(_fr.readline())
	
	line=line+"PV2="+" a*"+line_fr3[0] + "*EX+"\
	+" a*"+line_fr3[1]+"*EY+"+" a*"+line_fr3[2]+"*EZ\n"

	line_fr4=string.split(_fr.readline())

	line=line+"PV3="+" a*"+line_fr4[0] + "*EX+"\
	+" a*"+line_fr4[1]+"*EY+"+" a*"+line_fr4[2]+"*EZ\n"

	line=line + "CV1=PV1\nCV2=PV2 \nCV3=PV3\n"
	return line
#############################################################
## Main Routinue ############################################
if __name__ == '__main__':
	### 1. User set CSY File PATH
	csyFilePath = "./temp/xxx.csy1"
	
	fedit  = open("./result/EditWindow.dat","wt")

	enginekey='Vasp'
	print ' ===== start Vasp_POSCAR_import ======'
	fr=open(csyFilePath,"rt")
	result = ""
	site=[]
	type=[]
	# first read system name
	line1 = fr.readline()
	sysname = line1
	# second read
	line = set_cell_information(fr)
	result = result + line

	#third 
	line_type,natom,ntype,type_num = set_type_information(fr)

	# then write site

	line_fr=fr.readline()
	if line_fr[0]=="S" or line_fr[0]=="s":
		line_fr_next=fr.readline()
		if line_fr_next[0]=="D" or line_fr_next[0]=="d":
			line_syte=set_site_information(ntype,type_num,natom,fr)
       	elif line_fr[0]=="D" or line_fr[0]=="d":
		line_syte=set_site_information(ntype,type_num,natom,fr)
	else:
		line_syte=set_site_information2(ntype,type_num,natom,fr)
	# last we add line_type
	line = line + line_syte+line_type

	result=result=line
	
# we get type information
	
	fedit.write(result)
	fedit.close()


