/*
maj: créer les grilles à mettre dans les calques rep pour faciliter l'affichage par etage
*/

try(destroydialog createLayerRLT)catch()
rollout createLayerRLT "create R layers"
(
	
	spinner startrSP "start:" type: #integer across: 2
	spinner endrSP "end:" type: #integer range: [0,100,5]
	button createBT "create R layers"
	
	on createBT pressed do
	(
		local oneGridAr = #()
		format "% %\n" startrSP.value endrSP.value
		
		-- creation des layers d etage
		for i = startrSP.value to endrSP.value do
		(
			-- creation des grids
			gridName =  ("R"+(i as string))
			res = getnodebyname  gridName
			format "res: %\n" res
			if res == undefined then
			(
				-- collecte de la grille crée
				local oneGrid = grid name: gridName
				append 	oneGridAr oneGrid
			)
			else
			(
				-- collecte de la grille deja existante
				append 	oneGridAr res
			)
			
			-- creation du layer R
			local rName = ("R"+(i as string))
			local rLayer = layermanager.getLayerFromName rName
			if rLayer == undefined then repLayer = layermanager.newLayerFromName  rName
		)
		format "oneGridAr: %\n" oneGridAr
		-- creation du layer rep general
		repName = "rep"
		repLayer = layermanager.getLayerFromName repName
		if repLayer == undefined then repLayer = layermanager.newLayerFromName  repName
			
		rgName = "rep_general"
		rgLayer = layermanager.getLayerFromName rgName
		if rgLayer == undefined then rgLayer = layermanager.newLayerFromName  rgName
			
		rgLayer.setParent repLayer
		
		-- ajout des grids au layer R
		format "oneGridAr: %\n" oneGridAr
		for g in oneGridAr do rgLayer.addnode g
	)
	
)
createdialog createLayerRLT

