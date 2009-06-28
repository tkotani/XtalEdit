import string
import os
import sys
sys.path.append("./UserModule/Common")
from AtomData import AtomData

class AddType:
	def __init__(self,script):
		
		### member variable ###
		self.script = script   # translated python script
		self.outdata = ""
		
		exec self.script
		
		for i in range(len(Site)):
			key = Site[i]["TYPE"]
			if Type.has_key(key)==0:
				sym	=	"???"
				for z in range(104):
					if len(AtomData[z])!=2:
						continue
					if string.find(key,AtomData[z])!=-1:
						sym	=	AtomData[z]
						break
				if sym=="???":
					for z in range(104):
						if len(AtomData[z])==2:
							continue
						if string.find(key,AtomData[z])!=-1:
							sym	=	AtomData[z]
							break

				self.outdata = self.outdata + "TYPE %s ATOM = (%s:1.0)\n" % (key,sym)
				Type[key] = ""
