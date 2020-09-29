-- faceSel = polyop.getfaceselection $ 
sel = selection as array
ep = sel[1].edit_poly

ep = $

-- ep.GetSelection  #face

-- $.GetFaceVertex 14 3

faceSel = ep.GetSelection  #face
-- $.GetFaceVertex  faceSel[1] 2

-- 	s.edit_poly.GetSelection  #face
fSel =faceSel as array
	
-- recupération des id de points 
pts = for i = 1 to 3 collect ep.GetFaceVertex  fSel[1] i
	
-- recuperation des position de points
ptsPos = for p in pts collect ep.getVertex p 
		
	-- calcul des vecteurs
	v1 = normalize(ptsPos[1] - ptsPos[2])
	v2 = normalize(ptsPos[2] - ptsPos[3])
	
	-- cross vecteurs
	theZ = normalize (cross v1 v2)
	theY = normalize (cross [0,0,1] theZ )
	theX = normalize (cross theY theZ)



facesNormals = for f in facesel collect polyop.getFaceNormal $.baseobject f
SuperFacesNormals = #(facesNormals[1])


-- collecte des normales
for i = 2 to facesNormals.count do 
(
	appendThis = false
	alreadyAppend = false
	for j = 1 to SuperFacesNormals.count do
	(
		testAngle = (acos (dot facesNormals[i] SuperFacesNormals[j]))

		if testAngle <= 0.1 then
		(
			format "alreadyAppend: % facesNormals[%]: %  SuperFacesNormals[%]: % \n" testAngle i facesNormals[i] j SuperFacesNormals[j]
			alreadyAppend = true
		)
	)
	if not alreadyAppend then append SuperFacesNormals facesNormals[i]
)
SuperFacesNormals


faceNormalAr = for i = 1  to SuperFacesNormals.count collect #()

-- classement des faces selon les normales
for f in faceSel do
(
	for k = 1 to SuperFacesNormals.count  do
	(
		testAngle = (acos (dot (polyop.getFaceNormal $.baseobject f) SuperFacesNormals[k]))
		
		if testAngle <= 0.1 then
		(
			append faceNormalAr[k] f
		)
	)
)
faceNormalAr

faceNormalAr[1] as bitarray