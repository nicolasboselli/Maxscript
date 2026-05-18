/*
	RailClone Placer
	Version: 0.2.0
	- Keeps a persistent editable list of RailClone .max files.
	- Merges the selected file.
	- Finds the single RailClone object merged from that file.
	- Assigns selected splines/shapes to the RailClone base spline input.

	Preference file:
	(GetDir #maxData) + "NicoScriptTools\\RAICLONE_PLACER\\railclone_placer.ini"
*/

global RCPLACER_floater
global RCPLACER_VERSION = "0.2.0"

struct RCPlacerItem
(
	name = "",
	file = ""
)

struct RCPlacerTool
(
	prefsDir = ((GetDir #maxData) + "NicoScriptTools\\RAICLONE_PLACER\\"),
	legacyPrefsDir = ((GetDir #maxData) + "VisiolabTools\\RAICLONE_PLACER\\"),
	prefsFile = "",
	legacyPrefsFile = "",
	items = #(),
	lastBrowseDir = "",
	deleteSplineModifiers = false,

	fn cleanPath p =
	(
		if p == undefined then "" else pathConfig.normalizePath p
	),

	fn getDisplayNames =
	(
		for item in items collect
		(
			local suffix = if (doesFileExist item.file) then "" else "  [missing]"
			item.name + suffix
		)
	),

	fn makeItemFromFile filePath =
	(
		local cleanFile = cleanPath filePath
		local itemName = getFilenameFile cleanFile
		RCPlacerItem name:itemName file:cleanFile
	),

	fn loadItems =
	(
		items = #()
		lastBrowseDir = getINISetting prefsFile "settings" "lastBrowseDir"
		deleteSplineModifiers = ((getINISetting prefsFile "settings" "deleteSplineModifiers") == "true")

		local itemCountStr = getINISetting prefsFile "items" "count"
		local itemCount = itemCountStr as integer
		if itemCount == undefined do itemCount = 0

		for i = 1 to itemCount do
		(
			local nameKey = "name" + (i as string)
			local fileKey = "file" + (i as string)
			local itemName = getINISetting prefsFile "items" nameKey
			local itemFile = getINISetting prefsFile "items" fileKey

			if itemFile.count > 0 do
			(
				if itemName.count == 0 do itemName = getFilenameFile itemFile
				append items (RCPlacerItem name:itemName file:(cleanPath itemFile))
			)
		)
	),

	fn saveItems =
	(
		if (doesFileExist prefsDir) == false do makeDir prefsDir all:true

		setINISetting prefsFile "settings" "lastBrowseDir" lastBrowseDir
		setINISetting prefsFile "settings" "deleteSplineModifiers" (deleteSplineModifiers as string)
		setINISetting prefsFile "items" "count" (items.count as string)

		for i = 1 to items.count do
		(
			setINISetting prefsFile "items" ("name" + (i as string)) items[i].name
			setINISetting prefsFile "items" ("file" + (i as string)) items[i].file
		)
	),

	fn init =
	(
		prefsFile = prefsDir + "railclone_placer.ini"
		legacyPrefsFile = legacyPrefsDir + "railclone_placer.ini"
		if (doesFileExist prefsDir) == false do makeDir prefsDir all:true
		if (doesFileExist prefsFile) == false and (doesFileExist legacyPrefsFile) == true do copyFile legacyPrefsFile prefsFile
		loadItems()
	),

	fn addFile filePath =
	(
		local cleanFile = cleanPath filePath
		if cleanFile.count == 0 then false
		else if (toLower (getFilenameType cleanFile)) != ".max" then false
		else
		(
			local exists = false
			for item in items where (toLower item.file) == (toLower cleanFile) do exists = true

			if exists == false do
			(
				append items (makeItemFromFile cleanFile)
				lastBrowseDir = getFilenamePath cleanFile
				saveItems()
			)
			true
		)
	),

	fn removeIndex index =
	(
		if index >= 1 and index <= items.count do
		(
			deleteItem items index
			saveItems()
		)
	),

	fn moveIndex index offset =
	(
		local target = index + offset
		if index >= 1 and index <= items.count and target >= 1 and target <= items.count do
		(
			local item = items[index]
			deleteItem items index
			insertItem item items target
			saveItems()
			target
		)
	),

	fn renameIndex index newName =
	(
		if index >= 1 and index <= items.count and newName.count > 0 do
		(
			items[index].name = newName
			saveItems()
		)
	),

	fn isSplineNode obj =
	(
		if obj == undefined then false
		else
		(
			local result = false
			try(result = (superclassof obj.baseObject == Shape))catch()

			if result == false do
			(
				result = ((superClassOf obj == Shape) or (isKindOf obj SplineShape) or (isKindOf obj Line))
			)
			result
		)
	),

	fn getSelectedSplines =
	(
		for obj in (selection as array) where isSplineNode obj collect obj
	),

	fn isRailCloneNode obj =
	(
		if obj == undefined then false
		else
		(
			local result = false
			try(result = (classof obj.baseObject == RailClone_Pro))catch()

			if result == false do
			(
				local classText = toLower ((classOf obj) as string)
				result = ((findString classText "railclone") != undefined)
			)
			result
		)
	),

	fn getSceneRailClones =
	(
		for obj in objects where isRailCloneNode obj collect obj
	),

	fn getSelectedRailClones =
	(
		for obj in (selection as array) where isRailCloneNode obj collect obj
	),

	fn getRailCloneSpline rc =
	(
		local spline = undefined
		try(spline = rc.banode[1])catch()
		if spline != undefined and isSplineNode spline then spline else undefined
	),

	fn getMergedRailClones filePath =
	(
		local beforeRC = getSceneRailClones()
		local beforeHandles = for obj in beforeRC collect obj.inode.handle

		local ok = mergeMAXFile filePath #select #useSceneMtlDups #mergeDups quiet:true
		if ok != true then #()
		else
		(
			local mergedRC = #()
			for obj in getSceneRailClones() do
			(
				if (findItem beforeHandles obj.inode.handle) == 0 do append mergedRC obj
			)
			mergedRC
		)
	),

	fn callIfMethodExists rc methodName args =
	(
		local success = false
		try
		(
			if isProperty rc methodName do
			(
				local fnRef = getProperty rc methodName
				case args.count of
				(
					0: fnRef()
					1: fnRef args[1]
					2: fnRef args[1] args[2]
					3: fnRef args[1] args[2] args[3]
				)
				success = true
			)
		)
		catch
		(
			format "RCPLACER method % failed: %\n" methodName (getCurrentException())
		)
		success
	),

	fn getRailCloneInterface rc =
	(
		local iface = undefined
		try
		(
			if isProperty rc #railclone do iface = rc.railclone
		)
		catch
		(
			format "RCPLACER could not access %.railclone interface: %\n" rc.name (getCurrentException())
		)
		if iface == undefined then rc else iface
	),

	fn setFirstCompatibleProperty target spline =
	(
		local propNames = getPropNames target
		local candidates = #(#spline, #Spline, #path, #Path, #baseObject, #BaseObject, #baseSpline, #BaseSpline, #splineObject, #SplineObject, #pathObject, #PathObject)
		local success = false

		for propName in candidates while success == false do
		(
			if (findItem propNames propName) > 0 do
			(
				try
				(
					setProperty target propName spline
					success = true
					format "RCPLACER assigned % to property %\n" spline.name propName
				)
				catch
				(
					format "RCPLACER property % failed: %\n" propName (getCurrentException())
				)
			)
		)
		success
	),

	fn removeSplineModifiers spline =
	(
		try
		(
			local modCount = spline.modifiers.count
			for i = 1 to modCount do deletemodifier spline 1
			format "RCPLACER removed % modifiers from %\n" modCount spline.name
			true
		)
		catch
		(
			format "RCPLACER could not remove modifiers from %: %\n" spline.name (getCurrentException())
			false
		)
	),

	fn assignSplineToRailClone rc spline deleteModifiers:false =
	(
		local success = false

		try
		(
			if classof rc.baseObject == RailClone_Pro and superclassof spline.baseObject == Shape do
			(
				if deleteModifiers == true do
				(
					local modCount = spline.modifiers.count
					for i = 1 to modCount do deletemodifier spline 1
					format "RCPLACER deleted % modifiers from % before assign\n" modCount spline.name
				)

				rc.banode[1] = spline
				rc.transform = copy spline.transform
				rc.banode[1] = spline

				rc.disabled = on
				redrawViews()
				rc.disabled = off
				redrawViews()

				success = true
				format "RCPLACER assigned spline % to % with banode[1]\n" spline.name rc.name
			)
		)
		catch
		(
			format "RCPLACER banode[1] assignment failed for % / %: %\n" rc.name spline.name (getCurrentException())
		)

		if success == true do return true

		local iface = getRailCloneInterface rc

		-- iToo has changed exposed interfaces between versions. Try the common scripted entry points first.
		local methodAttempts = #(
			#(#setSpline, #(spline)),
			#(#SetSpline, #(spline)),
			#(#setPath, #(spline)),
			#(#SetPath, #(spline)),
			#(#setBaseObject, #(1, spline)),
			#(#SetBaseObject, #(1, spline)),
			#(#setBaseObject, #(spline)),
			#(#SetBaseObject, #(spline))
		)

		for attempt in methodAttempts while success == false do
		(
			success = callIfMethodExists rc attempt[1] attempt[2]
		)

		for attempt in methodAttempts while success == false do
		(
			success = callIfMethodExists iface attempt[1] attempt[2]
		)

		if success == false do success = setFirstCompatibleProperty rc spline
		if success == false and iface != rc do success = setFirstCompatibleProperty iface spline

		if success == false do
		(
			format "RCPLACER object properties for %: %\n" rc.name (getPropNames rc)
			if iface != rc do format "RCPLACER railclone interface properties for %: %\n" rc.name (getPropNames iface)
		)

		try rc.update() catch()
		try completeRedraw() catch()

		success
	),

	fn mergeAndAssign itemIndex splines =
	(
		if itemIndex < 1 or itemIndex > items.count then
		(
			messageBox "Choisis un RailClone dans la liste." title:"RailClone Placer"
			undefined
		)
		else if splines.count == 0 then
		(
			messageBox "Selectionne au moins une spline avant d'assigner." title:"RailClone Placer"
			undefined
		)
		else
		(
			local item = items[itemIndex]
			if (doesFileExist item.file) == false then
			(
				messageBox ("Fichier introuvable:\n" + item.file) title:"RailClone Placer"
				undefined
			)
			else
			(
				local created = #()
				for sp in splines do
				(
					if deleteSplineModifiers == true do removeSplineModifiers sp

					local mergedRC = getMergedRailClones item.file
					if mergedRC.count == 0 then
					(
						messageBox ("Aucun objet RailClone trouve apres merge:\n" + item.file) title:"RailClone Placer"
					)
					else if mergedRC.count > 1 then
					(
						messageBox ("Plusieurs RailClone trouves apres merge. Le script attend un seul RailClone par fichier:\n" + item.file) title:"RailClone Placer"
					)
					else
					(
						local rc = mergedRC[1]
						rc.name = uniqueName (item.name + "_")
						local assigned = assignSplineToRailClone rc sp deleteModifiers:deleteSplineModifiers
						if assigned == true then
						(
							append created rc
							format "RCPLACER merged % and assigned spline % to %\n" item.file sp.name rc.name
						)
						else
						(
							format "RCPLACER could not assign spline % to %. Inspect RailClone exposed properties.\n" sp.name rc.name
							messageBox ("RailClone merge, mais l'assignation MaxScript de la spline a echoue.\nRegarde le Listener pour les details:\n" + rc.name) title:"RailClone Placer"
						)
					)
				)
				if created.count > 0 do select created
				created
			)
		)
	),

	fn replaceSelectedRailClones itemIndex railClones =
	(
		if itemIndex < 1 or itemIndex > items.count then
		(
			messageBox "Choisis un RailClone dans la liste." title:"RailClone Placer"
			undefined
		)
		else if railClones.count == 0 then
		(
			messageBox "Selectionne au moins un RailClone a remplacer." title:"RailClone Placer"
			undefined
		)
		else
		(
			local item = items[itemIndex]
			if (doesFileExist item.file) == false then
			(
				messageBox ("Fichier introuvable:\n" + item.file) title:"RailClone Placer"
				undefined
			)
			else
			(
				local created = #()

				for oldRC in railClones where isValidNode oldRC do
				(
					local spline = getRailCloneSpline oldRC
					if spline == undefined then
					(
						format "RCPLACER could not find banode[1] spline on %\n" oldRC.name
						messageBox ("Impossible de trouver la spline banode[1] de:\n" + oldRC.name) title:"RailClone Placer"
					)
					else
					(
						if deleteSplineModifiers == true do removeSplineModifiers spline

						local oldName = oldRC.name
						local oldLayer = oldRC.layer
						local oldParent = oldRC.parent
						local mergedRC = getMergedRailClones item.file

						if mergedRC.count == 0 then
						(
							messageBox ("Aucun objet RailClone trouve apres merge:\n" + item.file) title:"RailClone Placer"
						)
						else if mergedRC.count > 1 then
						(
							messageBox ("Plusieurs RailClone trouves apres merge. Le script attend un seul RailClone par fichier:\n" + item.file) title:"RailClone Placer"
						)
						else
						(
							local newRC = mergedRC[1]
							local assigned = assignSplineToRailClone newRC spline deleteModifiers:deleteSplineModifiers

							if assigned == true then
							(
								try(oldLayer.addNode newRC)catch()
								newRC.parent = oldParent
								delete oldRC
								newRC.name = oldName
								append created newRC
								format "RCPLACER replaced RailClone % with %\n" oldName newRC.name
							)
							else
							(
								format "RCPLACER could not assign spline % to replacement RailClone %\n" spline.name newRC.name
								messageBox ("RailClone merge, mais l'assignation de la spline a echoue:\n" + newRC.name) title:"RailClone Placer"
							)
						)
					)
				)

				if created.count > 0 do select created
				created
			)
		)
	)
)

global RCPLACER_tool = RCPlacerTool()
RCPLACER_tool.init()

rollout RCPLACER_rollout "RailClone Placer" width:420 height:520
(
	local currentSelection = 0

	label lbVersion "RailClone Placer v0.2.0" align:#left

	group "RailClone files"
	(
		listbox lbRailClones "" height:12 width:390
		button btAdd "Add .max..." width:92 across:4
		button btRemove "Remove" width:92
		button btUp "Up" width:92
		button btDown "Down" width:92
		editText etName "Name:" width:390
		editText etFile "File:" readonly:true width:390
	)

	group "Selection"
	(
		label lbSplineCount "Selected splines: 0 | Selected RailClones: 0" align:#left
		checkbox cbDeleteModifiers "Delete spline modifiers before assign" checked:false
		button btRefreshSel "Refresh selection" width:130 across:2
		button btAssign "Merge + assign to selected splines" width:230
		button btReplace "Replace selected RailClones" width:230
	)

	group "Prefs"
	(
		editText etPrefs "List saved in:" readonly:true width:390
	)

	fn refreshDetails =
	(
		if currentSelection >= 1 and currentSelection <= RCPLACER_tool.items.count then
		(
			local item = RCPLACER_tool.items[currentSelection]
			etName.text = item.name
			etFile.text = item.file
		)
		else
		(
			etName.text = ""
			etFile.text = ""
		)
	)

	fn refreshList keepIndex:0 =
	(
		lbRailClones.items = RCPLACER_tool.getDisplayNames()

		if keepIndex == 0 do keepIndex = currentSelection
		if keepIndex < 1 and RCPLACER_tool.items.count > 0 do keepIndex = 1
		if keepIndex > RCPLACER_tool.items.count do keepIndex = RCPLACER_tool.items.count

		currentSelection = keepIndex
		if RCPLACER_tool.items.count > 0 then lbRailClones.selection = keepIndex else lbRailClones.selection = 0
		refreshDetails()
	)

	fn refreshSelectionLabel =
	(
		local splines = RCPLACER_tool.getSelectedSplines()
		local railClones = RCPLACER_tool.getSelectedRailClones()
		lbSplineCount.text = "Selected splines: " + (splines.count as string) + " | Selected RailClones: " + (railClones.count as string)
	)

	on RCPLACER_rollout open do
	(
		etPrefs.text = RCPLACER_tool.prefsFile
		cbDeleteModifiers.state = RCPLACER_tool.deleteSplineModifiers
		refreshList keepIndex:1
		refreshSelectionLabel()
	)

	on cbDeleteModifiers changed state do
	(
		RCPLACER_tool.deleteSplineModifiers = state
		RCPLACER_tool.saveItems()
	)

	on lbRailClones selected index do
	(
		currentSelection = index
		refreshDetails()
	)

	on etName entered txt do
	(
		RCPLACER_tool.renameIndex currentSelection txt
		refreshList keepIndex:currentSelection
	)

	on btAdd pressed do
	(
		local startDir = if RCPLACER_tool.lastBrowseDir.count > 0 then RCPLACER_tool.lastBrowseDir else maxFilePath
		local picked = getOpenFileName caption:"Add RailClone .max" filename:startDir types:"3ds Max (*.max)|*.max|All files (*.*)|*.*|"

		if picked != undefined do
		(
			if RCPLACER_tool.addFile picked then refreshList keepIndex:RCPLACER_tool.items.count
			else messageBox "Choisis un fichier .max valide." title:"RailClone Placer"
		)
	)

	on btRemove pressed do
	(
		RCPLACER_tool.removeIndex currentSelection
		refreshList keepIndex:currentSelection
	)

	on btUp pressed do
	(
		local newIndex = RCPLACER_tool.moveIndex currentSelection -1
		if newIndex != undefined do refreshList keepIndex:newIndex
	)

	on btDown pressed do
	(
		local newIndex = RCPLACER_tool.moveIndex currentSelection 1
		if newIndex != undefined do refreshList keepIndex:newIndex
	)

	on btRefreshSel pressed do refreshSelectionLabel()

	on btAssign pressed do
	(
		RCPLACER_tool.deleteSplineModifiers = cbDeleteModifiers.state
		RCPLACER_tool.saveItems()
		refreshSelectionLabel()
		local splines = RCPLACER_tool.getSelectedSplines()
		RCPLACER_tool.mergeAndAssign currentSelection splines
	)

	on btReplace pressed do
	(
		RCPLACER_tool.deleteSplineModifiers = cbDeleteModifiers.state
		RCPLACER_tool.saveItems()
		refreshSelectionLabel()
		local railClones = RCPLACER_tool.getSelectedRailClones()
		RCPLACER_tool.replaceSelectedRailClones currentSelection railClones
	)
)

try(closeRolloutFloater RCPLACER_floater)catch()
RCPLACER_floater = newRolloutFloater ("RailClone Placer v" + RCPLACER_VERSION) 440 560
addRollout RCPLACER_rollout RCPLACER_floater

