import string
import os
import re
from numpy import *
#from Numeric import *
#from LinearAlgebra import *
#from Numeric import * 
EX = array((1., 0., 0.))
EY = array((0., 1., 0.)) 
EZ = array((0., 0., 1.))
def addSite(Site,type,pos,posData):
	indexSite = len(Site)
	Site[indexSite] = {'TYPE': type,'POS': pos,"PosData":posData}
