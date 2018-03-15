-- ponderate vertex

-- vx = $.editablepoly.GetSelection #vertex
fn copyVxPos s =
(
	local vx = polyop.getVertSelection s

	local count = 0
	local sum = [0,0,0]
	for i in vx do
	(
	-- 	local data = $.editablepoly.getvertex i
		local data = polyop.getVert s i
		sum += data
		count += 1
		format "data:%\n" data
	)
	sum/count
)

fn pasteVxPos s avgPos multi: 0.5=
(
-- 	multi = 0.5
	vx2 = polyop.getVertSelection s
	for i in vx2 do
	(
		local data = polyop.getVert s i
		polyop.setVert s i (data*(1-multi) + (avgPos*multi))
	)
)

-- avgPos = copyVxPos $
-- pasteVxPos $ avgPos
try(destroydialog vertexPositionPonderationRLT)catch()
rollout vertexPositionPonderationRLT "vertex position poderation"
(
	local avgPos
	
	button copyBT "copy"
	spinner multiSP "multi" default:[0,1,0.5]
	button pasteBT "paste"
	
	on copyBT pressed do
	(
		undo on
		(
			avgPos = copyVxPos $
		)
	)
	
	on pasteBT pressed do
	(
		undo on
		(
			pasteVxPos $ avgPos multi: multiSP.value
		)
	)
	
	
)
createdialog vertexPositionPonderationRLT