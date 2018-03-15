rollout rendWithoutSelRLT "MR Render sans la Selection"
(
-- 	UI
	button RendWithoutSelBT "Go! Go! Render"
	
-- 	event

	on RendWithoutSelBT pressed do
	(
		SelToHide = ($selection as array)
		for o in SelToHide do hide o

		CleanOutEltsFN ()
		max quick render
		
		for o in SelToHide do unhide o
	)
)

createdialog rendWithoutSelRLT