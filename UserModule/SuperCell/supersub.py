import string
import os
import re
from numpy import *
from numpy.linalg import *
#from Numeric import *
#from LinearAlgebra import *
#======== supercell  subroutines ====================
def  PVtoPVo(s):
	s1=re.sub("PV1","PV1o",s )
	s2=re.sub("PV2","PV2o",s1 )
	s3=re.sub("PV3","PV3o",s2 )
	return s3

def  GenSuperCell(SV1,SV2,SV3,PV1,PV2,PV3):
	SV1n,SV2n,SV3n,nnn=SetNNN(PV1,PV2,PV3, SV1,SV2,SV3)
	return nnn,SV1n,SV2n,SV3n,GenTrans(nnn)

def AddPV (newPOS, i,ix):
	if(i == 1 ): newPOS=newPOS + ' + PV%d'  % (ix)
	elif(i == -1 ): newPOS=newPOS + ' - PV%d'   % (ix) 
	elif(i < 0 ): newPOS=newPOS + ' %d *PV%d' % (i,ix)
	elif(i != 0 ): newPOS=newPOS + ' +%d *PV%d' % (i,ix)
	return newPOS

def VecPVbase(i,j,k):
	newPOS=AddPV (' ', i,1) 
	newPOS=AddPV (newPOS, j,2) 
	newPOS=AddPV (newPOS, k,3) 
	if(newPOS==' '): newPOS=' 0.'
	return  newPOS

def GenTrans(nnn):
	Trans=[]
	for i,j,k in  nnn:
		newPOS=AddPV (' ', i,1) 
		newPOS=AddPV (newPOS, j,2) 
		newPOS=AddPV (newPOS, k,3) 
		if(newPOS==' '): newPOS=' 0.'
		Trans.append(newPOS)
	return  Trans
	
def  vol(PV1,PV2,PV3):
	return  abs(det(array([PV1,PV2,PV3])))

def  perio(ax):
	axx= ax + int(abs(ax))+1 
	return axx-int(axx)


def  perioP(PV1,PV2,PV3, POS):
	pvmat= transpose(array([PV1,PV2,PV3]))
	invpvmat= inv(pvmat)
	P= dot(invpvmat,POS)
	P[0] = perio(P[0])
	P[1] = perio(P[1])
	P[2] = perio(P[2])
	return dot(pvmat,P),P

def  UnitP(PV1,PV2,PV3, POS):
	pvmat= transpose(array([PV1,PV2,PV3]))
	invpvmat= inv(pvmat)
	P= dot(invpvmat,POS)
	return P

def  SetNNN(PV1,PV2,PV3, SV1in,SV2in,SV3in):

	fres = open("result.data","wt")

	P_SV1=UnitP(PV1,PV2,PV3, SV1in)
	P_SV2=UnitP(PV1,PV2,PV3, SV2in)
	P_SV3=UnitP(PV1,PV2,PV3, SV3in)

	i,j,k = int(1.01*P_SV1[0]),int(1.01*P_SV1[1]),int(1.01*P_SV1[2])
	SV1n= VecPVbase(i,j,k)
	SV1= i*PV1+j*PV2+k*PV3
	P_SV1=UnitP(PV1,PV2,PV3, SV1)

	i,j,k = int(1.01*P_SV2[0]),int(1.01*P_SV2[1]),int(1.01*P_SV2[2])
	SV2n= VecPVbase(i,j,k)
	SV2= i*PV1+j*PV2+k*PV3
	P_SV2=UnitP(PV1,PV2,PV3, SV2)

	i,j,k = int(1.01*P_SV3[0]),int(1.01*P_SV3[1]),int(1.01*P_SV3[2])
	SV3n= VecPVbase(i,j,k)
	SV3= i*PV1+j*PV2+k*PV3
	P_SV3=UnitP(PV1,PV2,PV3, SV3)

	if(vol(SV1,SV2,SV3)<1e-6): 
		print 'error vol(SV1,SV2,SV3)=0'
		sys.exit()

	Min= [None,]*3
	Max=[None,]*3
	for i in  range(3):
		a,b=MMrange(P_SV1[i],P_SV2[i],P_SV3[i])
		Min[i],Max[i]=MMrange(P_SV1[i],P_SV2[i],P_SV3[i])
		fres.write("range Min Max=%s, %s\n" % (Min[i],Max[i]))
	nnn=[]

	for i in  range(int(Min[0]-0.1),int(Max[0]+1.1),1):
		for j in  range(int(Min[1]-0.1),int(Max[1]+1.1),1):
			for k in  range(int(Min[2]-0.1),int(Max[2]+1.1),1):
				candidate=i*PV1+j*PV2+k*PV3 +  0.0001*SV1+0.00021*SV2+0.00033*SV3
				if( 0<= UnitP(SV1,SV2,SV3, candidate)[0] <1): 
					if( 0<= UnitP(SV1,SV2,SV3, candidate)[1] <1): 
						if( 0<= UnitP(SV1,SV2,SV3, candidate)[2] <1): 
							nnn.append([i,j,k])
# check
	spratio=vol(SV1,SV2,SV3)/vol(PV1,PV2,PV3)
	fres.write('supercell/primitivecell = %4.1f' % spratio)
	fres.write(' ---This should be the same as number of POSS for each POS\n')
	if(  (len(nnn)-spratio) >1e-8):
		fres.write(' GenSuperCell: abs(len(nnn) -spratio) >1e-8 meaning sum bug...')
	fres.close()
	return SV1n,SV2n, SV3n, nnn

def MMrange(a,b,c):
	V=a,b,c
	Min=0.
	Max=0.
	for i in range(3):
		if(V[i]>0): Max=Max + V[i]
		if(V[i]<0): Min=Min + V[i]
	return Min,Max

