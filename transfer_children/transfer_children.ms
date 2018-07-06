-- transfer children

fn transferChildren source target =
(
-- 	source = sel[1]
-- 	target = sel[2]

	childrenAr = #(source)

	-- collecte enfant source
	for c in childrenAr do 
	(
		for ch in c.children do appendifunique childrenAr ch
	)

	--creation de la copy
	maxOps.cloneNodes childrenAr cloneType:#copy newNodes:&copyChilds
	
	-- prendre en charge les copies de railclone
	
	-- rotate
	 copyChilds[1].transform = target.transform

	--
	childTargetAr = #(target)
	-- collecte enfant source
	for c in childTargetAr do 
	(
		for ch in c.children do appendifunique childTargetAr ch
	)
	-- delete des target
	for i = 2 to childTargetAr.count where isvalidnode childTargetAr[i] do  delete childTargetAr[i]
		
	-- reparent dela copy
	for i = 2 to copyChilds.count do
	(
		if copyChilds[i].parent == copyChilds[1] then copyChilds[i].parent = target
	)

	-- nettoyage
	delete  copyChilds[1]
)

sel = selection as array
-- transferChildren sel[1] sel[2]

for i = 2 to sel.count do
(
	transferChildren sel[1] sel[i]
)
