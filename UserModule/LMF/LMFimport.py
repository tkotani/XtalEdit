#!/usr/bin/python
# For LMF
import sys
import os
from numpy import *
#from numpy.linalg import *
#from Numeric import *
import string
import re

def sitestringPV(s1,s2,s3):
	add=' '
	if string.find(s1,'-')==0: add=''
	sitedata= add+s1+ " *a*EX"
	add=' +'
	if string.find(s2,'-')==0: add=' '
	sitedata = sitedata + add + s2+ " *a*EY"
	add=' +'
	if string.find(s3,'-')==0: add=' '
	sitedata = sitedata + add + s3+ " *a*EZ"
	return sitedata

def getblock(wtext,key):
	out=''
#	print 'ssssssssssss len=',len(key)
	ix=0
	for iline in wtext:
		if(string.find(iline,'#')==0): continue
		if ix==1 and string.strip(iline[0:1])!="":	
			break
		if iline[0:len(key)]==key:	ix=1
		if(ix==1): out=out+iline
	sss1=string.replace(out[len(key):], '=',' = ')
	sss2=string.replace(sss1, ',',' ')
	return string.split(sss2)

def getdat(wtext,category,token,nsize):
	ic=-1
	if nsize!=1 :
		dat=['None']*nsize
	for sss in getblock(wtext,category):
		if sss==token: ic=0
		if ic>=1 and ic<=nsize:
			if nsize!=1: 
				dat[ic-1]=sss
				if ic==nsize : break
				ic=ic+1
			else:
				dat=sss
				break
		if ic==0 and sss=='='	 : ic=1
	return dat

def getdat2(wtext,category,token):
	ic=-1
	out=''
	for sss in getblock(wtext,category):
		if sss==token and ic==1: 
			ic=0
			out=out+'\n'
		if sss==token: ic=0
		if ic>=1:
			out=out + ' '+ sss
		if ic==0 and sss=='='	 : ic=1
	return string.split(out,'\n')

def findpos(sssx,key):
	for i in range(len(sssx)):
		if sssx[i]==key: break
	return i

#############################################################
## Main Routinue ############################################
if __name__ == '__main__':
	
	### 1. User set CSY File PATH
	csyFilePath = "./temp/xxx.csy1"
	fr=open(csyFilePath,"rt")
	wtext = fr.read()
	wtext = string.split(wtext, "\n")


# skip structure-related sections
#	lmfsec='<lmf>\n'
#	ix=1
#	for iline in wtext:
#		if iline[0:1]=="#":	continue
#		if ix==0 and iline[0:1]!=" ":	ix=1
#		if iline[0:4]=="SITE":	ix=0
#		if iline[0:5]=="CONST":	ix=0
#		if ix==1:	lmfsec=lmfsec+iline+"\n"
#	lmfsec= lmfsec + '</lmf>'+ "\n" + "\n"
#
	lmfsec=''	

	print ' ===== start LMFimport ======'
	sss=''
	for iline in wtext:
		if(string.find(iline,'#')==0): continue
		sss = sss+iline+'\n'
	sss = string.replace(sss, '=','= ')
	sss = string.split(sss)

#	for x in sss:
#		print x

### CONST section ###
	constdat0 = getblock(wtext,"CONST")
	constdat=''
	idat =''
	ixold=''
	ix=''
	for ix in constdat0:
#		print ix
		if ix=='=':
			constdat= constdat+idat+'\n'
			idat=''
		idat = idat +ixold
		ixold=ix
	constdat = constdat +idat+ix+'\n'

### PV section ###
	alat = getdat(wtext,"STRUC","ALAT",1)
	plat = getdat(wtext,"STRUC","PLAT",9)
	alatline=  'alat=%s' % alat
	platline1= 'PV1= alat*(%s)*EX + alat*(%s)*EY + alat*(%s)*EZ\n' % (plat[0],plat[1],plat[2])
	platline2= 'PV2= alat*(%s)*EX + alat*(%s)*EY + alat*(%s)*EZ\n' % (plat[3],plat[4],plat[5])
	platline3= 'PV3= alat*(%s)*EX + alat*(%s)*EY + alat*(%s)*EZ\n' % (plat[6],plat[7],plat[8])
	platline= platline1+platline2+platline3 + 'CV1=PV1\nCV2=PV2\nCV3=PV3\n'

### SITE section ###
	print ' --- readin SITE.ATOM.POS ----'
	outdata=''
	sss = getdat2(wtext,"SITE","ATOM")
	for atomline in sss:
#		print atomline
		sssx=string.split(atomline)
#		print sssx
		i = findpos(sssx, 'POS') +1
		stype= sssx[0]
		pos1 = sssx[i+1]
		pos2 = sssx[i+2]
		pos3 = sssx[i+3]
		print stype,pos1,pos2,pos3
		outdata = outdata+ 'SITE TYPE=%s, POS= (%s)*alat*EX+ (%s)*alat*EY + (%s)*alat*EZ \n' % (stype,pos1,pos2,pos3)

### CLASS section ###
	print ' --- readin CLASS.ATOM ----'
	sss = getdat2(wtext,"CLASS","ATOM")
	for atomline in sss:
#		print atomline
		sssx=string.split(atomline)
#		print 'xxxxxxxxxxxxxxxxxxxx',sssx
		stype= sssx[0]
		zzz  = sssx[findpos(sssx,'Z') +2 ]
		outdata = outdata+ 'TYPE %s ATOM=(%s:1.0) ' % (stype,zzz)
		try:
			rmt  = sssx[findpos(sssx,'R') +2 ]
			outdata = outdata+ ' ,RMT=%s' % (rmt)
		except:
			pass
		try:
			rmt  = sssx[findpos(sssx,'LMX') +2 ]
			outdata = outdata+ ' ,LMX=%s' % (rmt)
		except:
			pass
		outdata = outdata+ '\n'
	
	fedit = open("./result/EditWindow.dat","wt")
	fedit.write(constdat + '\n'  + alatline + '\n' + 'a=alat\n' + platline + '\n' +outdata + '\n' + lmfsec)
#	fedit.write(constdat)
#	fedit.write( outdata )

	flog  = open("./result/ResultWindow.dat","wt")
	flog.write("O.K! LMF input is transformed to *.csy\n")
	flog.close()

