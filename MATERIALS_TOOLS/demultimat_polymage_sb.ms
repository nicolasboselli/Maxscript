/*
faire un set de selection
1- dupliquer le multi mat et appliquer une copie à chaque objet
afficher les materiaux de la selection d'objets dans le mat editor
2 - supprimer les ids non utilisé (script medit)
3 - collapser les multimat identiques ( clean multi mat)
4 - quand un multimat n'a plus qu'une id, appliqué l'id directement
*/
-- meditmaterials[7].materialIDList = #(1, 2, 3, 4, 5, 7, 14, 20)

-- $.material.numsubs
-- $.material.materialList 
-- $.material.materialIDList 


-- copie d'un multimat unique à chaque objet
sel = selection as Array

-- for s in sel do
-- (
-- 	format "s.name: % s.class: %\n" s.name (classof s)
-- )

reMat = sel[1].material

-- mettre securité pour ne pas appliquer le multimat à des objets qui ne le porte pas
reMat.materialIDList = sel[1].material.materialIDList
materialIDListBak = sel[1].material.materialIDList

for s in sel do
(
	if iskindof s dummy do continue
		
	s.material = multimaterial ()
	s.material.materialList  = reMat.materialList 
	s.material.materialIDList  = materialIDListBak
	s.material.name = s.name + "_Multi_Mat"
)


-- nettoyage su multimat
sel = selection as Array
for s in sel do
(
	if iskindof s dummy do continue
		
-- 	format "\ns: %\n" s.name
	addmodifier s (edit_mesh())
		
	idsUsed = #()
	facesCount = getNumFaces s
	for i = 1 to facesCount do appendifunique idsUsed (getFaceMatID s i)
-- 	for i = 1 to facesCount do appendifunique idsUsed (s.getFaceMaterial i)

	matUsed = #()
-- 	mmIDs = #()
		
	for id in idsUsed do
	(
		local oneID = findItem s.material.materialIDList id
-- 		format "	id: % oneID: %\n" id oneID
		try(append 	matUsed s.material.materialList[oneID])catch(format "fail!: id: % oneID: % s: %\n" id oneID s)
	)
	
		
-- 	for id in idsUsed do append matUsed s.material.materialList[id]
	
-- 	format "	idsUsed: % matUsed: % \n" idsUsed matUsed
	
	s.material.materialList = matUsed
	s.material.materialIDList  = idsUsed
	
	deletemodifier s 1
)


fn collapseMultiMatonVisibleObjects visSel=
(

-- 	visSel = for o in  $* where o.ishidden == false collect o
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
-- collapse des multimats / replaceinstance des multi mat identiques
collapseMultiMatonVisibleObjects sel

-- copie des ids uniques / replace insatnce des multis à id unique par des materiaux simple
sel = selection as Array
for s in sel where iskindof s.material Multimaterial do
(
	if s.material.materialList.count == 1 then
	(
		format "s: % s.mat: % mat: %\n" s.name s.material.name s.material.materialList[1]
-- 		print "youhou"
		replaceInstances s.material s.material.materialList[1]
	)
)


