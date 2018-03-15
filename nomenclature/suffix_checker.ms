try(destroydialog suffixCheckRLT)catch()
rollout suffixCheckRLT "Suffix Checker"
(
	local suffixAr = #()
	global basename
	
	edittext basenameET "basename:" --readonly: true
	multilistbox unSufMLB "uncorrect:" height: 40
	edittext countET "count" readonly: true
	button refreshBT "refresh"
	
	fn initVars =
	(
		suffixAr = #()
		for o in objects do
		(
			if matchpattern o.name pattern: "*_RIG" then ()
			else if matchpattern o.name pattern: "*_CTRL" then ()
			else if matchpattern o.name pattern: "*_MDL" then ()
			else if matchpattern o.name pattern: "*_ROOT" then ()
			else if matchpattern o.name pattern: "*_AssetNode" then ()
			else if matchpattern o.name pattern: (basename + "_*") then (append suffixAr o)
			else()
		)
	)
	
	fn refreshUI =
	(
		if not basename == undefined then basenameET.text = basename
		unSufMLB.items = for o in suffixAr collect o.name
		countET.text = suffixAr.count as string
	)
	
	on suffixCheckRLT open do
	(
		initVars()
		refreshUI()
	)
	
	on unSufMLB selectionEnd do
	(
		clearselection ()
		for i in unSufMLB.selection do selectmore suffixAr[i]
	)
	
	on refreshBT pressed do
	(
		initVars()
		refreshUI()
	)
)
createdialog suffixCheckRLT width: 300