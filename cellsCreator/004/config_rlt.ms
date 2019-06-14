-- maj:
	-- rendre editable le chemin d'enregistrement des configs
	-- ajouter une fonction delete


global cellSetPath = getroot() +"cellsCreator/cellSettings/*"

try(destroydialog savePrefRLT)catch()
rollout savePrefRLT "cell configuration"
(
	
	local params = #("open")
	
	local cellSetAr = #()
	local layerStructAr = #()
	
	local cellSetIni -- = getRoot() + "cellsCreator/cellSettings/cellSettings.ini"
-- 	local mursPrefix = "_Splines Murs "
	
	local murSel = undefined 
	
	group "configuration:"
	(
		dropdownlist  configDDL "select:"  enabled: true
		button saveBT "save" across: 3  enabled: true
		button saveAsBT "saveAs" enabled: true
		button loadBT "load"  enabled: true
	)
	
	-- UI functions
	fn refreshUI =
	(
		configDDL.items = for c in cellSetAr collect (getFilenameFile c)
	)	
	
	fn loadSettings f =
	(
-- 		layerStructAr = #()
		if 	prepaMursRLT.isdisplayed then 
		(
			mursSettingsAr = getINISetting f "mursSettings2"
			prepaMursRLT.layerStructAr = #()
			for o in  mursSettingsAr do
			(
				append prepaMursRLT.layerStructAr (execute(getINISetting f "mursSettings2" o))
				prepaMursRLT.refreshUI()
			)
		)
		
		if prepaPercementRLT.isdisplayed then
		(
			setsAr = getINISetting f "drillSettings"
			prepaPercementRLT.layerStructAr = #()
			for o in  setsAr do
			(
				append prepaPercementRLT.layerStructAr (execute(getINISetting f "drillSettings" o))
				prepaPercementRLT.refreshUI()
			)
		)
	)
	
	fn saveSettings f =
	(
		format "start save\n"
-- 		delIniSetting f "mursSettings2"
		
		for l in prepaMursRLT.layerStructAr do
		(
			format "% = %\n" l.name (l as string)
			setINISetting f "mursSettings2" l.name  (l as string)
		)
		
		for l in prepaPercementRLT.layerStructAr do
		(
			format "% = %\n" l.name (l as string)
			setINISetting f "drillSettings" l.name  (l as string)
		)
	)

		
	on savePrefRLT open do
	(
		-- collecte des settings de cellules
		cellSetAr = getfiles cellSetPath
		loadRolloutParams savePrefRLT params
		
		-- collecte des types de mur
		if cellSetAr.count == 0 then()
		else loadSettings cellSetAr[1]
		
		refreshUI()
	)
	
	on savePrefRLT close do
	(
		writeRolloutParams savePrefRLT params
	)
	
	on loadBT pressed do
	(
		local config = cellSetAr[configDDL.selection]
-- 		format "configSel: %\n"  config

		if not doesfileexist config then()
		else 	loadSettings config
		format "layerStructAr: %\n" layerStructAr
		for l in layerStructAr do format "%\n" l
		refreshUI()
	)
	
	on saveBT pressed do
	(
		local config = cellSetAr[configDDL.selection]
		format "configSel: %\n"  config
		if doesfileexist config then saveSettings config
		cellSetAr = getfiles cellSetPath
		refreshUI()
	)
	
	on saveAsBT pressed do
	(
		local newFileName = getSaveFileName filename: cellSetPath caption: "save sell preferences" types: "Ini(*.ini)|*.ini|All|*.*|"
		
		if newFileName != undefined then
		(
			format "newFileName: %\n" newFileName 
			saveSettings newFileName
			cellSetAr = getfiles cellSetPath
			refreshUI()
		)
	)
)
-- createdialog savePrefRLT