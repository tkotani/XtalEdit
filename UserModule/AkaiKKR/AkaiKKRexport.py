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
sys.path.append("./UserModule/AkaiKKR")
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
# for setting primitive vector--- for older AkaiKKR.
# See cpa2002v005/source/prmvec.f
	pvecline= "# this aux option is only effective for newest versions of AkaiKKR\n"+ \
	" aux\n%18.12f %18.12f %18.12f\n%18.12f %18.12f %18.12f\n%18.12f %18.12f %18.12f\n %18.12f"  % \
	(PV1[0]/a,PV1[1]/a,PV1[2]/a,
	 PV2[0]/a,PV2[1]/a,PV2[2]/a, 
	 PV3[0]/a,PV3[1]/a,PV3[2]/a,a )
	return pvecline

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
#############################3
        print A.script
###########################
	exec A.script
	flog  = open("./result/ResultWindow.dat","wt")	
	
	enginekey='AkaiKKR'
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
	err=''

### Set default values. 
	edelt = 0.001
	ewidth= 1.0
	reltyp= 'sra'
	sdftyp= 'vwn'
	magtyp= 'nmag'
	record= '2nd'
	outtyp= 'update'
	bzqlty= 't'
	maxitr= 40
	pmix  = 0.020
	go  = 'go'
	TypeKey = {'field':'0.000'}

	for i in Type:
		for ikey in TypeKey:
			Type[i][ikey+enginekey] = TypeKey[ikey]
			
### readin values overide default values.
# Read <enginekey> section, which is a part of *.csy sandwitched with Tag <enginekey>.
# A version supporting CLASS key.
	try:
		Section	= "./temp/AkaiKKR.sec"
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
				sys.exit()
		fr.close()
		os.remove(Section)
	except:	pass

### pvec lines
	pvecline = setpvecline(PV1,PV2,PV3,a)
	
### type lines
	typeline=''
	for i in Type:
#		print i,Type[i]["ATOM"]
		comp,conc,l_max,ncom = Concsolve(Type[i]["ATOM"])
		try: 
			rmt=Type[i]['RMT']
		except:
			rmt='0.'
		try:
			print i,' LMX',Type[i]['LMX']
		except:
			err = 'LMX is not set. For default. Push ChkType again!'
			print 'error LMX is not set'
			flog.write(err)
			sys.exit()
		
		head = '  %s   %d         %s  %s   %s     ' %\
	       	  (i, ncom, rmt, Type[i]['field'+ enginekey],Type[i]['LMX']) #
		typeline= typeline + head + '%s %6.2f \n' % 	(comp[0], conc[0]) #
		if(len(comp)-1):
			for ix in range(1,len(comp)):
				typeline = typeline + ' '*len(head) + '%s %6.2f \n' % (comp[ix], conc[ix])

### site lines
	if(abs(det(array([PV1,PV2,PV3])))<1e-6):
		err= 'Wrong input!: ====== PV are not linear independent ========= '
		flog.write(err)
	mat= inv(transpose(array([PV1,PV2,PV3])))
	siteline=''
	for i in range(SiteNum):
# These are cartesian
#		pt=Site[i]['PosData']
#		siteline= siteline + '%18.12f %18.12f %18.12f  %s \n' % (pt[0],pt[1],pt[2],Site[i]["TYPE"])
		pt=dot(mat	,Site[i]["PosData"])
		siteline= siteline + '%18.12fa %18.12fb %18.12fc  %s \n' % (pt[0],pt[1],pt[2],Site[i]["TYPE"])

#### main printing from here
	result= result + '''
#----------------------- input data    ----------------------------#
# go/ngo/dos/dsp/spc    file name
 %s                     %s

#- primitive vector --------------------------------------#
%s             

#- edelt  ewidth  nrl/sra mjw/vbh/vwn mag/nmag/-mag/rvrs/kick ------#
   %6.4f  %6.4f  %s    %s        %s                  

#- init/1st/2nd quit/update  0/1/2/../t/l/m/h/u iteration  pmix -#
    %s         %s          %s                %d       %7.5f

#- number of type   -----------------------------------------------#
 %d
# type components rtin  field l_max  Z  concentration----------#
%s
#   number of atoms------------------------------------------------#
 %d
#-  position  ---------------------------------------------- type -#
%s
'''  % (go,fname,pvecline, \
		edelt,ewidth,reltyp,sdftyp,magtyp,record,outtyp,bzqlty,maxitr,pmix, \
		TypeNum, typeline, SiteNum, siteline)

# # primitive vector pvec--------------------------------------------#
# %s
	print result
	flog.write(result)
