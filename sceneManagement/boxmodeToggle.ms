

-- boxmodeToggle ()

macroScript BoxmodeToggle
	category:"ArmadasScripts"
	buttonText: "boxmodeToggle"
	toolTip:""
-- 	icon: #("ArmadasScriptMaterialsUtilities",1)
(
	for s in selection do s.boxmode = not s.boxmode
)

-- boxmodeToggle()