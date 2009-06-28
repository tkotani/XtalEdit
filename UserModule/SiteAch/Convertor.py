import sys
import os
import os.path
import string
import thread
import time

from numpy import *
from numpy.linalg import *
#from Numeric import *
#from LinearAlgebra import *
sys.path.append("./UserModule/Common")
sys.path.append("./UserModule/SiteAch")

from Converter import Converter
from addSite import *
def SetSiteInfo(wtext,outxxx):
	outdata = ""
	NSiteNum	=0
	wtext	=	string.split(wtext,"\n")
	for nline in range(len(wtext)):
		s = wtext[nline]
		s2 = string.lstrip(s)
		if string.find(s2,"SITE")==0:
			if NSiteNum==0:
				outdata	=	outdata	+outxxx
			NSiteNum	=	NSiteNum+1
		else:
			outdata = outdata + wtext[nline]+"\n"
			pass

	return outdata


#############################################################
## Main Routinue ############################################
if __name__ == '__main__':

	### 1. User set CSY File PATH ###
	csyFilePath = "./temp/xxx.csy1"
	
	### 2. Create Conveter Object ###
	A = Converter(csyFilePath)

	exec A.script
        print ' 222 EX=',EX
        print ' 222 PV1[0]=',PV1[1]
	arg = string.atoi(sys.argv[1])
        print ' bbb arg=',arg
        print ' CV=',CV1,CV2,CV3
	
	execfile("./UserModule/SiteAch/ChVec.form")
	
	fr = open("./UserModule/SiteAch/Site.dat")
	output = fr.read()
	
	outdata = SetSiteInfo(A.csy,output)
	
	fw = open("./result/EditWindow.dat","wt")
	fw.write(outdata)
	fw.close()
	
	flog = open("./result/ResultWindow.dat","w")
	flog.write("===== Base Change ( EV ) =====\n")
	flog.write(output)
	flog.close()
	
