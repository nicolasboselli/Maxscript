-- plus: au double click sur le set, selectionner les objets dans la scene
-- plus: créer un commande dupliquer le set
-- plus: mettre une alerte avant de charger un autre set pour eviter de perdre les poses

-- getThisScriptFilename() 

stockSetRLT = undefined
oneSetTemp



-- structure
struct valueRange ( range , start , end)

-- function
-- appendOneSet
fn AppendOneSetFN PS oneSetTemp = 
(
	PSPS = PS.poseStackerTracks
	-- pour la piste stack_setName
	append PSPS.stack_setName oneSetTemp.setname
	
	-- pour la piste stack_objSet
	for o in oneSetTemp.objSet do append PSPS.stack_objSet o
	
	-- pour la piste stack_objNum
	append PSPS.stack_objNum oneSetTemp.objSet.count
	
	-- pour la piste stack_ref
	append PSPS.stack_ref oneSetTemp.setRef
	
	-- pour la piste stack_poseNum
	append PSPS.stack_poseNum oneSetTemp.poseArray.count
	
	-- pour la piste stack_pose_name
	for o in oneSetTemp.poseArray do append psps.stack_pose_name o.onePoseName

-- 		pour la piste stack_quatx, y , z w
	for o in oneSetTemp.poseArray do
	(
		for one in o.rotArray do append psps.stack_quatx one.x
		for one in o.rotArray do append psps.stack_quaty one.y
		for one in o.rotArray do append psps.stack_quatz one.z
		for one in o.rotArray do append psps.stack_quatw one.w
	)
	
	-- pour la piste stack_position
	for o in oneSetTemp.poseArray do 
	(
		for one in o.PosArray do append psps.stack_position one
	)
)
-- deleteOneSet
-- insertOneSet
-- rebuildOnSet


-- creation du blankset
if (getnodebyname "blankSetObj" == undefined) then (point name: "blankSetObj" pos: [0,0,50] )
blankSetObj = (getnodebyname "blankSetObj")

if (getnodebyname "blankSetRef" == undefined) then (point name: "blankSetRef" pos: [0,50,0])
blankSetRef = (getnodebyname "blankSetRef")

global blankPose = onePose posArray: #([0,0,0]) onePoseName:   "(blank Pose)"  rotArray: #((quat 0 0 0 0))
global blankSet = oneSet setName:"(blank set)" setRef:blankSetRef objSet:#(blankSetObj) poseArray:#(blankpose)


