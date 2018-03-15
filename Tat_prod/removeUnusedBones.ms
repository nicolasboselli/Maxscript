
m = modPanel.getCurrentObject() 
vxCount = $.editablepoly.GetNumVertices ()
-- pour chaque vertex collecter les skin qui influencent à plus de zero
bonesUsed = #()
for i = 1 to vxCount do
(
-- pour chaque vertex
	-- trouver le nombre d'influence
	maxInf = skinOps.GetVertexWeightCount m i
	
	for id = 1 to maxinf do
	(
		res = skinOps.GetVertexWeightBoneID m i id
		-- si le bone selectionner est dans les influence du vertex collecter le numero du vertex
-- 		if res == boneId do append goodVxAr i
		appendifunique bonesUsed res
	)
)
format "%\n" bonesUsed
bonesUsed.count

bonesNum = skinOps.GetNumberBones m
-- skinOps.multiRemove m
-- comparer avec la liste des bones

for i = bonesNum to 1 by -1 do
(
	res = finditem bonesUsed i
	if res > 0 then
	(
		format "used: % ; id:%\n" (skinOps.GetBoneName m i 0 ) i
	)
	else
	(
		format "not used: % ; id: %\n" (skinOps.GetBoneName m i 0 ) i
		skinOps.removebone m i
	)
	redrawviews()
)