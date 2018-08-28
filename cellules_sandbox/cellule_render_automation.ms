fn sceneStatesAutomation =
(
	lmax = LayerManager.count
	goodLayers = #()

	-- collecte des layer groupe
	for i = 0 to lmax - 1 do
	(
		l =  LayerManager.getLayer i
		if matchpattern l.name pattern: "Grp*" then
		(
			local excludeL = false
			local patterns = #("*mur*", "*plan*", "*LetC*", "*Murs*", "*murs*", "*plans*", "*Plans*", "*meubles*","*amenagement*", "*Cam&light*")
		
			for p in patterns do
			(
				if  matchpattern l.name pattern: p then 
				(
					excludeL = true
	-- 				format "exclusion: %\n" l.name
					exit
					
				)
			)
			
			if not excludeL then
			(
				format "l.name:%\n" l.name
				append goodLayers l
				
			)
		)
	-- 	else format "not Grp: %\n" l.name
	)

	-- pour chaque layer de groupe	
		-- cacher tous les layer
		-- décacher le layer en cours
		-- enregistrer le scene state
	for l in goodLayers do
	(
		for l2 in goodlayers do l2.ishidden = true
	-- 	sceneStateMgr.MapIndexToPart 6
		l.ishidden = false
		sceneStateMgr.Capture l.name #{6}
	)
)
-- sceneStatesAutomation()



-- outputPath = @"T:\Kaufman\Amiens_0518\Prevue\Cellule\T2"
-- outputPath = @"T:\Kaufman\Amiens_0518\Cellules\CELLULES TYPE\T2_amenagement\rendus"

fn batchRenderAutomation outputPath  pref  suf=
(
-- 	outputPath = @"T:\Bouygues Immobilier\Olonne sur Mer_0518\Cellule\T3\Amenagement_01\rendus"
	
-- 	pref = "olonne"
-- 	suf = "3D"
	
	cams = for c in cameras where classof c != Targetobject collect c
	ssmCount = sceneStateMgr.GetCount()  

	for id = 1 to ssmCount do 
	(
		sceneStateName = 	sceneStateMgr.GetSceneState id
		format "sceneStateName: %\n" sceneStateName
		-- check scene state
		local check = batchRenderMgr.FindView  sceneStateName
		if check == 0 then
		(
			local batch = batchRenderMgr.CreateView undefined
			batch.name = sceneStateName
			-- trouver camera
			camCandidate = getNodebyname sceneStateName
			if superclassof camCandidate == camera then 	batch.camera = camCandidate
			
			-- trouver le nom de fichier correpondant
			local fileNameAr = filterString sceneStateName "_"
			local filename = outputPath + "\\" + pref + "_" + fileNameAr[fileNameAr.count] +"_"+ suf + ".jpg"
			
			batch.sceneStateName = sceneStateName
			batch.outputFilename = filename
		)
	)
)

-- oneOutputPath = @"T:\Bouygues Immobilier\Olonne sur Mer_0518\Cellule\T3\Amenagement_01\rendus"
-- onePref = "olonne"
-- oneSuf = "3D"

-- batchRenderAutomation oneOutputPath onePref oneSuf
try(destroydialog celluleAutoRLT)catch()
rollout celluleAutoRLT "Cellules Automation"
(
	button createSceneStateBT "create scene state"
	
	group "batch render"
	(
		edittext pathET "outPut Path:" 
		edittext prefET "prefix:" text: ""
		edittext sufET "suffix" text: ""
		button createBatchRender "create batch render"
	)
	
	on createSceneStateBT pressed do
	(
		sceneStatesAutomation()
	)
	
	on createBatchRender pressed do
	(
		if pathET.text != undefined then
		(
			if pathET.text.count > 0 then
			(
				batchRenderAutomation pathET.text prefET.text sufET.text
			)
		)
	)
)
createdialog celluleAutoRLT width: 300
