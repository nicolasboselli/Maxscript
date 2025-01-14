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
*/

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



try(destroydialog gridRLT)catch()
rollout gridRLT "Grids Manager"
(
	--vars
	local params = #("pos")
	local gridList = #()
	local gridListToDisp = #()
	
	local setsList = #()
	
	local selectedGridID = 1
	
	local helpersLayer
	local plansAr = #()
		

/* 	group "STATES SETS:"
	(
		listbox statesLB "Sets :" 
		edittext setNameET "name:"
		button addStateBT "add Set"
		button delStateBT "delet Set"
	) */
	
/* 	group "MODE LAYERS:"
	(
		multilistBox layersMLB "Layers :"
	) */
	
	group "GRIDS:"
	(
		button homeGridBT "HOME GRID"
		listbox gridsLB "Grids List :" height: 20
		
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
		listbox listPlanLB "list plan:" height: 3 readonly: true
		button cleanPlanBT "clean plan"
		checkbox hiddeOtherCB "Hide Others Plans" checked: false
	)
	
-- 	fn	
	fn initValues =
	(
-- 		setsList = checkHelpersLayerParents()
		-- collecte
		gridList = for o in helpers where  iskindof o grid collect o
		gridListToDisp = gridList
		qsort gridListToDisp sortbyname
		
		
		
	)
	
	fn refreshUI =
	(		
		
-- 		statesLB.items = for s in setsList collect s.name
		
		gridsLB.items =  for oneGrid in gridListToDisp collect oneGrid.name
		selectedGridID = gridsLB.selection
		if selectedGridID > 0 then gridnameET.text = gridListToDisp[selectedGridID].name	
		listPlanLB.items = for p in plansAr collect p.name	
	)
	
	-- actions
	
	on addStateBT pressed do
	(
		helpersLayer = checkHelpersLayer ()
		
		LM = layermanager	
		setLayer
		setLayerName = "set1"
		if (LM.getLayerFromName setLayerName) == undefined then setLayer = LM.newLayerFromName setLayerName
		else setLayer = LM.getLayerFromName setLayerName
		
		setLayer.setParent helpersLayer
	)
	
	
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
-- 		selectedGridID = gridsLB.selection
-- 		num = gridsLB.selection		
		
		activeGrid = gridListToDisp[selectedGridID]

		viewport.setType #view_grid
		viewport.setType #view_iso_user
		
		plansAr = checkTagGrid gridListToDisp[selectedGridID]
		format "plansAr: %\n" plansAr
		if plansAr.count > 0 then viewport.ZoomToBounds false plansAr[1].min plansAr[1].max
		
-- 		for p in plansAr where isvalidnode p do p.ishidden = false
		-- décacher les plans selectionnés
		if hiddeOtherCB.checked then
		(
			-- cacher tous les plans
			for p in $plane_* do p.ishidden = true
			-- decacher les plans selectionnés
			for p in plansAr where isvalidnode p do p.ishidden = false
			
		)
		else()
	)
	
	on gridsLB selected arg do
	(
		selectedGridID = arg
		plansAr = checkTagGrid gridListToDisp[selectedGridID]
		
		
		initValues()
		refreshUI()
		
-- 		format "plansAr: %\n" plansAr
-- 		select gridListToDisp[selectedGridID]
	)
	
	on gridsLB doubleclicked arg do
	(
		gridViewBT.pressed()
/* 		selectedGridID = arg
		activeGrid = gridListToDisp[selectedGridID]

		viewport.setType #view_grid
		viewport.setType #view_iso_user */
	)
/* 	
	on gridnameET changed newName do
	(
-- 		format "gridnameET.text: %\n" gridnameET.text
	)
	 */
		
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
			
			tagGrid newGrid s.name
			
			initValues()
			refreshUI()
		)
	)
	
	on addPlanBT pressed do
	(
		sel = selection as array
		for s in  sel do tagGrid gridListToDisp[selectedGridID] s.name
		
		plansAr = checkTagGrid gridListToDisp[selectedGridID]
		initValues()
		refreshUI()
	)
	
	on cleanPlanBT pressed do
	(
		cleanTagGrid gridListToDisp[selectedGridID]
		plansAr = checkTagGrid gridListToDisp[selectedGridID]
		initValues()
		refreshUI()
	)
)

-- max autogrid ?

createdialog gridRLT


