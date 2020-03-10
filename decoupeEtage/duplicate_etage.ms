/*
sel = selection as array
-- s = $w
id = 1
jump = 1

for s in sel do
(
	newS = copy s
	var = s.name
	var[id] = (((var[id] as integer) + jump) as string)
	newS.name = var
	
	newS.wirecolor = s.wirecolor

	move newS [0,0,300]
)
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

-- incrementName "205" charId: 2 inc: 2

fn copyIncNameNMove s id:1 jump:1 moving: true decay: [0,0,300] =
(
	local newS
	local newName = incrementName s.name charId: id inc: jump
	
	if newName == undefined then (format "fail: %\n" s.name)
	else
	(
		newS = copy s
		
		newS.name = newName
		
		newS.wirecolor = s.wirecolor
		
		s.layer.addnode newS
		
		if moving then move newS decay
	)
	newS
)

try(destroydialog incNameRLT )catch()

rollout incNameRLT "Duplicate Etages"
(
	local layerList = #()
	local layerListDisplay = #()
	local layerListName = #()
	
	local testname = ""
	local testBaseName = ""
	
	local sourceLayer
	local targetLayer
	
	local gridLayer
	
	
	group "work on"
	(
		radiobuttons workOnTypeRB "type:" labels: #("selection", "layers")
		dropdownlist  sourceLayerCB "layer source:" height: 120 across: 2
		dropdownlist  targetLayerCB "layer target:"  height: 80
		edittext gridLayerET "layer grid:" readonly: true
	)

	group "renaming"
	(
		spinner idSP "character index:" type: #integer range:  [1,1000,1] across: 2
		spinner jumpSP "increment:" type: #integer  range: [-100,100,1]
		edittext cellBaseNameET "cell base name:"  readonly: true across: 2
		edittext cellNewNameET "cell new name:"  readonly: true
	)
	
	group "moving"
	(
		spinner xSP "x:" type: #worldunits  range: [-1000,1000,0] across: 3
		spinner ySP "y:" type: #worldunits range: [-1000,1000,0]
		spinner zSP "z:" type: #worldunits range: [-1000,1000,300]
	)
	
	button cloneBT "duplicate"
	
	fn refreshUI =
	(
		-- collecte des layers
		layerListDisplay = layerList
		layerListName = for l in layerListDisplay collect l.name
		sourceLayerCB.items = layerListName
		targetLayerCB.items = layerListName
-- 		format "layerList count: %\n" layerListName.count
		
		-- recuperation de la grille
		local baseName = layerListDisplay[targetLayerCB.selection].name
		local gridName = substitutestring baseName "cell_" ""
		gridLayer =  getNodebyname gridName
		if isvalidnode gridLayer then 	gridLayerET.text = gridLayer.name else gridLayerET.text = "NONE"
		
		-- test du rename
		if testBaseName != undefined then cellBaseNameET.text = testBaseName else cellBaseNameET.text = "NONE"
		if testname != undefined then cellNewNameET.text = testname else cellNewNameET.text = "NONE"
	)
	
	on incNameRLT open do
	(
		layerList = for i = 0 to (LayerManager.count - 1) collect (LayerManager.getLayer i)
		refreshUI()
	)
	
	on sourceLayerCB selected val do
	(
		format "source id:%\n" val
		sourceLayer =  (LayerManager.getLayer (val - 1))
		format "sourceLayer: %\n" sourceLayer.name
-- 		format "%\n" val
		refreshUI()
	)
	
	on targetLayerCB selected val do
	(
		targetLayer = (LayerManager.getLayer (val - 1))
		format "targetLayer: %\n" targetLayer.name
		refreshUI()
	)
	
	on idSP changed val do
	(
		local sel

		if workOnTypeRB.state == 1 then sel = selection as array
		else if workOnTypeRB.state == 2 then
		(
			sourceLayer.nodes &sel
		)
		else(sel = #())
		
		if sel.count > 0 then
		(
			testBaseName = sel[1].name
			testName = incrementName sel[1].name charId: val inc: jumpSP.value
			format "new name: %\n" testName
		)
		
		refreshUI()
	)
	
	on jumpSP changed val do
	(
		local sel

		if workOnTypeRB.state == 1 then sel = selection as array
		else if workOnTypeRB.state == 2 then
		(
			sourceLayer.nodes &sel
		)
		else()
		
		if sel.count > 0 then
		(
			testBaseName = sel[1].name
			testName = incrementName sel[1].name charId: idSP.value inc: val
			format "new name: %\n" testName
		)
		
		refreshUI()
	)
	
	on cloneBT pressed do
	(
		local newSel = #()
		local copyS
		local sel	
		
		if workOnTypeRB.state == 1 then
		(
			sel = selection as array
			if sel.count > 0 then
			(
				for s in sel do
				(
					copyS = copyIncNameNMove s id:idSP.value jump:jumpSP.value moving: true decay: [xSp.value, ySP.value, zSp.value]
					if not copyS == undefined then append newSel copyS
				)
				select newSel
			)
		)
		else if workOnTypeRB.state == 2 then
		(
			sourceLayer.nodes &sel
			if sel.count > 0 then
			(
				for s in sel do
				(
					copyS = copy s
					copyS.wirecolor = s.wirecolor
					copyS.position.z = gridLayer.position.z
					copyS.name = incrementName s.name charId: idSP.value inc: jumpSP.value
					copyS.xray = true
					targetLayer.addnode copyS
				)
			)
		)
		else(sel = #())
		
	)
)
createdialog incNameRLT width: 400


