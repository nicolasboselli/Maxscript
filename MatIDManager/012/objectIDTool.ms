



try(destroydialog gbufferChannel0RLT)catch()
rollout gbufferChannel0RLT ("Visiolab Objects ID Tool v." + ( getScriptVersion (getThisScriptFilename()) as string))
(
	local params = #("open")
	
	-- 	$.gbufferChannel = 0
		button id0bt "0 none" width: 100  across: 3 
		button id2bt "2 Vitres" width: 100
		button id4bt "4 Menuiseries"  width: 100
		button id6bt "6 Cloture" width: 100 across: 3 
		button id8bt "8 GC" width: 100
		button id10bt "10 Haies" width: 100
		button id25bt "25 Plantes" width: 100 across: 3 
		button id30bt "30 Persos" width: 100 -- across: 3 
	-- 	INT_M05 02_.PASSE_chaises
		button id40bt "40 Chaises" width: 100

		button id45bt "45 Habillage" width: 100 across: 3 
		button id50bt "50 Herbe" width: 100  -- across: 3 
		button id55bt "55 arbres" width: 100
		button id60bt "60 Terrasse" width: 100  across: 3
		button id61bt "61 Sol" width: 100 -- across: 3 
		button id62bt "62 Plafond" width: 100
		-- INT_M05 02_.PASSE_terrasse
	-- INT_M05 02_.PASSE_sol
	-- INT_M05 02_.PASSE_plafond
	
	


	on gbufferChannel0RLT open do
	(
		loadRolloutParams gbufferChannel0RLT params
	)
	
	on gbufferChannel0RLT close do
	(
		writeRolloutParams gbufferChannel0RLT params
	)
	
	on id0bt pressed do
	(
		sel = selection as Array
		for s in sel do s.gbufferChannel = 0
	)
	
	on id2bt pressed do
	(
		-- passer la vray propertie alpha à 0
		sel = selection as Array
		for s in sel do 
		(
			s.gbufferChannel = 2
			setUserPropVal s "VRay_Matte_Alpha"  0.000000
		)
	)
	
	on id4bt pressed do
	(
		sel = selection as Array
		for s in sel do s.gbufferChannel = 4
	)
	
	on id6bt pressed do
	(
		sel = selection as Array
		for s in sel do s.gbufferChannel = 6
	)
	
	on id8bt pressed do
	(
		sel = selection as Array
		for s in sel do s.gbufferChannel = 8
	)
	
	on id10bt pressed do
	(
		sel = selection as Array
		for s in sel do s.gbufferChannel = 10
	)
	
	on id25bt pressed do
	(
		sel = selection as Array
		for s in sel do s.gbufferChannel = 25
	)
	
	on id30bt pressed do
	(
		-- persos
		sel = selection as Array
		for s in sel do 
		(
			s.gbufferChannel = 30
			s.renderByLayer = true
		)
		-- ajouter au calque HAB_persos
	)
	
	on id40bt pressed do
	(
		sel = selection as Array
		for s in sel do s.gbufferChannel = 40
	)
	
	on id45bt pressed do
	(
		sel = selection as Array
		for s in sel do s.gbufferChannel = 45
	)
	
	on id50bt pressed do
	(
		sel = selection as Array
		for s in sel do s.gbufferChannel = 50
	)
	
	on id55bt pressed do
	(
		sel = selection as Array
		for s in sel do 
		(
			s.gbufferChannel = 55
			s.renderByLayer = true
		)
		-- ajouter au calque HAB_arbres
	)
	
	on id60bt pressed do
	(
		sel = selection as Array
		for s in sel do s.gbufferChannel = 60
	)
	
	on id61bt pressed do
	(
		sel = selection as Array
		for s in sel do s.gbufferChannel = 61
	) 
	
	on id62bt pressed do
	(
		sel = selection as Array
		for s in sel do s.gbufferChannel = 62
	)
)
-- createdialog gbufferChannel0RLT width: 400