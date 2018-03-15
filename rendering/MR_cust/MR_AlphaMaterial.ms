-- amélioration  option: dans le cas d'objet présentant de la transparence ou de l'alpha adapter le matériaux blanc

Global re = maxOps.GetCurRenderElementMgr ()


	fn CleanOutEltsFN = 
(
	num = re.numrenderelements ()
		
	clean_name = ""

	for i = 0 to (num - 1) do
	(
		re.SetRenderElementFilename i clean_name
	)
)

rollout MRAlphaSelRLT "Rendu Apha de la selection."
(

	-- DECLARATION ---------------------------------------------------------------------------------------------------

	local MRbak = undefined

	-- declaration de la structure du couple objet/material
	struct objMatPair (obj , objMat )

	-- declaration de l'array d'objet à passer en alpha
	local objSelBak = #()

	-- declaration le matériaux blanc autoilluminé
		
	local MRMatLite = Arch___Design__mi name: "Alpha_Mat" diff_color: (color 255 255 255) refl_weight: 0 self_illum_on: on

	-- declaration du preset de rendu alpha
	local MR_alpha_preset = mental_ray_renderer name: "Alpha_Preset" \
	FinalGatherEnable2: false \-- désactivation du final gather, ,  
	GlobalIllumEnable: false \ -- du photon map
	ReflectionsEnable: false \ -- de la reflection,
	RefractionsEnable: false \ -- de la refraction,
	ShadowsEnable: false  -- des shadows, 

	--declaration de la structure light et etat de la light
	struct liteStatePair (lite, liteState)

	-- declaration de l'array de light
	local lightBak = #()

	-- declaration de la variable de l'état du background
	local skyStateBak = undefined

	-- declaration de la variable de l'état  de l'exposition
	local expStateBak = undefined 
	
-- 	UI
	Button selAphaMrBT "Go! Go! l'alpha"
	
-- 	event
	on selAphaMrBT pressed do
	(
		-- CREATION BACKUP ---------------------------------------------------------------------------------------------------

		-- mémoriser les objets selectionner et leur matériaux dans une structure
		objSelBak = #()
		for o in ($selection as array) do
		(
			if superclassof o == geometryclass then 
			(
				TempObjMatPair = objMatPair obj: o objMat: o.material
				append objSelBak TempObjMatPair
			)
		)
		print objSelBak

		-- mémoriser les paramètres courant de mental ray: 
		MRbak = renderers.production

		-- mémoriser les light de la scène et leur état grâce à une structure
		lightBak = #()
		for o in ($* as array) do
		(
			if superclassof o == light then 
			(
				liteTemp = liteStatePair lite: o liteState: o.on
				append lightBak liteTemp
			)
		)
		print lightBak

		-- mémoriser l'état du background
		skyStateBak = useEnvironmentMap

		-- mémoriser l'état de l'exposition
		expStateBak = SceneExposureControl.exposureControl.active

		-- PRESET ---------------------------------------------------------------------------------------------------

		-- appliqué le materiaux blanc autoilluminé aux objects selectionner
		for o in objSelBak do o.obj.material = MRMatLite

		-- application du preset de rendu alpha
		renderers.production = MR_alpha_preset

		-- extinction des lumières
		for o in lightBak do o.lite.on = false

		-- desactivation du background
		useEnvironmentMap = off

		-- desactivation de l'exposition
		SceneExposureControl.exposureControl.active = false

		-- RENDU ---------------------------------------------------------------------------------------------------
		-- faire le rendu
		CleanOutEltsFN ()
		max quick render

		-- RESTAURATION BACKUP ---------------------------------------------------------------------------------------------------

		-- restauration des matériaux aux objets
		for o in objSelBak do o.obj.material = o.objMat

		-- restauration des reglages mental ray
		renderers.production = MRbak

		-- restauration des lumières
		for o in lightBak do o.lite.on = o.liteState

		-- restauration du background
		useEnvironmentMap = skyStateBak

		-- restauration de l'état de l'exposition
		SceneExposureControl.exposureControl.active = expStateBak
	)
)

createdialog MRAlphaSelRLT
