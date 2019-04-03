import numpy as np, sys
from math import *
EX= np.array([1.0, 0.0, 0.0])
EY= np.array([0.0, 1.0, 0.0])
EZ= np.array([0.0, 0.0, 1.0])
SITE=[]
#-----------------------------------                                                            
#NOTE: Be careful for math in python2.x; for example, 1/3 gives 0.
au=  0.529177
a =  3.82/au   #  a is in a.u.     
c =  6.26/au   #  c  is in a.u.
u= 3./8
CV1 = 1/2.* a * EX - 1/2. *sqrt(3.) * a * EY
CV2 = 1/2.* a * EX + 1/2. *sqrt(3.) * a * EY
CV3 =  EZ/3.0
PV1 =  CV1
PV2 =  CV2
PV3 =  CV3
SITE.append(["Zn", 1/3. *PV1 + 2/3. *PV2 +  PV3])
SITE.append(["Zn", 2/3. *PV1 + 1/3. *PV2 + 1/2.*PV3])
SITE.append(["S", 1/3. *PV1 + 2/3. *PV2 +   u  *PV3])
SITE.append(["S", PV3])
#-----------------------------------------                                            
#### test code ###
print PV1,PV2,PV3
print CV1,CV2,CV3
print CV1.dtype.name
print "%.16f" % au
print SITE[0][1].dtype.name
for i in SITE:
    print  "%s %.16f %.16f %.16f" % (i[0],i[1][0],i[1][1],i[1][2])

