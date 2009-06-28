#!/usr/bin/python
################################################################################
## Add Class Module ############################################################
import sys
import os
import os.path
import string
#from numpy import *
from numpy.linalg import *
#from LinearAlgebra import *

sys.path.append("./UserModule/Common")
sys.path.append("./UserModule/SuperCell")
from Converter import Converter
from addSite import *
import ConstantData
#############################################################
## Main Routinue ############################################
if __name__ == '__main__':
	
	### 1. User set CSY File PATH
	csyFilePath = "./temp/xxx.csy1"
	
	### 2. Create Conveter Object
	A = Converter(csyFilePath)
	
	### 3. Execute Csy
	exec A.script
	
	arg = string.atoi(sys.argv[1])
	
	CheckVariable	=	["PV1","PV2","PV3","a"]
	CheckKey		=	{"SITE": 1	,"TYPE": 0	,"GEN": 0}	#	1: Need
	
	SiteNum  = 1
	TypeNum = 1
	for Mat in Site.keys():
		EMat=array([0., 0., 0.])
		try:
			Site[Mat]["PosData"]	=	Site[Mat]["PosData"]+EMat
		except:
			Site[Mat]["PosData"] = EMat
			Site[Mat]["POS"]	=	"0."
################################################################################
## Make "crystr.in" ############################################################

## chdir temp	
	os.chdir("temp")
	
	fw = open("crystr.in","wt")
	SiteNum	= len(Site)
	TypeNum= len(Type)
	fw2=open("parameter.data","wt")
	fw2.write(str(SiteNum))
	fw2.close()
	
	fw.write("     %1d  !mode switch for computation. Next line is generators\n" % arg)
	
	try:
		fr	= open("GEN.sec","rt")
		GEN = fr.read()
		fr.close()
		fw.write("       "+GEN)
		OrgGenKey	="Exist"
	except:
		OrgGenKey	="Nothing"
		fw.write("       \n")
	fw.write("       %19.15f !alat\n" % a)
	
#	import ConstantData
	

	try:
		sxz1	="       %19.15f      %19.15f      %19.15f\n" % (PV1[0]/a
															,PV1[1]/a
															,PV1[2]/a)
		sxz2	="       %19.15f      %19.15f      %19.15f\n" % (PV2[0]/a
															,PV2[1]/a
															,PV2[2]/a)
		sxz3	="       %19.15f      %19.15f      %19.15f\n" % (PV3[0]/a
															,PV3[1]/a
															,PV3[2]/a)
		fw.write(sxz1)
		fw.write(sxz2)
		fw.write(sxz3)
		PVMat= inv(transpose(array([PV1,PV2,PV3])))
		PVec = ["PV1","PV2","PV3"]

	except:
		print "RunError, PV"
		sys.exit(0)
	
	typedic = {}
	i = 1
	for key in Type.keys():
		typedic[key] = i
		i=i+1

	fw.write("   %3d  !nbas\n" % SiteNum)
	for i in range(SiteNum):

		pt	=	Site[i]["PosData"]

		fw.write("       %19.15f      %19.15f      %19.15f  %3d\n" \
					% (  pt[0]/a	,pt[1]/a
						,pt[2]/a	,typedic[Site[i]["TYPE"]]))
	fw.write("  %3d  !ntyp\n" % TypeNum)

	ntypedic = {}
	for i2 in range(len(typedic)):
		i = i2+1
		for key in typedic.keys():
			if typedic[key]==i:
				try:
					rtin	=	string.atof(Type[key]["RMT"])
					fw.write("        %s       %3s\n" % (key,Type[key]["RMT"]))
				except:
					fw.write("        %s       0.0\n" % key)
				ntypedic[i] = key
	fw.close()
################################################################################
## Environment #################################################################
## Python Exec. Command ########################################################
	PythonExe   = "python"
	
## OS Setting ##################################################################
#ExeString		=	(PythonExe,	" > "," 2> ")
	ExeString		=	(PythonExe,	" > "," 2>")
################################################################################
## Execute "csym" ##############################################################
	import os
	#cwd = os.path.abspath(".")
	#expath = os.path.join(cwd,"UserModule")
	#exepath = os.path.join(expath,"Generator")
	expath = os.path.join("..","UserModule")
	exepath = os.path.join(expath,"Generator")	
#	if	os.name=="nt":
#		os.system("csym "+SysConf.ExeString[1]+"resultwin.data 2> reserr.data")
#	else:
#		os.system("./csym"+SysConf.ExeString[1]+"resultwin.data >& reserr.data") # 030307
	os.system(os.path.join(exepath,"csym" + ExeString[1] + "resultwin.data"+ ExeString[2] +"reserr.data"))	

################################################################################
## read "crystr.out" and write Site data #######################################

#	try:
#		OrgGenKey	= GEN
#	except:
#		OrgGenKey	="Nothing"
	
	
	try:
		fr	= open("crystr.out","rt")
	except:
