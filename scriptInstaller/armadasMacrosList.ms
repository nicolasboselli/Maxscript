-- oneCat = "ArmadasScripts"
(
	global ArmadasScriptLauncherPath = "\scriptsLauncher\001\launcher.ms"
	global ArmadasScriptModelingUtilitiesPath = "\MODELING_TOOLS\001\modeling_tools.ms"
	global ArmadasScriptMaterialsUtilitiesPath = "\MATERIALS_TOOLS\000\deMultiMat.ms"
	global ArmadasMatLibExplorerPath = "\MATLIB_EXPLORER\000\vrMatLib3.ms"
	global mxsHelpPath = #(@"C:\Users\Visiolab\Desktop\maxscript-2019-enu-help.chm",@"C:\Users\Visiolab\Desktop\maxscript-2017-help.chm", @"N:\Ressources Soft tutoriaux plugins\3D\maxscript_help\maxscript-2017-help.chm")

	-- install macroscript for explorer with relative path from ini file
	macroScript ArmadasScriptExplorer
		category: "ArmadasScripts"
		buttonText: "MSXexplorer"
		toolTip:""
		icon: #("armadasScriptsExplorer",1)
	(
		local root = getroot()
		filein (root +"\\" + "scriptsManager" + "\\" + "scriptsExplorer.ms" )
	)

	-- install macroscript for launcher with relative path from ini file
	macroScript ArmadasScriptLauncher
		category: "ArmadasScripts"
		buttonText: "MSXlauncher"
		toolTip:""
		icon: #("armadasScriptsFavorites",1)
	(
		filein ((getroot()) + ArmadasScriptLauncherPath)
-- 		filein ((getroot()) +  "\scriptsLauncher\001\launcher.ms")
	)

	-- install macroscript for asset opener with relative path from ini file
	macroScript ArmadasScriptAssetOpener
		category: "ArmadasScripts"
		buttonText: "assetOpener"
		toolTip:""
		icon: #("armadasScriptsAssetOpener",1)
	(
		local root = getroot()
		filein (root +"\\" + "assetManager" + "\\" + "assetOpenerUI_v5.ms" )
	)

	macroScript ArmadasScriptModelingUtilities
		category: "ArmadasScripts"
		buttonText: "modelingUtilities"
		toolTip:""
		icon: #("ArmadasScriptModelingUtilities",1)
	(
		filein ((getroot()) + ArmadasScriptModelingUtilitiesPath)
	)


	macroScript ArmadasScriptMaterialsUtilities
		category: "ArmadasScripts"
		buttonText: "materialsUtilities"
		toolTip:""
		icon: #("ArmadasScriptMaterialsUtilities",1)
	(
	-- 	local root = getroot()
		filein ((getroot()) + ArmadasScriptMaterialsUtilitiesPath )
-- 		filein ((getroot()) +"/rendering/Vray_Script/deMultiMat.ms" )
	)
	-- "C:/repo_github/DEV_maxscript/00_wip/rendering/Vray_Script/deMultiMat.ms"

	macroScript ArmadasScriptLastParent
		category: "ArmadasScripts"
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
		category: "ArmadasScripts"
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

	macroScript ArmadasReload
		category: "ArmadasScripts"
		buttonText: "Reload"
		toolTip:"Reload Armadas Script"
	-- 	icon: #("pickandmergeicon16",1)
	(
	-- 	local root = getroot()
	-- 	filein (@"N:\Ressources_Nico\github\00_wip\Maxscript\objReplacer\pickandmerge.ms")
		local armadasScriptsIni = (GetDir #maxData) + "armadasScriptsIni.ini"
		local root = getINISetting armadasScriptsIni "armadasScripts" "armadasScriptsRoot"
		filein (root +  "scriptInstaller/armadasScriptInstall.ms")
	)
	
	macroScript ArmadasMatLibExplorer
	category: "ArmadasScripts"
	buttonText: "Mat Lib"
-- 	toolTip:"Reload Armadas Script"
	-- 	icon: #("pickandmergeicon16",1)
	(
	-- 	local root = getroot()
	-- 	filein (@"N:\Ressources_Nico\github\00_wip\Maxscript\objReplacer\pickandmerge.ms")
-- 		local armadasScriptsIni = (GetDir #maxData) + "armadasScriptsIni.ini"
-- 		local root = getINISetting armadasScriptsIni "armadasScripts" "armadasScriptsRoot"
-- 		filein ((getroot()) +  "scriptInstaller/armadasScriptInstall.ms")
-- 		filein ((getroot()) +  "MATLIB_EXPLORER/000/vrMatLib3.ms")
		filein ((getroot()) +  ArmadasMatLibExplorerPath )
		
	)
	
	macroScript maxscriptHelp
	category:"ArmadasScripts"
	toolTip:""
	(
			for p in mxsHelpPath where doesfileexist p do
			(
				ShellLaunch  p ""
				exit
			)
	-- 		ShellLaunch  @"C:\Users\Visiolab\Desktop\3dsmax-2017-developer-help.chm" ""
	)

	
)

