
fn switchGamma val =
(
	test = renderers.current
	if not val then
	(
		test.colorMapping_adaptationOnly = true 
		IDisplayGamma.gamma = 2.2
	)
	else
	(
		test.colorMapping_adaptationOnly = false 
		IDisplayGamma.gamma = 1
	)
)

-- switchGamma false
try(destroydialog switchGamRLT)catch()
rollout switchGamRLT "switch gamma"
(
	checkbutton gamToggleCB "switch gamma"
	
	on gamToggleCB changed val do switchGamma val
)
createdialog switchGamRLT