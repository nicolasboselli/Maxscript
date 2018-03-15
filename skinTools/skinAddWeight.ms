-- todo: améliorer le calcul des poids à l'approche de 0 et de 1
-- faire les calculs sur 1000 en int
-- bug: quand une influence minorée descend sous zero avant que l'influence majoré atteigne 1,  
	-- par défaut l'influence minorée disparait et les influences restantes se moyennent.
	-- préféré une soustraction à l'influence ajoutée

fn getSkinVertSel m =
(
	vxCount = skinOps.GetNumberVertices m
	local vxSelAr = for i = 1 to vxcount where skinops.IsVertexSelected m i == 1 collect i
	vxSelAr
)

fn vertexInfo m vx =
(
	vxMaxBones = skinOps.GetVertexWeightCount m vx
	bnList = #()
	wtList = #()
	
	for i = 1 to vxMaxBones do
	(
		append bnList (skinOps.GetVertexWeightBoneID m vx i)
		append wtList (skinOps.GetVertexWeight m vx i)
	)
	#(bnList, wtList)
	
	format "info # vertex: %, bones:%, weight: % \n" vx bnList wtList 
)

fn majOneVertex m majoredBone unLockedBoneList  vx wtAdd =
(
	
	/* Collecte du set bones et de poids */
	-- collecter la liste de bones et la liste de poids correspondants
	vxMaxBones = skinOps.GetVertexWeightCount m vx
	bnList = #()
	wtList = #()
	
	for i = 1 to vxMaxBones do
	(
		append bnList (skinOps.GetVertexWeightBoneID m vx i)
		append wtList (skinOps.GetVertexWeight m vx i)
	)
	#(bnList, wtList)
-- 	format "vertex: %, bones: %, weights: % \n" vx bnList wtList


	/* Check du set sur lequel travailler*/
	boneMajoredUnlocked = False
	-- tester si le bone à majorer est delocké
	res = finditem unLockedBoneList majoredBone
	if res > 0 then boneMajoredUnlocked = true
	
	-- tester si le bone majorer est déja une influence du vertex
	mbiId = finditem bnList majoredBone
	majoredCorrect = False
	if mbiId > 0 and  boneMajoredUnlocked == true then 
	(
		majoredCorrect = True
-- 		format "bone majored: %, initial weight: %\n" bnList[mbiId] wtList[mbiId]
	)
	else if mbiId == 0 and  boneMajoredUnlocked == true then
	(
		append bnList majoredBone
		append wtList 0
		mbiId = bnList.count
		majoredCorrect = true
-- 		format "bone majored added : %, initial weight: %\n" bnList[mbiId] wtList[mbiId]
	)
	else format "the selected bone is locked: %\n" majoredBone
	
	-- collecter les bones sur lesquels on enlève du poid
	minoredCorrect = False
	minoredBnList = #()
	minoredWtList = #()
	minoredBnIdList = #()
	for i = 1 to bnList.count do
	(
		if bnList[i] != majoredBone and (finditem unLockedBoneList bnList[i]) > 0 then
		(
			append minoredBnList bnList[i]
			append minoredWtList wtList[i]
			append minoredBnIdList i
		)
		if minoredBnList.count >= 1 then minoredCorrect = True
	)
-- 	format "minored bones: % ,  initial weight: %\n" minoredBnList minoredWtList
	
	/* test du poids à ajouter */
	if majoredCorrect == true then majoredBoneWt = wtList[mbiId]
		-- prévoir que l'addition arrive à 0 ou à 1 sur le bone majorée et laisse un reste:
			-- permettre l'addition, soustraire le reste de l'influence à repartir sur les autres bones
		
	-- si le bone à majorer est correct et si les bone à minorer son correct
	if majoredCorrect == true and minoredCorrect == true  then 
	(
			format "BEFORE # vertex: %, bones:%, weight: % \n" vx bnList wtList 
			local maxAdd
			local maxSub
		
-- 			ADDITION
			-- tester si la valeur majorée est comprise entre 0 et 1
			if wtList[mbiId] + wtAdd >= 1 then maxAdd = 1 - wtList[mbiId]
			else if wtList[mbiId] + wtAdd <= 0 then maxAdd = 0 - wtList[mbiId]
			else maxAdd = wtAdd
						
-- 			COMPENSATION
			-- diviser le poids ajouter en autant de bones collecter
			minorWt = (maxAdd / minoredBnList.count) * -1
			
			-- le traitement ci dessous ne fonctionne pas mais c'est pour me rappeler qu'il faut faire quelquechose avec les suppression de poids maxi
			-- prévoir que la compensation arrive à 0 ou à 1 sur un bone minoré et laisse un reste:
				-- répartir ce reste sur les autre bones disponible
				-- s'il y n'y a pas d'autres bones sur lesquels repartir le poids diminuer l'ajout de poids
			
			for id in minoredBnIdList do
			(
				if wtList[id] + minorWt >= 1 then maxSub = 1 - wtList[id]
				else if wtList[id] + minorWt <= 0 then maxSub = 0 - wtList[id]
				else maxSub = minorWt
			)
				
			format "maxAdd: %, count: %, minorWt:% , maxSub:% \n" maxAdd minoredBnList.count minorWt maxSub
			if abs(maxSub) < abs(minorWt) then maxAdd = (maxSub * minoredBnList.count) * -1
						
-- 			CALCUL
			-- ajout du l'influence au bone majoré
			wtList[mbiId] = wtList[mbiId] + maxAdd
			-- retrancher le poids au poids des bones delockés (repartition égale)
			for id in minoredBnIdList do wtList[id] = wtList[id] + minorWt
			
--			EXECUTION
			format "AFTER # vertex: %, bones:%, weight: % \n\n" vx bnList wtList 
			skinOps.ReplaceVertexWeights m vx bnList wtList
	)
	else (format "7 # vertex: %, bones:%, weight: % \n\n" vx bnList wtList) 
)

