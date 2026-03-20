-- oneCat = "VisioLab"
(
	global ArmadasScriptLauncherPath = @"\scriptsLauncher\002\launcher.ms"
	global ArmadasScriptLauncherPath2 = @"\scriptsLauncher\002\launcher.ms"
	global ArmadasScriptModelingUtilitiesPath = @"\MODELING_TOOLS\001\modeling_tools.ms"
	global ArmadasScriptMaterialsUtilitiesPath = @"\MATERIALS_TOOLS\002\deMultiMat.ms"
	
-- 	global pickAndMergePath = @"PICKNMERGE/001/pickandmerge.ms"
	global objReplacerPath = @"objReplacer/002/obj_replacer.ms"
	global cellsCreatorPath = @"cellsCreator/005/cellsCreator.ms"
	
	global matIdManagerPath = @"MatIDManager/007/matIdManager.ms"
	global renderIdManagerPath = @"MatIDManager/011/matIdManager.ms"
	global renderIdManagerPath10 = @"MatIDManager/012/matIdManager.ms"
	
	global clientsImageSizePath =  @"visiolab/render_output/000/render_output.ms"
	global layersToolsPath =  @"LAYERS_TOOLS/000/layers_tools.ms"
	global pdvToolsPath =  @"PDV_TOOLS/004/pdv_tools_float.ms"
	global windowsToolsPath = @"WINDOWS_TOOL/005/windows_tools_float.ms"
	-- global cleanMultiMatPath = @"MATERIALS_TOOLS/002/cleanMultimaterials.ms"
	global cleanMultiMatPath = @"CLEAN_ARCHVIZ_FILE/000/cleanMultiMaterials.ms"
	
-- 	global boxArchiPath = @"BOXERIZE_archi/001/boxerize_archi.ms"
	global objIDToolPath = @"MATERIALS_TOOLS/objectIDTool.ms"
	global ralValToolPath = @"MATERIALS_TOOLS/Load_ral.ms"
	global fixForestIvyMapsPath = @"visiolab/fixForestIvyMaps.ms"
	global gridManagerPath = @"GRID_MANAGER/000/grid_manager.ms"
	
	global plansManagerToolPath = @"plansManagement/000/plansManagementTool.ms"
	
	global resetUIToolPath = @"sceneManagement/reset_UI_pos.ms"


	macroScript ScriptLauncher
	category: "Visiolab"
	buttonText: "MSXlauncher"
	toolTip:""
	icon: #("armadasScriptsFavorites",1)
	(
		filein ((getroot()) + ArmadasScriptLauncherPath)
-- 		filein ((getroot()) +  "\scriptsLauncher\001\launcher.ms")
	)
	
	macroScript ScriptLauncher2
	category: "Visiolab"
	buttonText: "MSXlauncher"
	toolTip:""
	icon: #("armadasScriptsFavorites",1)
	(
		filein ((getroot()) + ArmadasScriptLauncherPath2)
-- 		filein ((getroot()) +  "\scriptsLauncher\001\launcher.ms")
	)
		
	macroScript ModelingUtilities
	category: "Visiolab"
	buttonText: "Modeling Tools"
	toolTip:""
	icon: #("ArmadasScriptModelingUtilities",1)
	(
		filein ((getroot()) + ArmadasScriptModelingUtilitiesPath)
	)


	macroScript MaterialsUtilities
	category: "Visiolab"
	buttonText: "Materials Tools"
	toolTip:""
	icon: #("ArmadasScriptMaterialsUtilities",1)
	(
		filein ((getroot()) + ArmadasScriptMaterialsUtilitiesPath )
	)
	
	macroScript LayersTools
	category: "Visiolab"
	buttonText: "layersTools"
	toolTip:""
	icon: #("layersTools",1)
	(
		filein ((getroot()) + layersToolsPath )
	)
	
	macroScript PDVTools
	category: "Visiolab"
	buttonText: "pdvTools"
	toolTip:""
	icon: #("pdvTools",1)
	(
		filein ((getroot()) + pdvToolsPath )
	)
	
	
	macroScript clientsImageSize
	category: "Visiolab"
	buttonText: "clientsImageSize"
	toolTip:""
	icon: #("clientsImageSize",1)
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
/* 	
	macroScript PickAndMerge
	category: "Visiolab"
	buttonText: "PickAndMerge"
	toolTip:""
	icon: #("pickandmergeicon",1)
	(
		filein ((getroot()) +  pickAndMergePath)
	) */

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
-- 			o.weld = off
-- 			o.weldth = 0

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
	buttonText: "matIdManager v.8 beta"
	toolTip:""
	icon: #("matIdManager",1)
	(
-- 		filein cellsCreatorPath
		filein ((getroot()) +  matIdManagerPath)
	)
	
	macroscript renderIdManager
	category: "Visiolab"
	buttonText: "renderIdManager"
	toolTip:""
	icon: #("renderIdManager",1)
	(
-- 		filein cellsCreatorPath
		filein ((getroot()) +  renderIdManagerPath)
	)
	
	macroscript renderIdManager10
	category: "Visiolab"
	buttonText: "renderIdManager"
	toolTip:""
	icon: #("renderIdManager10",1)
	(
-- 		filein cellsCreatorPath
		filein ((getroot()) +  renderIdManagerPath10)
	)

	
	
	macroscript windowsTools
	category: "Visiolab"
	buttonText: "WindowsTools"
	toolTip:""
	icon: #("windowsTools",1)
	(
-- 		filein cellsCreatorPath
		filein ((getroot()) +  windowsToolsPath)
	)
	
	macroscript cleanMultiMatTool
	category: "Visiolab"
	buttonText: "CleanMultiMatTool"
	toolTip:""
	icon: #("cleanMultiMatTool",1)
	(
-- 		filein cellsCreatorPath
		filein ((getroot()) +  cleanMultiMatPath)
	)
	
	macroscript  objIDTool
	category: "Visiolab"
	buttonText: "objectIDTool"
	toolTip:""
	icon: #("objIDTool",1)
	(
		filein ((getroot()) +  objIDToolPath)
	)
	
	
	macroscript  ralValTool
	category: "Visiolab"
	buttonText: "ralValTool"
	toolTip:""
	icon: #("ralValTool",1)
	(
		filein ((getroot()) +  ralValToolPath)
	)
	
	macroscript fixForestIvy
	category: "Visiolab"
	buttonText: "Fix ForestIvy Maps"
	toolTip:"Fix ForestIvy Maps"
	icon: #("fixForestIvy",1)
	(
		filein ((getroot()) + fixForestIvyMapsPath)
	)
	
	macroscript displayTextureOn
	category: "Visiolab"
	buttonText: "Display Texture On"
	toolTip:""
	icon: #("displayTextureOn",1)
	(
		--- agit sur la visibilité des material avec showTextureMap
		sel = selection as Array
		for s in sel do
		(
			matAr = getClassInstances vraymtl  target: s
			for vr in matAr do showTextureMap vr true
				
			v2sAr = getClassInstances VRay2SidedMtl  target: s
			format "v2sAr: %\n" v2sAr
			for v2s in v2sAr do showTextureMap v2s v2s.frontMtl.texmap_diffuse  true
		)
	)
	
		
	macroscript displayTextureOff
	category: "Visiolab"
	buttonText: "Display Texture Off"
	toolTip:""
	icon: #("displayTextureOff",1)
	(
		--- agit sur la visibilité des material avec showTextureMap
		sel = selection as Array
		for s in sel do
		(
			matAr = getClassInstances vraymtl  target: s
			for vr in matAr do showTextureMap vr false
				
			v2sAr = getClassInstances VRay2SidedMtl  target: s
			format "v2sAr: %\n" v2sAr
			for v2s in v2sAr do showTextureMap v2s v2s.frontMtl.texmap_diffuse  false
		)
	)
	
	macroscript UV200
	category: "Visiolab"
	buttonText: "UV 200"
	toolTip:""
-- 	icon: #("displayTextureOff",1)
	(
		local sel = selection as array
		local uvwMissingAr = #()
		
		-- 
		for s in sel do
		(
			try
			(
				-- traite les objets avec modifiers
				s.uvwmap.maptype = 4
				s.uvwmap.length = sizeSp.value
				s.uvwmap.width = sizeSp.value
				s.uvwmap.height = sizeSp.value
			)
			catch
			(
				-- collecte les objets sans modifiers 
				append uvwMissingAr s
			)
		)
		
		format "uvwMissingAr : %\n" uvwMissingAr
		-- traite les objets sans modifiers
		if uvwMissingAr.count > 0 then
		(
			local UvwSquare = Uvwmap  maptype: 4 length: 200 width: 200  height: 200  -- axis: axis
			select uvwMissingAr 
			modPanel.addModToSelection UvwSquare ui:on
			select sel
		)
	)
	
/* 	macroScript BoxerizeArchi
	category: "Visiolab"
	buttonText: "BoxerizeArchi"
	toolTip:""poiso
	icon: #("boxArchi",1)
	(
		filein ((getroot()) + boxArchiPath)
-- 		filein ((getroot()) +  "\scriptsLauncher\001\launcher.ms")
	) */
	
	macroScript BGgradient
	category:"Visiolab"
	buttonText: "BG Grey"
	toolTip:""
	(
		actionMan.executeAction 0 "617"
	)
	
	macroScript gridManager
	category:"Visiolab"
	buttonText: "Grid Manager"
	toolTip:""
	icon: #("GridManager",1)
	(
		filein ((getroot()) +  gridManagerPath)
	)

	
	macroScript planManager
	category:"Visiolab"
	buttonText: "Plans Manager"
	toolTip:""
	icon: #("PlansManagement",1)
	(
		filein ((getroot()) +  plansManagerToolPath)
	)
		
	macroScript ResetUI
	category:"Visiolab"
	buttonText: "Reset UI"
	toolTip:""
-- 	icon: #("PlansManagement",1)
	(
		filein ((getroot()) +  resetUIToolPath)
/*		-- reset rollout pos
		try(sliceFloater.pos = [0,0])catch()
		try(theNewMaterialToolFloater.pos = [0,0])catch()
		try(modToolRF.pos = [0,0])catch()
		try(matIdExplorerRF.pos = [0,0])catch()

		-- reset dialog box pos
		try(setDialogPos scriptExplorerRLT [0,0])catch()
		try(setDialogPos createPlaneRLT [0,0])catch()
		try(setDialogPos boxerizeRLT  [0,0])catch()
		try(setDialogPos mxsLaunchRLT [0,0])catch()
		try(setDialogPos transferChildrenRLT [0,0])catch()
		try(setDialogPos Pt2vue_renderer_UI [0,0])catch()
		try(setDialogPos pdv_cam_RLT [0,0])catch()
		try(setDialogPos clientRenderOutputRLT [0,0])catch()
		try(setDialogPos objReplacerRLT [0,0])catch()
		try(setDialogPos transferChildrenRLT [0,0])catch()
		try(setDialogPos edgeToShapeOnModRLT [0,0])catch()
		try(setDialogPos layersToolsRLT [0,0])catch()
		try(setDialogPos opaRLT [0,0])catch()
		try(setDialogPos gouttiereRLT [0,0])catch()
		try(setDialogPos gridRLT [0,0])catch()
		try(setDialogPos VrayRenderRLT [0,0])catch()*/

	)
	
	
	

)