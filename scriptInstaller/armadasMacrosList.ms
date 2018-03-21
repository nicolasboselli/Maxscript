oneCat = "ArmadasScripts"


-- install macroscript for explorer with relative path from ini file
macroScript ArmadasScriptExplorer
	category: oneCat
	buttonText: "MSXexplorer"
	toolTip:""
	icon: #("armadasScriptsExplorer",1)
(
	local root = getroot()
	filein (root +"\\" + "scriptsManager" + "\\" + "scriptsExplorer.ms" )
)

-- install macroscript for launcher with relative path from ini file
macroScript ArmadasScriptLauncher
	category: oneCat
	buttonText: "MSXlauncher"
	toolTip:""
	icon: #("armadasScriptsFavorites",1)
(
	local root = getroot()	
	filein (root +"\\" + "scriptsManager" + "\\" + "launcher.ms" )
)

-- install macroscript for asset opener with relative path from ini file
macroScript ArmadasScriptAssetOpener
	category: oneCat
	buttonText: "assetOpener"
	toolTip:""
	icon: #("armadasScriptsAssetOpener",1)
(
	local root = getroot()
	filein (root +"\\" + "assetManager" + "\\" + "assetOpenerUI_v5.ms" )
)

macroScript ArmadasScriptModelingUtilities
	category: oneCat
	buttonText: "modelingUtilities"
	toolTip:""
	icon: #("ArmadasScriptModelingUtilities",1)
(
	local root = getroot()
	filein (root +"\\" + "zz_mode_archi" + "\\" + "misc.ms" )
)
-- "C:/repo_github/DEV_maxscript/00_wip/zz_mode_archi/misc.ms"

macroScript ArmadasScriptMaterialsUtilities
	category: oneCat
	buttonText: "materialsUtilities"
	toolTip:""
	icon: #("ArmadasScriptMaterialsUtilities",1)
(
	local root = getroot()
	filein (root +"\\" + "rendering" + "\\" + "Vray_Script" + "\\" + "deMultiMat.ms" )
)
-- "C:/repo_github/DEV_maxscript/00_wip/rendering/Vray_Script/deMultiMat.ms"

macroScript ArmadasScriptLastParent
	category: oneCat
	buttonText: "lastParent"
	toolTip:""
-- 	icon: #("ArmadasScriptMaterialsUtilities",1)
(
	on execute do
	(
		local sel = selection as array
		if sel.count >= 2 then 	lastParent sel else()
	)
)

macroScript ArmadasScriptCustomIsolate
	category: oneCat
	buttonText: "customIsolate"
	toolTip:"isolate selection without focus on"
-- 	icon: #("ArmadasScriptMaterialsUtilities",1)
(
	local isIsolate = false
	local isolatedList = #()
	
	on execute do
	(
		undo on
		(
			if not isIsolate then
			(
				for s in $* do
				(
					if not s.ishidden and not s.isselected then
					(
						s.ishidden = true
						append isolatedList s
					)
				)
				isIsolate = true
				format "isolation done\n"
			)
			else if isIsolate then
			(
				for i=isolatedList.count to 1 by - 1 do
				(
					if isvalidnode isolatedList[i] then 
					(
						isolatedList[i].ishidden = false
						deleteitem isolatedList i
					)
				)
				isIsolate = false
				format "isolation end\n"
			)
			else()
			redrawviews ()
		)
	)
	
	on ischecked return isIsolate
)

