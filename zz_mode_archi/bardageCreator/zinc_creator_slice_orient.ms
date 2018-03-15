--Define variables to hold the Out parameters:
plane_normal = Point3 0 0 0
plane_center = Point3 0 0 0
plane_size = 1.0
--Call the function and supply the variables by reference as In parameters
$.editablePoly.getSlicePlane &plane_normal &plane_center &plane_size
--The variables will now contain the actual values of the slice plane:
plane_normal
plane_center
plane_size

in coordsys parent $.min
	
depart = $dep_decoupe_001
fin = $fin_decoupe_003

ref = $plane005

distance depart fin

localDep = in coordsys $ depart.pos
localFin = in coordsys $ fin.pos
	
ecartX = distance [localDep.x,0,0] [localFin.x, 0, 0]
ecartY = distance [localDep.y,0,0] [localFin.y, 0, 0]
ecartZ = distance [localDep.z,0,0] [localFin.z, 0, 0]

localFin.x - localDep.x