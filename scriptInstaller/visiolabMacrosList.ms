-- oneCat = "VisioLab"

	pickAndMergePath = "PICKNMERGE/001/pickandmerge.ms"
	objReplacerPath = "objReplacer/000/obj_replacer.ms"

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
			o.faceType = 1
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
	-- 	icon: #("pickandmergeicon16",1)
	(
	-- 	local root = getroot()
	-- 	filein (@"N:\Ressources_Nico\github\00_wip\Maxscript\objReplacer\pickandmerge.ms")
		filein ((getroot()) +  "scriptInstaller/visiolabScriptInstall.ms")
	)


	macroscript bridgeShortcut
	category: "VisioLab"
	buttonText: "Brigde"
	toolTip:"bridge"
	(
		if classof $ == editable_poly then $.editablepoly.bridge()
	)