/*
maj:
	-- callback pour la selection des grilles dans la scene
	-- picker pour faire un placement auto des grilles
*/


fn collectGrid =
(
	
	local gridAr = for o in $* where  iskindof o grid collect o
	gridAr
)

try(destroydialog gridRLT)catch()
rollout gridRLT "Grids Manager"
(
	--vars
	local params = #("pos")
	local gridList = #()
	local gridListToDisp = #()
		
	-- ui
	button homeGridBT "HOME GRID"
	listbox gridsLB "Grids List :" height: 20
	
	button sortBT "sort"
	button refrListBT "refresh list"
	button gridViewBT "grid view"
	
-- 	fn	
	fn refreshUI =
	(		
		gridsLB.items =  for oneGrid in gridListToDisp collect oneGrid.name
	)
	
	-- actions
	
	on gridRLT open do
	(
		loadRolloutParams gridRLT params
		
		gridList = collectGrid()
		gridListToDisp = gridList
		
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
		num = gridsLB.selection		
		
		activeGrid = gridListToDisp[num]

		viewport.setType #view_grid
		viewport.setType #view_iso_user
	)
	
	on gridsLB doubleclicked arg do
	(
		activeGrid = gridListToDisp[arg]

		viewport.setType #view_grid
		viewport.setType #view_iso_user
	)		
	
	on refrListBT pressed do 
	(
		gridList = collectGrid()
		gridListToDisp = gridList
		
		refreshUI()
	)
)

createdialog gridRLT


