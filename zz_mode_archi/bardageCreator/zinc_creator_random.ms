s = plane name: "test" length: 50 width: 2000

s.pivot = [s.min.x,0,0]
s.pos = [0,0,0]
ResetXform s
convertToPoly s

sInt = s.editablePoly

faceNum = sInt.GetNumFaces ()

faceSelArr = for i = 1 to faceNum  collect i
faceSelBArr = faceSelArr as bitarray
sInt.SetSelection  #face faceSelBArr

v1 = $point001
v2 = $point002

dir = normalize (v2.position - v1.position)
--dir = [1,0,0]
start3 = [0,0,0]
pas = 25

/*
sInt.setSlicePlane dir [1000,0,0] 100
sInt.slice dir [1000,0,0]
*/

for i = 1 to 80 do
(
	posBak = v1.position
	rotBak = v1.rotation
	
	rotate v1 (angleaxis (random -2 2) [0,0,1])
	dir = normalize (v1.position - v2.position)
	--s.EditablePoly.setSlicePlane  dir start3 100
	s.EditablePoly.slice  dir start3 flaggedFacesOnly:on
	start3.x = start3.x + pas
	print start3 as string
	
	v1.rotation = rotBak
	v1.position = posBak
)

/*
--Define variables to hold the Out parameters:
plane_normal = Point3 0 0 0
plane_center = Point3 0 0 0
plane_size = 1.0
--Call the function and supply the variables by reference as In parameters
sInt.getSlicePlane &plane_normal &plane_center &plane_size
--The variables will now contain the actual values of the slice plane:
plane_normal
plane_center
plane_size
*/

