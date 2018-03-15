

Global re = maxOps.GetCurRenderElementMgr ()

	-- vars 
Global allObject = $* as array
Global RenderOutputName = ""
Global NetRenderState 
Global MatteRendEltsState
Global m
Global re
-- Global pas = 0

-- fonction
	fn CleanOutEltsFN = 
(
	num = re.numrenderelements ()
		
	clean_name = ""

	for i = 0 to (num - 1) do
	(
		re.SetRenderElementFilename i clean_name
	)
)

-- invert selection
fn invertSelFN obj =
(
	local allObjects = $* as array
	local ObjectSelected = obj as array

	for o in ObjectSelected collect
	(
		elt2del = findItem  allObjects o
		deleteItem allObjects elt2del
	)
	
	return allObjects
)

-- filter object visibles
fn ObjVisFN obj =
(
	local ObjectSelected = obj as array
	local VisObject = #()
	
	for o in ObjectSelected do
	(
		if (getUserProp o "VRay_Matte_Enable" != undefined) then
		(
			append VisObject o
		)
	)
	
	return VisObject
)

-- filtrer object with vrprop
fn VrPropFilterFN obj =
(
	local VRobject = #()
	local ObjectSelected = obj as array
	
	for o in ObjectSelected do
	(
		if (getUserProp o "VRay_Matte_Enable" != undefined) then
		(
			append VRobject o
		)
	)
	return VRobject
)

fn MakeObjVrMatteFN obj =
(
	setUserProp obj "VRay_Matte_Enable" true
	setUserProp obj "VRay_Matte_Shadows" true
	setUserProp obj "VRay_Matte_ShadowAlpha" true
	setUserProp obj "VRay_Matte_Alpha" -1
-- 	setUserProp obj "VRay_Matte_GIAmount" 0
)

fn MakeObjVrUnMatteFN obj =
(
	setUserProp obj "VRay_Matte_Enable" false
	setUserProp obj "VRay_Matte_Shadows" false
	setUserProp obj "VRay_Matte_ShadowAlpha" false
	setUserProp obj "VRay_Matte_Alpha" 1
-- 	setUserProp obj "VRay_Matte_GIAmount" 1
)

rollout MattePropertiesRLT "Vray Matte Utilities"
(
-- 	UI
	group "Vray Matte Utilities"
	(
		button DeclareVRpropBT "Declare Vray Properties" across:3
		button MakeOthersMatteBT "Make Others Matte" 
		button UnMatteAllBT "Un-Matte All"
	)
	
-- 	Actions
	on DeclareVRpropBT pressed do
	(
		
		select allObject
		doVRayObjectProperties()	
	)
	
	on MakeOthersMatteBT pressed do
	(
		InvertSel = invertSelFN (selection as array)
		VisiblesObj = ObjVisFN InvertSel
		VrInvertSel = VrPropFilterFN VisiblesObj
		for o in VrInvertSel do MakeObjVrMatteFN o
	)
	
	on UnMatteAllBT pressed do
	(
		AllObj = $* as array
		VisiblesObj = ObjVisFN AllObj
		VrSel = VrPropFilterFN VisiblesObj
		for o in VrSel do MakeObjVrUnMatteFN o
	)
)