rollout stockSetRLT "Anim Asset Stockage"
(
	Global PS
	
	local onePoseBak
	local poseArrayBak
	local oneSetBak
	
	
	group "stockage"
	(
		
-- 		button checkPosArrayBT "Check Pose Array"
-- 		button createStackBT "Création de node de stockage"
		listbox setListLB "Set list"
		edittext changeSetNameET "Rename:"
		
		button newSetBT "New Set" across: 4
-- 		button makeStackBt "Save" 
		button saveAsStackBt "Save As "
		button delSelStackBt "Delete Selection "

-- 		button checkSetSelBT "Load Set selected"   across:  1
-- 		button sendSetSelBT "Send Set Sel" 
		button reloadSelSelBT "Load Set Sel"
		
		button checkStackBT "Check tracks" across: 2
		button resetSetBT "Reset All tracks"
	)
	
	on stockSetRLT open do
	(
		PSarray = #()
		PS = undefined
		-- controle de la presence de staker
		for o in ($* as array) do
		(
			if ((classof o == point) AND (custAttributes.count o == 1)) AND (o.name == "PS_001") then 
			(
				append PSarray o
			)
		)

		if PSarray.count < 1 then
		(
			"pas de pose staker"
			
			PS = point name: (uniquename "PS_")
			pose_stacker = attributes poseStackerTracks 
			(
				parameters main 
				(
					stack_setName type:#stringtab tabSizeVariable:true
					---- une piste pour enregistrer le nombre eelements de chaque pose #intergertab
					stack_objNum type:#indextab tabSizeVariable:true 
					---- une piste pour enregistrer les objets de references #nodetab
					stack_ref  type:#nodetab tabSizeVariable:true
					-- une piste pour enregistrer le nombre de poses du set
					stack_poseNum type: #indextab tabSizeVariable:true
					
					-- une piste pour enregistrer les sets d'objets #nodetab
					stack_objSet type:#nodetab tabSizeVariable:true
					
					---- une piste pour enregistrer les rotations #point4tab
					stack_axis type:#point3tab tabSizeVariable:true
					stack_angle type:#floattab tabSizeVariable:true
					
					stack_quatX type:#floattab tabSizeVariable:true
					stack_quatY type:#floattab tabSizeVariable:true
					stack_quatZ type:#floattab tabSizeVariable:true
					stack_quatW type:#floattab tabSizeVariable:true

					---- une piste pour enregistrer les positions #point3tab
					stack_position type:#point3tab tabSizeVariable:true

					-- une piste pour enregistrer les noms des poses #nodetab
					stack_pose_name type:#stringtab tabSizeVariable:true
				)
			)
			-- custAttributes.add s supervisors
			custAttributes.add PS pose_stacker
			
		)	
		else if PSarray.count == 1 then
		(
			PS = PSarray[1]
			("il y a un pose staker dans la scéne:" + (ps.name))
			setListLB.items = PS.poseStackerTracks.stack_setName as array
			
		)
		else if PSarray.count > 1 then
		(
			"trop de staker"
		)
		else
		(
			"la chais pas"
		)
	)
	
	on setListLB selected oneSetSel do
	(
		changeSetNameET.text = PS.poseStackerTracks.stack_setName[oneSetSel]
	)
	
	on changeSetNameET entered newSetName do
	(
		PS.poseStackerTracks.stack_setName[setListLB.selection] = newSetName
		poseAssistRLT.setLoadedET.text =  newSetName
		setListLB.items = PS.poseStackerTracks.stack_setName as array
	)
	
	on newSetBT pressed do
	(		
		AppendOneSetFN PS blankSet
		
		setListLB.items = PS.poseStackerTracks.stack_setName as array
	)
	
	on makeStackBt pressed do
	(
		AppendOneSetFN PS oneSetTemp
		setListLB.items = PSPS.stack_setName as array
	)
	
	on delSelStackBt pressed do
	(
-- 		vars
		setSelToDelID = setListLB.selection
		PSPS = PS.poseStackerTracks
		
		local setNameToDel 
		local objNumToDel = PSPS.stack_objNum[setSelToDelID]
		local refSetToDel
		local poseNumToDel = PSPS.stack_poseNum[setSelToDelID]
		
		-- suppression des objets du set de la piste stack_objSet
			-- suppression d'un plage d'element à définir		
		objSetToDelEnd = 0
		for i = 1 to setSelToDelID do objSetToDelEnd = objSetToDelEnd + PSPS.stack_objNum[i]
		objSetToDelStart = objSetToDelEnd - objNumToDel + 1
		
		for i = 1 to objNumToDel do deleteitem PSPS.stack_objSet objSetToDelStart 
		
		-- suppression des valeurs axis ange et position des pistes stack_axis, stack_position, stack_pose_name
			-- suppression d'une plage d'éléments à définir
		ValuesToDelRange = objNumToDel * poseNumToDel
		ValuesToDelEnd = 0
		for i = 1 to setSelToDelID do ValuesToDelEnd = ValuesToDelEnd + (PSPS.stack_objNum[i] * PSPS.stack_poseNum[i])
		ValuesToDelStart = ValuesToDelEnd - ValuesToDelRange + 1
		
		for i = 1 to ValuesToDelRange do
		(
			deleteitem PSPS.stack_quatx ValuesToDelStart
			deleteitem PSPS.stack_quaty ValuesToDelStart
			deleteitem PSPS.stack_quatz ValuesToDelStart
			deleteitem PSPS.stack_quatw ValuesToDelStart
			deleteitem PSPS.stack_position ValuesToDelStart
		)
		
		-- suppression des noms de poses de la piste stack_pose_name
			-- suppression d'une plage d'éléments à définir
		poseSetToDelEnd = 0
		for i = 1 to setSelToDelID do poseSetToDelEnd = poseSetToDelEnd + PSPS.stack_poseNum[i]
		poseSetToDelStart = poseSetToDelEnd - poseNumToDel + 1
		
		for i = 1 to poseNumToDel do deleteitem PSPS.stack_pose_name poseSetToDelStart
		
				-- suppression du nom du set  de la piste stack_setName
			-- suppression d'un element
		deleteitem PSPS.stack_setName setSelToDelID
		
		
		-- suppression du nombre d'objets du set de la piste stack_objNum
			-- suppression d'un element
		deleteitem PSPS.stack_objNum setSelToDelID
		 
		
		-- suppression de l'objet de reference de la piste stack_ref
			-- suppression d'un element
		deleteitem PSPS.stack_ref setSelToDelID
		
				
		-- suppresion du nombre de pose de la  piste stack_poseNum
			-- suppression d'un element
		deleteitem PSPS.stack_poseNum setSelToDelID
		
		-- refresh display
		setListLB.items = PSPS.stack_setName as array
		
		if setListLB.selection < setSelToDelID then (setListLB.selection = setSelToDelID - 1)
	
		changeSetNameET.text = setListLB.items[setListLB.selection]
	)
	
	on saveAsStackBt pressed do
	(
		
-- 		vars
		setSelToDelID = setListLB.selection
		PSPS = PS.poseStackerTracks
		
		local setNameToDel 
		local objNumToDel = PSPS.stack_objNum[setSelToDelID]
		local refSetToDel
		local poseNumToDel = PSPS.stack_poseNum[setSelToDelID]
		
		-- suppression des objets du set de la piste stack_objSet
			-- suppression d'un plage d'element à définir	
	
		objSetToDelEnd = 0
		for i = 1 to setSelToDelID do objSetToDelEnd = objSetToDelEnd + PSPS.stack_objNum[i]
		objSetToDelStart = objSetToDelEnd - objNumToDel + 1
		
		
-- 		insertItem <value> <array> <integer>  
		for i = 1 to objNumToDel do deleteitem PSPS.stack_objSet objSetToDelStart 
-- 		for i = 1 to oneSetTemp.objSet.count do insertItem oneSetTemp.objSet[i] PSPS.stack_objSet (i + objSetToDelStart - 1)
		
		if PSPS.stack_objSet.count < objSetToDelStart then
		(
			for i = 1 to oneSetTemp.objSet.count do append  PSPS.stack_objSet oneSetTemp.objSet[i]
		)
		else
		(
			for i =oneSetTemp.objSet.count to 1 by -1 do insertItem oneSetTemp.objSet[i] PSPS.stack_objSet (objSetToDelStart)
		)
		
		-- suppression des valeurs axis ange et position des pistes stack_axis, stack_position,
			-- définition de la plage
		ValuesToDelRange = objNumToDel * poseNumToDel
		ValuesToDelEnd = 0
		for i = 1 to setSelToDelID do ValuesToDelEnd = ValuesToDelEnd + (PSPS.stack_objNum[i] * PSPS.stack_poseNum[i])
		ValuesToDelStart = ValuesToDelEnd - ValuesToDelRange + 1
		
		print ValuesToDelStart
		print ValuesToDelEnd
		print ValuesToDelRange
		
		print PSPS.stack_quatx.count
		-- suppression d'une plage d'éléments à définir
		for i = 1 to ValuesToDelRange do
		(
			deleteitem PSPS.stack_quatx ValuesToDelStart
			deleteitem PSPS.stack_quaty ValuesToDelStart
			deleteitem PSPS.stack_quatz ValuesToDelStart
			deleteitem PSPS.stack_quatw ValuesToDelStart
			deleteitem PSPS.stack_position ValuesToDelStart
		)
		
		-- 		collecte des valeurs
		stack_quatxTemp = #()
		stack_quatyTemp = #()
		stack_quatzTemp = #()
		stack_quatwTemp = #()
		stack_positionTemp = #()
		
		for o in oneSetTemp.poseArray do
		(
			for one in o.rotArray do 
			(
				append stack_quatxTemp one.x 
				append stack_quatyTemp one.y 
				append stack_quatzTemp one.z 
				append stack_quatwTemp one.w 
			)
			
			for one in o.posArray do append stack_positionTemp one
		)
		
		print stack_quatxTemp.count
		
		if PSPS.stack_quatx.count < ValuesToDelStart then
		(
			for i = 1 to stack_quatxTemp.count do
			(
				append  PSPS.stack_quatx stack_quatxTemp[i]
				append  PSPS.stack_quaty stack_quatyTemp[i]
				append  PSPS.stack_quatz stack_quatzTemp[i]
				append  PSPS.stack_quatw stack_quatwTemp[i]
				append  PSPS.stack_position stack_positionTemp[i]
			)
		)
		else
		(
			-- 		insertion de la plage prévoir la variation append
			for i = stack_quatxTemp.count to 1 by -1 do
			(
				insertItem stack_quatxTemp[i] PSPS.stack_quatx ValuesToDelStart
				insertItem stack_quatyTemp[i] PSPS.stack_quaty ValuesToDelStart
				insertItem stack_quatzTemp[i] PSPS.stack_quatz ValuesToDelStart
				insertItem stack_quatwTemp[i] PSPS.stack_quatw ValuesToDelStart
				insertItem stack_positionTemp[i] PSPS.stack_position ValuesToDelStart
			)
		)
		print PSPS.stack_quatx.count
		
		
		
		-- suppression des noms de poses de la piste stack_pose_name
			-- suppression d'une plage d'éléments à définir
		poseSetToDelEnd = 0
		for i = 1 to setSelToDelID do poseSetToDelEnd = poseSetToDelEnd + PSPS.stack_poseNum[i]
		poseSetToDelStart = poseSetToDelEnd - poseNumToDel + 1
		
		for i = 1 to poseNumToDel do deleteitem PSPS.stack_pose_name poseSetToDelStart
			
		if PSPS.stack_pose_name.count < poseSetToDelStart then
		(
			for o in oneSetTemp.poseArray do append psps.stack_pose_name o.onePoseName
		)
		else
		(
			for i = oneSetTemp.poseArray.count to i = 1 by -1  do insertItem  oneSetTemp.poseArray[i].onePoseName psps.stack_pose_name poseSetToDelStart
		)
		
		-- suppression du nombre d'objets du set de la piste stack_objNum
			-- suppression d'un element
		deleteitem PSPS.stack_objNum setSelToDelID
		
		if  PSPS.stack_objNum.count < setSelToDelID then
		(
			append  PSPS.stack_objNum oneSetTemp.objSet.count
		)
		else
		(
			insertitem oneSetTemp.objSet.count PSPS.stack_objNum setSelToDelID
		)
		
		
		-- suppression de l'objet de reference de la piste stack_ref
			-- suppression d'un element
		deleteitem PSPS.stack_ref setSelToDelID
		
		if  PSPS.stack_ref.count < setSelToDelID then
		(
			append  PSPS.stack_ref oneSetTemp.setRef
		)
		else
		(
			insertitem oneSetTemp.setRef PSPS.stack_ref setSelToDelID
		)
		
				
		-- suppresion du nombre de pose de la  piste stack_poseNums
		-- suppression d'un element
		deleteitem PSPS.stack_poseNum setSelToDelID
		-- insertion de l'element correct
		if  PSPS.stack_poseNum.count < setSelToDelID then
		(
			append  PSPS.stack_poseNum oneSetTemp.poseArray.count
		)
		else
		(
			insertitem oneSetTemp.poseArray.count PSPS.stack_poseNum setSelToDelID
		)
		
		setListLB.items = PSPS.stack_setName as array
		poseAssistRLT.setLoadedET.text =  setListLB.items[setListLB.selection]
		poseAssistRLT.modifiedET.text = "no"
		
	)


	
	on reloadSelSelBT pressed do
	(
			print"youhou"
		-- 	réinitialisation des variables
		setSelToBakID = setListLB.selection
		
		poseArrayBak = #()

		
		PSPS = PS.poseStackerTracks
		
		-- recuperation du set d'objet
-- 		objSetNum = PSPS.stack_objNum[setSelToBakID]
		
		objSetEnd = 0
		for i = 1 to setSelToBakID do	objSetEnd= objSetEnd + PSPS.stack_objNum[i]
		objSetStart = objSetEnd - PSPS.stack_objNum[setSelToBakID] + 1
		
		objetSetBak = #()
		objetSetBak = for i = objSetStart to objSetEnd collect PSPS.stack_objSet[i]
		
		
		-- récupération des noms du set de pose 
		
-- 		poseSetRange = PSPS.stack_poseNum[setSelToBakID]
		
		poseSetEnd = 0
		for i = 1 to setSelToBakID do 	poseSetEnd = poseSetEnd + PSPS.stack_poseNum[i]
		poseSetStart = poseSetEnd -  PSPS.stack_poseNum[setSelToBakID] +1
		
		poseSetNames = #()
		poseSetNames = for i = poseSetStart to poseSetEnd collect PSPS.stack_pose_name[i]
			
		-- reconstruction des poses
		
		-- récupération de la plage de valeur pour tous les objets d'un set ou toute les valeur d'un posearray
		-- récupération du range dudébut et de la fin des valeurs
-- 		poseArrayRangeSize = PSPS.stack_objNum[setSelToBakID] * PSPS.stack_poseNum[setSelToBakID] 
		
		poseArrayEnd = 0
		for i = 1 to setSelToBakID do poseArrayEnd = poseArrayEnd + (PSPS.stack_objNum[i] * PSPS.stack_poseNum[i])
		poseArrayStart = poseArrayEnd - (PSPS.stack_objNum[setSelToBakID] * PSPS.stack_poseNum[setSelToBakID]) + 1
		
-- 		récupération des valeurs
		poseArrayRotBak = #()
		poseArrayPosBak = #()
		
		for i = poseArrayStart to poseArrayEnd do
		(
			RotTemp = (quat 0 0 0 0)
			RotTemp.x = psps.stack_quatx[i]
			RotTemp.y =psps.stack_quaty[i]
			RotTemp.z = psps.stack_quatz[i]
			RotTemp.w = psps.stack_quatw[i]
			append poseArrayRotBak RotTemp
			
			append poseArrayPosBak PSPS.stack_position[i]
		)
-- 		print (PSPS.stack_axis as string)
		print (poseArrayRotBak as string)
		
-- 		redistribution dans les poses
		startCol = 1
		endCol = PSPS.stack_objNum[setSelToBakID]

		for o in poseSetNames do
		(
			onePoseRotValTemp = #()
			onePosePosValTemp = #()
			
-- 			print startCol
-- 			print endCol
			
			for i = startCol to endCol do
			(
				append onePoseRotValTemp poseArrayRotBak[i]
				append onePosePosValTemp poseArrayPosBak[i]
			)
			startCol = startCol + PSPS.stack_objNum[setSelToBakID]
			endCol = endCol + PSPS.stack_objNum[setSelToBakID]
			
			onePoseValTemp = onePose onePoseName: o RotArray: onePoseRotValTemp posArray: onePosePosValTemp
			append poseArrayBak onePoseValTemp
			
			print (onePoseValTemp.posarray as string)
			print (onePoseValTemp.rotarray as string)
			print poseArrayBak
		)
		
		
		-- recuperation du set
		oneSetBak =  oneSet setName: PSPS.stack_setName[setSelToBakID] \
		setRef: PSPS.stack_ref[setSelToBakID] \
		objSet: objetSetBak \
		poseArray: poseArrayBak \
		
-- mise à jour de l'assistanyt de pose
	
		oneSetTemp = oneSetBak
		print oneSetTemp
		
		selToWorkOn = oneSetTemp.objSet
		refToWorkWith = oneSetTemp.setRef
		poseArray = oneSetTemp.poseArray
		
		poseAssistRLT.refPB.text = refToWorkWith.name
		poseAssistRLT.objSetLB.items = for o in selToWorkOn collect o.name
		poseAssistRLT.posesLB.items = for o in oneSetTemp.poseArray collect o.onePoseName
			
		poseAssistRLT.setLoadedET.text = oneSetTemp.setName
		poseAssistRLT.modifiedET.text = "no"
		
		poseAssistRLT.refPB.enabled = false
		poseAssistRLT.addSelToSetBT.enabled = false
		poseAssistRLT.delSelInSetBT.enabled = false

	)
	
		
	on checkStackBT pressed do
	(		
		print PS.poseStackerTracks.stack_setName
		print PS.poseStackerTracks.stack_objNum
		print PS.poseStackerTracks.stack_ref
		print PS.poseStackerTracks.stack_poseNum
		print PS.poseStackerTracks.stack_objSet
		print ""
		print PS.poseStackerTracks.stack_axis
		print PS.poseStackerTracks.stack_angle
		print ""
		print PS.poseStackerTracks.stack_quatx
		print PS.poseStackerTracks.stack_quaty
		print PS.poseStackerTracks.stack_quatz
		print PS.poseStackerTracks.stack_quatw
		print PS.poseStackerTracks.stack_position
		print PS.poseStackerTracks.stack_pose_name
		
		setListLB.items = PS.poseStackerTracks.stack_setName as array
	)
	
	on resetSetBT pressed do
	(
		PS.poseStackerTracks.stack_setName = #() 
		PS.poseStackerTracks.stack_objNum = #() 
		PS.poseStackerTracks.stack_ref = #() 
		PS.poseStackerTracks.stack_poseNum = #() 
		PS.poseStackerTracks.stack_objSet = #() 
-- 		PS.poseStackerTracks.stack_axis = #() 
-- 		PS.poseStackerTracks.stack_angle = #() 
		PS.poseStackerTracks.stack_quatX = #() 
		PS.poseStackerTracks.stack_quaty = #()
		PS.poseStackerTracks.stack_quatz = #()
		PS.poseStackerTracks.stack_quatw = #()
		PS.poseStackerTracks.stack_position = #() 
		PS.poseStackerTracks.stack_pose_name = #() 
		
		setListLB.items = PS.poseStackerTracks.stack_setName as array
	)
)
-- createdialog stockSetRLT width: 400
	