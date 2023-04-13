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
	global sourceLayerAr -- = #()
	global targetLayerAr -- = #()

	
	group "cells creation"
	(
		spinner startSP "start:" type: #integer across: 3
		spinner endSP "end:" type: #integer range: [0,100,5]
		button createCellsBT "create cells"
	)
	multilistbox cellsLayerMTL "Cells layers:" height:15
	
	button addTargetBT "add target" across: 6
	button removeTargetBT "remove target" 
	button clearTargetBT "clear target" 
	
	button addSourceBT "add source"
	button remSrcBT "remove source"
	button clearSourceBT "source target" 
	
	
	listbox targetLayersMTL "targets:" height:15 across: 2
	multilistbox sourceLayersMTL "sources:" height:15 
	
	button transferBT "TRANSFER !!!" width: 200 height: 50
	
	
	fn refreshUI =
	(
		cellsLayerMTL.items = cellsLayersAr
		targetLayersMTL.items = targetLayerAr
		try(sourceLayersMTL.items = sourceLayerAr[targetLayersMTL.selection])catch(sourceLayersMTL.items= #())
	)
	
	on cellsTransferRLT open do
	(
		if sourceLayerAr == undefined then sourceLayerAr = #()
		if targetLayerAr == undefined then targetLayerAr = #()
		cellsLayersAr = for i = 0 to (LayerManager.count - 1) where  matchpattern (LayerManager.getLayer i).name pattern: "Cells*" collect (LayerManager.getLayer i).name
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
	)
	
	on addTargetBT pressed do
	(
		local tmpAr = for i in (cellsLayerMTL.selection as array) collect cellsLayersAr[i]
		for o in tmpAr do appendifunique targetLayerAr o
-- 		format "sel: %\n" 
		
		for l in targetLayerAr do
		(
			append sourceLayerAr #()
		)
		
		refreshUI()
	)
	
	on removeTargetBT pressed do
	(
-- 		targetLayersMTL.selection
		local selId = targetLayersMTL.selection
		deleteitem targetLayerAr selId
		deleteitem sourceLayerAr selId
		
		refreshUI()
	)
	
	on clearTargetBT pressed do
	(
		targetLayerAr = #()
		sourceLayerAr = #()
		refreshUI()
	)		
	
	on addSourceBT pressed do
	(
		local tmpAr = for i in (cellsLayerMTL.selection as array) collect cellsLayersAr[i]
		format "sel: %\n" targetLayersMTL.selection
		
		if sourceLayerAr[targetLayersMTL.selection] == undefined then sourceLayerAr[ targetLayersMTL.selection] = #()
		for l in tmpAr do
		(
			appendifunique sourceLayerAr[targetLayersMTL.selection] l
		)
		format "sourceLayerAr: %\n" sourceLayerAr
		
		refreshUI()
	)
	
	on remSrcBT pressed do
	(		
-- 		format "sourceLayersMTL.selection:%\n"  
		idar = sourceLayersMTL.selection as array
		format "idar:%\n"  idar
		format "sourceLayerAr:%\n"  sourceLayerAr
		for i = idar.count to 1 by -1 do deleteitem sourceLayerAr[targetLayersMTL.selection] idar[i]
		format "sourceLayerAr:%\n"  sourceLayerAr
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
)
createdialog cellsTransferRLT width: 600 --height: 1500