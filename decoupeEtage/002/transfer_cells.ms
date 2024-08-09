/*
maj:
	- ajouter un filtre sur les noms de calques
	- faire fonctionner la creation des calques cells
	- ajouter des removes dans les menus d'actions
*/


try(destroydialog cellsTransferRLT)catch()
rollout cellsTransferRLT "Cells Transfer"
(
	local cellsLayersAr = #()
	global freeLayersAr
	global sourceLayerAr -- = #()
	global targetLayerAr -- = #()

	
	group "cells creation"
	(
		spinner startSP "start:" type: #integer across: 3
		spinner endSP "end:" type: #integer range: [0,100,5]
		button createCellsBT "create cells"
	)
	
	button resetBT "reset"
	multilistbox cellsLayerMTL "Cells layers:" height:15
	
	button addTargetBT "add target" across: 5
	button removeTargetBT "remove target" 

	
	button addSourceBT "add source"
	button remSrcBT "remove source"
-- 	button clearSourceBT "source target" 
	
	button clearTargetBT "clear all" 
		
	listbox targetLayersMTL "targets:" height:15 across: 2
	multilistbox sourceLayersMTL "sources:" height:15 
	
	button transferBT "TRANSFER SELECTED"  across: 2 --width: 200 height: 50
	button transferAllBT "TRANSFER ALL!!!" width: 200 height: 50
	
	
	fn refreshUI =
	(
		cellsLayerMTL.items = freeLayersAr
		targetLayersMTL.items = targetLayerAr
		
		try(sourceLayersMTL.items = sourceLayerAr[targetLayersMTL.selection])catch(sourceLayersMTL.items= #())
	)
	
	on cellsTransferRLT open do
	(
		cellsLayersAr = for i = 0 to (LayerManager.count - 1) where  matchpattern (LayerManager.getLayer i).name pattern: "Cells*" collect (LayerManager.getLayer i).name
		sort cellsLayersAr
		
		if freeLayersAr == undefined then freeLayersAr = for l in cellsLayersAr collect l
		if sourceLayerAr == undefined then sourceLayerAr = #()
		if targetLayerAr == undefined then targetLayerAr = #()
			
		refreshUI()
	)
	
	on resetBT pressed do
	(
		cellsLayersAr = for i = 0 to (LayerManager.count - 1) where  matchpattern (LayerManager.getLayer i).name pattern: "Cells*" collect (LayerManager.getLayer i).name
		sort cellsLayersAr
		
		freeLayersAr = for l in cellsLayersAr collect l
		sourceLayerAr = #()
		targetLayerAr = #()
		
		refreshUI()
	)
	
	on createCellsBT pressed do
	(
		local daddyL, rName, rLayer
		
		daddyL = layermanager.getLayerFromName "Cells"
		if daddyL == undefined then daddyL = layermanager.newLayerFromName  "Cells"
		format "daddyL: %\n" daddyL
		
		for i = startSP.value to endSP.value do
		(
			rName = ( "Cells_R" + ( i as string ) )
			rLayer = layermanager.getLayerFromName rName
			if rLayer == undefined then rLayer = layermanager.newLayerFromName  rName
			format "rLayer: %\n" rLayer 
			
			rLayer.setParent daddyL
		)
		
		cellsLayersAr = for i = 0 to (LayerManager.count - 1) where  matchpattern (LayerManager.getLayer i).name pattern: "Cells*" collect (LayerManager.getLayer i).name
		
		refreshUI()
	)
	
	on addTargetBT pressed do
	(
		-- ajout des layer au target Array
		local tmpAr = for i in (cellsLayerMTL.selection as array) collect freeLayersAr[i]
		for o in tmpAr do appendifunique targetLayerAr o
		
		-- suppression des target de l'array freelayer
		selAr = cellsLayerMTL.selection as array
		for i= selAr.count to 1 by -1 do deleteitem freeLayersAr selAr[i]
		
		-- initialisation des array de sources
		-- maj: empecher de rajouter toujours plus d'array
 		for l in targetLayerAr do
		(
			append sourceLayerAr #()
		)
		format "sourceLayerAr: %\n" sourceLayerAr
		
		refreshUI()
	)
	
	
	
	on removeTargetBT pressed do
	(
-- 		targetLayersMTL.selection
		local selId = targetLayersMTL.selection
		append freeLayersAr targetLayerAr[selId]
		sort freeLayersAr
		
		deleteitem targetLayerAr selId
		deleteitem sourceLayerAr selId
		
		refreshUI()
	)
	
	on clearTargetBT pressed do
	(
		freeLayersAr = for l in cellsLayersAr collect l
		targetLayerAr = #()
		sourceLayerAr = #()
		refreshUI()
	)		
	
	on addSourceBT pressed do
	(
		-- ajout des layer au source Array
		local tmpAr = for i in (cellsLayerMTL.selection as array) collect freeLayersAr[i]
		if sourceLayerAr[targetLayersMTL.selection] == undefined then sourceLayerAr[targetLayersMTL.selection] = #()
		for l in tmpAr do appendifunique sourceLayerAr[targetLayersMTL.selection] l
			
		-- -- suppression des sources de l'array freelayer
		selAr = cellsLayerMTL.selection as array
		for i= selAr.count to 1 by -1 do deleteitem freeLayersAr selAr[i]
			

		
		refreshUI()
	)
	
	on remSrcBT pressed do
	(		
		idar = sourceLayersMTL.selection as array

		for i = idar.count to 1 by -1 do
		(
			append freeLayersAr sourceLayerAr[targetLayersMTL.selection][idar[i]]
			deleteitem sourceLayerAr[targetLayersMTL.selection] idar[i]
		)
		
		sort freeLayersAr

		refreshui() 
	)
	
	on targetLayersMTL selected val do
	(
		refreshUI()
	)
	
	on transferBT pressed do
	(
		local targetLayer = layermanager.getLayerFromName  targetLayersMTL.selected
		format "targetLayer: %\n" targetLayer.name
		
		for Ar in sourceLayerAr[targetLayersMTL.selection] do
		(
			local l = layermanager.getLayerFromName  ar
			format "l:%\n" l.name
			l.nodes &tmpCells
			format "tmpCells:%\n" tmpCells
			for c in tmpCells do targetLayer.addnode c
		)

	)
	
	on transferAllBT pressed do
	(
		for i = 1 to targetLayerAr.count do
		(
			local targetLayer = layermanager.getLayerFromName  targetLayerAr[i]
-- 			format "targetLayer: %\n" targetLayer.name
			
			for Ar in sourceLayerAr[i] do
			(
				local l = layermanager.getLayerFromName  ar
-- 				format "l:%\n" l.name
				l.nodes &tmpCells
				format "% to % ;tmpCells:%\n" l.name targetLayer.name  tmpCells
				for c in tmpCells do targetLayer.addnode c
			)
		)
	)
)
createdialog cellsTransferRLT width: 600 --height: 1500