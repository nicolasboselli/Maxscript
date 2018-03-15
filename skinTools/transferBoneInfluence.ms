-- transfer skin
	-- transfere l'influence d'un bone sur l'autre 


-- pour chaque point ou on trouve l'influence de la source:
	-- ecrire la liste des nouvelles influences 

fn selectSkinMod s = 
(
	local skinM
	for m in s.modifiers where classof m == skin do skinM = m
	modPanel.setCurrentObject skinM node: s
	skinM
)

fn transferBoneInfluence source dest m =
(
	vxCount = skinOps.GetNumberVertices m
	
	local sourceID 
	local destID
	
	-- et de la destination dans les bones su skin	
	skinMaxBones = skinOps.GetNumberBones m
	for b = 1 to skinMaxBones do
	(
		boneName = skinOps.GetBoneName m b 0
		if boneName == dest.name then destID = b
	)
	
	if destID == undefined then 
	(
		skinOps.addbone m dest  -1
-- 		destID = skinMaxBones + 1
		skinMaxBones = skinOps.GetNumberBones m
		for b = 1 to skinMaxBones do
		(
			boneName = skinOps.GetBoneName m b 0
			if boneName == dest.name then destID = b
		)
	)
	
	-- trouver les index de la source 
	for b = 1 to skinMaxBones do
	(
		boneName = skinOps.GetBoneName m b 0
		if boneName == source.name then sourceID = b
	)
	
	format "source: %, id:%\n" source.name sourceID
	format "destination: %, id:%\n" dest.name destId
	-- 
	if sourceID != undefined and destID != undefined then
	(
		-- pour chaque vertex remplacer l'ancien bone par le nouveau
		for i = 1 to vxCount do 
		(
			bnAr = #()
			wtAr = #()
			
			maxinf = skinOps.GetVertexWeightCount m i
			
			for id = 1 to maxinf do
			(
				bn = skinOps.GetVertexWeightBoneID m i id
				if bn == sourceID then bn = destID
				append bnAr bn
				
				wt = skinOps.GetVertexWeight m i id
				append wtAr wt
			)
			
			format "bnAr: %, wtAr: %\n" bnAr wtAr
			skinOps.ReplaceVertexWeights m i bnAr wtAr
		--  skinOps.SetVertexWeights 
		)
	)else(format "source: %, dest: %\n" sourceID destID)
)




sel = selection as array
transferBoneInfluence sel[1] sel[2] (selectSkinMod sel[3])
