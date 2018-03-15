-- ponderate vertex

-- vx = $.editablepoly.GetSelection #vertex
fn copyPose s =
(
	local vx = polyop.getVertSelection s

	local count = 0
	local sum = [0,0,0]
	for i in vx do
	(
	-- 	local data = $.editablepoly.getvertex i
		local data = polyop.getVert $ i
		sum += data
		count += 1
		format "data:%\n" data
	)
	sum/count
)

multi = 0.5
vx2 = polyop.getVertSelection $
for i in vx2 do
(
	local data = polyop.getVert $ i
	polyop.setVert $ i (data*(1-multi) + (avgPos*multi))
)
