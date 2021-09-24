l = LayerManager.getLayerFromName  "02_BAT"

-- collecte des calques enfants de 02_BAT
j = 0
lAr = #(l)
for l in lAr do
(
	for i = 1 to (l.getNumChildren ()) do
	(
		l2 = l.getChild i
		format "%\n" l2.name
		append lAr l2
	)
	-- 
	j+=1
	if j > 500 then exit
)
lAr.count

-- renommage des objets du layer
grpAr = #()
for l in lAr do
(
	l.nodes &tmpNodes
	for o in tmpNodes do
	(
		if isKindof o AvizstudioToolsATiles then 
		(
			o.name = uniquename(l.name + "_Aviz_")
			format "ignore: %\n" o.name
		)
		else if isKindof o Forest_Pro then
		(
			o.name = uniquename(l.name + "_FP_")
			format "ignore: %\n" o.name
			-- trouver les quides
		)
		else if isKindof o RailClone_Pro then 
		(
			o.name = uniquename(l.name + "_RC_")
			format "ignore: %\n" o.name
			-- trouver les guides
		)
		else if iskindof o dummy and isgrouphead o then
		(
-- 			if (matchpattern o.name pattern: "Group*") then o.name = uniquename(l.name + "_GRP_")
			o.name = uniquename(l.name + "_GRP_")
			append grpAr o
		)
		else
		(
			o.name = uniquename(l.name + "_MDL_")
		)
	)
)

for g in grpAr do
(
	-- collecter les enfants
	--
	grpChildrenAr = for c in g.children collect c
	for o in grpChildrenAr do
	(
		for c in o.children do appendifunique grpChildrenAr c
	)
	for s in grpChildrenAr do s.name = uniquename (g.name + "_MDL_" )
	
	if not (matchpattern g.layer.name pattern:g.name) then
	(
		local daddy = g.layer
		if not iskindof (layermanager.getlayerfromname g.name) MixinInterface then layermanager.newlayerfromname g.name
		local tpL = layermanager.getlayerfromname g.name
		tpL.setParent daddy
		
		tpL.addnode g
		for c in grpChildrenAr do tpL.addnode c
	)
)

-- renommages des groups et de leurs enfant
-- distinguer les aviz tiles, les forest, les atiles, les fenetres
-- trouver et renommer les guides forest et railclone  

