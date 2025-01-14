/*
maj:
	-- callback pour la selection des grilles dans la scene
	x- placer les grilles dans un calque grille
	x- picker pour faire un placement auto des grilles
		- activer autoalign
	x-- renamer de grille
	-- mettre la selection des grille en checkbox
	-- mettre le sort des grilles en checkbox
	-- associer un plan à une grille (auto hide/unhide)
	-- faire un toggle cacher/decacher tous les plans
	-- faire un cadrage automatique sur tout ce qui est visible
	-- prévoir option de cacher les pans de la grille selectionnée sans aligner la vue à la grille
	
	-- enregistrer dans un fichier ini les etats de modelisation
		-- associés avec les grilles, les plans et les layers de modelisation et les etats des plans te des modelisations
	
*/

fn findDoubleName =
(
	(
		allCellNames = #()

		lCount = LayerManager.count
		for i = 0 to (lCount - 1)  do
		(
			l = LayerManager.getLayer i
			res = matchpattern l.name pattern: "plans_*"
			if res then
			(
				format "%\n" l.name
				 l.nodes &nodes
				format "nodes: %\n" nodes
				for n in nodes do append allCellNames n
			)
		)

		qsort allCellNames sortbyname

		-- for c in allCellNames do print c.name
		doubleAr = #()
		for i = 1 to (allCellNames.count - 1) do
		(
			if allCellNames[i].name == allCellNames[i+1].name then
			(
				format "i: % i+1: %\n" allCellNames[i].name allCellNames[i+1].name
				append doubleAr allCellNames[i]
				append doubleAr allCellNames[i + 1]
			)
		)
		format "doubleAr: %\n" doubleAr
		select doubleAr
	)
	
	$.name = uniqueName $.name
)

fn sortbyname v1 v2 =
(
-- 	vars
	local d
	
	if ( (toLower v1.name) < (toLower v2.name)) then d=-1
	else d=1
	
--compare les numeros entre eux et les classe	
	if 	(d < 0.) then -1
	else if (d > 0.) then 1
	else 0
)

fn collectGrid =
(
	local gridAr = for o in helpers where  iskindof o grid collect o
	gridAr
)

fn checkHelpersLayer =
(
	LM = layermanager	
	local lcName = "helpers"
	local lcl
	if (LM.getLayerFromName lcName) == undefined then lcl = LM.newLayerFromName lcName
	else lcl = LM.getLayerFromName lcName
	
	lcl
)

fn checkHelpersLayerParents =
(
	LM = layermanager	
	local lcName = "helpers"
	local lcl
	if (LM.getLayerFromName lcName) == undefined then lcl = LM.newLayerFromName lcName
	else lcl = LM.getLayerFromName lcName
	
	childCount = lcl.getNumChildren()
	lparents = for i = 1 to childCount collect lcl.getChild i
	format "lcl.getparent: %\n" lparents
	lparents
)
-- checkHelpersLayerParents()



-- getuserprop $ "planesAr "
fn checkTagGrid g =
(
	local plansAr = #()
	local userProp  = getuserprop g "planesAr"
	
	format "userProp plan: %\n"  userProp
	if userProp == undefined then()
	else
	(
		-- tester si le nom est un array
-- 			format "repName: %\n" (execute repName)
		local testArray = execute userProp
		-- traiter l'array
-- 		format "testArray: %\n"  testArray
		
		if iskindof testArray array then 
		(
			for t in testArray do
			(				
				local oneplan = getnodebyname t
				if isvalidnode oneplan do append plansAr oneplan
			)
		)
		else #()
	)
	plansAr
)
-- checkTagGrid $

fn tagGrid g planeName =
(
	local planesAr = getuserprop g "planesAr" 
	if planesAr == undefined or (execute planesAr) == undefined then
	(
		setuserprop g "planesAr" #(planeName)
	)
	else
	(
		local testArray = execute planesAr
		
		-- ajouter un nom à l'array
		if iskindof testArray array then
		(
			testArray = makeuniquearray testArray
			appendifunique testArray planeName
		)
			
		-- ecrire l'array
		setuserprop g "planesAr" testArray			
	)
	
	format "wrote: %\n" (getuserprop g "planesAr")
)

