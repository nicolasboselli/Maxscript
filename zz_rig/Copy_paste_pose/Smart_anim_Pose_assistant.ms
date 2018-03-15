-- plus : pourvoir faire un control z, 
-- plus:  selectionné les objets du set quand on charge un set
-- plus : mettre une alerte avant d'appliquer la pose pour voir si on ne veut pas passer en auto key

-- prob: gérer la parenté à un objet nul
-- bug: quand l'un des objets du set est aussi l'objet de référence ça ne fonctionne pas
-- bug: quand la référence est l'enfant d'un des objets du set et qu'il est inclu dans le st ça fait n'importe quoi
-- bug: quand la référence est l'enfant d'un des objets du set et qu'il n'est pas inclu dans le st ça fait n'importe quoi aussi
-- bug: crash à la suppression de la derniere pose

-- bug: crash quand on crée une pose sans avoir selectionner un set d'objet 

-- plus :  afficher le nombre d'objet selectionné
-- plus : supprimer des objets
-- plus : selectionner la pose nouvellement créer
-- plus: changer l'ordre des poses ou les classer par ordre alphabétique

-- getThisScriptFilename() 

poseAssistRLT = undefined
struct oneSet (setName, setRef, objSet, poseArray)
struct onePose (onePoseName, PosArray, RotArray)

