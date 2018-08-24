/*
maj: 
-- increment du nom:
	-- récupérer le nombre en suffixe en entier avant de faire l'increment
	-- faire fonctionner sur la selection locker et delocker et non sur la selection d'objetx dans la scene
*/

fn incrementName n charId: 1 inc: 1 =
(
	local newName
	local count
	
	try (count = n[charId] as integer) catch(count = undefined)
	
	if not count == undefined then
	(
		newName = n
		newName[charId] = ((count + inc) as string)
	)
	newName
)

try(destroydialog multiRenameRLT)catch()
rollout multiRenameRLT "Multi Renamer" width: 400
(
	-- vars
	local s
	local sel
	
	local callSel
	local copyName
	
	local search = ""
	local rep = ""
	local basename
	-- function
	

			
	-- UI
	checkbutton lockedCB "locked selection"
	multiListbox namesMLB "names:"
	
	edittext nameET "name:"
	
	group "number"
	(
		spinner idSP "char index:" type: #integer range:  [1,1000,1] across: 3
		spinner jumpSP "inc:" type: #integer  range: [-100,100,1]
		button numberBT "+"
	)
	
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
		button ctrlBT "CTRL" across:8
		button bipBT "BIP"
		button mdlBT "MDL"
		button rigBT "RIG"
		button plotBT "PLOT"
		button loBT "LO"
		button refBT "REF"
		button skinBT "SKIN"
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
	fn refreshUI =
	(
		-- names prevue
		namesMLB.items = for s in sel collect s.name
		
		-- copy name
		if copyName != undefined then copyNameET.text = copyName else copyNameET.text = "NONE"
			
		-- selected name prvue
		if s != undefined and isDeleted s == false then nameET.text = s.name else nameET.text = "NONE"
		
		-- replace prevue
		if s != undefined and search != undefined and rep != undefined and isDeleted s == false then prevET.text = substituteString s.name search rep
	)
	
	fn initS =
	(
		selAr = for i in namesMLB.selection collect i
		
		if selAr.count == 1 then s = sel[selAr[1]]
		else 	s = undefined
	)
	
	fn updateUI  locked: false =
	(
		if locked then
		(
			format "bouh\n"
		)
		else
		(
			format "youpi\n"
			sel = selection as array
			refreshUI()
			namesMLB.selection = 1

		)
		
-- 		sel = selection as array
-- 		refreshUI()
-- 		namesMLB.selection = 1
		initS()
		refreshUI()
	)
	
	fn refreshUI_NEC ev nd = updateUI  locked: lockedCB.state
	
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
	on namesMLB selectionEnd do
	(
		for s in sel do s.xray = false
		
		if lockedCB.state then
		(
			tmpSelId = for i in namesMLB.selection collect i
			clearselection()
			for id in tmpSelId do 
			(
				selectmore sel[id]
				sel[id].xray = true
			)
-- 			for
-- 			select smpSel
		)
		
		initS()
		refreshUI()

	)
	
	on idSP changed val do
	(
-- 		format "youpi\n"
		sel = selection as array
		if sel.count > 0 then
		(
-- 			local var = sel[1].name
			testName = incrementName sel[1].name charId: val inc: jumpSP.value
			format "new name: %\n" testName
		)
	)
	
	on jumpSP changed val do
	(
		sel = selection as array
		if sel.count > 0 then
		(
-- 			local var = sel[1].name
			testName = incrementName sel[1].name charId: idSP.value inc: val
			format "new name: %\n" testName
		)
	)
	
	on numberBT pressed do
	(
		sel = selection as array
		newSel = #()
		for s in sel do
		(
			tmpName = incrementName s.name charId: idSP.value inc: jumpSP.value
			if tmpName != undefined then s.name = tmpName
-- 			copyS = copyIncNameNMove s id:idSP.value jump:jumpSP.value moving: true decay: [xSp.value, ySP.value, zSp.value]
-- 			append newSel copyS
		)
-- 		select newSel
		refreshUI()
	)
	
	on nameET changed val do
	(
		if s != undefined then s.name = val
		refreshUI()
-- 		print val
	)
	
	on copyNameBT pressed do
	(
		if s != undefined then copyName = s.name else copyName = undefined
		refreshUI()
-- 		copyNameET.text = copyName
	)
	
	on pasteNameBT pressed do
	(
		if copyName != undefined then
		(
			for i in namesMLB.selection do
			(
				sel[i].name = copyName
			)
		)
		refreshUI()
	)
	
	on baseNameET changed val do
	(
		basename = val
		format "basename: %\n" basename
	)
	
	on addBasenameBT pressed do
	(
-- 		format "s.name: %\n" s.name
		if basename != undefined then
		(
			for i in namesMLB.selection do
			(
				sel[i].name = basename + "_" + sel[i].name
			)
		)
-- 		s.name = basename + "_" + s.name
		refreshUI()
	)
	
	-- groupe suffix	
	on ctrlBT pressed do
	(
		for i in namesMLB.selection do sel[i].name = changeSuffix sel[i].name "CTRL"
		refreshUI()
	)
	
	on bipBT pressed do
	(
		for i in namesMLB.selection do sel[i].name = changeSuffix sel[i].name "BIP"
		refreshUI()
-- 		s.name = changeSuffix s.name "BIP"
-- 		updateUI()
	)
	
	on mdlBT pressed do
	(
		for i in namesMLB.selection do sel[i].name = changeSuffix sel[i].name "MDL"
		refreshUI()
	)
	
	on rigBT pressed do
	(
		for i in namesMLB.selection do sel[i].name = changeSuffix sel[i].name "RIG"
		refreshUI()
	)
	
	on plotBT pressed do
	(
		for i in namesMLB.selection do sel[i].name = changeSuffix sel[i].name "PLOT"
		refreshUI()
	)
	
	on loBT pressed do
	(
		for i in namesMLB.selection do sel[i].name = changeSuffix sel[i].name "LO"
		refreshUI()
	)
	
	on refBT pressed do
	(
		for i in namesMLB.selection do sel[i].name = changeSuffix sel[i].name "REF"
		refreshUI()
-- 		s.name = changeSuffix s.name "REF"
-- 		updateUI()
	)
	
	on skinBT pressed do
	(
		for i in namesMLB.selection do sel[i].name = changeSuffix sel[i].name "SKIN"
		refreshUI()
-- 		s.name = changeSuffix s.name "SKIN"
-- 		updateUI()
	)
	
	-- group replace
	on searchET changed val do
	(
		search = val
		refreshUI()
	)
	
	on replaceET changed val do
	(
		rep = val
		refreshUI()
	)
	
	on repalceBT pressed do
	(
		for i in namesMLB.selection do
		(
			sel[i].name = substituteString sel[i].name search rep
		)
-- 		s.name = substituteString s.name search rep
		
-- 		format "s.name: %, search: %, replace: %\n" s.name search rep
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
-- 		(gc ())
		callSel = NodeEventCallback  selectionChanged: refreshUI_NEC
		updateUI locked: lockedCB.state
-- 		print "youpi"
	)
	
	on renameRLT close do
	(
		callSel = undefined
		(gc ())
-- 		print "ploufe"
	)
	
	on subLeftBT pressed do
	(
		for i in namesMLB.selection do
		(			
			if matchpattern sel[i].name pattern: "*_*_D_*" then sel[i].name = substitutestring sel[i].name "_D_" "_G_"
		)
		refreshUI()
	)
	
	on subRightBT pressed do
	(
		for i in namesMLB.selection do
		(			
			if matchpattern sel[i].name pattern: "*_*_G_*" then sel[i].name = substitutestring sel[i].name "_G_" "_D_"
		)
		refreshUI()
	)
	
)
createdialog(multiRenameRLT)

--  printName = undefined 

