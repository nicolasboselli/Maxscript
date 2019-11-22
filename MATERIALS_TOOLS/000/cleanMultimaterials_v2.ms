/*
maj:
spliter la fonction collectSameMultiMat:
	faire une fonction qui récupère les copy du materiau de reference parmi une selection d'objet
	faire une fonction qui retourne la stricte selection d'objet qui porte ce materiau
	
	
memo:
-- on peut travailler les materiaux de la scene, d'une selection d ojets, des objets visible, des materiaux de l'editeur de materiaux
*/


-- ### collect same multi material
fn collectSameMultiMat3 matRef matSet =
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
				
				if collectMat then append sameMultiMatList m 
			)
		)
	)
	sameMultiMatList
)

-- collecte d'objet par materiaux dans un  set d'objets
fn collectObjByMat matRef objSet =
(
	/*utiliser  refs.dependents meditmaterials[activeMeditSlot] */
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

fn clusterAttach objArr =
(
	j = 1
	count = objArr.count

	undo off
	(
		while objArr.count > 1 do
		(
			
			
			if classof objArr[j].baseobject != editable_Mesh then converttoMesh objArr[j]
				
			-- DESINSTANCE
			
			if (InstanceMgr.CanMakeObjectsUnique objArr[j]) then
			(
				format "desinstance: %\n" objArr[j].name
				InstanceMgr.MakeObjectsUnique objArr[j] #prompt
			)
			
			if (InstanceMgr.CanMakeObjectsUnique objArr[j+1]) then
			(
				format "desinstance: %\n" objArr[j+1].name
				InstanceMgr.MakeObjectsUnique objArr[j+1] #prompt
			)
			
			-- ATTACH
			attach objArr[j] objArr[j+1]
			
			deleteItem objArr (j+1)

			j += 1

			if (j + 1) > objArr.count then j = 1

		)
	)
	objArr[1]
)

fn getFacesID s =
(
	local idArray = #()
	local faceMax = meshop.getNumFaces s
	for i = 1 to faceMax do appendifunique idArray (getFaceMatID s i)
	idArray
)

fn exploseMeshBymat s = 
(
	-- maj: mettre les morceaux sur le meme calque que l'objet unique
	local splitObjList = #(s)
	-- debug de l objet
	resetpivot s
	if (InstanceMgr.CanMakeObjectsUnique s) then (InstanceMgr.MakeObjectsUnique s #prompt )

	idArray = getFacesID s

	for id in idArray where id > 1 do
	(
		local new
		local faceMax = meshop.getNumFaces s
		local faceList = #()
		for f = 1 to faceMax do
		(
			if (getFaceMatID s f ) == id do append faceList f
		)
-- 		format "id: % facelist: %\n" id (facelist as bitarray)
		
		local newMesh = meshop.detachFaces s faceList delete: true asMesh: true
		
		-- creation de la nouvelle mesh
-- 		format "res: %\n" res
		emesh = Editable_mesh() --create an empty Editable_mesh
		emesh.mesh = newMesh --assign the detached faces to the new mesh
		update emesh --update the mesh
		
		emesh.material = s.material[id]
		emesh.transform = s.transform
		
		append splitObjList emesh
		
		-- ajout sur le meme calque
		s.layer.addnode emesh
	)
	s.material = s.material[1]
	update s
	
	splitObjList
)

-- ################################	-- collapse des multimariaux des objets visibles
fn collapseMultiMatonVisibleObjects =
(

	visSel = for o in  $* where o.ishidden == false collect o
	visSelMultiMat = #()
	for o in visSel where classof o.material == multimaterial do
	(
		appendifunique visSelMultiMat o.material
	)
	format "visSelMultiMat count: %\n" visSelMultiMat.count

	for j = 1 to visSelMultiMat.count do
	(
		local matList = collectSameMultiMat3 visSelMultiMat[j] visSelMultiMat
	-- 	format "matList: %\n" matList
	-- 	format "mat.name: % , % versions, collapse % materials\n" mat.name matList.count  (matList.count - 1)
		if matList.count > 1 then
		(
			format "matref : % , collapse % materiaux\n" j matList.count 
			for i = 1 to matList.count do
			(
				replaceinstances matList[i] matList[1]
	-- 			format "% replaces %\n" matList[1] matList[i]
	-- 			format "medit: % , collapse: %/% \n" j i matList.count 
			)
			
			visSelMultiMat = #()
			for o in visSel where classof o.material == multimaterial do
			(
				appendifunique visSelMultiMat o.material
			)
			format "visSelMultiMat count: %\n" visSelMultiMat.count
			
			j = 1
		)
	)
)

-- ################################Attach/ EXPLODE MESH avec meme MULTIMAT 
fn explodeVisibleObjectsByMultiMat =
(
	local i = 0
	-- collecte des objets visibles
	visSel = for o in  $* where o.ishidden == false collect o
	format "visSel count before: %\n" visSel.count

	-- collecte des multimateriaux de la scene
	multiMatList = getclassinstances multimaterial target: scenematerials
	format "multiMatList count: %\n" multiMatList.count

	for m in multiMatList do
	(
		i += 1
		local sel
		local splitObj
		local oneObj
		
		sel = collectObjByMat m visSel
-- 		format "i: % mat: % sel: %\n" i m.name sel 
		
		if sel.count == 0 then continue
		else if sel.count == 1 then
		(
			oneObj = sel[1]
			format "i: % mulitmat: % sel.count: % obj: %\n" i m.name sel.count oneObj
			if not isvalidnode oneObj then continue
			else
			(	
				if not iskindof oneObj editable_mesh then  converttomesh oneObj
				splitObj = exploseMeshBymat oneObj
			)
		)
		else
		(
			oneObj = clusterAttach sel
			format "i: % mulitmat: % sel.count: % obj: %\n" i m.name sel.count oneObj
			
			if not isvalidnode oneObj then continue
			else
			(		
				splitObj = exploseMeshBymat oneObj
			)
		)
	)
	visSel = for o in  $* where o.ishidden == false collect o
	format "visSel count after: %\n" visSel.count
)

-- ############################################## ATTACH MESH AVEC MEME MONOMAT
-- sur la selection d'objet mono mat
-- fusion des objets visibles par mateiraux
fn attachVisiblesObjectsByMonoMat maxSel: 1000 =
(
	visSel = for o in  $* where o.ishidden == false collect o
	format "visSel count: %\n" visSel.count

	meditMonoMatList = #()
	for s in visSel where s.material != undefined and classof s.material != multimaterial do appendifunique meditMonoMatList s.material 
	format "meditMonoMatList count: %\n" meditMonoMatList.count


	for m in meditMonoMatList do
	(
		sel = collectObjByMat m visSel
		format "mat: % attach count: %\n"  m.name sel.count
	-- 	combineMesh sel
			
		if sel.count > maxSel then
		(
			
	-- 		select sel
			format "attachement manuel\n"
	-- 		exit
		)
		else if sel.count == 1 then
		(
			format "pas d'attachement à faire\n"
		)
		else
		(
			local bef = timestamp()
			clusterAttach sel
			format "attach done: % s\n" (((timestamp()) - bef) / 1000 as float)
	-- 		combineMesh sel
		)
	)
)


-- collapseMultiMatonVisibleObjects()
-- explodeVisibleObjectsByMultiMat()
-- attachVisiblesObjectsByMonoMat maxSel: 1000


