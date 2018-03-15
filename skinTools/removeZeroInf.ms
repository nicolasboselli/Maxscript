fn selectSkinMod s = 
(
	local skinM
	for m in s.modifiers where classof m == skin do skinM = m
	modPanel.setCurrentObject skinM node: s
	skinM
)

max modify mode
m = selectSkinMod $
skinMaxBones = skinOps.GetNumberBones m
bnWtAr = for i = 1 to skinMaxBones collect 0

vxCount = skinOps.GetNumberVertices m

for i = 1 to vxCount do 
(
	bnAr = #()
	wtAr = #()
	
	maxinf = skinOps.GetVertexWeightCount m i
	
	for id = 1 to maxinf do
	(
		bn = skinOps.GetVertexWeightBoneID m i id
		wt = skinOps.GetVertexWeight m i id
		bnWtAr[bn] += wt
-- 		append wtAr wt
	)
	

-- 	skinOps.ReplaceVertexWeights m i bnAr wtAr
--  skinOps.SetVertexWeights 
)
format "bnWtAr: %\n" bnWtAr

for i = bnWtAr.count to 1 by -1 where bnWtAr[i] == 0 do
(
	format " remove id: %, name:%\n" i (skinOps.GetBoneName m i 0)
	skinOps.removebone m i
	redrawViews() 	
)

