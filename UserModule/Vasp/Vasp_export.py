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
sys.path.append("./UserModule/Vasp")
from Converter import Converter
from addSite import *
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
	
def setpvecline(PV1,PV2,PV3,a):
	pvecline= "%18.12f\n  %18.12f %18.12f %18.12f\n%18.12f %18.12f %18.12f\n%18.12f %18.12f %18.12f\n"  % \
	(a,PV1[0]/a,PV1[1]/a,PV1[2]/a,
	   PV2[0]/a,PV2[1]/a,PV2[2]/a, 
	   PV3[0]/a,PV3[1]/a,PV3[2]/a)
	return pvecline

def Concsolve(atomconc):
	ncom =len(atomconc)
	comp=['None']*ncom
	conc=['None']*ncom
	for ic in range(ncom):
		comp[ic],conc[ic] = string.split(string.strip(atomconc[ic]),':')
		conc[ic]=string.atof(conc[ic])
#		print '%s %6.2f ' % (comp[ic], conc[ic]) 
	return comp,conc,ncom

#############################################################
## Main Routinue ############################################
if __name__ == '__main__':
	
	### 1. User set CSY File PATH
	csyFilePath = "./temp/xxx.csy1"
	
	### 2. Create Conveter Object
	A = Converter(csyFilePath)

	exec A.script
	flog  = open("./result/ResultWindow.dat","wt")	
	
	enginekey='Vasp'
	#Matlist	=	Type.keys()
	#fname = Matlist[0]+"_
	fname=''
	j=0
	for i in Type:
		if j==1:	fname =  fname + '_'
		fname = fname + i
		j=1
	fname=fname + '.inp'
	result=''
	result = result + "SYSTEM_NAME \n"
	err=''

### Set default values. 
	try:
		Section	= "./temp/Vasp.sec"
		fr=open(Section,"rt")
		result=result+ '# readin <'+ enginekey + '>setion \n'
		wtext = string.split(fr.read(), "\n")
		for nline in range(len(wtext)):
			s = wtext[nline]
			if string.find(s,"#")>=0:	s=s[:string.find(s,"#")]
			result=result +'# %s\n' % s
			outdata = ConvertTagSec(s,enginekey)
			
			try: 
				exec outdata
			except: 
				err= ' <' + enginekey + '> section is wrong ! %s' % s
				flog.write(err)
		fr.close()
		os.remove(Section)
	except:	pass

### pvec lines
	pvecline = setpvecline(PV1,PV2,PV3,a)
	result = result +pvecline
### type lines
# here we assume TYPE is arranged in one region in csy1.file
	typeline=''
	type_name_old=Site[0]['TYPE']
	ntype = TypeNum
	type_num=[0]*ntype
	j=0
	for i in range(SiteNum):
		type_name_new = Site[i]['TYPE']
		if(type_name_old != type_name_new):
			j=j+1
			type_name_old = type_name_new
			type_num[j]=type_num[j]+1
		else:
			type_num[j]=type_num[j]+1
	for j in type_num:
		typeline=typeline + str(j)+' '
	typeline = typeline + '\n'
	result = result +typeline
# if need selective dynamics 
	result = result + '#Selective dynamics \n'
### site lines
	if(abs(det(array([PV1,PV2,PV3])))<1e-6):
		err= 'Wrong input!: ====== PV are not linear independent ========= '
		flog.write(err)
	mat= inv(transpose(array([PV1,PV2,PV3])))
	siteline='Direct \n'
		# These are cartesian
#		pt=Site[i]['PosData']
#		siteline= siteline + '%18.12f %18.12f %18.12f  %s \n' % (pt[0],pt[1],pt[2],Site[i]["TYPE"])

	for i in range(SiteNum):
		pt=dot(mat	,Site[i]["PosData"])
		siteline= siteline + '%18.12f %18.12f %18.12f\n' % (pt[0],pt[1],pt[2])
	result = result + siteline
#### main printing from here
	print result
	flog.write(result)
