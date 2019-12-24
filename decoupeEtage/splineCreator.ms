try(destroydialog splineCreatorRLT)catch()
rollout splineCreatorRLT "spline creator"
(
	local newCell
	
	checkbutton newCellCB "new cell"
	
	tool splineTool
	(
		on start do
		(
			max modify mode

			newCell= SplineShape ()
			updateShape newCell
			newCell.vertexTicks = on

			addmodifier newCell (edit_poly ())

			select newCell
			
			modPanel.setCurrentObject newCell.baseobject 
-- 			splineOps.startCreateLine newCell
		)
		
		on mousePoint clickno do
		(
			format "mousePoint: %\n" clickno
-- 			max modify mode
			format "pickPoint: %\n" (pickPoint())

-- 			newCell= SplineShape ()
-- 			updateShape newCell
-- 			newCell.vertexTicks = on

-- 			addmodifier newCell (edit_poly ())

-- 			select newCell
-- 			
-- 			modPanel.setCurrentObject newCell.baseobject 
-- 			splineOps.startCreateLine newCell
		)
		
		on mouseMove clickno do
		(
			format "mouseMove: %\n" clickno
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
			showEndResult = true
			newCell.vertexTicks = off
			newCell.pivot = newCell.center
			newCell.xray = on
			newCell.wirecolor = color 135 6 6
		)			
		
		on stop do
		(
			format "stop\n" 
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