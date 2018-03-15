


rollout bonesSwapRLT "bones swap"
(
	local blankBone
	local bonesSourceAr = #()
	local bonesTargetAr = #()
	
	local srceSel = #()
	local tgtSel = #()
-- 	UI
	multilistbox sourceBonesLB "source bones :" height: 30 across: 2 
	multilistbox targetBonesLB "target bones :" height: 30
	
	group "source"
	(
		button scanSourceBT "scan source" across: 2
		button selSourceBT "select source"
	)
	
	group "target"
	(
		button addTargetBT "add bones" across: 5
		button removeBT "remove bones" enabled: true
		button upBT "^" enabled: true
		button dwBT "v" enabled: true
		button selTargetBT "select target" enabled: true
	)
	
	button swapBT "SWAP!" enabled: false
	
	on bonesSwapRLT open do
	(
		if getnodebyname "<blankBone>" == undefined then
		(
			blankBone = point name:"<blankBone>"
		) else (blankBone = getnodebyname "<blankBone>" )
	)
	
	on scanSourceBT pressed do
	(
		try
		(
			setCommandPanelTaskMode #modify
			modPanel.setCurrentObject $.skin
			print "youhou"
			bonesNum = skinOps.GetNumberBones $.skin
			print bonesnum
			bonesSourceArName = for i = 1 to bonesNum collect  (skinOps.GetBoneName $.skin i 0)
			print bonesSourceArName
			bonesSourceAr = for o in bonesSourceArName collect (getnodebyname o)
			print bonesSourceAr
			sourceBonesLB.items = for o in bonesSourceAr collect o.name
			print sourceBonesLB.items
				
			bonesTargetAr = for i = 1 to bonesNum collect blankBone
			targetBonesLB.items = for o in bonesTargetAr collect o.name
			
		)catch( print "error")
	)
	
	on selSourceBT pressed do
	(
		selAr = for o in srceSel collect bonesSourceAr[o]
		select selAr
	)
	
	on targetBonesLB selectionEnd do
	(
		tgtSel =  (targetBonesLB.selection as array)
		print (tgtSel as string)
		sourceBonesLB.selection = tgtSel as bitarray
	)
	
	on targetBonesLB doubleClicked elt do
	(
		select #(bonesSourceAr[elt],bonesTargetAr[elt]) 
	)
	
	on sourceBonesLB selectionEnd do
	(
		srceSel =  (sourceBonesLB.selection as array)
		print (srceSel as string)
		targetBonesLB.selection = srceSel as bitarray
	)
	
	on sourceBonesLB doubleClicked elt do
	(
		select #(bonesSourceAr[elt],bonesTargetAr[elt]) 
	)
	
	
	on addTargetBT pressed do
	(
		bonesTemp = $selection as array
		for i = 1 to bonesTemp.count do deleteitem bonesTargetAr tgtSel[1]
		for i = 1 to bonesTemp.count do insertitem bonesTemp[i] bonesTargetAr tgtSel[1]
		targetBonesLB.items = for o in bonesTargetAr collect o.name
		
	)
	
	on removeBT pressed do
	(
		for o in tgtSel do
		(
			deleteitem bonesTargetAr o
			insertitem blankBone bonesTargetAr o
			targetBonesLB.items = for o in bonesTargetAr collect o.name
		)
	)
	
	on upBT pressed do
	(
		try
		(
			for o in tgtSel do
			(
				
				bakBone = bonesTargetAr[o]
				print bakBone
				print (o - 1)
				insertitem bakBone bonesTargetAr (o - 1)
				deleteitem bonesTargetAr  (o + 1)
-- 				insertitem blankbone bonesTargetAr o
				
				targetBonesLB.items = for o in bonesTargetAr collect o.name
			)
			tgtSel = for o in tgtSel collect (o - 1)
			sourceBonesLB.selection = tgtSel as bitarray
			targetBonesLB.selection = tgtSel as bitarray
		)catch(print "limite")
	)
	
	on dwBT pressed do
	(
		try
		(
			for i = tgtSel.count to 1 by -1 do
			(
-- 				print bonesTargetAr[tgtSel[i]+ 1]
				bakBone = bonesTargetAr[tgtSel[i]+ 1]
				deleteitem bonesTargetAr (tgtSel[i]+1)
				insertitem bakBone bonesTargetAr (tgtSel[i])
				targetBonesLB.items = for o in bonesTargetAr collect o.name
			)
			tgtSel = for o in tgtSel collect (o + 1)
			sourceBonesLB.selection = tgtSel as bitarray
			targetBonesLB.selection = tgtSel as bitarray
			
		)catch(print "limite basse")
	)
	
	on selTargetBT pressed do
	(
		selAr = for o in tgtSel collect bonesTargetAr[o]
		select selAr
	)
	
	on swapBT pressed do
	(
		goodID = #()
		for i = 1 to bonesTargetAr.count do
		(
			if bonesTargetAr[i].name =! "<blankBone>" then append goodID i
		)
		
		for i = 1 to goodID.count do
		(
		skinOps.removebone $.skin goodID[i]
			
		skinOps.addbone $.skin bonesTargetAr[i]
		
		)
	)
	
	
)



createdialog  bonesSwapRLT width: 500
