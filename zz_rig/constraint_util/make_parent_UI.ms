rollout makeParentRlt "Parentage"
(
-- vars
	local paireAr = #()
-- 	ui
	button  checkBT "check selection"
	editText parentEt "parent:" readonly: true
	editText enfantEt "enfant:" readonly: true
	button  makeparentBT "make parent"
-- events
	
	on checkBT pressed do
	(
		paireAr = $selection as array
		if paireAr.count == 2 then
		(
			parentEt.text = paireAr[2].name
			enfantEt.text = paireAr[1].name
		)
		else
		messagebox "sélectionnez deux objets"
	)
	
	on makeparentBT pressed do
	(
		paireAr[1].parent = paireAr[2]
	)
)
createdialog makeParentRlt width: 600