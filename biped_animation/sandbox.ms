
-- test = biped.getTransform $ #rotation
-- test as eulerAngles

-- align selection on parent
fn alignOnParent s =
(
	rot = biped.getTransform s.parent #rotation 
	biped.setTransform s #rotation  rot true
)

-- select root biped
fn selectBip =
(
	bip = undefined
	for s in selection do
	(
		if s.parent != undefined then 
		(
			selectmore s.parent
		)
		else
		(
			bip = s
		)
	)
	select bip
	bip
)

-- select all biped controllers
fn selectAll =
(
	selectBip()
	for s in selection do
	(
		if s.children != undefined then selectmore s.children
	)
)


try(destroydialog bipedToolsRLT)catch()
rollout bipedToolsRLT "biped utilities"
(
	button alignBT "align on parent"
	button selRootBT "select root"
	button selAllBT "select all"
	
	on alignBT pressed do
	(
		sel = selection as array
		for s in sel do alignOnParent s
	)
	
	on selRootBT pressed do
	(
		selectBip()
	)
	
	on selAllBT pressed do
	(
		selectAll()
	)
)
createdialog bipedToolsRLT
