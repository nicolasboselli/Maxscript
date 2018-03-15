-- MutiMatUnificator
-- amélioration: appliquer aux objets selectionnés ou a toute la scene

-- CREATION DU MASTERMULTIMAT de la scene
	-- rassemble tous les materiaux des multimateriaux de la scene dans un seul multimaterial:
		-- collecter tous les multimaterial de la scene
multiMatArray = #();

for i = 1 to sceneMaterials.count do
(	
	if classof sceneMaterials[i] == multimaterial then append multiMatArray sceneMaterials[i];
)

		-- collecter tous les material des multimaterial

multiMatMatArray = #();

for multiMat in multiMatArray do
(
	for mat in multiMat do append multiMatMatArray mat
)

multiMatMatArray.count

		-- rendre les materiax de même nom unique
masterMultimatList = #()
masterMultimatList = makeuniqueArray multiMatMatArray
masterMultimatList.count

		-- créer un multimaterial avec tous les materiaux uniques
masterMultiMat =  multimaterial numsubs: masterMultimatList.count name: (uniqueName("MultiMat"))
for i = 1 to masterMultiMat.count do masterMultiMat[i] = masterMultimatList[i]
	
-- refaire le master multi mat en fonctiond  des noms de materiaux

-- collecte des tous les noms
MultiMatName = for o in scenematerials["MultiMat001"] collect o.name
MultiMatName = makeuniquearray MultiMatName
sort MultiMatName

-- collecte des bons noms
MultiMatGoodName = #()
for o in MultiMatName do
(
	print (findstring o "default")
	if (findstring o "default") == undefined do 
	(
		append  MultiMatGoodName o
	)
)

-- collecte des materiaux avec les bons noms
MultiMatWithGoodName = #()
	
for mat in masterMultiMat do
(
	for matName in MultiMatGoodName do
	(
		if mat.name == matName then print matName
	)
		
)

-- collecte de  tous les materiaux default même quand ils ont le même nom
MultiMatDefault = #()
for o in masterMultiMat do
(
-- 	print o.name 
	if (findstring o.name "default") != undefined  do append MultiMatDefault o
)

meditmaterials[1] =masterMultiMat

		-- collecte des objets présentant un multimaterial
multiMatObjArray = #()
for o in ($* as array) do
(
	if superclassof o == geometryclass AND classof o.material == multimaterial then append multiMatObjArray o
)
select multiMatObjArray

-- pour chaque objet presentant un multimaterial:


-- POUR un objet Presentant un multi material
-- recuperation du multimaterial de l'objet
curMultiMat = $.material
	
-- comparaison les id de materiaux employés sur l'objet dans le master material, creation du tableau d'id
idMapping = #()

for a = 1 to curMultiMat.count do 
(
	for b = 1 to masterMultiMat.count do
	(
		if (curMultiMat[a] == masterMultiMat[b]) then
		(
			
			subobjectLevel = 4
			
			-- collecter l'array de face auquele il faudra applique la future id par comparaison de materiaux
			
			$.EditablePoly.selectByMaterial a
			if (((polyop.getFaceSelection $) as array).count != 0) then 
			(
			idCouple = #()
				
			faceToSwitch = ((polyop.getFaceSelection $) as array)
			
			polyop.setFaceSelection $ #{}
			redrawViews()

			-- 		collecter la future id
			idToSwitch = b
			
-- 			creation du mapping d'id
			idCouple = #(faceToSwitch, idToSwitch)
			
			append idMapping idCouple
			print ("curMultiMat[" + (a as string) + "] == masterMultiMat[" + (b as string) + "]")
			)

			-- collecter l'array de face auquele il faudra applique la future id par comparaison de nom de materiaux
			
		)
	)
)

-- appliquer le mastermultimat
$.material = masterMultiMat
-- pour chaque id d'origine du poly appliquer l'id du mastermat appropriée

subobjectLevel = 4
for i = 1 to  idMapping.count do
(
polyop.setFaceSelection $ (idMapping[i][1] as bitarray)
polyop.setFaceMatID $ #selection idMapping[i][2]
redrawViews()
)


			
			-- appliquer le master multi, 
