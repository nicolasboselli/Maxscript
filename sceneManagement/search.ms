/*
maj:
spliter la fonction collectSameMultiMat:
	faire une fonction qui récupère les copy du materiau de reference parmi une selection d'objet
	faire une fonction qui retourne la stricte selection d'objet qui porte ce materiau
	
	
memo:
-- on peut travailler les materiaux de la scene, d'une selection d ojets, des objets visible, des materiaux de l'editeur de materiaux
*/

faceNumRef = meshop.getNumFaces $
-- edgeNumRef = meshop.getNumVerts  $
vertNumRef =  meshop.getNumVerts  $

for o in all do
(
	local faceNumTest  = meshop.getNumFaces o
-- 	local edgeNumTest  =  meshop.getEdgesUsingFace o #{1}
	local vertNumTest  =  meshop.getNumVerts  o
	
	if faceNumRef == faceNumTest and vertNumRef == vertNumTest then
	(
		if o.ishidden == false then selectmore o
	)	
)


-- collect les multimaterials identique 
fn collectSameMultiMat matRef objSel=
(
-- 	matRef = $.material
	sameMultiMatList = #(matRef)
	sameMultiMatObjList = #()

	if (classof matRef == multimaterial) then
	(
		for o in objSel where isvalidnode o do
		(
			if classof o.material == multimaterial and o.material.numsubs == matRef.numsubs then
			(
				local collectMat = true
				local collectObj = true
				
				for i = 1 to matRef.numsubs do
				(
					if matRef[i] != o.material[i] then 
					(
						collectMat = false 
						collectObj = false
					)
					else()
				)
				
				if o.material  == matRef then 
				(
					collectMat = false
				)
				
				if collectMat then append sameMultiMatList o.material 
				if collectObj then append sameMultiMatObjList o
			)
		)
	)
	else
	(
		for o in objSel where isvalidnode o do
		(
			if o.material == matRef do
			(
				append sameMultiMatObjList o
			)
		)
	)
	
-- 	for i = 1 to sameMultiMatList.count where i <= 24 do meditmaterials[i] = sameMultiMatList[i]
	#( sameMultiMatObjList, sameMultiMatList)
)

fn collectSameMultiMat3 matRef matSet=
(
-- 	matRef = $.material
	local sameMultiMatList = #(matRef)
	
	for m in matSet do
	(
		if (classof matRef == multimaterial) and (classof m == multimaterial)   then
		(
			if  m.numsubs == matRef.numsubs then
			(
				local collectMat = true
				
				if m == matRef then  collectMat = false
				
				for i = 1 to matRef.numsubs do
				(
					if matRef[i] != m[i] then 
					(
						collectMat = false 
					)
					else()
				)
				
				if collectMat then append sameMultiMatList o.material 
			)
		)
	)
	sameMultiMatList
)


fn collectObjByMat matRef objSet =
(
	local sameMultiMatObjList = #()
		
	for o in objSet where isvalidnode o do
	(
		if o.material == matRef do
		(
			append sameMultiMatObjList o
		)
	)
	sameMultiMatObjList
)

-- ############################### COLLAPSE des MULTIMATERIAUX
	-- collapser les multimat de la selection dans l'editeur de materiaux
	-- sel = for o in  $* where o.ishidden == false collect o
	-- listRes = collectSameMultiMat meditmaterials[activeMeditSlot] sel
	-- matList = listRes[2]
	-- for i = 1 to matList.count do replaceinstances matList[i] matList[1]
	-- format "% versions, collapse % materials\n" matList.count  (matList.count - 1)


-- collapser les multimat de la selection dans l'editeur de materiaux v2
sel = for o in  $* where o.ishidden == false collect o
matSel = for s in sel collect s.material
matList = collectSameMultiMat3 meditmaterials[activeMeditSlot] matSel
format "% versions, collapse % materials\n" matList.count  (matList.count - 1)

-- collapse tous les multimateriaux de la scene visible
	-- 	sceneMultiMatList = getClassInstances multimaterial target: scenematerials
	-- 	sceneMultiMatList.count

	-- 	sel = for o in  $* where o.ishidden == false collect o
	-- 	for mat in meditmaterials do
	-- 	(
	-- 		if classof mat == multimaterial then
	-- 		(
	-- 			listRes = collectSameMultiMat mat sel
	-- 			matList = listRes[2]
	-- 			format "% versions, collapse % materials\n" matList.count  (matList.count - 1)
	-- 			for i = 1 to matList.count do replaceinstances matList[i] matList[1]
	-- 		)
	-- 	)

-- collapse tous les multimateriaux de l editeur de materiaux dans la scene visible
visSel = for o in  $* where o.ishidden == false collect o
	
