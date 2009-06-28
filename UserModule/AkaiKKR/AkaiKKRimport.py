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

def sitestring(s1,s2,s3):
	add=' '
	if string.find(s1,'-')==0: add=''
	sitedata= add+s1+ " *a*EX"
	add=' +'
	if string.find(s2,'-')==0: add=' '
	sitedata = sitedata + add + s2+ " *a*EY"
	add=' +'
	if string.find(s3,'-')==0: add=' '
	sitedata = sitedata + add + s3+ " *a*EZ"
	print 'cccccccccc----- ',sitedata
	sitedata= re.sub('a \*a\*E[X-Z]', " *PV1", sitedata)
	sitedata= re.sub('b \*a\*E[X-Z]', " *PV2", sitedata)
	sitedata= re.sub('c \*a\*E[X-Z]', " *PV3", sitedata)
	return sitedata

#############################################################
## Main Routinue ############################################
if __name__ == '__main__':
	
	### 1. User set CSY File PATH
	csyFilePath = "./temp/xxx.csy1"
	
	fedit  = open("./result/EditWindow.dat","wt")

	enginekey='AkaiKKR'
	print ' ===== start AkaiKKRimport ======'
	fr=open(csyFilePath,"rt")
	wtext = fr.read()
	
	wtext = string.split(wtext, "\n")
	
	sss=''
	for iline in wtext:
		if(string.find(iline,'#')==0): continue
		if(string.find(iline,'c')==0): continue
		if(string.find(iline,'C')==0): continue
		sss = sss+iline+'\n'
	sss = string.replace(sss, ',',' None ')
	sss = string.split(sss)
	ixx=0
	sssn=''
	for x in sss:
		if ixx==0  and x=="None": 
			ixx  =1
			inone=1
		elif ixx==1 and x=="None":
			inone=inone+1
		elif ixx==1 and x!="None":
			sssn=sssn + ' None'*(inone-1) + ' ' + x +' '
			ixx=0
		else:
			sssn=sssn + x + ' '
	sss = string.split(sssn)
	for x in sss:
		print x
# go fname
	akaiop  = "go ='%s'\nfname = '%s'\n"  % (sss[0],sss[1])
	print akaiop
# Bravais lattice
	c0=0.; 	c1=0.5; c2=-0.5; c3=1.; c4=-1.
	c5=0.8660254037844386; c6=-c5
	prmr=reshape(array([
		c0,c1,c1, c1,c0,c1, c1,c1,c0,  c2,c1,c1, c1,c2,c1, c1,c1,c2,
    	c1,c6,c0, c1,c5,c0, c0,c0,c3,  c3,c0,c0, c0,c3,c0, c0,c0,c3,
	    c2,c1,c1, c1,c2,c1, c1,c1,c2,  c3,c0,c0, c0,c3,c0, c0,c0,c3,
    	c0,c1,c1, c1,c0,c1, c1,c1,c0,  c2,c1,c1, c1,c2,c1, c1,c1,c2,
		c1,c2,c0, c1,c1,c0, c0,c0,c3,  c3,c0,c0, c0,c3,c0, c0,c0,c3,
		c1,c2,c0, c1,c1,c0, c0,c0,c3,  c3,c0,c0, c0,c3,c0, c0,c0,c3,
		c3,c0,c0, c0,c3,c0, c0,c0,c3,  c0,c0,c0, c0,c0,c0, c0,c0,c0,
		c0,c1,c1, c1,c0,c1, c1,c1,c0])
		,(15,3,3))
	print prmr[0,0,0],prmr[0,0,1],prmr[1,0,0]
	brtyp = sss[2]
	print ' brtyp=%s ' % brtyp
	PV1x=['None']*3
	PV2x=['None']*3
	PV3x=['None']*3
	boacoa=''
	if(brtyp=='aux'):
		for ix in range(3):
			PV1x[ix] = sss[3+ix]
			PV2x[ix] = sss[6+ix]
			PV3x[ix] = sss[9+ix]
		a = sss[12]
		print a,range(3)
		ix=12
	else:
		a     = sss[3]
		coa   = sss[4]
		boa   = sss[5]
		alpha = sss[6]
		beta  = sss[7]
		gamma = sss[8]
		print a,coa,boa,alpha,beta,gamma