Rollout MatteRendConfigRLT "Render Selection"
(
	local MatteRendWidth = 1350
-- 	UI
	group "Chemin d'Enregistrement"
	(
		edittext RenderOutPutET "Chemin:"  readonly: true 
		edittext OuputPathResizeET "Chemin:"  readonly: true 
		Checkbox SaveRenderCB "Save Render" across: 2
		button RenderOutputBT "..."
	)
	
	group "Render Config"
	(
		radiobuttons RenderMatteTypeRB "Render Type" labels: #("View","Region") across: 2
 		radiobuttons RenderMatteSizeRB "Render Size" labels: #("1350","2700", "5000")
	)
	
	group "Render Complete"
	(
		checkbox BaseNetRenderCB "Net Render"  across: 3
		checkbox RenderEltsBaseCB "Render Elements" 
		button RenderBase2BT "Render Complete!" 
	)
	
	group "Render without Selection "
	(
		checkbox NetRenderEmptyCB "Net Render"  across: 3
		checkbox EltsRenderEmptyCB "Render Elements" 
		button RenderEmptyBT "Render Empty!" 
	)
		
	group "Selection Matte Render "
	(
		checkbox NetRenderMatteCB "Net Render" across: 3
		checkbox EltsRendMatteCB "Render Elements" 
		button RenderOtherMatteBT "Matte Render!" 
	)
	
	group "Selection Alpha Render"
	(
		checkbox NetRenderAlphaCB "Net Render" across: 2
		button RenderOtherAlphaBT "Alpha Render!"
	)
	
-- 	Actions
	
	on MatteRendConfigRLT open do
	(
		RenderOutPutET.text = rendOutputFilename
		
		BaseNetRenderCB.state =  rendusenet
		RenderEltsBaseCB.state = (re.GetElementsActive ())
		
		NetRenderEmptyCB.state = rendusenet
		EltsRenderEmptyCB.state = (re.GetElementsActive ())
		
		NetRenderMatteCB.state = rendusenet 
		EltsRendMatteCB.state = (re.GetElementsActive ())
			
		NetRenderAlphaCB.state = rendusenet
	)
	
	on RenderOutputBT pressed do
	(
		outputPath = getBitmapSaveFileName filename: RenderOutPutET.text 
-- 		if RenderOutPutET.text 
		
-- 		outputPath = selectSaveBitMap caption: ""
		if outputPath != undefined then
		(
			
			RenderOutPutET.text = outputPath
			
			renderSceneDialog.close ()
			rendOutputFilename = outputPath
			renderSceneDialog.commit ()
		)
		else
		(
			
			print "Fail"
		)
	)
	
	on RenderMatteTypeRB changed arg do
	(
		case RenderMatteTypeRB.state of
		(
			1: (
					print "view"
					renderSceneDialog.close ()
					setRenderType #view
					EditRenderRegion.UpdateRegion ()
					renderSceneDialog.commit ()
					-- renderSceneDialog.open ()
					redrawViews() 
				)
				
			2: (
					print "Region"
					renderSceneDialog.close ()
					setRenderType #region
					EditRenderRegion.EditRegion ()
					renderSceneDialog.commit ()
					-- renderSceneDialog.open ()
					redrawViews() 
				)
		)
	)
	
	on RenderMatteSizeRB changed arg do
	(
		MatteRendWidth = case RenderMatteSizeRB.state of
		(
			1: 1350
			2: 2700
			3: 5000
		)
		print MatteRendWidth
	)
		
	on RenderBase2BT pressed do
	(
		
		
		renderSceneDialog.close ()			
		
		bakOutput = rendOutputFilename
		
		slidertime 
		rendTimeType = 1
		renderWidth  = MatteRendWidth
		renderHeight  = (MatteRendWidth/1.8)
		rendSaveFile = SaveRenderCB.state
		rendusenet = BaseNetRenderCB.state
		rendOutputFilename =  RenderOutPutET.text 
		re.setElementsActive RenderEltsBaseCB.state
		
		CleanOutEltsFN ()
		
		renderSceneDialog.commit()
		max quick render
		
		rendOutputFilename = bakOutput
	)
	
		on RenderEmptyBT pressed do
	(
		SelToHide = ($selection as array)
		for o in SelToHide do hide o

		bakOutput = rendOutputFilename
		
		slidertime 
		rendTimeType = 1
		renderWidth  = MatteRendWidth
		renderHeight  = (MatteRendWidth/1.8)
		rendSaveFile = SaveRenderCB.state
		rendusenet = NetRenderEmptyCB.state
		rendOutputFilename =  (RenderOutPutET.text)
		re.setElementsActive EltsRenderEmptyCB.state
		
		CleanOutEltsFN ()
		
		renderSceneDialog.commit()
		max quick render
		
		for o in SelToHide do unhide o
		
		rendOutputFilename = bakOutput
	)
	
	on RenderOtherMatteBT pressed do
	(
		InvertSel = invertSelFN ($selection as array)
		VisiblesObj = ObjVisFN InvertSel
		VrInvertSel = VrPropFilterFN VisiblesObj
		for o in VrInvertSel do MakeObjVrMatteFN o
		CleanOutEltsFN ()
			
		renderSceneDialog.close ()			
		
		bakOutput = rendOutputFilename
		
		slidertime 
		rendTimeType = 1
		renderWidth  = MatteRendWidth
		renderHeight  = (MatteRendWidth/1.8)
		rendSaveFile = SaveRenderCB.state
		rendusenet = NetRenderMatteCB.state
		rendOutputFilename =  (RenderOutPutET.text)
		re.setElementsActive EltsRendMatteCB.state
		
		CleanOutEltsFN ()
		
		renderSceneDialog.commit()
		max quick render
		
		rendOutputFilename = bakOutput
			
		AllObj = $* as array
		VisiblesObj = ObjVisFN AllObj
		VrSel = VrPropFilterFN VisiblesObj
		for o in VrSel do MakeObjVrUnMatteFN o
	)
	
	on RenderOtherAlphaBT pressed do
	(
		-- prepa de la selection
		local SelToAlpha = selection as array
		print SelToAlpha
		Material_Bak = for o in SelToAlpha collect o.material
		for o in SelToAlpha do o.material = AutoIllumMat
		
		-- backup des parametres de rendu
		VrayStateBak = renderers.current
		backgroundColorBak = backgroundColor
		EnvironStateBak = useEnvironmentMap
		ExpoStateBak = sceneExposureControl.exposureControl
		RenderEltsStateBak = re.getElementsActive ()
		
		-- applicationd des params de rendus alpha
		renderers.current = VrayAlphaPreset
		useEnvironmentMap = false
		backgroundColor = (color 0 0 0)
		sceneExposureControl.exposureControl = undefined
		
		SwapVrayCamExpFN false
		
		-- rendu
		renderSceneDialog.close ()			
	
		slidertime 
		rendTimeType = 1
		renderWidth  = MatteRendWidth
		renderHeight  = (MatteRendWidth/1.8)
		rendSaveFile = SaveRenderCB.state
		rendusenet = NetRenderAlphaCB.state
		rendOutputFilename =  (RenderOutPutET.text + "_alpha.jpg")
		re.setElementsActive false
		
		CleanOutEltsFN ()
		
		renderSceneDialog.commit()
		
		-- rendus
		max quick render
		
		-- recup des materiaux originaux de la selection
		for i = 1 to SelToAlpha.count do SelToAlpha[i].material = Material_Bak[i]
		
		-- recup des preset de rendu
		SwapVrayCamExpFN true
		
		renderers.current = VrayStateBak
		useEnvironmentMap = EnvironStateBak
		backgroundColor = backgroundColorBak
		sceneExposureControl.exposureControl = ExpoStateBak 
		re.setElementsActive RenderEltsStateBak
	)
)

rollout PersVrayRendererRT "Vray Pers"
(
	subrollout TestPlaceSRLT height: 600
)

-- Check RE et M

createdialog PersVrayRendererRT width: 600

-- AddSubRollout PersVrayRendererRT.TestPlaceSRLT VrayPropertiesDeclareRLT
AddSubRollout PersVrayRendererRT.TestPlaceSRLT MattePropertiesRLT
-- AddSubRollout PersVrayRendererRT.TestPlaceSRLT BaseRendConfRLT
AddSubRollout PersVrayRendererRT.TestPlaceSRLT MatteRendConfigRLT










------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


	-- ameliorations

-- Base render
	-- net render: le chemin d'enregistrement ne s'écrit pas correctement
	-- prévoir un renommage de fichier si dans les jobs deja envoyés il y en a un du meme nom

-- parametrer le render elements independamment : au niveau de la fonction render, le parametre renderelements permet juste d autoriser la sortie des elemenst. pour empecher le calcul il faut agir au niveau du manager de render element


-- Matte render

-- 	créer le rendu alpha de la selection


	
	



