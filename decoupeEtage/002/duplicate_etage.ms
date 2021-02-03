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
	local params = #("pos", "workOnTypeRB", "sourceLayerCB", "targetLayerCB", "idSP", "jumpSP")
	
	local layerList = #()
	local layerListDisplay = #()
	local layerListName = #()
	
	local testname = ""
	local testBaseName = ""
	
	local sourceLayer
	local targetLayer
	
	local gridLayer
	
	edittext gridLayerET "active grid:" readonly: true
	
	radiobuttons workOnTypeRB "work on:" labels: #("selection", "layers")
	dropdownlist  sourceLayerCB "layer source:" height: 120 -- across: 2
	dropdownlist  targetLayerCB "layer target:"  height: 80
	
	group "renaming"
	(
		spinner idSP "character index:" type: #integer range:  [1,1000,1] across: 2
		spinner jumpSP "increment:" type: #integer  range: [-100,100,1]
		edittext cellBaseNameET "cell base name:"  readonly: true across: 2
		edittext cellNewNameET "cell new name:"  readonly: true
	)
	/*
	group "moving"
	(
		spinner xSP "x:" type: #worldunits  range: [-1000,1000,0] across: 3
		spinner ySP "y:" type: #worldunits range: [-1000,1000,0]
		spinner zSP "z:" type: #worldunits range: [-1000,1000,300]
	)
	*/
	button cloneBT "duplicate"
	
	fn init =
	(
		-- collecte de la grille active
		if activeGrid != undefined then gridLayer = activeGrid
		
		-- collecte des layers
		layerList = for i = 0 to (LayerManager.count - 1) collect (LayerManager.getLayer i)
		layerListDisplay = for l in layerList where matchpattern l.name pattern: "Cells*" collect l
		layerListName = for l in layerListDisplay collect l.name
	)
	
	fn refreshUI =
	(
		-- collecte des layers
		sourceLayerCB.items = layerListName
		targetLayerCB.items = layerListName
		
		if sourceLayerCB.selection > 0 then sourceLayer = layerListDisplay[sourceLayerCB.selection]
		if targetLayerCB.selection > 0 then targetLayer = layerListDisplay[targetLayerCB.selection]
-- 		format "sourceLayer: %\n" sourceLayer
		
		-- recuperation de la grille
		if not isvalidnode gridLayer then gridLayerET.text = "NONE"
		else gridLayerET.text = activeGrid.name
		
		-- test du rename
		if testBaseName != undefined then cellBaseNameET.text = testBaseName else cellBaseNameET.text = "NONE"
		if testname != undefined then cellNewNameET.text = testname else cellNewNameET.text = "NONE"
	)
	
	on incNameRLT open do
	(
		loadRolloutParams incNameRLT params
-- 		format "1 sourceLayerCB.selection: % \n" sourceLayerCB.selection 
		
-- 		format "2.4 sourceLayerCB.selection: % \n" sourceLayerCB.selection 
		init()
-- 		format "2.5 sourceLayerCB.selection: % \n" sourceLayerCB.selection 
		refreshUI()
-- 		format "3 sourceLayerCB.selection: % \n" sourceLayerCB.selection 
	)
	
	on incNameRLT close do 
	(
		writeRolloutParams incNameRLT params
	)
	
	on sourceLayerCB selected val do
	(
		init()
-- 		format "source id:%\n" val
-- 		sourceLayer = layerListDisplay[val]
-- 		sourceLayer =  (LayerManager.getLayer (val - 1))
		refreshUI()
		format "sourceLayer: %\n" sourceLayer
		
	)
	
	on targetLayerCB selected val do
	(
		init()
-- 		targetLayer = layerListDisplay[val]
-- 		targetLayer = (LayerManager.getLayer (val - 1))
		refreshUI()
		format "targetLayer: %\n" targetLayer.name
		
	)
	
	on idSP changed val do
	(
		local sel
		
-- 		init()
		
		if workOnTypeRB.state == 1 then sel = selection as array
		else if workOnTypeRB.state == 2 then sourceLayer.nodes &sel
		else(sel = #())
		format "sel:%\n" sel
			
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

-- 		init()
		
		if workOnTypeRB.state == 1 then sel = selection as array
		else if workOnTypeRB.state == 2 then sourceLayer.nodes &sel
		else(sel = #())
		format "sel:%\n" sel
		
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
		
		init()
		format "gridLayer: %\n" gridLayer
		-- selection des objets
		if workOnTypeRB.state == 1 then
		(
			sel = selection as array
		)
		else if workOnTypeRB.state == 2 then
		(
			sourceLayer.nodes &sel
		)
		else(sel = #())
		
		-- copie des objets
		if sel.count > 0 and  isvalidnode gridLayer then
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
)
createdialog incNameRLT width: 400

-- incNameRLT.sourceLayerCB.selection
format "sourceLayerCB.selection: % \n" incNameRLT.sourceLayerCB.selection 

