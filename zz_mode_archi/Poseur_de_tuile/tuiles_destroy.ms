-- création du repère 
Vz = polyop.getFaceNormal $ 1

VertFrEdge = polyop.getVertsUsingEdge $ #selection as array

Vx = normalize ((polyop.getvert $ VertFrEdge[1]) - (polyop.getvert $ VertFrEdge[2]))

Vy = cross Vz Vx

posTemp = polyop.getvert $ VertFrEdge[1]

rootFace = box ()
rootFace.transform = ( matrix3 Vx Vy Vz posTemp)

-- recuperation des faces à delete
MaxFace = polyop.getnumfaces $
FaceToDel = #()

for i = 1 to MaxFace do
(
	if (in coordsys rootFace polyop.getFaceCenter $ i ).y > 0 do append FaceToDel i
)

-- delete
polyop.deleteFaces $ (FaceToDel as bitarray)

------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------
-- par les rayons

for i = 1 to MaxFace do
(
ray (polyop.getFaceCenter $ i) [0,0,1]
)
rayTest = ray [] [


rayTemp = ray (polyop.getFaceCenter $  31) [0,0,1]
intersectRay $box003 raytemp