#!/usr/bin/python
# 1/6/2003 by I.Fukumoto

import string
from AtomData import AtomData

#-----------------------------------------------------
# Key Word
#-----------------------------------------------------
def SiteProcessing(s=[],n = 0):
	"SITE processing"

	## check "," between SITE and POS
	n		= string.count(s, ",")	
	if n==0:	
		return "<ERROR>: no SITE defined!"
	
	## s : SITE TYPE=AlFe, POS=  0.00000000 *EX +0.00000000 *EY +0.00000000 *EZ
	## st: TYPE=AlFe, POS=  0.00000000 *EX +0.00000000 *EY +0.00000000 *EZ
	st		= string.join(string.split(s)[1:])

	Site		=	{}
	s		=	""
	k		=	0

	for i in range(len(st)):  # len(st) the nubmer of st characters

		
		## For treating bracket 
		if st[i]=="(":
			k	=	k+1
		elif st[i]==")":
			k	=	k-1
		
		if k==0:
			## set TYPE info (ATOM name) : skey
			## when getting "," set Site[TYPE] = AlFe
			## set POS info : skey
			## when i = len(st)-1, set Site[POS] = 0.00000000 *EX +0.00000000 *EY +0.00000000 *EZ
			
			if st[i]=="=":
				skey=	string.strip(s) # remove top and tail space
				## initialize s
				s	=	""
			elif st[i]==",":
				Site[string.strip(skey)] = string.strip(s)
				## initialize
				s	=	""
				skey=	""
			elif i==len(st)-1:
				Site[string.strip(skey)] = string.strip(s+st[i])
			else:
				s	=	s+st[i]
		else:
			s	=	s+st[i]

	return Site

def TypeProcessing(s=[], mode	=	0):
	"Type Processing"

	## count "," between TYPE and ATOM and LMX and so on
	## we must read (n+1) times
	n		= string.count(s, ",")

	## st ['TYPE', 'AlFe', 'ATOM=(Fe:100)(Al:0)', ',LMX', '=', '2', ',RWS', '=', '2.970052', ',RMT', '=', '0']
	## Eq ['ATOM=(Fe:100)(Al:0)', ',LMX', '=', '2', ',RWS', '=', '2.970052', ',RMT', '=', '0']
	## TypeName = AlFe
	st		= string.split(s)						
	Eq		= string.split(string.join(st[2:]),",")	#	Remove Keyword	
	TypeName	=	st[1]
	
	Type = ""
	for i in range(n+1):
		## ['ATOM', '(Fe:100)(Al:0) '] : i=0
		## ['LMX ', ' 2 ']			   : i=1
		## ['RWS ', ' 2.970052 ']      : i=2
		## ['RMT ', ' 0']              : i=3
		EqP = string.split(Eq[i],"=")

		
		for	j in range(len(EqP)):
			## EqP[0] = ATOM
			## EqP[1] = (Fe:100)(Al:0)
			## EqP[2] = LMX
			## EqP[3] = 2
			## EqP[4] = RWS
			## EqP[5] = 2.970052
			## EqP[6] = RMT
			## EqP[7] = 0
			EqP[j]	=	string.strip(EqP[j]) # remove head and tail space
			
		if	EqP[0]=="ATOM":
			ASplitE	=	[]
			ANum	=	0
			## Type : ,"ATOM";
			Type	=	Type	+	",\"ATOM\":"
			Typet	=	""
			for i in range(len(EqP[1])):
				if EqP[1][i]=="(":
					n1	=	i
				elif	EqP[1][i]==")":
					n2	=	i
					## ASplitE[0] = Fe:100
					## ASplitE[1] = Al:0
					ASplitE.append(EqP[1][n1+1:n2])
					## ASE2 = Fe,100
					## ASE[0] = Fe
					## ASE[1] = 100
					ASE2	=	string.split(ASplitE[ANum],":")
					ASE2[0]	=	string.strip(ASE2[0])
					ASE2[1]	=	string.strip(ASE2[1])
					
					## Mkinput use mode 1
					if mode==1:
						try:
							z	=	string.atoi(ASE2[0])
						except:
							try:
								z	=	AtomData[ASE2[0]]["Z"]
							except:
								z	=	-1
						## Typet ,26:"100"
						##        ,26:"100",13:"0"
						Typet	=	Typet	+	", %d:\"%s\"" % (z,ASE2[1])
						
					elif mode==2:
						try:
							sym	=	AtomData[ASE2[0]]
						except:
							try:
								sym	=	AtomData[string.atoi(ASE2[0])]
							except:
								sym	=	"?"

						Typet	=	Typet	+	", \"%s\":\"%s\"" % (sym,ASE2[1])
						
					else:
						Typet	=	Typet	+	", %s:\"%s\"" % (ASE2[0],ASE2[1])
					## The number of kinds of Atoms set +1
					ANum	=	ANum+1
			## End for loop
			## Types Type["AlFe"]={"ATOM":{ 26:"100", 13:"0"}}
			Type	=	Type	+	"{"	+	Typet[1:]	+	"}"
		else:  ## if "ATOM" comment does not exit at first sentense
			## Type : ,"ATOM":EqP[0] EqP[1]
			Type	=	Type + ", \"%s\":\"%s\"" % (string.strip(EqP[0]),string.strip(EqP[1]))
	
	## TypeR Type["AlFe"]={"ATOM":{ 26:"100", 13:"0"}, "LMX":"2", "RWS":"2.970052", "RMT":"0"}
	TypeR	=	"Type[\"%s\"]={%s}" % (TypeName, Type[1:])


	return TypeR


