#!/usr/bin/python
import sys
import os
import os.path
import string
import thread
import time
import re
from numpy import *
from numpy.linalg import *
#from Numeric import *
#from LinearAlgebra import *

sys.path.append("./UserModule/Common")
sys.path.append("./UserModule/SuperCell")
from Converter import Converter
import supersub
import KeyWord


#############################################################
## Main Routinue ############################################
if __name__ == '__main__':
	
	### 1. User set CSY File PATH
	csyFilePath = "./temp/xxx.csy1"
	
	### 2. Create Conveter Object
	A = Converter(csyFilePath)

	exec A.script

	flog  = open("./result/ResultWindow.dat","wt")
	flog.write("===== Super Cell =====\n")

	CheckVariable	=	["SV1"	,"SV2"	,"SV3"
						,"PV1"	,"PV2"	,"PV3"]

	nnn,SV1t,SV2t,SV3t,Trans= supersub.GenSuperCell(SV1,SV2,SV3,PV1,PV2,PV3)
	outxxx = "SV1n = %s\n" % supersub.PVtoPVo(SV1t)
	outxxx = outxxx + "SV2n = %s\n" % supersub.PVtoPVo(SV2t)
	outxxx = outxxx + "SV3n = %s\n" % supersub.PVtoPVo(SV3t)

	outxxx = outxxx +  "%d\n" % len(Trans)
	for i in range(len(Trans)):
		outxxx = outxxx + "Trans%d =%s\n" % (i,supersub.PVtoPVo(Trans[i]))
	outxxx2=outxxx
###############################################################################
	
	outdata = ""
	NSiteNum=	0
	PVKeyNum=	0
	StCount	=	0
	outxxx	=	string.split(outxxx,"\n")
	NewKey	=	{}
	for i in range(3):
		SV = "SV%1d" % (i+1)
		NewKey[SV]	=	outxxx[StCount]
		StCount	=	StCount+1
	for i in range(3):
		NewKey["PV%1d" % (i+1)]	=	"PV%d = SV%dn" % (i+1 ,i+1)
		if i==2:
			NewKey["PV%1d" % (i+1)]=NewKey["PV%1d" % (i+1)]+"\n"
	
	Trans	=	[]
	TNum	=	string.atoi(outxxx[StCount])
	print TNum
	StCount	=	StCount+1
	for i in range(TNum):
		Trans.append(outxxx[StCount])
		StCount	=	StCount+1
	
	fww = open(csyFilePath,"rt")
	wtext = fww.read()
	wtext	=	string.split(wtext,"\n")
	SVNum	=	0

#	RasMaxNum	=	0
#	RasMinNum	=	0
	for nline in range(len(wtext)):
		s = wtext[nline]
		hspace = ""                               # add T.sora
		for c in s:                               #
			if c=="\t" or c==" ":                 #
				hspace = hspace+c                 #
			else:                                 #
				break                             #
		s2	= string.lstrip(s)			# remove space
		flg = 0                                   # add T.sora 2003/8/26 write Flag
		if string.find(s2,"SV")==0:
			SVNum	=	SVNum+1
		elif string.find(s2,"PV")==0:
			sss=string.replace(s,  'PV1','PV1o')
			sss=string.replace(sss,'PV2','PV2o')
			sss=string.replace(sss,'PV3','PV3o')
		   	outdata = outdata + sss + "\n"
		elif string.find(s2,"CV")==0:
			flg=1                                 # add T.Sora 2003/8/26
			sss=string.replace(s,  'PV1','PV1o')  #
			sss=string.replace(sss,'PV2','PV2o')  #
			sss=string.replace(sss,'PV3','PV3o')  #
		   	outdata = outdata + sss + "\n"        #
		for key in CheckVariable:
			#flg = 0
			if	string.find(s2,key)==0:
				PVKeyNum=	PVKeyNum+1
				flg		=	1
				if	PVKeyNum==6:
					for s in ("SV1","SV2","SV3","PV1","PV2","PV3"):
						outdata	=	outdata + NewKey[s]+"\n"
					for s in Trans:
						outdata = outdata + s+"\n"
				break
		if flg==1:
			continue
		if string.find(s2,"SITE")==0:
			if SVNum!=3:
				flog.write("=== Error ===\nSV should be given before SITE\n")
			outdata = outdata + "# "+s+"\n"		# Backup original SITE Infomation
			
			if string.find(s,"#")>0:
				s	=	s[:string.find(s,"#")]
			# Keep original algebraical position
			Site	= KeyWord.SiteProcessing(s)
			for i in range(len(Trans)):
				outdata = outdata + hspace +"SITE "
				flog.write("SITE ")
				for key in Site.keys():
					if key!="POS":
						outdata = outdata + key + "= "+Site[key] + " ,"
						flog.write(key + "= "+Site[key] + " ,")
				sss=string.replace(Site["POS"],'PV1','PV1o')
				sss=string.replace(sss,'PV2','PV2o')
				sss=string.replace(sss,'PV3','PV3o')
				outdata = outdata + "POS = "+ sss+" + Trans%d\n" % i
				flog.write("POS = "+ sss+" + Trans%d\n" % i)
		else:
			outdata = outdata + wtext[nline]+"\n"
			pass
	while 1:
		if outdata[-1]=="\n":
			outdata=outdata[:-1]
		else:
			outdata=outdata + "\n"
			break
		

	#### Set Result to File #####
	fedit = open("./result/EditWindow.dat","a+")
	fedit.write(outdata)
	fedit.close()
	flog.close()

		
