

		

------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
		
-- DECOUPE DE LA PLAQUE


-- recuperation des vecteurs et vertex de decoupe
select CleanFace
polyop.setfaceselection CleanFace #all
initVars CleanFace

MainVectors
vertexDuo
		
		
CutVectors = #()
CutVertex = #()

for i = 1 to MainVectors.count do
(
	if (acos (dot MainVectors[i] [0,1,0])) > 2 then
	(
		if (acos (dot MainVectors[i] [0,1,0])) < 178 then
		(
			append CutVectors (cross MainVectors[i] [0,0,1])
			append CutVertex  (cleanFace.editablepoly.getvertex vertexDuo[i][1])
		)
	)
)

-- decoupe de la plaque
select tuilebase
polyop.setfaceselection tuilebase #all
subobjectLevel = 4

tuilebase.split =on

for i = 1 to CutVectors.count do
(
	tuilebase.editablepoly.slice CutVectors[i] CutVertex[i]
)

-- delete des faces 
-- par les rayons

MaxFace = polyop.getnumfaces tuileBase
FaceTotal = #{1..MaxFace}
FaceToKeep = #()


for i = 1 to MaxFace do
(
rayTemp = ray (polyop.getFaceCenter tuileBase  i) [0,0,-1]
if (intersectRay CleanFace raytemp != undefined) do append FaceToKeep i
)

for i = 1 to MaxFace do
(
rayTemp = ray (polyop.getFaceCenter tuileBase  i) [0,0,1]
if (intersectRay CleanFace raytemp != undefined) do append FaceToKeep i
)

polyop.setfaceselection tuileBase #none
polyop.setfaceselection tuileBase FaceToKeep
TuileBase.EditablePoly.SelectElement ()
EltToKeep = polyop.getfaceselection tuileBase

FaceToDel = FaceTotal - EltToKeep

polyop.deleteFaces tuileBase FaceToDel

polyop.setfaceselection tuilebase #all
TuileBase.EditablePoly.capHoles #face
	
------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------

-- REPLACEMENT DE LA PLAQUE

tuilebase.parent = guide
move tuilebase  [0,0,(tuilebase.min.z * -1) ] 
delete cleanface
guide.transform = PosBack
delete guide
subobjectLevel = 0

	



	


