-- oneCat = "VisioLab"
(
	global ArmadasScriptLauncherPath = @"\scriptsLauncher\001\launcher.ms"
	global ArmadasScriptModelingUtilitiesPath = @"\MODELING_TOOLS\001\modeling_tools.ms"
	global ArmadasScriptMaterialsUtilitiesPath = @"\MATERIALS_TOOLS\000\deMultiMat.ms"
	
	global pickAndMergePath = @"PICKNMERGE/001/pickandmerge.ms"
	global objReplacerPath = @"objReplacer/002/obj_replacer.ms"
	global cellsCreatorPath = @"cellsCreator/005/cellsCreator.ms"
	global matIdManagerPath = @"MatIDManager/004/matIdManager.ms"
	global clientsImageSizePath =  @"visiolab/render_output/000/render_output.ms"
	global initScenePath =  @"visiolab/initScene.ms"
	global initLayersPath =  @"visiolab/initScene_initLayers.ms"
	
	
	macroScript ScriptLauncher
	category: "Visiolab"
	buttonText: "MSXlauncher"
	toolTip:""
	icon: #("armadasScriptsFavorites",1)
	(
		filein ((getroot()) + ArmadasScriptLauncherPath)
-- 		filein ((getroot()) +  "\scriptsLauncher\001\launcher.ms")
	)
	
	macroScript initScene
	category: "Visiolab"
	buttonText: "Init Scene"
	toolTip:""
	(
		filein ((getroot()) + initScenePath)
-- 		initLayers()
	)
	
	macroScript initLayers
	category: "Visiolab"
	buttonText: "Init Layers"
	toolTip:""
	(
		filein ((getroot()) + initLayersPath)
-- 		initLayers()
	)
	
	macroScript ModelingUtilities
	category: "Visiolab"
	buttonText: "modelingUtilities"
	toolTip:""
	icon: #("ArmadasScriptModelingUtilities",1)
	(
		filein ((getroot()) + ArmadasScriptModelingUtilitiesPath)
	)


	macroScript MaterialsUtilities
	category: "Visiolab"
	buttonText: "materialsUtilities"
	toolTip:""
	icon: #("ArmadasScriptMaterialsUtilities",1)
	(
		filein ((getroot()) + ArmadasScriptMaterialsUtilitiesPath )
	)

	
	
	macroScript clientsImageSize
	category: "Visiolab"
	buttonText: "clientsImageSize"
	toolTip:""
-- 	icon: #("pickandmergeicon",1)
	(
		filein ((getroot()) +  clientsImageSizePath)
	)
	
	macroScript openMaxFolder
	category: "Visiolab"
	buttonText: "openMaxFolder"
	toolTip:""
	(
		doscommand ("explorer " + (substituteString maxFilePath "/" "\\"))
	)
	
	macroScript PickAndMerge
	category: "Visiolab"
	buttonText: "PickAndMerge"
	toolTip:""
	icon: #("pickandmergeicon",1)
	(
		filein ((getroot()) +  pickAndMergePath)
	)

	macroScript objectReplacer
	category: "Visiolab"
	buttonText: "Obj Replacer"
	toolTip:""
	-- 	icon: #("pickandmergeicon16",1)
	(
		filein ((getroot()) +  objReplacerPath)
	)

	macroScript collapseRailClone
	category: "Visiolab"
	buttonText: "Collapse RC"
	toolTip:""
	(

		-- collapse railclone
		objs = objects as array
		-- objs = selection as array

		i = 0
		for o in objs where classof o.baseobject == railclone_pro do
		(
			format "railclone:%\n" o.name
			o.rendermode = off
			o.weld = off
			o.weldth = 0

			o.vmesh = 0
-- 			o.faceType = 1
			i = i +1
		)

		sel = #()
		for o in objs where classof o.baseobject == railclone_pro do
		(
			append sel o
		)
		-- select sel

		for o in objs where classof o.baseobject == railclone_pro do
		(
			converttopoly o
			format "convert done:%\n" o.name
		)

	)
	
	macroScript VisiolabReload
	category: "Visiolab"
	buttonText: "Reload"
	toolTip:"Reload Visiolab Script"
	(
		local armadasScriptsIni = (GetDir #maxData) + "armadasScriptsIni.ini"
		local root = getINISetting armadasScriptsIni "armadasScripts" "armadasScriptsRoot"
		filein ((getroot()) +  "scriptInstaller/armadasScriptInstall.ms")
	)


	macroscript bridgeShortcut
	category: "Visiolab"
	buttonText: "Brigde"
	toolTip:"bridge"
	(
		if classof $ == editable_poly then $.editablepoly.bridge()
	)
	
	macroscript CleanOutElts
	category: "Visiolab"
	buttonText: "CleanOutElts"
	toolTip:"Clean Output Render Elements"
	(
		re = maxOps.GetCurRenderElementMgr ()
		num = re.numrenderelements ()
		for i = 0 to (num - 1) do re.SetRenderElementFilename i ""
	)
	
	macroscript cellsCreator
	category: "Visiolab"
	buttonText: "cellsCreator"
	toolTip:""
	(
-- 		filein cellsCreatorPath
		filein ((getroot()) +  cellsCreatorPath)
	)
	
	macroscript verticalCam
	category: "Visiolab"
	buttonText: "vertical Cam"
	toolTip:""
	(
-- 		filein cellsCreatorPath
		local cam = getActiveCamera()
		if cam != undefined then
		(
			if classof cam == physical then
			(
				cam.auto_vertical_tilt_correction = on
				cam.auto_vertical_tilt_correction = off
			)
			else if iskindof cam VRayPhysicalCamera then
			(
				cam.lens_tilt_auto = on
				redrawviews()
				cam.lens_tilt_auto = off
			)
			else()
		)
		else()
	)
	
	
	macroscript matIdManager
	category: "Visiolab"
	buttonText: "matIdManager"
	toolTip:""
	(
-- 		filein cellsCreatorPath
		filein ((getroot()) +  matIdManagerPath)
	)

)