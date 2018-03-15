
m = $.modifiers[ #skin]
vxCount = skinOps.GetNumberVertices m
bnCount = skinOps.GetNumberBones m

-- selectionner les element par vertes
vxSelAr = #()
for i = 1 to vxCount do
(
	if (skinOps.IsVertexSelected  m i) == 1 then append vxSelAr i
)
vxSelAr

-- pour chaque element calculer les influence moyenne

-- trouver l influence pricipale
	-- collecter les influences

for v in vxSelAr do
(
	bnTable = for i = 1 to bnCount collect 0
-- pour chaque vertex
	-- trouver le nombre d'influence
	maxInf = skinOps.GetVertexWeightCount m v
	
	for id = 1 to maxinf do
	(
		bn = skinOps.GetVertexWeightBoneID m v id
		wt = skinOps.GetVertexWeight  m v id
-- 			format "bone: %, weigth: %\n" bn wt
		bnTable[bn] = bnTable[bn] + wt
	)
	
	-- format "%" bnTable

	masterBone = finditem bnTable (amax bnTable)
	
	-- trouver l element selectionner par vertex
	faceSel = polyop.getFacesUsingVert $ v
	eltSel = polyop.getElementsUsingFace $ faceSel
	vxAr = (polyop.getVertsUsingFace $ eltSel) as array
	
	-- mettre l'influence princapale a 100
	for v in vxAr do skinOps.ReplaceVertexWeights m v masterBone 1
)



