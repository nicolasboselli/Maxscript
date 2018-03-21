oneCat = "VisioLab"

macroScript PickAndMerge
	category: oneCat
	buttonText: "PickAndMerge"
	toolTip:""
	icon: #("pickandmergeicon16",1)
(
-- 	local root = getroot()
-- 	filein (@"N:\Ressources_Nico\github\00_wip\Maxscript\objReplacer\pickandmerge.ms")
	filein ((getroot()) +  "objReplacer\pickandmerge.ms")
)

macroScript objectReplacer
	category: oneCat
	buttonText: "Obj Replacer"
	toolTip:""
-- 	icon: #("pickandmergeicon16",1)
(
-- 	local root = getroot()
-- 	filein (@"N:\Ressources_Nico\github\00_wip\Maxscript\objReplacer\pickandmerge.ms")
	filein ((getroot()) +  "objReplacer/obj_replacer_v2.ms")
)
