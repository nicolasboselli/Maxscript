

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