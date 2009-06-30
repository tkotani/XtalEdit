#from Numeric import *
#from LinearAlgebra import *
from numpy import *
from numpy.linalg import *
def WriteAtomInfo(ras, pdb, i,	Pos, AI, Type):
	writepdba(pdb, i+12,Pos,AI)
	ras.write("select %d\n" % (i+12))
	ras.write("label '%s'\n" %  (Type) )
	ras.write("cpk 202\n")

def CheckB(ras, pdb, j,	Pos, AI, Type,matinv,RangeMin,RangeMax,POSall):
	nmm0= range(int(RangeMin[0]-1),int(RangeMax[0]+1),1)
	nmm1= range(int(RangeMin[1]-1),int(RangeMax[1]+1),1)
	nmm2= range(int(RangeMin[2]-1),int(RangeMax[2]+1),1)
	for n1 in nmm0:
		for n2 in nmm1:
			for n3 in nmm2:
				Pos2=['0']*3
	 			Pos2[0]	=	Pos[0]	+n1
				Pos2[1]	=	Pos[1]	+n2
				Pos2[2]	=	Pos[2]	+n3
				if( (RangeMin[0] <= Pos2[0] <RangeMax[0]) &
					(RangeMin[1] <= Pos2[1] <RangeMax[1]) &
					(RangeMin[2] <= Pos2[2] <RangeMax[2]) ):
					WriteAtomInfo(ras, pdb, j,	dot(matinv,Pos2), AI, Type)
					POSall.append( dot(matinv,Pos2) )
					j = j+1
	return j

def MoveAtom(x):
	if x>=0:
		xt	=	int(x)
	else:
		xt	=	int(x)-1
	return x-xt

def MoveAtomV(a):
	ax	=	MoveAtom(a[0])
	ay	=	MoveAtom(a[1])
	az	=	MoveAtom(a[2])
	return [ax,ay,az]

def writepdbh(pdb, ii,CV,cu_color):
	ix=0.
	f1,f2,f3=CV
	ft1	=	f1
	ft2	=	f2
	ft3	=	f3
	pdb.write('HETATM%5d%15d    %8.3f%8.3f%8.3f%6.2f%8.3f\n'  %    (ii,ii,ft1, ft2, ft3,ix,cu_color))

def writepdba(pdb, ii,CV,cu_color):
	ix=0.
	f1,f2,f3=CV
	ft1	=	f1
	ft2	=	f2
	ft3	=	f3
	pdb.write('ATOM  %5d%15d    %8.3f%8.3f%8.3f%6.2f%8.3f\n'  %    (ii,ii,ft1, ft2, ft3,ix,cu_color))

import string, re
def ConvertTagSec(s,seckey): # For convert Tag Section with CLASS keyword.
	if re.search('(Type|TYPE)',s)!=None: #string.find(s,"TYPE")>=0:	# KeyWord: Class
		n	= string.count(s, ",")
		st	= string.split(s)
		Eq	= string.split(string.join(st[2:]),",")	#
		#print 'eq=',Eq
		ClassName	=	st[1]
		outdata = ""
		for i in range(n+1):
			EqP = string.split(Eq[i],"=")
			data = string.replace(string.strip(EqP[1])," ","','")
			outdata	= outdata+"Type['%s']['%s%s']='%s'" % (ClassName,string.strip(EqP[0]),seckey,data)
			outdata = outdata+'\n'
	else:
		outdata=s
	
	return outdata