fn cleanTagGrid g =
(
	local repName = getuserprop g "planesAr" 
	if repName != undefined then
	(
		setuserprop g "planesAr" #()
	)
	else()
)


fn checkLayersStates g =
(
	local layersStates
	local layersStatesStr = getuserprop g "layersStates"
-- 	format "layersStatesStr: %\n" layersStatesStr
	
	if not iskindof layersStatesStr UndefinedClass then
	(
-- 		format "layersStatesStr: %\n" layersStatesStr
		layersStates = execute layersStatesStr
		if iskindof layersStates array then
		(
			true
		)
		else false
	)else false
)	


fn tagGridWithLayersState g =
(
	local layersNames = #()
	local layersStates = #()
	local layerCountNum = LayerManager.count
	
	for i = 0 to (layerCountNum - 1) do
	(
		l =  LayerManager.getLayer i
-- 		format "i: %, name: %, on: %\n" i l.name l.on
		append layersStates  l.on
		append layersNames l.name
	)
	
	local layersNamesStr = with printAllElements on layersNames as string
	local layersStatesStr = with printAllElements on layersStates as string
	
	format "g.name: %\n" g.name
	format "\tlayersNamesStr: %\n" layersNamesStr
	format "\tlayersStatesStr: %\n" layersStatesStr
	
	setuserprop g "layersNames" layersNamesStr
	setuserprop g "layersStates" layersStatesStr
)

fn loadLayersStatesFromGrid g =
(
	local doubleAr = #()
	local layersStates = #()
	local layersStatesStr = getuserprop g "layersStates"
	
	local layersNames = #()
	local layersNamesStr = getuserprop g "layersNames"
-- 	format "layersStatesStr: %\n" layersStatesStr
	
	if not iskindof layersStatesStr UndefinedClass and not iskindof layersNamesStr UndefinedClass then
	(
-- 		format "layersStatesStr: %\n" layersStatesStr
		layersStates = execute layersStatesStr
		layersNames = execute layersNamesStr		
		
 		if iskindof layersStates array and iskindof layersNames array then
		(
			#( layersNames , layersStates )
			
/* 			for i = 1 to (layersNames.count) do
			(
				
-- 				l =  LayerManager.getLayer (i-1)
				l = LayerManager.getLayerFromName layersNames[i]
-- 				format "i: % , l: % , on: %\n " (i-1) l.name layersStates[i]
				if not iskindof l UndefinedClass then l.on = layersStates[i]
			) */
		) 
	)
	
)

-- test = getuserprop $ "layersStates"
-- classof (execute test)

