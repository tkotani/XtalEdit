import sys
sys.path.append("./UserModule/Common")
from addSite import *
from numpy import * 
EX = array((1., 0., 0.))
EY = array((0., 1., 0.)) 
EZ = array((0., 0., 1.))
Site = {}
Type = {}

Bohr_R	= 0.529177249  
PI = 3.14159265358979323846

a = 4.3338           
c = 40.910 
CV1 = 1/2.* a * EX - 1/2. *sqrt(3) * a * EY
CV2 = 1/2.* a * EX + 1/2. *sqrt(3) * a * EY
CV3 = c * EZ

PV1 =  2/3. * CV1  + 1/3. * CV2 + 1/3. * CV3
PV2 = -1/3. * CV1  + 1/3. * CV2 + 1/3. * CV3
PV3 = -1/3. * CV1  - 2/3. * CV2 + 1/3. * CV3

addSite(Site,'Mn','0.*EZ',0.*EZ)

z= 0.42488
addSite(Site,'Bi','+z *CV3',+z *CV3)
addSite(Site,'Bi','-z *CV3',-z *CV3)

z= 0.13333
addSite(Site,'Te1','+z *CV3',+z *CV3)
addSite(Site,'Te1','-z *CV3',-z *CV3)

z= 0.29436
addSite(Site,'Te2','+z *CV3',+z *CV3)
addSite(Site,'Te2','-z *CV3',-z *CV3)








#<RASMOL>
#BondMax  =    4.5000 
#RangeMin = [ -0.2000,  -0.2000,  -0.2000]  #[-0.0001,-0.0001,-0.0001]
#RangeMax = [  1.2000,   1.2000,   1.2000]  #[ 0.9999, 0.9999, 0.9999]
#Type Te1 Color=1
#Type Te2 Color=2
#Type Mn Color=3
#Type Bi Color=4
#</RASMOL>

SiteNum  = len(Site)
TypeNum = len(Type)
for Mat in Site.keys():
	EMat=array([0., 0., 0.])
	try:
		Site[Mat]["PosData"]	=	Site[Mat]["PosData"]+EMat
	except:
		Site[Mat]["PosData"] = EMat
		Site[Mat]["POS"]	=	"0."