#		ixx=9999
		if brtyp=='trc':
	  		boacoa = 'coa= ' +coa + '\n' + 'boa= ' +boa + '\n' \
	  		+ 'PI   = 3.1415926535897932\n'    \
	  		+ 'alpha= ' + alpha +' *PI/180.\n' \
	  		+ 'beta = ' + beta  +' *PI/180.\n' \
	  		+ 'gamma= ' + gamma +' *PI/180.\n' \
			+ 'cw= 1.-cos(alpha)**2-cos(beta)**2-cos(gamma)**2 + 2*cos(alpha)*cos(beta)*cos(gamma)'
			PV1x[0] = ' 1. ' 
			PV1x[1] = ' 0. '
			PV1x[2] = ' 0. '
			PV2x[0] = ' boa*cos(gamma) '
			PV2x[1] = ' boa*sin(gamma) '
			PV2x[2] = ' 0.0 '
			PV3x[0] = ' coa* cos(beta) '
			PV3x[1] = ' coa* (cos(alpha)-cos(beta)*cos(gamma))/sqrt(1.-cos(gamma)**2)'
			PV3x[2] = ' coa* sqrt(cw)/sqrt(1d0-(cos(gamma))**2)'
		elif brtyp=='rhb' or brtyp=='trg':
	  		boacoa = 'PI = 3.1415926535897932\n'    \
	  		+ 'theta= ' + alpha +' *PI/180.\n' \
	  		+ 'z = sqrt((.5+cos(theta))/(1.-cos(theta)))\n' \
	  		+ 'snrm=sqrt(1.+z**2)\n'
			PV1x[0] = ' .5*sqrt(3)/snrm '
			PV1x[1] = ' .5/snrm '
			PV1x[2] = ' z/snrm '
			PV2x[0] = ' -.5*sqrt(3.)/snrm '
			PV2x[1] = ' .5/snrm '
			PV2x[2] = ' z/snrm '
			PV3x[0] = ' 0.'
			PV3x[1] = ' -1/snrm'
			PV3x[2] = ' z/snrm'
		else:
			if brtyp=='fcc': ixx=0; boa='1.'; coa='1.'
			if brtyp=='bcc': ixx=1; boa='1.'; coa='1.'
			if brtyp=='hcp' or brtyp=='hex': ixx=2; boa='1.'
			if brtyp=='sc' : ixx=3; boa='1.'; coa='1.'
			if brtyp=='bct': ixx=4; boa='1.'
			if brtyp=='st' : ixx=5; boa='1.'
			if brtyp=='fco': ixx=6
			if brtyp=='bco': ixx=7
			if brtyp=='bso': ixx=8
			if brtyp=='so' : ixx=9
			if brtyp=='bsm': ixx=10
			if brtyp=='sm' : ixx=11
			if brtyp=='fct': ixx=14; boa='1.'
	  		boacoa= 'coa=%s\nboa=%s\n' % (coa,boa)
	
			for ix in range(3):
				PV1x[ix] = ' %15.12f    ' % prmr[ixx,0,ix]
				PV2x[ix] = ' %15.12f*boa' % prmr[ixx,1,ix]
				PV3x[ix] = ' %15.12f*coa' % prmr[ixx,2,ix]
		
		ix = 8
	akaiop  = akaiop +'''edelta = %s		
ewidth = %s
reltyp = '%s'
sdftyp = '%s'
magtyp = '%s'
record = '%s'
outtyp = '%s'
bzqlty = '%s'
maxitr = %s
pmix   = %s
''' 	% (sss[ix+1],sss[ix+2],sss[ix+3],sss[ix+4],sss[ix+5],
      	sss[ix+6],sss[ix+7],sss[ix+8],sss[ix+9],sss[ix+10])
	print akaiop
	
#Class data (type data)
	ix=ix+10
	TypeNum = string.atoi(sss[ix+1])
	print 'TypeNum'
	print TypeNum
	Type={}
	ic=ix+1
	for i in range(TypeNum):
		cname   = sss[ic+1]
		compnum = string.atoi(sss[ic+2])
		Type[cname]={}
		Type[cname]["RMT"]=sss[ic+3]
		Type[cname]["field"+enginekey]=sss[ic+4]

			
		Type[cname]["LMX"]=sss[ic+5]
		ic = ic+5

		atomx=''
		for icn in range(compnum):
			atomx = atomx + '('+sss[ic+1]+':'+sss[ic+2]+')'
			ic=ic+2
		Type[cname]["ATOMx"]=atomx
		for i in Type:	print i,Type[i]
		
#Site data
	snum  = string.atoi(sss[ic+1])
	print snum
	Site = {}
	ic=ic+1
	for i in range(snum):
			Site[i]={}
			Site[i]["TYPE"]=sss[ic+4]
			Site[i]["sitedata"] = sitestring(sss[ic+1],sss[ic+2],sss[ic+3])
			ic=ic+4
			print Site[i]["sitedata"],Site[i]["TYPE"]
	
# write *.csy
	outdata= 'a= %s\n' % a
	outdata= outdata+ boacoa
	outdata= outdata+ 'PV1= '+ sitestringPV(PV1x[0],PV1x[1],PV1x[2]) +'\n'
	outdata= outdata+ 'PV2= '+ sitestringPV(PV2x[0],PV2x[1],PV2x[2]) +'\n'
	outdata= outdata+ 'PV3= '+ sitestringPV(PV3x[0],PV3x[1],PV3x[2]) +'\n'
	outdata= outdata+ '\n'
	outdata= outdata+ 'CV1=PV1 #these are dummy for rasmol\nCV2=PV2\nCV3=PV3\n'

	outdata= outdata+ '\n'
	for i in range(snum):
		outdata= outdata+ 'SITE TYPE=%s, POS= %s\n' % (Site[i]["TYPE"],Site[i]["sitedata"])
	outdata= outdata+ '\n'
	for ic in Type:
		outdata= outdata+ 'TYPE %s ATOM=%s, LMX=%s, RMT=%s\n' % \
			            (ic, Type[ic]["ATOMx"], Type[ic]["LMX"], Type[ic]["RMT"])
	outdata= outdata+ '\n'
	outdata = outdata+ '<AkaiKKR>\n'
	outdata = outdata+ akaiop
	for ic in Type:
		outdata= outdata+ 'TYPE %s field=%s\n'  % \
			            (ic, Type[ic]["field"+enginekey])
	outdata= outdata+ '</AkaiKKR>\n'
	
	fedit.write(outdata)

	flog  = open("./result/ResultWindow.dat","wt")
	flog.write("O.K! AkaiKKR input is transformed to *.csy\n")
	flog.close()

	
