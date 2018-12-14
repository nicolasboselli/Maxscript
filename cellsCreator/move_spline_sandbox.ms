
-- getSplineSelection $
-- numsplines $
fn moveSplineSeg s mov:[0,0,0] =
(

-- 	spSel = getSplineSelection s
	numsp = numsplines s
-- 	spSel = 1
	for spSel = 1 to numsp do
	(
		kSel = #()
		segSel = getSegSelection s spSel
		for i in segsel do
		(
			appendifunique kSel  i
			appendifunique kSel  (i +1)
		)
		
		for k in kSel do
		(
			local pos = getKnotPoint s spSel k
			local newPos = pos +mov
			setKnotPoint s spSel k newPos
		)
	)

	updateShape s
)

fn moveObject l  mov:[0,0,0] =
(
	if classof l.baseobject == SplineShape or classof l.baseobject == line then
	(
		if getSelectionLevel  l == #object then -- object
		(
			move l mov
		)
		else if getSelectionLevel l == #vertex then -- knot
		(
			format "selection non prise en charge\n"
		)
		else if getSelectionLevel l == #face then -- segment
		(
			moveSplineSeg l mov: mov
		)
		else if getSelectionLevel l == #edge then -- spline
		(
			format "selection non prise en charge\n"
		)
		else(format "selection non prise en charge\n")
	)
)

try(destroydialog moveSplineRLT)catch()
rollout moveSplineRLT "move Spline"
(
	local moveVal = [0,0,120] 
	
	button moveUpBT "move up" across: 2
	button moveDwBT "move down"
	
	on moveUpBT pressed do
	(
		for s in selection do moveObject s mov: moveVal
	)
	
	on moveDwBT pressed do
	(
		for s in selection do moveObject s mov: (moveVal * -1)
	)
)
createdialog moveSplineRLT