meditMultiMatList = for m in  meditmaterials where classof m == multimaterial collect m
format "meditMultimatList count: %\n" meditMultiMatList.count

-- collapse tous les multimateriaux de la selection
	-- revoir la boucle pour éviter de traiter tout l'array à chaque fois, supprimer les materiaux collapser lde l'arret
		-- matSel = #()
		-- sel = for o in  $* where o.ishidden == false collect o
		-- for s in sel do  appendifunique matSel s.material
		-- matSel.count
	
for mat in meditMultiMatList do
(
	matList = collectSameMultiMat3 mat meditMultiMatList
	format "mat.name: % , % versions, collapse % materials\n" mat.name matList.count  (matList.count - 1)
-- 		for i = 1 to matList.count do replaceinstances matList[i] matList[1]
)

-- ################################ ATTACH/ EXPLODE MESH avec meme MULTIMAT 

fn combineMesh sel =
(
	
	if sel.count < 70 and sel.count > 1 then
	(
		format "attach count: %\n"  sel.count
		for i = 2 to sel.count do
		(
			if classof sel[1].baseobject  == editable_Mesh and  classof sel[i].baseobject  == editable_Mesh then attach sel[1] sel[i] else (format "mesh error: %, %\n" sel[1].name sel[i].name)
		)
		format "attach done\n" 
	)
	else if sel.count == 1 or sel.count == 0 then
	(
		format "pas assez d'objets: % \n" sel.count
	)
	else
	(
		format "trop d'objets: % \n" sel.count
		format "attach fail\n"
		select sel
	)
)


-- attash des meshes visibles d'un multimat selectionner dans le medit material
visSel = for o in  $* where o.ishidden == false collect o
sel = collectObjByMat meditmaterials[activeMeditSlot] visSel
combineMesh sel

-- attash des mesh visibles de tous les multimat de l'editeur de materiaux 
visSel = for o in  $* where o.ishidden == false collect o
	
meditMultiMatList = for m in  meditmaterials where classof m == multimaterial collect m
format "meditMultimatList count: %\n" meditMultiMatList.count

for m in meditMultiMatList do
(
	sel = collectObjByMat m visSel
	format "mat: % attach count: %\n"  m.name sel.count

	combineMesh sel
)

-- explose object avec multimat de l'editeru de materiaux
visSel = for o in  $* where o.ishidden == false collect o
	
meditMultiMatList = for m in  meditmaterials where classof m == multimaterial collect m
format "meditMultimatList count: %\n" meditMultiMatList.count

for m in meditMultiMatList do
(
	sel = collectObjByMat m visSel
	format "mat: % attach count: %\n"  m.name sel.count

	if sel.count == 1 then
	(
			local returnTomesh = false
			if classof sel[1] == Editable_mesh then
			(
				converttopoly sel[1]
				returnTomesh = true
			)
			
			-- eclate objets
			local splitObj = explodeMultiMatDef sel[1]  matchMat: true
			format "explose: %\n" sel[1]
			
			--
			if returnToMesh then
			(
				for o in splitObj do convertToMesh  o
			) else()
			
	)else(format "combine first")
)



-- ############################################## ATTACH MESH AVEC MEME MONOMAT
-- sur la selection d'objet mono mat
	-- collecter les materaux de la selection
-- sel = selection as array
-- matList = #()
-- for s in sel do
-- (
-- 	appendifunique matList s.material
-- )
-- matList.count


-- sur les materiaux de l'editeur de materiaux et sur les objest visibles
visSel = for o in  $* where o.ishidden == false collect o
meditMonoMatList = for m in  meditmaterials where classof m != multimaterial collect m
format "meditMultimatList count: %\n" meditMonoMatList.count


for m in meditMonoMatList do
(
	sel = collectObjByMat m visSel
	format "mat: % attach count: %\n"  m.name sel.count
	combineMesh sel
)


-- collecter les objets par materiaux
/*
k = 1
for i = 1 to  matList.count do
(
	if classof matList[i] != multimaterial then
	(		
		
		local matObj = #()
		-- collecte des objetc mono mat
		for s in sel do
		(
			if isvalidnode s then
			(
				if s.material == matList[i] then append matObj s
			)
		)
		
		format " name: % count: %\n" matList[i].name matObj.count
		if matObj.count < 70 then
		(
			for j = 2 to matObj.count do
			(
				if isvalidnode matObj[j]  then 
				(
					if classof matObj[j].baseobject != Editable_mesh then converttomesh matObj[j]
	-- 				format "attach % et %\n" matObj[1] matObj[j]
					attach matObj[1] matObj[j]
				)
			)
		)
		else
		(
			meditmaterials[k] =  matList[i]
			k += 1
			format "trop d'objets, mat: % count: %\n" matList[i].name matObj.count
		)
	)
)
*/
-- fusionner les objets ensemble

