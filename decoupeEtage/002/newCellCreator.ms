
/*
maj:
ajouter bouton uniquename

debug:, 
 � la premi�re ouverture le bsaename ne suit pas dans rollout rename

memo:

showProperties con
showProperties con.modifierKeys 
con=dotNetClass "system.windows.forms.control"
if con.modifierKeys==con.modifierKeys.alt do 


*/

decoupEtageRLT.cellLayer

global basename
	
try(destroydialog newCellCreatorRLT)catch()
rollout newCellCreatorRLT "new Cell Creator"
(
	global decoupEtageRLT
	global renameCellRLT
	global newCell
	
	local newWallState = true
	local newOne = false
	local cellLayer
	
-- 	local basename
	
	group "infos:"
	(
		editText activeGridET "active grid:" readonly: true--visible: false
		editText cellLayerET "cell layer:" readonly: true -- visible: false
		editText currentLayerET "current layer:" readonly: true
	)

	group "options:"
	(
		checkbox autoLayerCB "auto active layer:" checked: true
	)
	
	group "create cell"
	(
		editText baseNameET "basename"
		button uniqueNameBT "unique name" across: 2
		checkbutton newCellCB "new cell"
	)
-- 	checkbox continueCB "continue"
-- 	
-- 	fn testPickPoint  =
-- 	(
-- 		local p = pickPoint () -- mouseMoveCallback:printPickPoint
-- 		format "p = %\n" p
-- 		box position: p
-- 	)

	fn init =
	(
		format "init\n"
		
		
		try(cellLayer = decoupEtageRLT.cellLayer)catch(cellLayer= undefined)
				
		-- refreshUI
		if activeGrid == undefined then (activeGridET.text = "NONE") else activeGridET.text = activeGrid.name
		if cellLayer == undefined then
		(
			cellLayerET.text = "NONE"
			newCellCB.enabled = false
		) 
		else 
		(
			cellLayerET.text = cellLayer.name
			newCellCB.enabled = true
		)
		
		if basename != undefined then baseNameET.text = basename
-- 		format "basename: %\n" basename
		
		currentLayerET.text = LayerManager.current.name
	)
	
	tool splineTool
	(
-- 		local newOne = false
-- 		local newCell
		local lastPos
-- 		local lastgridpoint
		local firstGridPoint
		local restart = false
		local lastCount
		
		local i = 1
		
		on start do
		(
			format "start splineTool\n"
		)
		
		on freeMove do
		(
-- 			print "Free Moving"
			restart = false
		)
			
		on mousePoint clickno do
		(
			restart = true
			local closed = false
			
			format "\n######### restart: %\n" restart
			
			if clickno == 1 then
			(
-- 				format "mousePoint init: %\n" clickno
				max modify mode
								
				newCell= SplineShape name: (uniquename "cell_") transform: (getCPTM())

				newCell.vertexTicks = on

-- 				format "mousePoint delete: %\n" clickno
				addNewSpline newCell
				firstGridPoint = gridPoint
				addKnot newCell 1 #corner #curve (gw.mapCPToWorld firstGridPoint)
				
-- 				lastgridpoint = gridPoint
-- 				lastPos = gw.mapCPToWorld lastgridpoint
				lastPos = gw.mapCPToWorld gridPoint
				addKnot newCell 1 #corner #curve lastPos
				
				updateshape newCell	
					
				select newCell
				modPanel.setCurrentObject newCell.baseobject 
				showEndResult = false
					
				format "showEndResult: %\n" showEndResult
				format "start new spline: %\n" newCell.name
				format "mousePoint init: %\n" clickno
					
				newOne = false
			)
			else if clickno == 2 then
			(	
			)
			else
			(
-- 				lastgridpoint = gridPoint
				
-- 				if (distance firstGridPoint lastGridPoint) < 10.0 then 
				if (distance firstGridPoint gridPoint) < 10.0 then 
				(
					format "close spline\n"
					close  newCell 1
					knotToDel = numKnots newCell 1
					deleteknot newCell 1 knotToDel
					closed = true
				)
				else
				(
					if altKey then
					(
						-- suppression de l'avant dernier point
						knotCount = numKnots newCell 1
						deleteKnot newCell 1 (knotCount - 1)
					)
					else
					(
-- 						lastPos = gw.mapCPToWorld lastgridpoint
						lastPos = gw.mapCPToWorld gridPoint
						addKnot newCell 1 #corner #curve lastPos
					)
				)

			)
			updateshape newCell
			
			lastCount = numKnots newCell 1
			if closed then #stop
		)
		
		on mouseMove clickno do
		(
			local knotCount = numKnots newCell 1
			local lastCellpoint = in coordsys activegrid getKnotPoint newCell 1 (knotCount - 1)
			
			local newGridPoint = gridPoint
			local deleteLast = false
			
			-- contrainte en x ou y
			if shiftKey then  
			(
				local testVec =  normalize(newGridPoint - lastCellpoint)
				if abs(testVec.x) > abs(testVec.y) then newGridPoint.y = lastCellpoint.y
				else	newGridPoint.x = lastCellpoint.x	
			)
			
			local curPos = gw.mapCPToWorld newGridPoint
			
			setKnotPoint newCell 1 knotCount curPos
			updateshape newCell	
		)
		
		on mouseAbort clickno do
		(
			format "rbutton: %\n" rbutton 
			format "mouseAbort: %\n" clickno
		)			
		
		on stop do
		(
			format "stop\n" 
-- 			if isvalidnode newCell then updateshape newCell
				
			if isvalidnode newCell then 
			(					
				updateshape newCell
				showEndResult = true
				newCell.vertexTicks = off
				newCell.pivot = newCell.center
				newCell.xray = on
				newCell.wirecolor = color 135 6 6
				
				if isClosed newcell 1 then 
				(
					addmodifier newCell (edit_poly ())
					createdialog renameCellRLT modal: true
-- 					init()
					newCell = undefined
				)
			)
			
			if restart then 
			(
-- 				print "restart\n"
-- 				format "basename 3: %\n" basename
				baseNameET.text = basename
-- 				newCellCreatorRLT.baseNameET.text = basename
				starttool splineTool
			)
		)
	)
	
	on newCellCreatorRLT open do
	(
		init()
	)
	
	on baseNameET entered val do
	(
		basename = val
	)
	
	on newOneBT pressed do
	(
		 newOne = true
	)
	
	on uniqueNameBT pressed do
	(
		if basename != undefined then
		(
			basename = uniqueName basename
			baseNameET.text = basename
		)
	)
	
	on newCellCB changed state do
	(
		-- activer le calque
		if cellLayer != undefined and autoLayerCB.state then 
		(
			cellLayer.current = true
			unHideLayerHierarchy cellLayer
		)
		currentLayerET.text = LayerManager.current.name
			 
		if state then
		(
			local continueTool = true
			while continueTool == true do
			(
				continueTool = starttool splineTool
			)
			newCellCB.state = false
		)
		else
		(
			stoptool splineTool
		)
		
	)
)


rollout renameCellRLT "rename"
(
	global newCellCreatorRLT

	global newCell
		
	editText cellNameET "cell name:"
	button uniqueNameBT "unique name" across: 2
	button closeBT "ok"
	
	on closeBT pressed do 
	(
-- 		print "youpi"
		basename = cellNameET.text
-- 		format "basename 2: %\n" basename
		newCellCreatorRLT.baseNameET.text = basename
		destroydialog renameCellRLT
	)
	
	on renameCellRLT open do
	(
		if basename == undefined then()
		else if basename.count > 0 then 
		(
			cellNameET.text = basename
			format "basename 1: %\n" basename
			newCell.name = basename
		)
		else()
	)
	
	on uniqueNameBT pressed do
	(
		if basename != undefined then 
		(
			basename = uniqueName basename
			cellNameET.text = basename
		)
		else(format "basename: %\n" basename)
	)
	
	on cellNameET entered val do
	(
-- 		format "newName: %\n" val
		newCell.name = val
		closeBT.pressed()
	)
)


createdialog newCellCreatorRLT width: 250

