from pprint import pprint
import pymxs as pm
#~ import MaxPlus

import pymxs

rt = pymxs.runtime

def sortbyname(v1,v2):
	res
	
	if ( rt.toLower(v1.name) < rt.toLower(v2.name)): d =-1
	else : d=1
	
#~ compare les numeros entre eux et les classe	
	if 	(d < 0.): res = - 1
	elif (d > 0.) : res = 1
	else : res = 0
		
	res
	

def hello():
	print ("hello super super python!")
	


def createBox():
	oneBox = rt.box()
	return oneBox
	
	
#~ createBox()


def returnBBsize3(ref): 
	bb = rt.nodeGetBoundingBox(ref, ref.transform)
	#~ print bb[0].x
	xsize = rt.distance(rt.point3(bb[0].x, 0, 0), rt.point3(bb[1].x,0,0))
	ysize = rt.distance(rt.point3(0, bb[0].y, 0), rt.point3(0,bb[1].y,0))
	zsize = rt.distance (rt.point3(0,0,bb[0].z), rt.point3(0,0,bb[1].z))
	#~ format "ref: % scale: %\n" ref.name  [xsize, ysize, zsize]
	
	return rt.point3(xsize, ysize, zsize)
		

#~ sel = list(rt.selection)
#~ res = returnBBsize3(sel[0])
#~ print res

