-- plus: remplacer la listbox par une multibox
-- plus: prevoir de réappliquer plusieurs fois le transfert de pose pour compenser le lien de parenté. calculer la boucle exacte

rollout1 = rollout poseTransfertRLT "transfert de poses"
(

	
	local refDataObj = undefined 
	local sourceArr = #()
	local targetArr = #()
	
-- 	functions
	-- 	admin listbox
		-- 	ajouter un abjet à la liste
		function addObjToListFN theListBox theArray =
		(
			for o in ($selection as array) do  append theArray o 
			theArray = makeUniqueArray theArray
			theListBox.items = for o in theArray collect o.name
			return theArray
		)
			
		-- 	supprimer un objet de la liste
		function delObjInListFN theListBox theArray =
		(
			deleteItem theArray theListBox.selection
			if theListBox.selection > theArray.count then  theListBox.selection = theArray.count
			theListBox.items = for o in theArray collect o.name
			return theArray
		)
			
		-- 	faire monter un objet dans la liste
		function upObjInListFN theListBox theArray  =
		(
			if theListBox.selection > 1 then
			(
			bakObj = theArray[theListBox.selection - 1 ] 
			theArray[theListBox.selection - 1 ] = theArray[theListBox.selection]
			theArray[theListBox.selection] = bakObj
			theListBox.items = for o in theArray collect o.name
			theListBox.selection = theListBox.selection - 1
			)
			return theArray
		)
		
		-- 	faire descendre un objet dans la liste
		function downObjInListFN theListBox theArray =
		(
			if theListBox.selection <  theArray.count then
			(
			bakObj = theArray[theListBox.selection + 1 ] 
			theArray[theListBox.selection + 1 ] = theArray[theListBox.selection]
			theArray[theListBox.selection] = bakObj
			theListBox.items = for o in theArray collect o.name
			theListBox.selection = theListBox.selection + 1
			)
			return theArray
		)

		
		-- 	nettoyer la liste
		function clearListFN theListBox theArray =
		(
			theArray = #()
			theListBox.items = for o in theArray collect o.name
			return theArray
		)
	-- admin mapping
		function saveMappingFN idMap =
		(
		)
		
		function loadMappingFN idMap =
		(
		)
		
		-- classer par nom
		fn sortByNameFN v1 v2 =
		(
			stricmp v1.name v2.name
		)
	
-- 	UI
	group "save mapping"
	( 
		button saveMap1BT "M1" across: 2
		button saveMap2BT "M2"
-- 		button saveMap3BT "M3"
	)
	
	group "load mapping"
	(
		button loadMap1BT "M1" across: 2
		button loadMap2BT "M2"
-- 		button loadMap3BT "M3"
	)
	
	
	group "mapping"
	(
		pickbutton chooseRefPB "selectionner la reference"
		listbox sourceSetLB "set des sources" across: 2 height: 30
		listbox targetSetLB "set de targets" height: 30
		edittext sourceNumET "Nombre de sources:" across: 2 readonly: true
		edittext targetNumET "Nombre de target:" readonly: true
		button sortSourceByNameBT "sort" across: 2
		button sortTargetByNameBT "sort" 
	)	
	
	group "sources commandes"
	(
		button addSourceBT "add" across: 7
		button delSourceBT "delete"
		button upSourceBT "up"
		button downSourceBT "down"
		button clearSourceBT "Clear"
		button selSourceInScBT "Select"
		button loadGhostAsSourceBT "load ghost"
	)
	
	group "target commandes"
	(
		button addTgtBT "add" across: 7
		button delTgtBT "delete"
		button upTgtBT "up"
		button downTgtBT "down"
		button clearTargetBT "Clear"
		button selTargetInScB "Select"
		button loadGhostAsTargetBT "Load Ghost"
	)
	
	button compareBT "compare"
	button TransPoseBT "Transfert de la Poses!" across: 2
	button TransPisteBT "Transfert des Pistes!"
	
-- 	events

	
	
	
		on saveMap1BT pressed do
	(
		global sourceArr1 = sourceArr
		global targetArr1 = targetArr
	)
	
	on loadMap1BT pressed do
	(
		sourceArr = execute "sourceArr1"
		targetArr = execute "targetArr1"
		
		sourceSetLB.items = for o in sourceArr collect o.name
		sourceNumET.text = sourceArr.count as string
		
		targetSetLB.items = for o in targetArr collect o.name
		targetNumET.text = targetArr.count as string
	)
	
		on saveMap2BT pressed do
	(
		global sourceArr2 = sourceArr
		global targetArr2 = targetArr
	)
	
	on loadMap2BT pressed do
	(
		sourceArr = execute "sourceArr2"
		targetArr = execute "targetArr2"
		
		sourceSetLB.items = for o in sourceArr collect o.name
		sourceNumET.text = sourceArr.count as string
		
		targetSetLB.items = for o in targetArr collect o.name
		targetNumET.text = targetArr.count as string
	)
	
	
	
	on poseTransfertRLT open do
	(
		sourceSetLB.items = for o in sourceArr collect o.name
		sourceNumET.text = sourceArr.count as string
		
		targetSetLB.items = for o in targetArr collect o.name
		targetNumET.text = targetArr.count as string
	)

	
	on chooseRefPB picked obj do
	(
		refDataObj =  obj
		chooseRefPB.text = refDataObj.name
	)
	
	on sortSourceByNameBT pressed do
	(
		qsort sourceArr sortByNameFN
		
		sourceSetLB.items = for o in sourceArr collect o.name
		sourceNumET.text = sourceArr.count as string
	)
	
	on sortTargetByNameBT pressed do
	(
				qsort targetArr sortByNameFN
		
		targetSetLB.items = for o in targetArr collect o.name
		targetNumET.text = targetArr.count as string
	)
	
-- 	gestion sources
	
-- 	add
	on addSourceBT pressed do
	(		
		sourceArr = addObjToListFN sourceSetLB sourceArr
		sourceNumET.text = sourceArr.count as string
	)
	
-- 	delete	
	on delSourceBT pressed do
	(
		sourceArr = delObjInListFN sourceSetLB sourceArr
		sourceNumET.text = sourceArr.count as string
	)
-- 	monter
	on upSourceBT pressed do
	(
		sourceArr = upObjInListFN sourceSetLB sourceArr
		sourceNumET.text = sourceArr.count as string
	)
	
-- 	descendre
	on downSourceBT pressed do
	(
		sourceArr = downObjInListFN sourceSetLB sourceArr
		sourceNumET.text = sourceArr.count as string
	)
	
-- 	nettoyer
	on clearSourceBT pressed do
	(
		sourceArr = clearListFN sourceSetLB sourceArr
		sourceNumET.text = sourceArr.count as string
	)
	
-- 	selectionner
	on selSourceInScBT pressed do
	(
		select sourceArr[sourceSetLB.selection]
	)
	
	on loadGhostAsSourceBT pressed do
	(
		print "youhou"
		sourceArr = theGhostArray
		
		sourceSetLB.items = for o in sourceArr collect o.name
		sourceNumET.text = sourceArr.count as string
	)
	
-- 	gestion target
	
-- 	add
	on addTgtBT pressed do
	(
		targetArr  = addObjToListFN targetSetLB targetArr
		targetNumET.text = targetArr.count as string
	)
	
-- 	delete
	on  delTgtBT pressed do
	(
		targetArr = delObjInListFN targetSetLB targetArr
		targetNumET.text = targetArr.count as string	
	)


-- 	monter
	on upTgtBT pressed do
	(
		targetArr = upObjInListFN targetSetLB targetArr
		targetNumET.text = targetArr.count as string	
	)
	
-- 	descendre
	on downTgtBT pressed do
	(
		targetArr = downObjInListFN targetSetLB targetArr
		targetNumET.text = targetArr.count as string	
	)
	
-- 	nettoyer
	on  clearTargetBT pressed do
	(
		targetArr = clearListFN targetSetLB targetArr
		targetNumET.text = targetArr.count as string	
	)
	
	on selTargetInScB pressed do
	(
		 
		select targetArr[targetSetLB.selection]
	)
	
		
	on loadGhostAsTargetBT pressed do
	(		
		targetArr = theGhostArray

		targetSetLB.items = for o in targetArr collect o.name
		targetNumET.text = targetArr.count as string
	)
	
	
-- 	compare
	on compareBT pressed do
	(
		select #(targetArr[targetSetLB.selection],sourceArr[sourceSetLB.selection])
	)
	
-- 	apply
	on TransPoseBT pressed do
	(
		for i = 1 to  sourceArr.count do 
		(
			targetArr[i].rotation = sourceArr[i].rotation
			targetArr[i].position = sourceArr[i].position
		)
	)
	
	on TransPisteBT pressed do
	(
		for i = 1 to  sourceArr.count do 
		(
			targetArr[i].transform.controller = copy sourceArr[i].transform.controller
-- 			targetArr[i].position = sourceArr[i].position
		)
	)

	
)
-- createdialog poseTransfertRLT width: 500

newWindows = newRolloutFloater "Transfert de poses"  500 800


addRollout  rollout1 newWindows
-- addRollout  rollout2 newWindows