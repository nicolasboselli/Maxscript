try(destroydialog saveLoadAnimRLT )catch()
rollout saveLoadAnimRLT "saveLoadAnimation"
(
-- 	vars
	local correctAsset
	local AssetSel
	local attr
	local id
	local ctrls
	
	local savePath
	local loadPath
	local saveAnimName
	
	local saveName
	
-- 	ui
	group "Asset Selected"
	(
		button loadAssetNodeBT ">>" pos: [ 10 , 20 ]
		edittext assetNodeET "Asset Node:" readtextonly: true pos: [ 50 , 22 ] width: 240
		button selectCtrlsBT "Select Controls"
	)
	
	group "Save:"
	(
		edittext savePathET "path:" readtextonly: true pos: [ 10 , 95 ] width: 248
		button selSavePathBT "..." pos: [ 260 , 92]
		edittext savenameET "Anim Name:"
		button saveAnimBT "Save" 
	)
	
	group "Load:"
	(
		edittext loadPathET "path:" readtextonly: true pos: [ 10 , 190 ] width: 248
		button selLoadPathBT "..." pos: [ 260 , 188 ]
		dropdownlist animDDL "Anims:"
		button loadAnimBT "Load"
	)
	
-- 	functions
	fn initVars =
	(
		sel = selection as array
		if sel.count == 1 then 
		(
			try
			(
				AssetSel = sel[1]
				attr = AssetSel.modifiers[#Content_Node]				
				id = finditem attr.catNameList "MAIN_CTRL"
				
				ctrls = for o in attr.catContentList[id] collect o
				
				correctAsset = true
				
			)
			catch
			(
				AssetSel = undefined
				attr = undefined
				id = undefined
				
				correctAsset = false
				format "ERROR:%\n" (getcurrentexception())
			)
		)
		correctAsset
	)
	
-- 	ui functions
	fn refreshUI =
	(
		if AssetSel != undefined then assetNodeET.text = AssetSel.name else assetNodeET.text = "NONE"
		if savePath != undefined then savePathET.text = savePath else savePathET.text = "NONE"
	)
	
	-- actions
	on saveLoadAnimRLT open do
	(
		refreshUI()
	)
	
	on loadAssetNodeBT pressed do
	(
		initVars()
		refreshUI()
	)
	
	on selectCtrlsBT pressed do
	(
		select ctrls
	)
	
	on selSavePathBT pressed do
	(
		res = getSavePath caption: "Save Folder" -- initialDir: root
		if res != undefined then savePath = res
		refreshUI()
	)
	
	on savenameET changed val do
	(
		saveAnimName = val
	)
	
	on saveAnimBT pressed do
	(
		SaveFileName = savePath + "\\" + saveAnimName + ".xaf"
		format "filename: %\n" SaveFileName
-- 		LoadSaveAnimation.saveAnimationNodeAnim 
	)
)
createdialog saveLoadAnimRLT width: 300


LoadSaveAnimation.saveAnimation fileName nodes userAttributes userValues \
animatedTracks:true includeConstraints:false keyableTracks:true saveSegment:false segInterval: (interval 0f 0f)  segKeyPerFrame: false

