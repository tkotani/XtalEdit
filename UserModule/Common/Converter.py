#################################################################################
## Converter.py
## Takefumi SORA
## Converter Type can be used to get infomation  about *.csy.
## User can use this class as follows.
## 1, "Converter" module must be imported to use Converter module
##	from Converter import Converter
## 2, User set *.csy file PATH
##	csyFilePath = "./extendedModule/AkaiKKRExport/Al0Fe100.csy"
## 3, Create Convert Object : Converter Object has a file PATH as an argument
##	A = Converter(csyFilePath)
## 4, User write script for each module
##		if you want TYPE infomation ---- Obj.TYPE (get dictionary style)
##									---- Obj.TYPE["La"]["LMX"] (get La LMX)
##									---- Obj.TYPE["La"]["ATOM"] ( get La composition)
##		if you want SITE infomation ---- Obj.SITE (get dictionary style)
##									---- Obj.SITE[0][TYPE] (first entry TYPE info)
##									---- Obj.SITE[0][PosData] (first entry postion data)
##		if you want CV1  infomation ---- Obj.CV1
##		if you want PV1  infomation ---- Obj.PV1
##		if you want Number of Sites ---- Obj.SiteNum
##		if you want Number of Type  ---- Obj.TypeNum
##
## ConverterExample.py is an example of use of Converter.py.

import string
import os
from KeyWord import *
from addSite import *
class Converter:
	def __init__(self,path):
		
		#######################
		### member variable ###
		
		self.path = path   # path
		self.csy  = ""     # copy csy file
		self.script = ""   # translated python script
		
		##############################
		## file open and Initialize ##
		
		outtext =''
		fr = open(self.path,"rt")
		editText = fr.read()
		self.csy = editText
		wtext = string.split(editText,"\n") 
		fr.close()
		KeyNum			=	{}
		CheckKey		=	{"SITE": 1, "TYPE": 1 ,"GEN": 0}	
		for Key in CheckKey.keys():
			KeyNum[Key] = 0

		### Header part ###
		outtext = outtext +"import sys\n"
		outtext = outtext +"sys.path.append(\"./UserModule/Common\")\n"
		outtext = outtext +"from addSite import *\n"
#		outtext = outtext +"from Numeric import * \nEX = array((1., 0., 0.))\nEY = array((0., 1., 0.)) \nEZ = array((0., 0., 1.))\n"
		outtext = outtext +"from numpy import * \nEX = array((1., 0., 0.))\nEY = array((0., 1., 0.)) \nEZ = array((0., 0., 1.))\n"
		outtext = outtext + "Site = {}\n"
		outtext = outtext + "Type = {}\n"
		
		### Convert to Python Script  ##
	   	Tag = 0
		for nline in range(len(wtext)):
			s	= wtext[nline]
			s = string.replace(s,"\r","")
			s2	= s
			
			if Tag == 0 and  string.find(s2,"<")==0 and string.find(s2,">")>0:
				outtext = outtext + "#" + s + "\n"
				Tag			= 1
				Tagkey		=	s[1:string.find(s,">")]
				Tagendkey	=	"</%s>" % Tagkey
				fwTag		=	open(os.path.join("./temp",Tagkey+".sec"),"wt")
				continue
			elif Tag==1:
				if string.find(s,Tagendkey)==0:
					outtext = outtext + "#" + s + "\n"
					Tag	=	0
					fwTag.close()
				else:
					fwTag.write(s+"\n")
					outtext = outtext + "#" + s + "\n"
				continue

			## Delete comment and add string ###
			if string.find(s,"#")>=0:
				s=s[:string.find(s,"#")]
			if s == '' :
				outtext = outtext + "\n"
				continue
			
			## Hold Hspace ###
			hspace = ""
			for c in s:
				if c=="\t" or c==" ":
					hspace = hspace+c
				else:
					break
			
			## Site , TYPE Keyword ##
			s2	= string.lstrip(s)			# remove space
			if string.find(s2,"SITE")==0:	# KeyWord: SITE
				Site	= SiteProcessing(s,KeyNum["SITE"])
				#outtext = outtext + hspace+"Site[%d] = %s\n" % (KeyNum["SITE"], Site)
				#outtext = outtext + hspace+"Site[%d][\"PosData\"] = %s\n" %(KeyNum["SITE"], Site["POS"])
				#addSite(Site,'AlFe','0.00000000 *EX +0.00000000 *EY +0.00000000 *EZ',0.00000000 *EX +0.00000000 *EY +0.00000000 *EZ)
				outtext = outtext + hspace +"addSite(Site,'%s','%s',%s)\n" % (Site["TYPE"],Site["POS"],Site["POS"])
				#KeyNum["SITE"]	=	KeyNum["SITE"]+1
			elif string.find(s2,"TYPE")==0:	# KeyWord: Type
				TypeE	=	TypeProcessing(s ,1)
				outtext = outtext + hspace + str(TypeE) + "\n"
				KeyNum["TYPE"]	=	KeyNum["TYPE"]+1
			else:
				outtext = outtext +s+"\n"
				pass

		outtext = outtext + 'SiteNum  = len(Site)\n'
		outtext = outtext + 'TypeNum = len(Type)\n' 
		outtext = outtext + 'for Mat in Site.keys():\n'
		outtext = outtext + '	EMat=array([0., 0., 0.])\n'
		outtext = outtext + '	try:\n'
		outtext = outtext + '		Site[Mat]["PosData"]	=	Site[Mat]["PosData"]+EMat\n'
		outtext = outtext + '	except:\n'
		outtext = outtext + '		Site[Mat]["PosData"] = EMat\n'
		outtext = outtext + '		Site[Mat]["POS"]	=	"0."\n'
		
		fw = open("./temp/xxx.py","wt")
		fw.write(outtext)
		fw.close()

## set value
		self.script = outtext
