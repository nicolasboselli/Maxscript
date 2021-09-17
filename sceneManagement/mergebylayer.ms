-- Merge By Layer v0.4 (2011.01.27/31) by Anubis (project3d.narod.ru)


if classOf roMergeByLayer == RolloutClass do DestroyDialog roMergeByLayer
rollout roMergeByLayer "Merge By Layer"
(
	local maxFile, LNames = #(), ONames = #()
	
	button btnOpenFile "Choose Scene File" width:110 pos:[13,5]
	button btnMergeLayers "Merge Layers" pos:[132,5]
	button btnMergeObjects "Merge Objects" pos:[212,5]
	MultiListBox LList "Layers:" height:20 across:2
	MultiListBox OList "Objects:" height:20
	
	on btnOpenFile pressed do
	(
-- 		maxFile = @"J:\github_repo\00_wip\Maxscript\sceneManagement\layer_test.max"
		maxFile = getMAXOpenFileName dir:"$scenes"
		if maxFile != undefined and isMaxFile maxFile do
		(
			roMergeByLayer.title = "Merge By Layer - " + (filenameFromPath maxFile)
			curFile = maxFilePath + maxFileName
			if curFile != "" then saveMaxFile curFile else holdMaxFile()
			LNames = #(); ONames = #()
			with redraw off (
				loadMaxFile maxFile quiet:on
				for i = 0 to LayerManager.count-1 do (
					layer = LayerManager.getLayer i
					layer.nodes &theNodes
					append LNames layer.name
					append ONames (for n in theNodes collect n.name)
				)
			)
			
			if curFile == "" then (
				resetMaxFile #noPrompt ; fetchMaxFile quiet:on
			) else loadMaxFile curFile quiet:on
		)
		LList.items = LNames
		if LNames.count > 0 do LList.selection = #{1}
		if ONames.count > 0 do OList.items = ONames[1]
	)
	on LList selectionEnd do
	(
		local list = #()
		for i in LList.selection where LList.selection[i] do join list ONames[i]
		OList.items = list -- update obj-list
	)
	on btnMergeLayers pressed do
	(
		if OList.items.count > 0 do
			mergeMAXFile maxFile OList.items #select #mergeDups #renameMtlDups #neverReparent quiet:true
	)
	on btnMergeObjects pressed do
	(
		selIdx = OList.selection
		if OList.selection.numberSet > 0 do (
			objList = for i in selIdx where selIdx[i] collect OList.items[i]
			mergeMAXFile maxFile objList #select #mergeDups #renameMtlDups #neverReparent quiet:true
		)
	)
	on roMergeByLayer resized Point2 do
	(
		local ro_size = GetDialogSize roMergeByLayer
		LList.width = OList.width = (ro_size[1]/2) - 13
		OList.pos = [(ro_size[1]/2),47]
		LList.height = OList.height = ro_size[2] - 54
		if roMergeByLayer.width < 310 do roMergeByLayer.width = 310
		if roMergeByLayer.height < 320 do roMergeByLayer.height = 320
	)
)
createDialog roMergeByLayer 310 320 \
style:#(#style_titlebar, #style_border, #style_sysmenu, #style_minimizebox, #style_maximizebox, #style_resizing)
--//eof