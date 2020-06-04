-- activeGrid.transform

/*
- relancer automatiquement l outil quand un cellule est fini
x- ajouter une fonction d'auto close
x- ajouter une fonction de snap (contrainte en x ou y)quand on appui sur shift
	x- travailler dans l'orientation de la grille active

*/
-- newCellCreatorRLT.baseNameET.text = "toto"

rollout renameCellRLT "rename"
(
	global basename
	global newCell
	
	
	editText cellNameET "cell name:"
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
	
	on cellNameET entered val do
	(
-- 		format "newName: %\n" val
		newCell.name = val
		closeBT.pressed()
	)
)

try(destroydialog newCellCreatorRLT)catch()
rollout newCellCreatorRLT "new Cell Creator"
(
	global newCell
	local newWallState = true
	local newOne = false
	local cellLayer
	
	editText activeGridET "active grid:" readonly: true--visible: false
	editText cellLayerET "cell layer:" readonly: true -- visible: false
	editText currentLayerET "current layer:" readonly: true

	editText baseNameET "basename"
	checkbutton newCellCB "new cell"
-- 	checkbox continueCB "continue"
	
	fn testPickPoint  =
	(
		local p = pickPoint () -- mouseMoveCallback:printPickPoint
		format "p = %\n" p
		box position: p
	)

	fn init =
	(
		format "init\n"
		if activeGrid != undefined then 
		(
-- 			gridLayer = activeGrid
			activeGridET.text = activeGrid.name
			cellLayer =  LayerManager.getLayerFromName ("cell_"+ activeGrid.name)
			cellLayerET.text = cellLayer.name
		)
		else
		(
			activeGridET.text = "NONE"
			cellLayerET.text = "NONE"
		)
		
		if basename != undefined then baseNameET.text = basename
		format "basename: %\n" basename
		
		currentLayerET.text = LayerManager.current.name
	)
	
	tool splineTool
	(
-- 		local newOne = false
-- 		local newCell
		local lastPos
		local lastgridpoint
		local firstGridPoint
		local restart = false
		
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
			
			format "restart: %\n" restart
			
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
				
				lastgridpoint = gridPoint
				lastPos = gw.mapCPToWorld lastgridpoint
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
				lastgridpoint = gridPoint

				if (distance firstGridPoint lastGridPoint) < 10.0 then 
				(
					format "close spline\n"
					close  newCell 1
					knotToDel = numKnots newCell 1
					deleteknot newCell 1 knotToDel
					closed = true
					
				)
				else
				(
					lastPos = gw.mapCPToWorld lastgridpoint
					addKnot newCell 1 #corner #curve lastPos
				)

				format "mousePoint: %\n" clickno
			)
			updateshape newCell
			
			if closed then #stop
		)
		
		on mouseMove clickno do
		(
			local knotCount = numKnots newCell 1
			local newGridPoint = gridPoint
			
			-- contrainte en x ou y
			if shiftKey then  
			(
				local testVec =  normalize(newGridPoint - lastGridPoint)
				if testVec.x^2 > testVec.y^2 then newGridPoint.y = lastGridPoint.y		
				else	newGridPoint.x = lastGridPoint.x	
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
				print "restart\n"
				format "basename 3: %\n" basename
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
	
	on newCellCB changed state do
	(
		-- activer le calque
		if cellLayer != undefined then cellLayer.current = true
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
createdialog newCellCreatorRLT width: 250

