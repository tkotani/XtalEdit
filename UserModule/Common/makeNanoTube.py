from math import *
pi = 4.0 * atan(1.0)
class NanoTubeMaker:
	def __init__(self,n,m,numUnit):
		self.n = n                                        # this is chiral vector Ch = (n,m)
		self.m = m
		self.numUnit = numUnit                            # number of unit cell
		self.rC_C = 1.440                                 #distance between Carbon 1.44A
		self.a = self.rC_C * sqrt(3.0)                    # lattice constant 
		self.chiralVec =[n,m]                             # chiral vector
		self.lenC = self.a * sqrt(n*n + m*m + n*m)        #
		self.diameter = self.a * sqrt(n*n + m*m + n*m)/pi # diameter of tube (unit of Angstrom) 
		self.radius = self.diameter/2.0                   # radius of tube 
		self.dR = greatestCommonDivisor(2*m+n,2*n+m)      # dR
		self.gcdnm = greatestCommonDivisor(n,m)           # G.C.D of (n,m)
		self.T = [(2*m+n)/self.dR,-(2*n+m)/self.dR]       # translational Vector
		self.N = 2*(n*n + m*m + n*m)/self.dR              # number of atom in the unit cell
		self.R = self.symmetryVector(n,m)                 # symmetry Vector 
		
		self.Apos = []                                    # position for A atom in the unit cell
		self.Bpos = []									  # position for B atom in the unit cell				
		self.AposAll = []                                 # position of atom in the Carbon Nanotube
		self.BposAll = []
		# self.Apos[i] = [x,y,z] x,y,z is ith atom's position
		print 'Chiral Vector =',self.chiralVec
		print 'Number of Unit Cell',self.numUnit
		print 'Diameter of Carbon Nanotube =',self.diameter
		print 'Translational Vector = ',self.T
		print 'Number of Atom in the Unit Cell',self.N
		print 'Symmetry Vector ', self.R
	def symmetryVector(self,n,m):
		p = 0
		q = 0
		t1 = self.T[0]
		t2 = self.T[1]
		for p in range(-abs(t1),abs(t1)+1):
			for q in range(-abs(t2),abs(t2)+1):
				if((t1*q-t2*p==1) and (0<m*p-n*q) and (m*p-n*q<=self.N)):
					return [p,q]
		return [0,0]
	def makeCoordinates(self):
		n = self.n
		m = self.m
		unitnum = self.numUnit
		c = self.a * sqrt(n*n+m*m+n*m)
		r = sqrt(3.0) * c / self.dR
		t = sqrt(3.0)*c/self.dR
		self.makeCoordinatesInUnitCell(n,m)
		for i in range(0,unitnum):
			for j in range(0,self.N):
				xa = self.Apos[j][0]
				ya = self.Apos[j][1]
				za = self.Apos[j][2] + t * i
				xb = self.Bpos[j][0]
				yb = self.Bpos[j][1]
				zb = self.Bpos[j][2] + t * i				
				self.AposAll.append([xa,ya,za])
				self.BposAll.append([xb,yb,zb])			
	def makeCoordinatesInUnitCell(self,n,m):
		p = self.R[0]
		q = self.R[1]
		c = self.a * sqrt(n*n+m*m+n*m)
		r = self.a * sqrt(p*p+q*q+p*q)
		t = sqrt(3.0)*c/self.dR
		rt = self.radius
		theta1 = atan(sqrt(3.0)*m/(2*n+m))
		theta2 = atan(sqrt(3.0)*q/(2*p+q))
		theta3 = theta1 - theta2
		theta4 = 2.0 * pi / self.N
		theta5 = 2.0*pi*self.rC_C * cos(pi/6.0-theta1)/(c)
		h1 = t/(abs(sin(theta3)))
		h2 = self.rC_C * sin(pi/6.0 - theta1)
		for i in range(0,self.N):
			k = floor(i*r/h1)
			x = rt * cos(i * theta4)
			y = rt * sin(i * theta4)
			z = (i*r - k*h1) * sin(theta3)
			kk2 = floor(abs(z/t)) + 1
			if(z > t - 0.02):
				z = z - t * kk2
			if(z < -0.02 ):
				z = z + t * kk2
			xtemp=0
			ytemp=0
			ztemp=0
			if(abs(x) < 1.0E-10):
				xtemp=0.0
			else:
				xtemp =x
			if(abs(y) < 1.0E-10):
				ytemp = 0.0
			else:
				ytemp = y
			if(abs(z) < 1.0E-10):
				ztemp = 0
			else:
				ztemp = z
			self.Apos.append([xtemp,ytemp,ztemp])
			x = rt * cos(i*theta4 + theta5)
			y = rt * sin(i*theta4 + theta5)
			if((z>=-0.02)and(z<=t-0.02)):
				z = (i*r-k*h1)*sin(theta3) -h2
			else:
				z = (i*r-(k+1)*h1)*sin(theta3)-h2
				kk = floor(abs(z/t))+1
				if(z > t-0.01):
					z = z -t * kk
				else:
					z = z + t * kk
			if(abs(x) < 1.0E-10):
				xtemp=0.0
			else:
				xtemp =x
			if(abs(y) < 1.0E-10):
				ytemp = 0.0
			else:
				ytemp = y
			if(abs(z) < 1.0E-10):
				ztemp = 0
			else:
				ztemp = z
			self.Bpos.append([x,y,z])			
def greatestCommonDivisor(n,m):
	n = abs(n)
	m = abs(m)
	if(n > m):
		temp = n
		n = m
		m = temp
	if(n == 0):
		return m
	while(1):
		ir = n%m
		if(ir == 0):
			return m
		else:
			n = m
			m = ir	
			
