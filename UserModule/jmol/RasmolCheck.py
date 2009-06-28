import os.path
import sys
import string
import shutil

os.chdir(os.path.join("UserModule","Rasmol"))

KeyWord = "No suitable"
TmpFile = "tmp.data"
for rasexe in ("./rasmol_32BIT","./rasmol_16BIT","./rasmol_8BIT"):
	try:
		print "Testing Rasmol=",rasexe,
		os.system(rasexe+" -script check.ras > "+TmpFile)
		fw= open("tmp.data","rt")
		s = fw.read()
		if string.find(s,KeyWord)<0:
			shutil.copy(rasexe,"rasmol")
			print "---> this version works OK!"
			break
		else:
			print 
	except:
		pass
else:
	print "You have to install Rasmol!"

