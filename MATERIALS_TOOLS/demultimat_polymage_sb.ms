sel = selection as Array
reMat = sel[1].material
/* 


testMulti = meditMaterials[1]
testMulti.numsubs = 6
testMulti.mapEnabled =  #(true, true, false, true, true, true)
testMulti.materialList  = reMat.materialList 

newMulti.numsubs = reMat.numsubs
for m in reMat.numsubs */

 for s in sel do
(
	s.material = multimaterial ()
	s.material.materialList  = reMat.materialList 
	s.material.name = s.name + "_Multi_Mat"
) 

reMat.materialIDList
newMulti.materialIDList


/* -- ### collect same multi material
fn collectSameMultiMat3 matRef matSet =
(
-- 	matRef = $.material
	local sameMultiMatList = #(matRef)
	
	for m in matSet do
	(
		-- format 
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
	format "sameMultiMatList: %\n" sameMultiMatList
	sameMultiMatList
) */



sel = selection as Array
-- ################################	-- collapse des multimariaux des objets visibles


-- collecte des multi mat de la selection
visSelMultiMat = #()
for o in sel where iskindof o.material multimaterial do
(
	appendifunique visSelMultiMat o.material
)
format "visSelMultiMat count: %\n" visSelMultiMat.count

--pour chaque multi mat de selection,
for j = 1 to visSelMultiMat.count do
(
-- 	 recherche des multi mat identique
-- 	local matList = collectSameMultiMat3 visSelMultiMat[j] visSelMultiMat
-- 	format "matList: %\n" matList
	
	-- 	matRef = $.material
	local sameMultiMatList = #(visSelMultiMat[j])
-- 	format "start testing j:% visSelMultiMat[j][i]: %  visSelMultiMat[k][i]: % \n" k j i visSelMultiMat[j][i].name visSelMultiMat[k][i].name
	for k = 1 to visSelMultiMat.count do
	(
		-- format 
		format "start testing j:%  k:% visSelMultiMat[j]: %  visSelMultiMat[k]: % \n"  j k visSelMultiMat[j].name visSelMultiMat[k].name
		if k == j then continue
		if not (classof visSelMultiMat[j] == multimaterial) or not (classof visSelMultiMat[k] == multimaterial) then continue
		
		if  visSelMultiMat[j].numsubs != visSelMultiMat[k].numsubs then continue
			
		
				
-- 		if  visSelMultiMat[j] == visSelMultiMat[k] then continue
		
		format "start comparing  j:% k:% visSelMultiMat[j]: %  visSelMultiMat[k]: % visSelMultiMat[j].numsubs: % visSelMultiMat[k].numsubs: %\n" k j visSelMultiMat[j].name visSelMultiMat[k].name visSelMultiMat[j].numsubs visSelMultiMat[k].numsubs
		
		local collectMat = true
				
		for i = 1 to visSelMultiMat[j].numsubs do
		(
			if visSelMultiMat[j][i] != visSelMultiMat[k][i] then 
			(
				format "fail \n"
				format "k:% j:% i:% fail: visSelMultiMat[j][i]: %  visSelMultiMat[k][i]: % \n" k j i visSelMultiMat[j][i] visSelMultiMat[k][i]
				collectMat = false 
				exit
			)
			else()
		)
				
		if collectMat then append sameMultiMatList m 
			
		
	)
	format "sameMultiMatList: %\n" sameMultiMatList
-- 	sameMultiMatList
	
	
	
	
	
-- 	format "mat.name: % , % versions, collapse % materials\n" mat.name matList.count  (matList.count - 1)
/* 	if sameMultiMatList.count > 1 then
	(
		format "matref : % , collapse % materiaux\n" j sameMultiMatList.count 
		for i = 1 to sameMultiMatList.count do
		(
			replaceinstances sameMultiMatList[i] sameMultiMatList[1]
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
	) */
)


-- collapseMultiMatonVisibleObjects sel