-- Maj: add replace string

try(destroydialog renameRLT)catch()
rollout renameRLT "Renamer" width: 400
(
	-- vars
	local s
	local callSel
	local copyName
	
	local search = ""
	local rep = ""
	local basename = ""
	-- function
			
	-- UI
	edittext nameET "name:"
	
	group "name:"
	(
		button copyNameBT "copy" across: 2
		button pasteNameBT "paste"
		edittext copyNameET "copy:" readonly: true
	)
	
	group "basename:"
	(
		edittext baseNameET "basename:" 
		button addBasenameBT "add"
	)
	
	group "add suffix:"
	(
		button addCtrlBT "CTRL" across:5
		button addMdlBT "MDL"
		button addRigBT "RIG"
		button addPlotBT "PLOT"
		button addLoBT "LO"
	)
	
	group "change suffix:"
	(
		button ctrlBT "CTRL" across:5
		button mdlBT "MDL"
		button rigBT "RIG"
		button plotBT "PLOT"
		button loBT "LO"
	)
	
	group "Replace:"
	(
		edittext searchET "search:"
		edittext replaceET "replace:"
		edittext prevET "preview:" readonly: true
		button repalceBT "replace"
	)
	
	group "Erase:"
	(
		button eraseEndBT "End" across: 2
		button eraseStartBT "Start"
	)
	
	group "right/left"
	(
		
		button subLeftBT "G" across: 2
		button subRightBT "D" 
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
			
		if s != undefined and search != undefined and rep != undefined then prevET.text = substituteString s.name search rep
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
	-- groupe name
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
	
	on baseNameET changed val do
	(
		basename = val
		format "basename: %\n" basename
	)
	
	on addBasenameBT pressed do
	(
-- 		format "s.name: %\n" s.name
		s.name = basename + "_" + s.name
		updateUI()
	)
	
	-- groupe suffix	
	on ctrlBT pressed do
	(
		s.name = changeSuffix s.name "CTRL"
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
	-- group replace
	on searchET changed val do
	(
		search = val
		updateUI()
	)
	
	on replaceET changed val do
	(
		rep = val
		updateUI()
	)
	
	on repalceBT pressed do
	(
		s.name = substituteString s.name search rep
		
		format "s.name: %, search: %, replace: %\n" s.name search rep
		updateUI()
	)
	
	-- group erase
	on eraseEndBT pressed do
	(
		s.name = reraseEnd s.name
		updateUI()
	)
	
	on renameRLT open do 
	(
		callSel = NodeEventCallback  selectionChanged: refreshUI_NEC
		updateUI()
-- 		print "youpi"
	)
	
	on renameRLT close do
	(
		callSel = undefined
-- 		print "ploufe"
	)
	
	on subLeftBT pressed do
	(
		if matchpattern s.name pattern: "*_*_D_*" then $.name = substitutestring $.name "_D_" "_G_"
		updateUI()
	)
	
	on subRightBT pressed do
	(
		if matchpattern s.name pattern: "*_*_G_*" then $.name = substitutestring $.name "_G_" "_D_"
		updateUI()
	)
	
)
createdialog(renameRLT)

--  printName = undefined 

