-- oneCat = "VisioLab"
(
	global pickAndMergePath = "PICKNMERGE/001/pickandmerge.ms"
	global objReplacerPath = "objReplacer/002/obj_replacer.ms"
-- 	global cellsCreatorPath = @"M:\Interieur\Cellules\Modelisation\cellsCreator.ms"
	global cellsCreatorPath = "cellsCreator/004/cellsCreator.ms"
	
	macroScript PickAndMerge
	category: "VisioLab"
	buttonText: "PickAndMerge"
	toolTip:""
	icon: #("pickandmergeicon",1)
	(
	-- 	local root = getroot()
	-- 	filein (@"N:\Ressources_Nico\github\00_wip\Maxscript\objReplacer\pickandmerge.ms")
	-- 	filein ((getroot()) +  "objReplacer\pickandmerge.ms")
		filein ((getroot()) +  pickAndMergePath)
	)

	macroScript objectReplacer
	category: "VisioLab"
	buttonText: "Obj Replacer"
	toolTip:""
	-- 	icon: #("pickandmergeicon16",1)
	(
	-- 	local root = getroot()
	-- 	filein (@"N:\Ressources_Nico\github\00_wip\Maxscript\objReplacer\pickandmerge.ms")
		filein ((getroot()) +  objReplacerPath)
	)

	macroScript collapseRailClone
	category: "VisioLab"
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
	category: "VisioLab"
	buttonText: "Reload"
	toolTip:"Reload Visiolab Script"
	(
		local armadasScriptsIni = (GetDir #maxData) + "armadasScriptsIni.ini"
		local root = getINISetting armadasScriptsIni "armadasScripts" "armadasScriptsRoot"
		filein ((getroot()) +  "scriptInstaller/armadasScriptInstall.ms")
	)


	macroscript bridgeShortcut
	category: "VisioLab"
	buttonText: "Brigde"
	toolTip:"bridge"
	(
		if classof $ == editable_poly then $.editablepoly.bridge()
	)
	
	macroscript CleanOutElts
	category: "VisioLab"
	buttonText: "CleanOutElts"
	toolTip:"Clean Output Render Elements"
	(
		re = maxOps.GetCurRenderElementMgr ()
		num = re.numrenderelements ()
		for i = 0 to (num - 1) do re.SetRenderElementFilename i ""
	)
	
	macroscript cellsCreator
	category: "VisioLab"
	buttonText: "cellsCreator"
	toolTip:""
	(
-- 		filein cellsCreatorPath
		filein ((getroot()) +  cellsCreatorPath)
	)
	
	macroscript verticalCam
	category: "VisioLab"
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
			else()
		)
		else()
	)

)