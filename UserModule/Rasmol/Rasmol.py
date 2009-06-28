#!/usr/bin/python
import sys
import os
import os.path
import string
import thread
import time

from numpy import *
from numpy.linalg import *

sys.path.append("./UserModule/Common")
sys.path.append("./UserModule/Rasmol")
from RemoveTaggedSection import RemoveTaggedSection
from Converter import Converter
from addSite import *
import RasConf


def RasExe():
	os.chdir(os.path.join(".","UserModule/Rasmol"))
	os.system(os.path.join(".","rasmol -script rastest.ras"))
#############################################################
## Main Routinue ############################################
if __name__ == '__main__':

	### 1. User set CSY File PATH
	csyFilePath = "./temp/xxx.csy1"
	
	### 2. Create Conveter Object
	A = Converter(csyFilePath)

	### 3. Execute Translated Python Script
	exec A.script
	
	### 4. Write csy except RASMOL tagged section
	fw = open("./result/EditWindow.dat","wt")
	output = RemoveTaggedSection(A.csy,"RASMOL")
	fw.write(output)
	fw.close()
	
	### 5. Execute Rasmol Form
	execfile("UserModule/Rasmol/rasmol.form")
	thread.start_new_thread(RasExe, ())
	time.sleep(0.1)
	
	
