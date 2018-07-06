/*
l =$
-- superclassof $
if superclassof l == Shape then
(
	max modify mode
	modPanel.setCurrentObject l.baseobject
	subObjectLevel = 1

	spCount = numSplines   l
	for i = 1 to spCount do
	(
		knCount =numknots l i
	-- 	format "knots: % \n" knCount
		setKnotSelection l i #(knCount)
	)
	splineOps.makeFirst l

	subObjectLevel = 0
	
	format "make first done: %\n" l.name
)else()
*/

fn inverseKnotOrder l =
(
	if superclassof l == Shape then
	(
		max modify mode
		modPanel.setCurrentObject l.baseobject
		subObjectLevel = 1

		spCount = numSplines   l
		for i = 1 to spCount do
		(
			knCount =numknots l i
		-- 	format "knots: % \n" knCount
			setKnotSelection l i #(knCount)
		)
		splineOps.makeFirst l

		subObjectLevel = 0
		
		format "make first done: %\n" l.name
	)else()
)

sel = selection as array
for s in sel do inverseKnotOrder s