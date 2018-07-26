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
			local patterns = #("*mur*", "*plan*", "*LetC*", "*Murs*", "*murs*", "*plans*", "*Plans*", "*meubles*")
		
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
sceneStatesAutomation()
