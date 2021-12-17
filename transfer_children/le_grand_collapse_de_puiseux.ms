
-- récupérer tous les points de transfer de la scene
allTransferPoints = #()

mastersAr = getMasters()
-- allTransferPoints += mastersAr

for m in mastersAr do 
(
	targetAr = getTargets m
	allTransferPoints += targetAr
)
allTransferPoints.count

k = 0
-- pour chaque point de transfert
for tp in allTransferPoints do
(
	k += 1
	format "##### collapse tp started: % (%/%)\n" tp.name k allTransferPoints.count
	 -- collecter tous les enfant
	tpChildrenAr = for c in tp.children collect c
	for o in tpChildrenAr do
	(
		for c in o.children do appendifunique tpChildrenAr c
	)
	tpChildrenAr.count
	
	format "layering\n"
	-- verifier qu'il sont dans un calque au nom du point de transfer ou les deplacer
	-- tp = allTransferPoints[1]
	local tpL
	tpL = layermanager.getlayerfromname tp.name
	if not (matchpattern tp.layer.name pattern:tp.name) then
	(
		local daddy = tp.layer
		if not iskindof (layermanager.getlayerfromname tp.name) MixinInterface then layermanager.newlayerfromname tp.name
		tpL = layermanager.getlayerfromname tp.name
		tpL.setParent daddy
		tpL.addnode tp
		for c in tpChildrenAr do tpL.addnode c
		format "tpL: %\n" tpL.name
	)
	format "tpL: %\n" tpL.name
	
	-- ungrouping
	for o in tpChildrenAr where iskindof o dummy and isgrouphead o do
	(
		setGroupOpen o false
		ungroup o
	)
	
	-- import clean mulyimat fonction
	format "explosing\n"
	explodeVisibleObjectsByMultiMat tpChildrenAr
	
	-- attaching
	format "attaching\n"
	tpL.nodes &oneLayerSel
	res = findItem oneLayerSel tp
	
	if res > 0 then deleteitem oneLayerSel res
	if oneLayerSel.count > 0 then attachVisiblesObjectsByMonoMat oneLayerSel maxSel: 5000
	
	-- finishing
	format "finishing\n"
	tpL.nodes &oneLayerSel2
	
	res = findItem oneLayerSel2 tp
	format "res2: %\n" res
	if res > 0 then deleteitem oneLayerSel2 res
	
	format "renaming\n"
	
	for o in oneLayerSel2 do 
	(
-- 		format "o: % tpL: % \n" o.name tpL.name
-- 		if o.material != undefined then format "o.material: % \n"  o.material.name
		o.parent = tp
		if o.material != undefined then o.name = tpL.name + "_" + o.material.name else  o.name = tpL.name + "_NO_MAT"
	)
	format "##### collapse tp done: %\n" tp.name
)


-- verifier qu'il sont dans un calque au nom du point de transfer
-- tp = allTransferPoints[1]

-- sinon créer le calque en resepectant la hierarchie de calquemettre tous les enfant dedans 

-- éclater tous les groupe
-- procéder au collapse