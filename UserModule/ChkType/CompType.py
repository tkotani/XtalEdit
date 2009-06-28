import string
import os
import sys
from numpy import *
from numpy.linalg import *
#from Numeric import *
#from LinearAlgebra import *

sys.path.append("./UserModule/Common")
from AtomData import AtomData
from ConstantData import *

class CompType:
	def __init__(self,script):
		
		### member variable ###
		self.script = script   # translated python script
		self.outdata = ""
		
		exec self.script

		CheckList	=	{}

		Vall	= abs(det(array([PV1,PV2,PV3])))
		V3Sum	=	0.0
		RWSNewDic	=	{}
		MatDic		=	{}

		for key in Type.keys():							#	key: Type Name
			if Type[key].has_key("ATOM")==0:
				#	Error: ATOM data is nothing
				continue
			Mat	=	Type[key]["ATOM"].keys()				#	Mat: Atomic Number List
			MaxMatN	=	0
			MaxV	=	0.0
################################################################################
## LMX #########################################################################
			for z in Mat:									#	z:	Atomic Number
				Rate	=	string.atof(Type[key]["ATOM"][z])
				if Rate>MaxV:
					MaxV	=	Rate
					MaxMatN	=	z
			LMXNew	=	AtomData[AtomData[z]]["LMX"]		#	AtomData[z]: Atomic symbol
#takao			if Type[key].has_key("LMX")!=1 or LMXNew!=Type[key]["LMX"]:
			if Type[key].has_key("LMX")!=1:
				Type[key]["LMX"]	=	str(LMXNew)
				CheckList[key]		=	1

################################################################################
## RWS #########################################################################
			RateSum	=	0.0
			RWSSum	=	0.0
			if Type[key].has_key("RWS"):
				RWSNew	=	string.atof(Type[key]["RWS"])
			else:
				for z in Mat:									#	z:	Atomic Number
					Rate	=	string.atof(Type[key]["ATOM"][z])
					Sym		=	AtomData[z]						# Sym:	Atomic Symbol
					RWStmp	=	AtomData[Sym]["RWS"]**3*Rate
					RateSum	=	RateSum	+	Rate
					RWSSum	=	RWSSum	+	RWStmp
				RWSNew	=	(RWSSum/RateSum)**(1.0/3.)			#	Weighted Average of Each Site
			RWSNewDic[key]	=	RWSNew

		for Num in Site.keys():							#	key: Type Name
			RWSNew	=	RWSNewDic[Site[Num]["TYPE"]]
			V3Sum	=	V3Sum	+	RWSNew**3

################################################################################
## RWS Scaling #################################################################
		from ConstantData import PI

		SCAF	=	(Vall/(V3Sum*4.0/3.0*PI))**(1.0/3.0)
		for key in Type.keys():							#	key: Type Name
			if Type[key].has_key("RWS")!=1 or RWSNew!=Type[key]["RWS"]:
				Type[key]["RWS"]	=	"%8.6f" % (RWSNewDic[key]*SCAF)
				CheckList[key]		=	1

################################################################################
## RMT #########################################################################
#
#
#		RMTNew	=	
#		if Type[key].haskey("RMT")!=1 or RMTNew!=Type[key]["RMT"]:
#			Type[key]["RMT"]	=	"%5.3f" % RMTNew
#			CheckList[key]		=	1


################################################################################
## Make TYPE Format ###########################################################
		for key in Type.keys():							#	key: Type Name
			Mat	=	Type[key]["ATOM"].keys()				#	Mat: Atomic Number List
			if CheckList.has_key(key):
				s	=	"TYPE %s " % key
				for s2	in Type[key].keys():
					if s2=="ATOM":
						s	=	s+"ATOM="
						for z in Mat:						#	z:	Atomic Number
							s	=	s+"(%d:%s)" % (z	,Type[key]["ATOM"][z])
						s	=	s+", "
					else:
						s = s+"%s=%s, " % (s2, Type[key][s2])
				s	=	s[:-2]
				self.outdata = self.outdata + s+"\n"

