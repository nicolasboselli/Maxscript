/*
maj:
spliter la fonction collectSameMultiMat:
	faire une fonction qui récupère les copy du materiau de reference parmi une selection d'objet
	faire une fonction qui retourne la stricte selection d'objet qui porte ce materiau
	
	
memo:
-- on peut travailler les materiaux de la scene, d'une selection d ojets, des objets visible, des materiaux de l'editeur de materiaux
*/

-- permet de collacter les objets identiques
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

-- ################## clean editmesh isolated vertices
-- meshop.deleteIsoVerts $
i = 0
for s in selection do
(
	if classof s.baseobject == Editable_mesh then
	(
		meshop.deleteIsoVerts s
		s.pivot = s.center
		i += 1
		format "i: %\n" i
	)
)


-- ### collect same multi material
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
				
				if collectMat then append sameMultiMatList m 
			)
		)
	)
	sameMultiMatList
)


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


-- ############################### COLLAPSE des MULTIMATERIAUX
	-- collapser les multimat de la selection dans l'editeur de materiaux
	-- sel = for o in  $* where o.ishidden == false collect o
	-- listRes = collectSameMultiMat meditmaterials[activeMeditSlot] sel
	-- matList = listRes[2]
	-- for i = 1 to matList.count do replaceinstances matList[i] matList[1]
	-- format "% versions, collapse % materials\n" matList.count  (matList.count - 1)


-- collapser les multimat de la selection dans l'editeur de materiaux v2
-- sel = for o in  $* where o.ishidden == false collect o
-- matSel = for s in sel collect s.material
-- matList = collectSameMultiMat3 meditmaterials[activeMeditSlot] matSel
-- format "% versions, collapse % materials\n" matList.count  (matList.count - 1)

-- collapse tous les multimateriaux de l editeur de materiaux dans la scene visible
visSel = for o in  $* where o.ishidden == false collect o
visSelMultiMat = #()
for o in visSel where classof o.material == multimaterial do
(
	appendifunique visSelMultiMat o.material
)
format "visSelMultiMat count: %\n" visSelMultiMat.count

meditMultiMatList = for m in  meditmaterials where classof m == multimaterial collect m
format "meditMultimatList count: %\n" meditMultiMatList.count

for j = 1 to meditMultiMatList.count do
(
	local matList = collectSameMultiMat3 meditMultiMatList[j] visSelMultiMat
-- 	format "matList: %\n" matList
-- 	format "mat.name: % , % versions, collapse % materials\n" mat.name matList.count  (matList.count - 1)
	for i = 1 to matList.count do
	(
		replaceinstances matList[i] matList[1]
		format "% replaces %\n" matList[1] matList[i]
		format "medit: % , collapse: %/% \n" j i matList.count 
	)
)

-- collapse le multimat choisi dans l editeur de materiaux
matList = collectSameMultiMat3  meditmaterials[activeMeditSlot] visSelMultiMat
for i = 1 to matList.count do
(
	replaceinstances matList[i] matList[1]
	format "% replaces %\n" matList[1] matList[i]
	format "%/% ; % versions, collapse % materials\n" i matList.count   matList.count  (matList.count - 1)
)

-- collapse des multimariaux des objets visibles
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

-- select object by material
clearselection()
for o in $* do
(
	if o.material ==  meditmaterials[activeMeditSlot] then 
	(
		o.ishidden = false
		selectmore o
	)
	else
	(
		o.ishidden = true
	)
)

-- replaceinstances meditmaterials[2] meditmaterials[activeMeditSlot]z

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


-- test d attach
sel = selection as array

for i = 1 to sel.count by 10 do
(
	format "sel.count: % i: %\n" sel.count i
	for j = 1 to 10 do
	(
		attach sel[i] sel[i + j]
	)
	format "sel.count: % i: %\n" sel.count i
-- 	j = 1
)


for i = 1 to sel.count by 10 do
(
	format "% " i 
	i = i + 10 
-- 	if i < sel.count then i +=10 else exit
)


-- attash des meshes visibles d'un multimat selectionner dans le medit material
visSel = for o in  $* where o.ishidden == false collect o
sel = collectObjByMat meditmaterials[activeMeditSlot] visSel
select sel

combineMesh sel

-- attash des mesh visibles de tous les multimat de l'editeur de materiaux 
visSel = for o in  $* where o.ishidden == false collect o
	
meditMultiMatList = for m in  meditmaterials where classof m == multimaterial collect m
format "meditMultimatList count: %\n" meditMultiMatList.count

for m in meditMultiMatList do
(
	sel = collectObjByMat m visSel
	format "mat: % attach count: %\n"  m.name sel.count
-- 	combineMesh sel
	
	if sel.count > 70 then
	(
		exit
		select sel
		format "attachement manuel"
	)
	else
	(
		combineMesh sel
	)

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

-- fusion des objets visibles par mateiraux
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
	
	
	if sel.count > 5000 then
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