rollout poseAssistRLT "Poses Assistant"
(

	
-- 	function
	function addObjToListFN theListBox theArray =
	(
		for o in ($selection as array) do  append theArray o 
		theArray = makeUniqueArray theArray
		theListBox.items = for o in theArray collect o.name
		return theArray
	)
	
	function delObjInListFN theListBox theArray =
	(
		deleteItem theArray theListBox.selection
		if theListBox.selection > theArray.count then  theListBox.selection = theArray.count
		theListBox.items = for o in theArray collect o.name
		return theArray
	)
	


	
-- 	vars
	local poseNum = 1
	global oneSetTemp = oneSet ()
	
	global selToWorkOn = #()
	global refToWorkWith = undefined
	
	Global poseArray = #()
	
-- 	local refPB = undefined
-- 	local addSelToSetBT = undefined
	
-- functionsgénérique
	-- fonction pour collecter les valeurs de position d'un set d'objets par rapport à un point de reference sur une frame
	fn collectOnePoseObjPosFN Sel  selRef =
	(
		onePoseObjPos = #()
		for o in Sel do
		(
			 if o.parent == undefined then append onePoseObjPos (in coordsys selRef o.position) \
			 else append onePoseObjPos (in coordsys parent o.position)
		)
		return onePoseObjPos
	)
	
			-- fonction pour collecter les valeurs de rsotation d'un set d'objets par rapport à un point de reference sur une frame
	fn collectOnePoseObjRotFN Sel  selRef =
	(
		onePoseObjRot = #()
		for o in Sel do
		(
			 if o.parent == undefined then append onePoseObjRot (in coordsys selRef o.rotation) \
			 else append onePoseObjRot (in coordsys parent o.rotation)
		)
		return onePoseObjRot
	)
	
-- 	UI
	group "Set"
	(
		edittext setLoadedET "set loaded :" readonly: true across:2
		edittext modifiedET "modified :" readonly: true
	)
	
	group "paramétrage"
	(
		pickbutton refPB "selectionner reference"  across: 1
		
		listbox objSetLB "set d'objets:" readonly: true
		button addSelToSetBT "ajouter objets" across: 4
		button delSelInSetBT "delete objets"
		button selObjetsBT "selectionner"
		button sendObjBT "envoyer"
	)
	
	button clearSetBT "Reset"
	
	group "poses"
	(
		listbox posesLB "listes de poses"
		edittext renameET "rename"
		button applyPoseBT "appliquer la pose" across: 1
	)	
	
group "Gestion des Poses"
	(	
		button addPoseBT "Ajouter comme nouvelle pose" across: 1
		button saveAsPoseBT "Ecraser la pose" across: 2
		button delPoseBT "Supprimer la pose" 
	)
	
-- function du rollout
	function unLockObjSetFN theState =
	(
		refPB.enabled = theState
		addSelToSetBT.enabled = theState
		delSelInSetBT.enabled = theState
	)
	
-- 	event
	on addSelToSetBT pressed do
	(
		selToWorkOn = addObjToListFN objSetLB selToWorkOn
	)
	
	on delSelInSetBT pressed do
	(
		selToWorkOn = delObjInListFN objSetLB selToWorkOn
	)
	
	on refPB picked refSel do
	(
		refToWorkWith = refSel
		refPB.text = refToWorkWith.name
	)
	
	on selObjetsBT pressed do
	(
		select selToWorkOn
	)
	
	on sendObjBT pressed do
	(
		global theGhostArray  =  selToWorkOn
		print theGhostArray
	)
	
	on clearSetBT pressed do
	(
		selToWorkOn = #()
		refToWorkWith = undefined		
		
		objSetLB.items = for o in selToWorkOn collect o.name
		if refToWorkWith == undefined then refPB.text = "selectionner reference"
		
		poseArray = #()
		posesLB.items = #()
		
		unLockObjSetFN true
		/*
		refPB.enabled = true
		addSelToSetBT.enabled = true
		delSelInSetBT.enabled = true
		*/
	)
	
	on renameET entered poseName do
	(
		poseArray[posesLB.selection].onePoseName = poseName
		posesLB.items  = for o in poseArray collect o.onePoseName	
	)
	
	on posesLB selected poseSel do
	(
		renameET.text = poseArray[poseSel].onePoseName
	)
	
	on addPoseBT pressed do
	(
		 if (refPB.text == "selectionner reference") then (messagebox "selectionner un objet de reference")
		else
		(
			poseNum = poseNum + 1
			-- bloquer le set
			unLockObjSetFN false
			/*
			refPB.enabled = false
			addSelToSetBT.enabled = false
			delSelInSetBT.enabled = false
			*/
			
			--  collecte des valeur de position et de rotation des objets du set dans la pose
			posArrayTemp = collectOnePoseObjPosFN selToWorkOn refToWorkWith
			rotArrayTemp =collectOnePoseObjRotFN selToWorkOn refToWorkWith

	-- 		 stokage de la pose sous forme de structure
			onePoseTemp = onePose onePoseName: ("pose" + (poseNum as string)) \
			PosArray: posArrayTemp \
			RotArray: rotArrayTemp
			 
	-- 		 inclusion de la pose dans l'array de pose
			append  poseArray onePoseTemp 
				
			posesLB.items  = for o in poseArray collect o.onePoseName		
			
	-- 		création du set de pose sur lequel on travaille
			oneSetTemp = oneSet setName: setLoadedET.text setRef: refToWorkWith objSet: selToWorkOn poseArray: poseArray
			setLoadedET.text = oneSetTemp.setName
			modifiedET.text = "yes"
			
			print oneSetTemp
		)
	)
	
	on saveAsPoseBT pressed do
	(
		poseNum = poseNum + 1
		
		nameToErase  = poseArray[posesLB.selection].onePoseName
		print nameToErase
		-- bloquer le set
		unLockObjSetFN false
		/*
		refPB.enabled = false
		addSelToSetBT.enabled = false
		delSelInSetBT.enabled = false
		*/
		
		--  collecte des valeur de position et de rotation des objets du set dans la pose
		posArrayTemp = collectOnePoseObjPosFN selToWorkOn refToWorkWith
		rotArrayTemp =collectOnePoseObjRotFN selToWorkOn refToWorkWith

-- 		 création  de la pose sous forme de structure ave le nom de la pose à écraser
		onePoseTemp = onePose onePoseName: nameToErase \
		PosArray: posArrayTemp \
		RotArray: rotArrayTemp
		
		-- écrasement de la pose
		poseArray[posesLB.selection] = onePoseTemp
		posesLB.items  = for o in poseArray collect o.onePoseName
			
		-- 		création du set de pose sur lequel on travaille
		oneSetTemp = oneSet setName: setLoadedET.text setRef: refToWorkWith objSet: selToWorkOn poseArray: poseArray
		setLoadedET.text = oneSetTemp.setName
		modifiedET.text = "yes"
		
-- 		print oneSetTemp
		
	)
	
	on delPoseBT pressed do
	(
		poseNum = poseNum + 1
		
		if posearray.count > 0 then
		(
			deleteitem oneSetTemp.posearray posesLB.selection
			
			posesLB.items = for o in oneSetTemp.posearray collect o.onePoseName
				
			oneSetTemp = oneSet setName: setLoadedET.text setRef: refToWorkWith objSet: selToWorkOn poseArray: poseArray
			setLoadedET.text = oneSetTemp.setName
			modifiedET.text = "yes"
		)
		
		if posearray.count < 1 then
		(
			unLockObjSetFN true
			/*
			refPB.enabled = true
			addSelToSetBT.enabled = true
			delSelInSetBT.enabled = true
			*/
		)
	)
	
	on applyPoseBT pressed do
	(
		onePoseTemp = oneSetTemp.poseArray[posesLB.selection]
-- 		onePoseTemp = poseArray[posesLB.selection]
		print ( onePoseTemp.rotarray as string)
		
		for i = 1 to oneSetTemp.objSet.count do
		(
			if oneSetTemp.objSet[i].parent != undefined then
			(
				in coordsys parent oneSetTemp.objSet[i].rotation = onePoseTemp.RotArray[i]
-- 				print onePoseTemp.RotArray[i]
				in coordsys parent oneSetTemp.objSet[i].position = onePoseTemp.PosArray[i]
-- 				print onePoseTemp.PosArray[i]
			)
			else
			(
				in coordsys oneSetTemp.setRef  oneSetTemp.objSet[i].rotation = onePoseTemp.RotArray[i]
-- 				print onePoseTemp.RotArray[i]
				in coordsys oneSetTemp.setRef  oneSetTemp.objSet[i].position = onePoseTemp.PosArray[i]
-- 				print onePoseTemp.PosArray[i]
			)
		)
		
	)	
)

-- createdialog poseAssistRLT width: 400

