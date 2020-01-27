-- activeGrid.transform

try(destroydialog splineCreatorRLT)catch()
rollout splineCreatorRLT "spline creator"
(
	local newCell
	
	checkbutton newCellCB "new cell"
	
	fn testPickPoint  =
	(
		local p = pickPoint () -- mouseMoveCallback:printPickPoint
		format "p = %\n" p
		box position: p
	)

	tool splineTool
	(
		local newCell
		
		on start do
		(
			local activegridTM
			
			if activeGrid == undefined then activegridTM = matrix3 1
			else activegridTM = activeGrid.transform
			format "activegridTM: %\n" activegridTM
-- 			max modify mode
			max modify mode

			newCell= SplineShape transform: activegridTM
			updateShape newCell

			newCell.vertexTicks = on

			addmodifier newCell (sweep ())

			select newCell
			
			modPanel.setCurrentObject newCell.baseobject 
				
			addNewSpline newCell
			addKnot newCell 1 #corner #curve [0,0,0]
			addKnot newCell 1 #corner #curve [10,0,0]
			updateshape newCell
		)
		
		on mousePoint clickno do
		(
			format "mousePoint: %\n" clickno
-- 			format "mousePoint: %\n" viewPoint
-- 			splineOps.startCreateLine newCell
			if clickno == 1 then ()
			else
			(
				local activegridTM
				local creationTM
				
				if activeGrid == undefined then activegridTM = matrix3 1
				else activegridTM = activeGrid.transform
				
				creationTM = matrix3 1
				creationTM.translation = (gw.getPointOnCP viewPoint)
				
				newTm = creationTM * activegridTM
				
				addKnot newCell 1 #corner #curve newTm.translation
			)
			updateshape newCell
		)
		
		on mouseMove clickno do
		(
			local knotCount = numKnots newCell 1
			if activeGrid == undefined then activegridTM = matrix3 1
			else activegridTM = activeGrid.transform
			
			creationTM = matrix3 1
			creationTM.translation = (gw.getPointOnCP viewPoint)
				
			newTm = creationTM * activegridTM
			
			setKnotPoint newCell 1 knotCount newTm.translation
			updateshape newCell
-- 			format "mouseMove: %\n" clickno
-- 			max modify mode

-- 			newCell= SplineShape ()
-- 			updateShape newCell
-- 			newCell.vertexTicks = on

-- 			addmodifier newCell (edit_poly ())

-- 			select newCell
-- 			
-- 			modPanel.setCurrentObject newCell.baseobject 
-- 			splineOps.startCreateLine newCell
		)
		
		on mouseAbort clickno do
		(
			format "mouseAbort: %\n" clickno
			updateshape newCell
			showEndResult = true
			newCell.vertexTicks = off
			newCell.pivot = newCell.center
-- 			newCell.xray = on
-- 			newCell.wirecolor = color 135 6 6
		)			
		
		on stop do
		(
			format "stop\n" 
			updateshape newCell
		)
	)
	
	on newCellCB changed state do
	(
		if state do
		(
			local continueTool = true
			while continueTool == true do
			(
				continueTool = starttool splineTool
			)
			newCellCB.state = false
		)
	)
)
createdialog splineCreatorRLT