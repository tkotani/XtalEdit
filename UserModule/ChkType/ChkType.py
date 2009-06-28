#!/usr/bin/python
import sys
import os
import os.path
import string
import thread
import time

sys.path.append("./UserModule/Common")
from addSite import *

from Converter import Converter
from AddType import AddType
from CompType import CompType
from KeyWord import *

def AddWrite(wtext,outxxx):
	outdata = wtext
	while 1:		# delete last empty lines
		if outdata[len(outdata)-1]=="\n":
			outdata=outdata[:-1]
			if len(outdata)==0:
				break
		else:
			break
	outdata = outdata +"\n"
	outdata = outdata+outxxx

	fw	=	open("./result/EditWindow.dat","w")
	fw.write(outdata)
	fw.close()

def CompWrite(wtext,outxxx):
	outdata = ""
	slist	=	string.split(outxxx,"\n")
	slist	=	slist[:-1]
	print slist

	CDic = {}
	for i in range(len(slist)):
		CDic[string.split(slist[i])[1]]=slist[i]
	#fw = open("tmp.data","wt")
	wtext = string.split(wtext,"\n")
	Tag=0
	for nline in range(len(wtext)):
		s = wtext[nline]
		if s == '' :
			outdata = outdata + "\n"
			#fw.write("\n")
			continue
		s2	= string.lstrip(s)			# remove space

### Do nothing for TagSections
		if Tag == 0 and  string.find(s,"<")==0 and string.find(s,">")>0:
			Tag			= 1
			Tagkey		=	s[1:string.find(s,">")]
			Tagendkey	=	"</%s>" % Tagkey
		if Tag==1 :
			outdata = outdata + s+"\n"
			#fw.write(s+"\n")
			if Tag == 1 and string.find(s,Tagendkey)==0: Tag = 0
			continue

		if string.find(s2,"TYPE")==0:	# KeyWord: SITE
			key = string.split(s)[1]
			if CDic.has_key(key)==1:
				str =	CDic[key]+"\n"
				dic	=	TypeProcessing(str ,2)
				exec "Type={}\n"+dic
				str = "TYPE "+key+" ATOM="
				for mat in Type[key]["ATOM"].keys():
					str = str+"(%s:%s)" % (mat	,Type[key]["ATOM"][mat])
				del Type[key]["ATOM"]
				str	=	str+" ,LMX = %s" % Type[key]["LMX"]
				del Type[key]["LMX"]
				str	=	str+" ,RWS = %s" % Type[key]["RWS"]
				del Type[key]["RWS"]
				for classkey in Type[key].keys():
					str = str+" ,%s = %s" % (classkey, Type[key][classkey])

				outdata = outdata + str+"\n"
				#fw.write(str+"\n")
			else:
				outdata = outdata + s+"\n"
				#fw.write(s+"\n")
		else:
			outdata = outdata + s+"\n"
			#fw.write(s+"\n")
			pass
	#fw.close()

	#fr	=	open("tmp.data","rt")
	#outdata = fr.read()
	#fr.close()
	#os.remove("tmp.data")
	#fr	=	open("xxx.out","rt")
	#res = fr.read()
	#fr.close()
	#os.remove("xxx.out")
	#return (outdata,"-- Compensat Type Data --\n"+res)
	
	fw	=	open("./result/EditWindow.dat","w")
	fw.write(outdata)
	fw.close()

#############################################################
## Main Routinue ############################################
if __name__ == '__main__':

	### 1. User set CSY File PATH
	csyFilePath = "./temp/xxx.csy1"
	
	### 2. Create Conveter Object
	A = Converter(csyFilePath)

	### 3. ResultWindow
	flog = open("./result/ResultWindow.dat","w")
	AddObj = AddType(A.script)
	if AddObj.outdata!="":
		AddWrite(A.csy,AddObj.outdata)
		flog.write("===== AddClass =====\n")
		flog.write(AddObj.outdata)
	else:
		CompObj = CompType(A.script)
		if CompObj.outdata!="":
			CompWrite(A.csy,CompObj.outdata)
			flog.write("===== Compensate Class Data =====\n")
			flog.write(CompObj.outdata)
	flog.close()

