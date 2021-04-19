/*
-- faire fonctionner sur les edit mesh
-- prendre en charge les groupe de poly isolés
*/


-- faceSel = polyop.getfaceselection $ 
-- sel = selection as array
-- ep = sel[1].edit_poly

-- methode de calcul d'une normale pour edit mesh
/*
ep = $
faceSel = ep.GetSelection  #face
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
-- */


(
	local ep = $
	local tres = 1
	local faceSel = polyop.getfaceselection ep
	-- format "faceSel: %\n" faceSel
	local faceSelAr = faceSel as array 
	
	local SuperFacesNormals = #()
	local k
-- collecte des normales de reference
	for i = 1 to faceSelAr.count do 
	(
	-- 	appendThis = false
		local faceNormal = polyop.getFaceNormal ep.baseobject faceSelAr[i]
		if SuperFacesNormals.count == 0 then SuperFacesNormals = #(faceNormal)
		
		local testAngle
		local alreadyAppend = false
		
		-- teste si la normale est differente des normales déja collectées
		for j = 1 to SuperFacesNormals.count do
		(
			
			testAngle = (acos (dot faceNormal SuperFacesNormals[j]))
	-- 		format "\t\tfacesNormals[%] SuperFacesNormals[%] testAngle:%\n"  i j testAngle

-- 			if not testAngle > tres then alreadyAppend = true

				
			
			if testAngle <= tres then
			(
	-- 			format "\talreadyAppend testAngle: % facesNormals[%]: %  SuperFacesNormals[%]: % \n" testAngle i faceSelAr[i] j SuperFacesNormals[j]
				alreadyAppend = true
			)
			else if testAngle > tres then 
			(
				
			)
			else
			(
-- 				format "\tError testAngle: % faceSelAr[%]: %  SuperFacesNormals[%]: % \n" testAngle i faceNormal j SuperFacesNormals[j]
				alreadyAppend = true
			)
			
			
			k = j
			
			if alreadyAppend then exit
		)
		
		
		if not alreadyAppend then
		(				
			append SuperFacesNormals faceNormal
			format "append faceSelAr[%]: %  faceNormal: % SuperFacesNormals[%]\n" i faceSelAr[i] faceNormal (k+1)
		)
		
	-- 	format "SuperFacesNormals.count = %\n" SuperFacesNormals.count
	)
)


-- collecte des faces selon les normales
--init de l'array 
faceNormalAr = for i = 1  to SuperFacesNormals.count collect #()
faceNormalAr.count

for i = 1 to faceSelAr.count do
(
-- 	format "=============== start faceSelAr[%]: %\n" i faceSelAr[i]
	faceCollected = false
	local faceNormal = polyop.getFaceNormal ep.baseobject faceSelAr[i]
	
	for j = 1 to SuperFacesNormals.count  do
	(
		testAngle = (acos (dot faceNormal SuperFacesNormals[j]))
-- 		format "\tf: % SuperFacesNormals[%]: % testAngle: % \n" faceSelAr[i] k SuperFacesNormals[k] testAngle
			
		if testAngle <= tres then
		(
-- 			format "append SuperFacesNormals[%] %  \n" k faceSelAr[i]
			append faceNormalAr[j] faceSelAr[i]
			faceCollected = true
			exit
		)
		else if testAngle > tres then
		(
-- 			format "ignore faceSelAr[%] testangle: % \n" i testAngle
		)
		else
		(
-- 			format "append faceSelAr[%]: % SuperFacesNormals[%]: % testangle: % \n" i faceNormal j SuperFacesNormals[j] testAngle
			append faceNormalAr[j] faceSelAr[i]
			faceCollected = true
			exit
		)
	)
	if not faceCollected then format "not faceCollected: faceSelAr[%]: %\n" i faceSelAr[i]
-- 	format "=============== done faceSelAr[%]: %\n" i faceSelAr[i]
)

sum = 0
for ar in faceNormalAr do 
(
	sum += ar.count
	format "ar.count: %\n" ar.count
)
sum

format "facesNormals.count: %\n" facesNormals.count
format "SuperFacesNormals.count: %\n" SuperFacesNormals.count
format "faceNormalAr.count:%\n" faceNormalAr.count

-- random test des groupe de normales
q = random 1 faceNormalAr.count
bAr = faceNormalAr[q] as bitarray
format "q: % bAr:%\n" q bAr
polyop.setfaceselection ep bAr
redrawviews()



-- ============== selectionner des faces contigues sur le même plan
facesBitAr = undefined
facesBitAr = polyop.getFaceSelection ep
normalRef = polyop.getFaceNormal ep.baseobject (facesBitAr as array)[1]

tres = 5
loop = 0


while loop < 10 do
(
	loop += 1
	countBefore = facesBitAr.numberSet
	
	-- grow faces selection
	vertsBitAr = polyop.getvertsUsingFace ep facesBitAr
	facesBitAr = polyop.getFacesUsingVert ep vertsBitAr

	-- comparer les normales des faces contigues avec la normale de la première face selectionnée
	facesBitArToDel = #{}
	for f in facesBitAr do
	(
		tmpNormal = polyop.getFaceNormal ep.baseobject f
		testAngle = (acos (dot normalRef tmpNormal))
		
		if testAngle > tres do 
		(
	-- 		format "testAngle: %\n" testAngle
			append facesBitArToDel f
		)
	)
	
	-- suppression des faces qui ne sont pas sur le même plan
	facesBitAr = facesBitAr - facesBitArToDel
	countAfter = facesBitAr.numberSet
	
	format "loop: % count before: % count after: %\n" loop countBefore countAfter
	if countBefore == countAfter then exit
)

polyop.setFaceSelection ep facesBitAr
redrawviews()

