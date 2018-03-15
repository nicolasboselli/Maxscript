-- copy modifier and keep it
fn copyMod obj = 
(
-- 	modList = obj.modifiers
	modList = for o in obj.modifiers collect ( copy o)
	return modList
)



-- paste modifier

fn pasteMod obj modList= 
(
	for i = modList.count  to 1 by -1 do
	(
		addmodifier obj modList[i]
	)
)



-- modsList = copyMod $

-- for m in modsList do print m
-- pasteMod $ modsList
	-- erase or not existing modifier on paste

rollout copyPasteModifiersRLT "copy paste modifiers utilities"
(
-- 	vars
	local oneModList = #()
-- 	UI
	checkbutton copyModsCB "Copy Modifiers"
	button addModsBT "Add Modifiers"
	
-- UI relative function
	fn copyMods state =
	(
		sel = selection as array
		
-- 		check selection
		if state == true then
		(
-- 			if sel.count != 1 do return 
			for s in sel do oneModList = copyMod s
		)
		
		else if state == false then oneModList = #()

		else print "bof"
	)
	
	fn pasteMods =
	(
		sel = selection as array
-- 		if sel.count != 1 do return
-- 		if modList.count<1 do return
		
		print "start paste"
		print oneModList
		for s in sel do
		(
			pasteMod s oneModList
		)
		print "paste done"
	)
	
	fn refreshUI =
	(
		if copyModsCB.state == true then
		(
			addModsBT.enabled = true
		)
		else if copyModsCB.state == false then
		(
			addModsBT.enabled = false
		)
	)
	
-- 	actions
	on copyModsCB changed theState do
	(
		copyMods theState
		refreshUI()
	)
	
	on addModsBT pressed do
	(
		pasteMods()
	)

	
	
	
)

createdialog copyPasteModifiersRLT width: 400