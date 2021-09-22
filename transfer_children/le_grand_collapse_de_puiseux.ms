
-- récupérer tous les points de transfer de la scene
allTransferPoints = #()

mastersAr = getMasters()
allTransferPoints += mastersAr

for m in mastersAr do 
(
	targetAr = getTargets m
	allTransferPoints += targetAr
)
allTransferPoints.count

-- pour chaque point de transfert
 -- collecter tous les enfant
for tp in allTransferPoints do
(
	tpChildrenAr = for c in tp.children collect c
	for o in tpChildrenAr do
	(
		for c in o.children do appendifunique tpChildrenAr c
	)
	tpChildrenAr.count
	
	-- verifier qu'il sont dans un calque au nom du point de transfer
	-- tp = allTransferPoints[1]
	if not (matchpattern tp.layer.name pattern:tp.name) then
	(
		local daddy = tp.layer
		if not iskindof (layermanager.getlayerfromname tp.name) MixinInterface then layermanager.newlayerfromname tp.name
		local tpL = layermanager.getlayerfromname tp.name
		tpL.setParent daddy
		for c in tpChildrenAr do tpL.addnode c
	)
)


-- verifier qu'il sont dans un calque au nom du point de transfer
-- tp = allTransferPoints[1]

-- sinon créer le calque en resepectant la hierarchie de calquemettre tous les enfant dedans 

-- éclater tous les groupe
-- procéder au collapse