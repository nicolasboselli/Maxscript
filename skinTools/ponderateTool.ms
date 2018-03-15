/* WEIGHT PONDERATION */



-- ########################################### MAIN FUNCTIONS
struct vxInf
(
	id,
	bnList,
	WtList
)


fn collectVxInfAr m =
(
	local vxSelAr = #()

	vxCount = skinOps.GetNumberVertices m
	vxSelIdAr = for i = 1 to vxcount where skinops.IsVertexSelected m i == 1 collect i
	
	for vx in vxSelIdAr do
	(
		bnList = #()
		wtList = #()
		vxMaxBones = skinOps.GetVertexWeightCount m vx
		
		for i = 1 to vxMaxBones do
		(
			append bnList (skinOps.GetVertexWeightBoneID m vx i)
			append wtList (skinOps.GetVertexWeight m vx i)
		)
		append vxSelAr (vxInf id: vx bnList: bnList WtList: wtList)
	)
	vxSelAr
)



--############################### COPY FUNCTIONS

fn returnAverage vxWtAr skinMaxBones =
(
	format "vxWtAr: % \n" vxWtAr
	-- créer un array du nombre de bone
	local bnAr = for bn = 1 to skinMaxBones collect 0.0
		
	-- pour chaque influence trouvée sur chaque vertex ajouté l'influences
	for vxVal in vxWtAr do
	(
		format "vx Influence: % \n" vxVal
		-- deploiement de l'array
		for i = 1 to vxVal.bnList.count do
		(
			id = vxVal.bnList[i]			
			bnAr[id] = bnAr[id] + vxVal.wtList[i]
		)
	)
	
	-- moyenne sur l'array
	local bnArAdd = for val in bnAr collect val/vxWtAr.count
	format "bnArAdd: % \n" bnArAdd
	
	bnArAdd
)




--############################### PASTE FUNCTIONS

fn mixVxInf m  bnArAdd multiAdd: 0.5  = 
(
	local vxWtDestAr = collectVxInfAr m
	local skinMaxBones = skinOps.GetNumberBones m
	
	-- pour chaque vertex de la destination appliquer la moyenne
	for vxVal in vxWtDestAr do
	(
		format "vertex influences added : % \n" bnArAdd
		
		local multiOrig = 1 - multiAdd
		local bnAr = for bn = 1 to skinMaxBones collect 0.0
			
		-- deployer les valeur initiale
		for i = 1 to vxVal.bnList.count do
		(
			id = vxVal.bnList[i]
			bnAr[id] = vxVal.wtList[i]
		)
		format "vertex influences orig: % \n" bnAr
		
		-- mixage
		for i = 1 to bnAr.count do
		(
			bnAr[i] = bnAr[i]*multiOrig + bnArAdd[i]*multiAdd
		)
		format "vertex value mixed: % \n" bnAr
		
		-- rangement des vertex pour le replace
		bnListMedium = #()
		wtListMedium = #()
		for bn = 1 to bnAr.count where bnAr[bn] != 0.0 do
		(
		-- calculer une moyene de poids sur les poids d'une selection de vertex
			append bnListMedium bn
			append wtListMedium bnAr[bn]
		)
		
		format "vertex: %, bones:%, weight: % \n\n" vxVal.id bnListMedium wtListMedium 
		skinOps.ReplaceVertexWeights m vxVal.id bnListMedium wtListMedium
	)
)


-- ################################# PONDERATE FUNCTION
fn ponderate multiAdd: 0.5  =
(
	m = modPanel.getCurrentObject()
	skinMaxBones = skinOps.GetNumberBones m

	vxCount = skinOps.GetNumberVertices m
	vxSelBak = for i = 1 to vxcount where skinops.IsVertexSelected m i == 1 collect i

	vxSel = collectVxInfAr m

	-- vx = vxSel[1]
	for vx in vxSel do
	(
		format "vx: %\n" vx
		-- select vx id
		skinOps.SelectVertices m vx.id
		-- grow selection
		skinOps.growSelection m
		
		-- collect vx select except vx initial
		vxCount = skinOps.GetNumberVertices m
		vxSelIdAr = for i = 1 to vxcount where skinops.IsVertexSelected m i == 1 collect i
		res = finditem vxSelIdAr vx.id
		deleteItem vxSelIdAr res
		skinOps.SelectVertices m vxSelIdAr
		vxSelTmp = collectVxInfAr m
		
		-- calcul average value sur grow selection
		avg = returnAverage vxSelTmp skinMaxBones
		format "avg: %\n" avg
		
		skinOps.SelectVertices m vx.id
		mixVxInf m avg  multiAdd: multiAdd 
	)
	skinOps.SelectVertices m vxSelBak
)

Try(destroydialog AverageToolRLT)catch()
rollout AverageToolRLT "Average Tool"
(
	local selAverage
	
	group "Multiplier:"
	(
		button minusBT "-" across: 7
		button o1BT "0.1"
		button o25BT "0.25"
		button o5BT "0.5"
		button o75BT "0.75"
		button o9BT "0.9"
		button plusBT "+"
		Spinner multiSP "Multi:" range: [0.0, 1.0, 0.5]
	)
	group "Actions:"
	(
		button copyBT "Copy" across: 3
		button pasteBT "Paste"
		button pondBT "Ponderate"
	)
	
	on minusBT pressed do 
	(
		if multiSP.value > 0 then multiSP.value -= 0.1
	)
	
	on plusBT pressed do
	(
		if multiSP.value < 1 then multiSP.value += 0.1
	)
	
	on o1BT pressed do multiSP.value = 0.1
	on o25BT pressed do multiSP.value = 0.25
	on o5BT pressed do multiSP.value = 0.5
	on o75BT pressed do multiSP.value = 0.75
	on o9BT pressed do multiSP.value = 0.9
	
	on copyBT pressed do
	(
		undo on
		(
			m = modPanel.getCurrentObject()
			skinMaxBones = skinOps.GetNumberBones m
			vxWtAr = collectVxInfAr m
			selAverage = returnAverage vxWtAr skinMaxBones
		)
	)
	
	on pasteBT pressed do
	(
		undo on
		(
-- 			format "selAverage: %\n" selAverage
			m = modPanel.getCurrentObject()
-- 			format "vxWtDestAr: %\n" vxWtDestAr
			mixVxInf m selAverage  multiAdd: multiSP.value 
		)
	)
	
	on pondBT pressed do
	(
		undo on
		(
			ponderate multiAdd: multiSP.value
		)
	)
)
createdialog AverageToolRLT width: 300