rollout addWtRLT "Weight Operation"
(
	local wtAdd
	local m 
	local skinMaxBones 
	local unLockedBoneList 
	local majoredBone
	local vxSelAr
	local parentRLT
	
	group "addition"
	(
		spinner wtSP "weight:" range: [0,1,0.1] type: #float
		button majWtBT "+" across: 2
		button minWtBT "-"
	)
	button testBT "vertex infos"
	
	on addWtRLT open do
	(
		m = modPanel.getCurrentObject() 
	)
	
	on majWtBT pressed do
	(
		wtAdd = wtSP.value
		m = modPanel.getCurrentObject() 
		skinMaxBones = skinOps.GetNumberBones m
-- 		unLockedBoneList = for i = 1 to skinMaxBones collect i
		unLockedBoneList = for o in parentRLT.skinBonesAr where o.isLocked == false collect o.id
		majoredBone = skinOps.GetSelectedBone m
		vxSelAr = getSkinVertSel m
		format "unLockedBoneList: %, majoredBone:%\n" unLockedBoneList majoredBone
		for vx in vxSelAr do	majOneVertex m majoredBone unLockedBoneList  vx wtAdd 
	)
	
	on minWtBT pressed do
	(
		wtAdd = wtSP.value
		m = modPanel.getCurrentObject() 
		skinMaxBones = skinOps.GetNumberBones m
-- 		unLockedBoneList = for i = 1 to skinMaxBones collect i
		unLockedBoneList = for o in parentRLT.skinBonesAr where o.isLocked == false collect o.id
		majoredBone = skinOps.GetSelectedBone m
		vxSelAr = getSkinVertSel m
		
		for vx in vxSelAr do	majOneVertex m majoredBone unLockedBoneList  vx (wtAdd*-1)
	)
	
	on testBT pressed do
	(
		vxSelAr = getSkinVertSel m
		for vx  in vxSelAr do vertexInfo m vx 
	)
)
-- createdialog addWtRLT
