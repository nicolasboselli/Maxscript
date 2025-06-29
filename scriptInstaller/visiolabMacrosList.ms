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
	global renderIdManagerPath = @"MatIDManager/009/matIdManager.ms"
	global renderIdManagerPath10 = @"MatIDManager/010/matIdManager.ms"
	
	global clientsImageSizePath =  @"visiolab/render_output/000/render_output.ms"
	global layersToolsPath =  @"LAYERS_TOOLS/000/layers_tools.ms"
	global pdvToolsPath =  @"PDV_TOOLS/004/pdv_tools_float.ms"
	global windowsToolsPath = @"WINDOWS_TOOL/005/windows_tools_float.ms"
	global cleanMultiMatPath = @"MATERIALS_TOOLS/001/cleanMultimaterials.ms"
-- 	global boxArchiPath = @"BOXERIZE_archi/001/boxerize_archi.ms"
	global objIDToolPath = @"MATERIALS_TOOLS/objectIDTool.ms"
	global ralValToolPath = @"MATERIALS_TOOLS/Load_ral.ms"
	global fixForestIvyMapsPath = @"visiolab/fixForestIvyMaps.ms"
	
	
	
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

)