try(destroydialog gridRLT)catch()
rollout gridRLT "Grids Manager"
(
	--vars
	local params = #("pos")
	local gridList = #()
	local gridListToDisp = #()
	
	local setsList = #()
	local selectedSet
	
	local selectedGridID = 1
	
	local helpersLayer
	local plansAr = #()
	
	local stateBoolean = false
		

	group "STATES SETS:"
	(
		listbox statesLB "Sets :" 
		edittext setNameET "name:"
		button addStateBT "add Set"
		button delStateBT "delet Set"
	)
	
/* 	group "MODE LAYERS:"
	(
		multilistBox layersMLB "Layers :"
	) */
	
	group "GRIDS:"
	(
		button homeGridBT "HOME GRID"
		listbox gridsLB "Grids List :" --height: 20
		
		edittext gridnameET	
		button sortBT "sort" across: 2
		button refrListBT "refresh list"
		button gridViewBT "grid view" across: 2
		button selectGridBT "select grid"
		button deleteGridBT "delete grid"
		button createGridBT "create grid" 
		button createGridBT2 "grid from plane"
	)
	
	group "PLANS:"
	(
		button addPlanBT "add plan"
-- 		listbox listPlanLB "list plan:" height: 5 readonly: true
		multilistbox listPlanLB "list plan:" height: 5 readonly: true
		button cleanPlanBT "clean plan"
		checkbox hiddeOtherCB "Hide Others Plans" checked: false
	)
	
	group "LAYERS STATE:"
	(
		edittext stateET 
		checkBox autoLoadCB "autoload state" checked: true
		button saveBT "save state" 
		button loadBT "load state"
		
		button copyBT "test state"
		button pasteBT "paste state"
		button deleteBT "delete state"
	)
	
-- 	fn	
	fn initValues =
	(
		-- collecte des sets
		setsList = checkHelpersLayerParents()
		qsort setsList sortbyname		
		
		-- collecte grilles
-- 		if statesLB.selection == 0 then statesLB.selection = 1
-- 		setsList[statesLB.selection].nodes &gridList
-- 		gridList = for o in helpers where  iskindof o grid collect o
-- 		gridListToDisp = gridList
-- 		qsort gridListToDisp sortbyname		
	)
	
	fn refreshUI =
	(		
		-- collecte des noms de sets
		statesLB.items = for s in setsList collect s.name
		
		-- affichage du nom du set selectionné
		if not iskindof selectedSet UndefinedClass then setNameET.text = selectedSet.name
		
		-- collecte des grilles du set
		if statesLB.selection == 0 then statesLB.selection = 1
		if setsList.count > 0 then
		(
			setsList[statesLB.selection].nodes &gridListToDisp
			qsort gridListToDisp sortbyname		
			
			-- affichage du nom des grilles
			gridsLB.items =  for oneGrid in gridListToDisp collect oneGrid.name
			
			-- collecte du numero de grille choisie
			selectedGridID = gridsLB.selection
			
			if selectedGridID > 0 then 
			(
				-- affichage du nom de la grille
				gridnameET.text = gridListToDisp[selectedGridID].name
					
				-- collecte des plans de la grille choisie
				plansAr = checkTagGrid gridListToDisp[selectedGridID]
				-- afichage des plans
				listPlanLB.items = for p in plansAr collect p.name	
				
				-- collecte des états de scènes 
				stateBoolean = checkLayersStates gridListToDisp[selectedGridID]
				-- affichage des etats de scenes
				if stateBoolean then stateET.text = "true" else  stateET.text = "false"
			)
		)
	)
	
	-- actions
	

	
	
	on gridRLT open do
	(
		loadRolloutParams gridRLT params
		
		initValues()
		refreshUI()
	)
	
	on gridRLT close do
	(
		writeRolloutParams gridRLT params
	)
	
	on setNameET entered newName do
	(
		format "newName: %\n" newName
		selectedSet.setname newName
		
		initValues()
		refreshUI()
	)
	
	on addStateBT pressed do
	(
-- 		format "new set\n" 
		-- 
		helpersLayer = checkHelpersLayer ()
		
		LM = layermanager	
		setLayer
		setLayerName = "set1"
		if (LM.getLayerFromName setLayerName) == undefined then setLayer = LM.newLayerFromName setLayerName
		else setLayer = LM.getLayerFromName setLayerName
		
		setLayer.setParent helpersLayer
		
		initValues()
		refreshUI()
	)
	
	on statesLB selected arg do
	(
		selectedSet = setsList[arg]
		format "set: %\n" selectedSet.name
		refreshUI()
	)
	
	
	on statesLB doubleClicked arg do
	(
		selectedSet = setsList[arg]
		format "\ndouble clic set: %\n" selectedSet.name
		refreshUI()
		format "selectedGridID: %\n" selectedGridID
		if selectedGridID > 0 then
		(
			gridViewBT.pressed()
			loadBT.pressed()
		)
		
	)
	
	on homeGridBT pressed do
	(
		activeGrid = undefined

		viewport.setType #view_grid
		viewport.setType #view_iso_user
	)
	
	on sortBT pressed do
	(
		qsort gridListToDisp sortbyname
		refreshUI()
	)
	
	on gridViewBT pressed do
	(	
		if selectedGridID > 0 then
		(
			activeGrid = gridListToDisp[selectedGridID]

			viewport.setType #view_grid
			viewport.setType #view_iso_user
			
-- 			plansAr = checkTagGrid gridListToDisp[selectedGridID]
			format "plansAr: %\n" plansAr
			if plansAr.count > 0 then viewport.ZoomToBounds false plansAr[1].min plansAr[1].max
			
	-- 		for p in plansAr where isvalidnode p do p.ishidden = false
			-- décacher les plans selectionnés
			if hiddeOtherCB.checked then
			(
				format "youhou!\n"
				-- cacher tous les plans
				for p in $plane_* do p.ishidden = true
				-- decacher les plans selectionnés
				for p in plansAr where isvalidnode p do p.ishidden = false
				
			)
			else()
		)
	)
	
	on gridsLB selected arg do
	(
		selectedGridID = arg
		
-- 		plansAr = checkTagGrid gridListToDisp[selectedGridID]
		
-- 		stateBoolean = checkLayersStates gridListToDisp[selectedGridID]

		refreshUI()
	)
	
	on gridsLB doubleclicked arg do
	(
		gridViewBT.pressed()
	)

		
	on gridnameET entered newName do
	(
-- 		format "gridnameET.text: %\n" gridnameET.text
		gridListToDisp[selectedGridID].name = gridnameET.text
		refreshUI()
	)
	
	on refrListBT pressed do 
	(
		initValues()		
		refreshUI()
	)
	
	on deleteGridBT pressed do
	(
		delete gridListToDisp[selectedGridID]
		
		initValues()		
		refreshUI()
	)
	
	on selectGridBT pressed do
	(
		select gridListToDisp[selectedGridID]
	)
	
	on createGridBT pressed do 
	(
		-- creation du layer
		helpersLayer = checkHelpersLayer()
		
		--
		objCount = (helpers as array).count
		
		startObjectCreation grid returnNewNodes: true
		
		newobjCount = (helpers as array).count
		newGrids = for i = objCount to newobjCount collect  helpers[i]
		
		StopCreating()
		format "newGrid: %\n" newGrids
		
		
		helpersLayer.addnodes newGrids
		initValues()
		refreshUI()
	)
	
	on createGridBT2 pressed do
	(
		sel = selection as Array
		format "sel: %\n" sel
		for s in sel do
-- 		if sel.count == 1 then
		(
			format "s: %\n" s
			newGrid = grid transform: s.transform name: (s.name + "_GRID")
			newGrid.scale = (point3 1 1 1)
			
			helpersLayer = checkHelpersLayer()
			helpersLayer.addnodes newGrid
			
			if not iskindof selectedSet UndefinedClass  then selectedSet.addnodes newGrid
			
			tagGrid newGrid s.name
			
			initValues()
			refreshUI()
		)
	)
	---------------------------- group plans
	on addPlanBT pressed do
	(
		sel = selection as array
		for s in  sel do tagGrid gridListToDisp[selectedGridID] s.name
		
		plansAr = checkTagGrid gridListToDisp[selectedGridID]
		initValues()
		refreshUI()
	)
	
	on listPlanLB selected val do
	(
		-- script les selection en mode toggle
		format "val: %\n" listPlanLB.selection
		for id in listPlanLB.selection do 
		(
			format "id % : %\n" id plansAr[id]
		)
		
	)			

	on cleanPlanBT pressed do
	(
		cleanTagGrid gridListToDisp[selectedGridID]
		plansAr = checkTagGrid gridListToDisp[selectedGridID]
		initValues()
		refreshUI()
	)
	
	---------------------------- group states
	on saveBT pressed do
	(
		for g in gridListToDisp do tagGridWithLayersState g
-- 		tagGridWithLayersState gridListToDisp[selectedGridID]
		refreshUI()
	)
	
	on loadBT pressed do
	(
		res = loadLayersStatesFromGrid gridListToDisp[selectedGridID]
		format "grid: %\n" gridListToDisp[selectedGridID]
		try
		(
			layersNames = res[1]
			layersStates = res[2]
			
			for i = 1 to layersNames.count do
			(
				l = LayerManager.getLayerFromName layersNames[i]
				if not iskindof l UndefinedClass then l.on = layersStates[i]
				format "l.name: % state: % \n" layersNames[i] layersStates[i]
			)
		)
		catch(format "load Fail!\n")
		
	)
	
	on copyBT pressed do
	(
		
	)
)

-- max autogrid ?

createdialog gridRLT

