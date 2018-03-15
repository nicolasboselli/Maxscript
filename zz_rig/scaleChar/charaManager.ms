
--  getThisScriptFilename() 
charaAttDef = attributes charAtt
(
	parameters charParam 
	(
		charNodes type:#nodetab tabSizeVariable:true 
	)
)

rollout charManagerRlt "character manager"
(
	local charAr = #()
	
	fn scanSceneFN =
	(
		charAr = #()
		for o in ($* as array) do
		(
			try( 
				
				o.charnodes
				append  charAr o
				charAr = makeuniqueArray charAr
				)
			catch()
		)
		return charAr
	)
	
	listbox charListLB "Characters:" 
	editText charNameET "Name:"
	button editBT "edit" across:3
	button newBT "New"
	button delBT "Del"
	
	on charManagerRlt open do
	(
		scanSceneFN ()
		try
		(
		charListLB.items = for o in charAr collect o.name
		charNameET.text = charAr[1].name
		)catch(print "rien dans la scene")
	)
	
	on charNameET entered newName do
	(
		charAr[charListLB.selection].name = newName
		charListLB.items = for o in charAr collect o.name
	)
	
	on charListLB selected elt do
	(
		try
		(
			charNameET.text = charAr[elt].name
		)catch()
	)
	
	on editBT pressed do
	(
		global sGlob = charAr[charListLB.selection]
		print sGlob
		rollout1 =  execute( openfile ( (getDir #scripts) + "\zz_rig\scaleChar\CharaList.ms"))
-- 		createdialog charNodesRLT width: 400
		newWindows = newRolloutFloater ("Character Explorer: " + charAr[charListLB.selection].name)  400 800
		addRollout  rollout1 newWindows
		destroydialog charManagerRlt
	)
	
	on newBT pressed do
	(
		ctrChar = point name: (uniquename "ctrChar") box: true cross: true axistripod: false size: (units.decodeValue "8cm") wirecolor: yellow 
		custAttributes.add ctrChar charaAttDef
		append charAr ctrChar
		charListLB.items = for o in charAr collect o.name
	)
	
	
	on delBT pressed do
	(
		try
		(
-- 			deleteitem charAr charListLB.selection
			delete charAr[charListLB.selection]
			scanSceneFN ()
			charListLB.items = for o in charAr collect o.name
			charNameET.text = charAr[charListLB.selection].name
			if charListLB.selection == 0 then charNameET.text = ""
		)catch(print "test")
	)	
	
)

createdialog charManagerRlt