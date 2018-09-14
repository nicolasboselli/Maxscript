-- extraction d'asset
/*
bug:
	-- le move sur les groupes nne recentre pas les objets
		-- peut etre qu'il y a un probleme avec les hierarchies
	

todo:
	-- changer le chemin du repository
	-- ramene la selection au centre de 

	-- par calque
		-- selectionner les objets
		-- faire un save selected avec le nom du calque dans le dossier d'asset
		
		
	
*/


try(destroydialog assetExtractorRLT)catch()
rollout assetExtractorRLT "Assets Extractor"
(
	local prefs
	local theNodes = #()
	local assetPath = @"M:\Interieur\Cellules\Modelisation\Library\Objects"
	group "Tools:"
	(
		button tagBT "tag layers"
	)
	
	group "Extraction Options:"
	(
		checkbox originCB "return to origin" checked: true
	)
	
	group "Extract by Layer:"
	(
		multilistbox layerMLB "Layers:"
		button refreshBT "refresh"
		button extractLayerBT	"Extract by Layer"
	)
	
	group "Extract Selection:"
	(
		edittext assetNameET "asset name"
		button extractSelBT "Extract selection"
	)
	
	on assetExtractorRLT open do
	(
		
	)
	
	on tagBT pressed do
	(
		local pattern =  "____[ASSET_A_EXTRAIRE]"
		layerExplorer = SceneExplorerManager.GetActiveExplorer()
		selectedItems = layerExplorer.SelectedItems()
		layersName = for i in selectedItems where isKindOf i Base_Layer collect i.name
			
		for name in layersName do
		(
			l = LayerManager.getLayerFromName name
			if matchpattern l.name pattern: ("*" + pattern) then
			(
				l.setname (substitutestring l.name pattern "")
			)
			else
			(
				l.setname ( l.name + pattern)
			)
		)
	)
	
	on assetNameET entered newName do
	(
		local newFilename = assetpath + "\\" + newName + ".max"
		if doesfileexist newFilename then (format "file exist: %\n" newFilename )
		else(format "file does not exist: %\n" newFilename)
	)
	
	on extractSelBT pressed do
	(
		theNodes = selection as array
		
		if theNodes.count > 0 and assetNameET.text.count > 0 then
		(
			-- centrage des objets à extraire
			-- bug sur les groupe
			/*
			if originCB.checked do
			(
				local sum = [0,0,0]
				for s in theNodes do sum += s.center
				moveVal = [((sum.x/theNodes.count)* -1), ((sum.y/theNodes.count)* -1), 0]

				move theNodes moveVal
				format "move:%\n" moveval
			)
			*/
			
			-- save selected
			local newFilename = assetpath + "\\" + assetNameET.text + ".max"
			if doesfileexist newFilename then (format "file exist: %\n" newFilename )
			else saveNodes theNodes newFilename
			
			-- retour à la position initiale
-- 			if originCB.checked do move theNodes (moveVal* - 1)
		)
	)
)
createdialog assetExtractorRLT

-- assetExtractorRLT.originCB.checked

