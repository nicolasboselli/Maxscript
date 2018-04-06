-- oneCat = "VisioLab"

	pickAndMergePath = "PICKNMERGE/001/pickandmerge.ms"
	objReplacerPath = "objReplacer/obj_replacer_v2.ms"

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


