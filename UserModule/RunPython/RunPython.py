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
	# read Edit window
	fw = open("./temp/xxx.csy1","rt")
	EditWindow = fw.read()
	# run ccc as python, output is going to ResultWindow.
	print "======== This is a test (UserModule/RunPython/RunPython.py) ====="
	exec EditWindow
	
	
	
	
