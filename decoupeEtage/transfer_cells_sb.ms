try(destroydialog cellsTransferRLT)catch()
rollout cellsTransferRLT "Cells Transfer"
(
	local cellsLayersAr = #()
	global sourceLayerAr -- = #()
	global targetLayerAr -- = #()

	
	group "cells creation"
	(
		spinner startSP "start:" type: #integer across: 3
		spinner endSP "end:" type: #integer
		button createCellsBT "create cells"
	)
	multilistbox cellsLayerMTL "Cells layers:" height:15
	button addTargetBT "add target" across: 4
	button clearTargetBT "clear target" 
	button addSourceBT "add source"
	button clearSourceBT "source target" 
	
	listbox targetLayersMTL "targets:" height:15 across: 2
	multilistbox sourceLayersMTL "sources:" height:15 
	
	button transferBT "TRANSFER !!!" width: 200 height: 50
	
	
	fn refreshUI =
	(
		cellsLayerMTL.items = cellsLayersAr
		targetLayersMTL.items = targetLayerAr
		try(sourceLayersMTL.items = sourceLayerAr[targetLayersMTL.selection])catch()
	)
	
	on cellsTransferRLT open do
	(
		cellsLayersAr = for i = 0 to (LayerManager.count - 1) where  matchpattern (LayerManager.getLayer i).name pattern: "Cells*" collect (LayerManager.getLayer i).name
		refreshUI()
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
		
		sourceLayerAr[targetLayersMTL.selection] = tmpAr
		format "sourceLayerAr: %\n" sourceLayerAr
		
		refreshUI()
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