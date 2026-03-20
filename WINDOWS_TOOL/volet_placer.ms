fn returnBBsize4 sel = 
(
	/*
	faire focntionner la fonction sur les groupes ou les selections d'objects
	*/
	
	-- fonctionne sur les selection d'objets
	ref = sel[1]
		
	xAr = #()
	yAr = #()
	zAr = #()
	
	for s in sel do
	(
		
		local BBtmp = nodeGetBoundingBox s ref.transform
		append xAr BBtmp[1].x
		append xAr BBtmp[2].x
		append yAr BBtmp[1].y
		append yAr BBtmp[2].y
		append zAr BBtmp[1].z
		append zAr BBtmp[2].z
		for c in s.children do append sel c
	)
	
	xsize = distance ([(amin xAr),0,0]) ([(amax xAr),0,0])
	ysize = distance ([0, (amin yAr),0]) ([0,(amax yAr),0])
	zsize = distance ([0,0,(amin zAr)]) ([0,0,(amax zAr)])
		
	[xsize, ysize, zsize]
)






try(destroydialog voletsPlacerRLT)catch()
rollout voletsPlacerRLT "volet placer"
(
	local PVC_volets_roulantsMat
	
	local randomOpeningList
	
	local lameSize = 5
	local minArrayZCount = 1
	
	local percent000 = 60
	local percent050 = 20
	local percent100 = 20
	
	
	group "Random Openning Settings:"
	(
		spinner open100SP "100 %:" type: #integer range:[0,100,20]
		spinner open075SP "75 %:" type: #integer range:[0,100,20]
		spinner open050SP "50 %:" type: #integer range:[0,100,20]
		spinner open025SP "25 %:" type: #integer range:[0,100,20]
		spinner open000SP "0 %:" type: #integer range:[0,100,20]
	)
	
	group "Volets Creation:"
	(
		button placeVoletSelBT "on selection"
		button placeVoletSceneBT "on scene"
		button clearVoletSceneBT "clear volets scene"
	)
	
	group "Volets Randomisation:"
	(
		button randomizeSelVoletsBT "on selection"
		button randomizeVoletsBT "on scene"
	)
	
	fn initRandomOpeningList = 
	(
		randomOpeningList = #()
		for i = 1 to open000SP.value do append randomOpeningList 0
		for i = 1 to open025SP.value do append randomOpeningList 25
		for i = 1 to open050SP.value do append randomOpeningList 50
		for i = 1 to open075SP.value do append randomOpeningList 75
		for i = 1 to open100SP.value do append randomOpeningList 100
			
		with printAllElements on format "randomOpeningList: %\n" randomOpeningList
	)
	
	on voletsPlacerRLT open do
	(
		-- creation du materiaux des volets
		PVC_volets_roulantsMat = sceneMaterials["PVC_volets_roulants"]
		if PVC_volets_roulantsMat == undefined then PVC_volets_roulantsMat = VRayMtl diffuse: (color 235 235 235) name: "PVC_volets_roulants"
		
		initRandomOpeningList ()
		
	)
	
	on placeVoletSelBT pressed do
	(
		initRandomOpeningList()
		
		-- dans une selection
		sel = selection as Array

		windowHeads = #()

		-- collecte des fenetres
		for s in sel do
		(
			try(if (isgrouphead s) and (getUserProp s "windowsTemplate" ) then append windowHeads s)catch()
		)

		-- calculer l'emplcement du rideau
		for i=1  to windowHeads.count do
		(
			-- collecter tous les objets d'une fenetre
			windowsSet = #(windowHeads[i])
			
			for o in windowsSet do 
			(
				for c in o.children do
				(
					append windowsSet c
				)
			)
			
			-- recuperer la taille de la fenetre
			oneSize = returnBBsize4 windowsSet

			
			-- creation de la lame de volet
			oneBox = Box width: 2 length:oneSize[2] height: lameSize wirecolor: blue name: (uniquename "volet_roulant_")
			oneBox.rotation = windowHeads[i].rotation
			oneBox.position = windowHeads[i].center
			
			-- decalage vers le haut
			oneBox.position.z += oneSize.z / 2 -- lameSize
-- 			oneBox.position.x -= oneSize.x / 2 -- lameSize
			
			-- un decalage en y
-- 			oneBox.position.x -= 15
			in coordsys local oneBox.position.x -= 15
				
			-- ajout du chamfer 
			addModifier oneBox (Chamfer miterEndBias: 0 segments: 0 amount: 0.2)
			
			-- ajout du mod array
			random
			maxArrayZCount = ( oneSize.z / 5 ) as integer
			startArrayZCount =  ( random minArrayZCount maxArrayZCount)

				
			-- calcul du pourcentage d'ouverture
-- 			openPercent =  100 - ((( ( lamesize *  (startArrayZCount - 1) ) / oneSize[3]  ) * 100) as integer)
			openPercent =  randomOpeningList[random 1 randomOpeningList.count]
			
			startArrayZCount = ((maxArrayZCount * (100 - openPercent)) / 100 as integer)
			
			addModifier oneBox (Arraymodifier countX: 1 countZ: startArrayZCount offsetZ: -1)
-- 			addModifier oneBox (Arraymodifier countX: 1 countZ: 3 offsetZ: -1)
			-- format "oneSize: % maxArrayZCount: %\n" oneSize maxArrayZCount
			
			-- tagger les volets pour le retrouver dans la scene
			setUserProp oneBox "voletRoulant" "true"
			
			-- ajouter un spinner pourcentage
			voletMod = EmptyModifier name: "Ouverture_Volet"

			the_attributes = attributes volets_attributes
			(

				Parameters main rollout:voletRLT
				(
					openVal Type: #integer UI:openingSP Default:75
					vheight type: #integer  Default:200
					lamesize type: #integer  Default:5
				)
				
				
				rollout voletRLT "parametres:"
				(
					
					spinner openingSP "Ouverture (%)"  range:[0, 100, 0]  type:#integer

					on voletRLT open do
					(
						$.modifiers[#Array].countZ = ((((( 100 - openVal ) * vheight )/100)/lamesize) as integer)
					)
					
					on openingSP changed val do
					(
						$.modifiers[#Array].countZ = (((((100 - val)*vheight)/100)/lamesize) as integer)
					)
				)
			)

			custAttributes.add voletMod the_attributes
			addModifier onebox voletMod
			
			oneBox.ouverture_volet.openVal = openPercent
			oneBox.ouverture_volet.vheight = oneSize.z
-- 			oneBox.ouverture_volet.voletRLT.init()
			
			-- ajouter pvc blanc
			oneBox.material = PVC_volets_roulantsMat

			
			-- rail de gauche
			-- rail de droite
			
			
			format "volet: % / % box: % percent: % \n" i windowHeads.count onebox openPercent 
		)
	)
	
	on placeVoletSceneBT pressed do
	(
		windowHeads = #()
		
		for h in helpers where iskindof h dummy do
		(
			try(if (isgrouphead h) and (getUserProp h "windowsTemplate" ) then append windowHeads h)catch()
		)
		
		format "windowHeads: %\n" windowHeads
		for i=1  to windowHeads.count do
		(
			
			-- collecter tous les objets d'une fenetre
			windowsSet = #(windowHeads[i])
			
			for o in windowsSet do 
			(
				for c in o.children do
				(
					append windowsSet c
				)
			)
			
			-- recuperer la taille de la fenetre
			oneSize = returnBBsize4 windowsSet

			
			-- creation de la lame de volet
			oneBox = Box width: 2 length:oneSize[2] height: lameSize wirecolor: blue name: (uniquename "volet_roulant_")
			oneBox.rotation = windowHeads[i].rotation
			oneBox.position = windowHeads[i].center
			

			-- decalage vers le haut
			oneBox.position.z += oneSize.z / 2 -- lameSize
			oneBox.position.x -= oneSize.x / 2 -- lameSize
			
			-- un decalage en y
			oneBox.position.x += 15
			
			-- ajout du chamfer 
			addModifier oneBox (Chamfer miterEndBias: 0 segments: 0 amount: 0.2)
			
			-- ajout du mod array
			maxArrayZCount = ( oneSize.z / 5 ) as integer
			startArrayZCount =  ( random minArrayZCount maxArrayZCount)

				
			-- calcul du pourcentage d'ouverture
			openPercent =  randomOpeningList[random 1 randomOpeningList.count]
			
			startArrayZCount = ((maxArrayZCount * (100 - openPercent)) / 100 as integer)
			
			addModifier oneBox (Arraymodifier countX: 1 countZ: startArrayZCount offsetZ: -1)
			
			-- tagger les volets pour le retrouver dans la scene
			setUserProp oneBox "voletRoulant" "true"
			
			-- ajouter un spinner pourcentage
			voletMod = EmptyModifier name: "Ouverture_Volet"

			the_attributes = attributes volets_attributes
			(

				Parameters main rollout:voletRLT
				(
					openVal Type: #integer UI:openingSP Default:75
					vheight type: #integer  Default:200
					lamesize type: #integer  Default:5
				)
				
				
				rollout voletRLT "parametres:"
				(
					
					spinner openingSP "Ouverture (%)"  range:[0, 100, 0]  type:#integer
					
					fn init =
					(
						$.modifiers[#Array].countZ = ((((( 100 - openVal ) * vheight )/100)/lamesize) as integer)
					)
					
					on voletRLT open do
					(
						$.modifiers[#Array].countZ = ((((( 100 - openVal ) * vheight )/100)/lamesize) as integer)
					)
					
					on openingSP changed val do
					(
						$.modifiers[#Array].countZ = (((((100 - val)*vheight)/100)/lamesize) as integer)
					)
				)
			)

			custAttributes.add voletMod the_attributes
			addModifier onebox voletMod
			
			oneBox.ouverture_volet.openVal = openPercent
			oneBox.ouverture_volet.vheight = oneSize.z
			
			-- ajouter pvc blanc
			oneBox.material = PVC_volets_roulantsMat
			
			-- rail de gauche
			-- rail de droite
			
			
			format "volet: % / % box: %\n" i windowHeads.count onebox
		)
	)
	
	on clearVoletSceneBT pressed do
	(
		voletsAr = #()
		for o in objects do
		(
			res = getUserProp o "voletRoulant"
			
			if res == undefined then continue
			else if not res then continue
			
			format "res: %\n" res
			append voletsAr o
		-- 	try ()catch(false) collect o
		)
		delete voletsAr
	)
	
	on randomizeVoletsBT pressed do
	(
		-- collecte des valeur d'ouverture 

						
		
		initRandomOpeningList()
-- 		format "RandomOpeningList: %\n" RandomOpeningList 
		
		-- collecte des volets
		voletsAr = #()
		
		for g in geometry where (getUserProp g "voletRoulant" == true) do append voletsAr g

		format "voletsAr: %\n" voletsAr
		
		
		for v in voletsAr do
		(
			maxArrayZCount = ( v.ouverture_volet.vheight / 5 ) as integer
			openPercent =  randomOpeningList[random 1 randomOpeningList.count]
			startArrayZCount = ((maxArrayZCount * (100 - openPercent)) / 100 as integer)
			
			v.array.countz = startArrayZCount
			v.ouverture_volet.openVal = openPercent
-- 			v.ouverture_volet.voletRLT.init()
		)
	)
)
createdialog voletsPlacerRLT


-- placer l'objet sur la fenetres à la bonne taille