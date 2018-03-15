undo on
(
	lm = layermanager 
	cl = lm.current
	cl.name
	for s in selection do cl.addnode s
)
