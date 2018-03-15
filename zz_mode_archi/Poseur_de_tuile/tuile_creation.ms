

------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------
-- CREATION des TUILES
	-- creation de la tuile de base / selection d'une tuile de base
-- 	TuileLong = 20
-- 	TuileLarge = 45
	
-- 	TuileBase = cylinder name: "tuile" sides: 8 rotation: (quat 0.5 -0.5 0.5 -0.5) radius: (TuileLong/2) height: TuileLarge slice: on sliceto: 180 heightsegs: 1
	
	TuileLong = TuileY
	TuileLarge = TuileX

	
	TuileBase = GlobTuileMod2
	
	ResetXForm TuileBase
	converttopoly TuileBase


-- CREATION DE LA PLAQUE



	-- recup de la taille de la bounding box
	CleanFaceSize=  (CleanFace.min - CleanFace.max)
	ToitLong = abs CleanFaceSize.y
	ToitHaut = abs CleanFaceSize.x
	
	-- calcul du nombre de tuile en longueur
	NumLongFloat = ToitLong / (TuileLong - 4)
	RoundValue = NumLongFloat - (floor NumLongFloat)
	
	NumLongInt = 
	(
			if RoundValue > 0.5 then 
		(
		int (ceil NumLongFloat)
		)
		else
		(
		int (floor NumLongFloat)
		)
	)
	
	-- calcul de l'écartement des tuile en y
	EcartY = ToitLong / NumLongInt

	-- application du modifier clone à la tuile en y
	select TuileBase

	addmodifier TuileBase (clone  ())
	TuileBase.modifiers[#Clone].clones = NumLongInt
	TuileBase.modifiers[#Clone].movey = EcartY

	-- calcul du nombre de tuile en largeur
	NumLargFloat = ToitHaut / (TuileLarge - 4)
	RoundValue = NumLargFloat - (floor NumLargFloat)
	
	NumLargInt = 
	(
			if RoundValue > 0.5 then 
		(
		int (ceil NumLargFloat)
		)
		else
		(
		int (floor NumLargFloat)
		)
	)		

		-- calcul de l'écartement des tuile en x
	EcartX = ToitHaut / NumLargInt
			
	-- application du modifier clone à la tuile en x


	addmodifier TuileBase (clone ())
	TuileBase.modifiers[#Clone].clones = NumLargInt
	TuileBase.modifiers[#Clone].movex = EcartX
	
	
	centerpivot TuileBase
	TuileBase.pos = cleanface.pos
	converttopoly tuilebase
	ResetXForm TuileBase
	converttopoly tuilebase

		

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

	



	


