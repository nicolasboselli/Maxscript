-- structure to collect and keep grid object
struct gridST
(
	obj,
	name = obj.name
)

-- fonction to collect grids in the scene
--return array of the grid with home grid first
fn collectGridFN =
(
	local gridAr = #(gridST undefined "home")
	
	for obj in $* do
	(
		if (classof obj) == grid do
		(
			print obj
			gridObj = gridST obj
			append gridAr gridObj
		)
	)
	return gridAr
)

try(destroydialog gridRLT)catch()
rollout gridRLT "Grids Manager"
(
	-- 	vars
	local maxIni = getMAXIniFile()
	local armadasScriptsIni = (getFilenamePath maxIni) + "armadasScriptsIni.ini"
-- 	local root = getINISetting armadasScriptsIni "armadasScripts" "armadasScriptsRoot"
	
	--vars
	local gridList = #()
	local gridListToDisp = #()
	
	-- functions
		
	fn writePosition rlt =
	(
		posBak = GetDialogPos rlt
		res = setINISetting armadasScriptsIni rlt.name "pos" (posBak as string)
		res
		format  "position saved: %\n" res
	)
	
	fn loadPosition rlt =
	(
		posBak = [800,250]

		if (hasINISetting armadasScriptsIni rlt.name "pos") then
		(
			posBakStr = getINISetting armadasScriptsIni  rlt.name "pos"
			posBak = execute posBakStr
		)
		
		SetDialogPos rlt posBak
	)
	
	-- ui
	listbox gridsLB "Grids List :" height: 20
	button refrListBT "refresh list"
	button gridViewBT "grid view"
	
-- 	fn

	
	fn refreshUIFN =
	(
		gridList = collectGridFN()
		gridListToDisp = gridList
		gridsLB.items = for oneGrid in gridListToDisp collect oneGrid.name
	)
	
	-- actions
	
	on gridRLT open do
	(
		refreshUIFN()
		-- load ini file
		try loadPosition gridRLT
		catch format "*** % ***\n" (getCurrentException())

	)
	
	on gridRLT close do
	(
		writePosition gridRLT
	)
	
	on gridViewBT pressed do
	(
		num = gridsLB.selection		
		
		activeGrid = gridList[num].obj

		viewport.setType #view_grid
		viewport.setType #view_iso_user
	)
	
	on gridsLB doubleclicked arg do
	(
		activeGrid = gridList[arg].obj

		viewport.setType #view_grid
		viewport.setType #view_iso_user
	)		
	
	on refrListBT pressed do refreshUIFN()
	
	
)

createdialog gridRLT