#		sys.stderr.write("Run Error\n")
		fr	=	open("resultwin.data","rt")
		s	=	fr.readline()
		while 1:
			s	=	fr.readline()
			if	s=="":
				break
			s2	=	s
		fr.close()
		while 1:
			if s2[-1]!="\n":
				break
			s2	=	s2[:-1]
		sys.stderr.write("*.csy is inconsistent. See output window.")
		sys.exit(1)

	s	= fr.readline()			# 1
	GenKey	= fr.readline()		# 2: GEN Keyword
	for i in range(4):
		s = fr.readline()		# 3-6: Cut
	s = fr.readline()
	NSiteNum =  string.atoi(string.split(s)[0])	#SiteNum
	NSite = {}

	outxxx = "GEN "+string.lstrip(GenKey)		
	print outxxx
#	print 'xxxxxxxx a=',a

	addtext = "" # additional line by generator

	for i in range(NSiteNum):
		s = fr.readline()
		if i<SiteNum:
			continue
#		print 'xxxxxxxx',s
		SiteInfo=	string.split(s)
		CNum	=	SiteInfo[3]
		SiteVEX	=	[string.atof(SiteInfo[0])*a
					,string.atof(SiteInfo[1])*a
					,string.atof(SiteInfo[2])*a]					# To a.u.
		SiteVPV	=	dot(PVMat	,SiteVEX)               #PV base
		#print 'pppsitevpv',SiteVPV,array([3.4,3.4,2])
		#absSiteVPV= norm(SiteVPV)
		#print 'normSiteVPV=',norm(SiteVPV)
		if norm(SiteVPV)>1e-10:
			Sign	= ["Z","Z","Z"]
			SiteVPVstr	=	["","",""]
			for i2 in range(3):
				if SiteVPV[i2]<0:
					Sign[i2]="-"
					SiteVPV[i2]	=	-SiteVPV[i2]
				elif SiteVPV[i2]>0:
					Sign[i2]="+"
				s = "%13.10f" % SiteVPV[i2]
				SiteVPVstr[i2] = s
			if Sign[0]=="-":
				Pos = " -"+SiteVPVstr[0]+" *"+PVec[0]+" "
			elif Sign[0]=="+":
				Pos = "  "+SiteVPVstr[0]+" *"+PVec[0]+" "
			else:
				Pos = "                     "
			for i2 in (1,2):
				if Sign[i2]!="Z":
					Pos = Pos+Sign[i2]+SiteVPVstr[i2]+" *"+PVec[i2]+" "
				else:
					Pos = Pos+"                    "
		else:
			Pos	=	"           0.0 *PV1 +          0.0 *PV2 +          0.0 *PV3"
		addtext = addtext + "SITE TYPE=%s, POS=%s\n" % (ntypedic[string.atoi(CNum)], Pos)
	fr.close()
################################################################################

	flog  = open("../result/ResultWindow.dat","wt")	
	fr	= open("resultwin.data","rt")
	s	= string.join(fr.readlines())
	fr.close()
	s = s+"\n------------------------------------\n"
	try:
		fr	= open("reserr.data","rt")
		s	= s+string.join(fr.readlines())
		fr.close()
	except:
		pass
	resultmes	=	s
	
	outfile	=	os.path.join(os.getcwd()	,"crystr.out")
	if os.path.exists(outfile)!=1:
		flog.write(resultmes)
		
	fr	=	open("parameter.data","rt")
	SiteNum = string.atoi(fr.read())
	fr.close()

	outdata 	= ""
	outclass	=	string.split(outxxx,"\n")
	
	if arg==0:
		outtmp		=	string.split(outclass[0])
		outtmp2 = ""
		for i in range(len(outtmp)):
			if i == 0:
				continue
			outtmp2 = outtmp2 + " " + outtmp[i]
					
		OutGen = "<GEN>\n"  + outtmp2 + "\n" +  "</GEN>\n"
	else:
		OutGen = ""
	
	outclass	=	outclass[1:]
	skipoutcl=0
	if(len(string.strip(string.join(outclass)))==0): skipoutcl=1
	NSiteNum	=	1
	GENflg		=	0
	GENflg2 = 0		
	csyfile = open( "xxx.csy1")
	wtext = csyfile.read()
	wtext = string.split(wtext,"\n")		
	for nline in range(len(wtext)):
		s	=	wtext[nline]
		s2	=	string.lstrip(s)			# remove space
		if len(s)==0 and GENflg==0 :
			continue #takao
		if GENflg==0 and s[0]!="#":
			outdata = outdata + OutGen+"\n"
			GENflg=1
		if arg==0:
			if string.find(s2,"<GEN>")==0:
				GENflg2 = 1
				continue
			if string.find(s2,"</GEN>") == 0:
				GENflg2 = 0
				continue
			if GENflg2 == 1:
				continue		
		if string.find(s2,"SITE")==0:
			outdata = outdata + s +"\n"
			if NSiteNum==SiteNum and skipoutcl==0:
				try:
					ISiteNum	=	0
					while 1:
						s			=	string.strip(outclass[ISiteNum])+"\n"
						outdata 	=	outdata + s
						ISiteNum	=	ISiteNum+1	
				except:
					pass
			NSiteNum	=	NSiteNum+1
		else:
			outdata = outdata + s +"\n"
			pass
	os.remove("resultwin.data")
	os.remove("crystr.in")
	
	fw = open("../result/EditWindow.dat","wt")
	fw.write(outdata)
	fw.write(addtext)
	flog.write("==== Generator ====\n"+resultmes)
	
	
	
	
