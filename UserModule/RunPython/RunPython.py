#!/usr/bin/python
import sys
import os
import os.path
import string
import thread
import time

from numpy import *
#from LinearAlgebra import *

sys.path.append("./UserModule/Common")
from Converter import Converter
from addSite import addSite

#############################################################
## Main Routinue ############################################
if __name__ == '__main__':

	### 1. User set CSY File PATH
	csyFilePath = "./temp/xxx.csy1"
	
	### 2. Create Conveter Object
	A = Converter(csyFilePath)

	### 3. Execute Traslated Script ###
	exec A.script
	
	### 4. Execute Module ###
	fw = open("./result/EditWindow.dat","wt")
	fw.write(A.csy)
	fw.close()
	
	
	
	
