
try(destroydialog renameRLT)catch()
rollout renameRLT "Renamer" width: 400
(
	-- vars
	local s
	local callSel
	local copyName
	-- function

			
	-- UI
	edittext nameET "name:"
	
	group "name:"
	(
		button copyNameBT "copy" across: 2
		button pasteNameBT "paste"
		edittext copyNameET "copy:" readonly: true
	)
	
	group "add suffix:"
	(
		button ctrlBT "CTRL" across:8
		button bipBT "BIP"
		button mdlBT "MDL"
		button rigBT "RIG"
		button plotBT "PLOT"
		button loBT "LO"
		button refBT "REF"
		button skinBT "SKIN"
	)
	
	group "Erase:"
	(
		button eraseEndBT "End" across: 2
		button eraseStartBT "Start"
	)
	
	group "switch droite/gauche"
	(
		button dBT "_D_" across: 2
		button gBT "_G_"
	)
	
	-- functions ui dependant
	fn updateUI =
	(
		sel = selection as array
		if sel.count == 1 then
		(
			s= sel[1]
		)
		else if sel.count == 1 or sel.count> 1 then
		(
			s = undefined 
		)
		
		if s != undefined then nameET.text = s.name
	)
	
	fn refreshUI_NEC ev nd = updateUI ()
	
	fn changeSuffix sname suf =
	(
		nameAr = filterString  sname "_"
		deleteItem nameAr nameAr.count
		
		newname = ""
		for n in nameAr do newname += (n + "_")
		newname  = newname + suf
		
		newname
	)
	
	fn reraseEnd sname =
	(
		nameAr = filterString  sname "_"
		deleteItem nameAr nameAr.count
		
		newname = ""
		for i = 1 to (nameAr.count - 1) do newname += nameAr[i] + "_"
		newname  = newname + nameAr[nameAr.count]
		
		newname
	)
	
	-- Actions
	on nameET changed val do
	(
		s.name = val
		print val
	)
	
	on copyNameBT pressed do
	(
		copyName = s.name
		copyNameET.text = copyName
	)
	
	on pasteNameBT pressed do
	(
		s.name = copyName
		nameET.text = s.name
-- 		updateUI()
	)
	
	on ctrlBT pressed do
	(
		s.name = changeSuffix s.name "CTRL"
		updateUI()
	)
	
	on bipBT pressed do
	(
		s.name = changeSuffix s.name "BIP"
		updateUI()
	)
	
	on mdlBT pressed do
	(
		s.name = changeSuffix s.name "MDL"
		updateUI()
	)
	
	on rigBT pressed do
	(
		s.name = changeSuffix s.name "RIG"
		updateUI()
	)
	
	on plotBT pressed do
	(
		s.name = changeSuffix s.name "PLOT"
		updateUI()
	)
	
	on loBT pressed do
	(
		s.name = changeSuffix s.name "LO"
		updateUI()
	)
	
	on refBT pressed do
	(
		s.name = changeSuffix s.name "REF"
		updateUI()
	)
	
	on skinBT pressed do
	(
		s.name = changeSuffix s.name "SKIN"
		updateUI()
	)
	
	on eraseEndBT pressed do
	(
		s.name = reraseEnd s.name
		updateUI()
	)
	
	on renameRLT open do 
	(
		callSel = NodeEventCallback  selectionChanged: refreshUI_NEC
		updateUI()
		print "youpi"
	)
	
	on renameRLT close do
	(
		callSel = undefined
		print "ploufe"
	)
	
	on dBT pressed do
	(
		s.name = substitutestring s.name "_G_" "_D_"
		updateUI()
	)
	
	on gBT pressed do
	(
		s.name = substitutestring s.name "_D_" "_G_"
		updateUI()
	)
	
)
createdialog(renameRLT)

--  printName = undefined 

