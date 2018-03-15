rollout MakeSelectionMatte "make selection matte" width: 600
(
	-- vars 
	local allObject = $* as array
	local RenderOutputName = ""
	local NetRenderState 
	
	-- fonction
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
		)
		
		fn MakeObjVrUnMatteFN obj =
		(
			setUserProp obj "VRay_Matte_Enable" false
			setUserProp obj "VRay_Matte_Shadows" false
			setUserProp obj "VRay_Matte_ShadowAlpha" false
			setUserProp obj "VRay_Matte_Alpha" 1
		)

	
	-- UI
	group "vray properties"
	(
		button DeclareVRpropBT "declare vray properties" 
	)
-- 	checkbutton MatteToggleCB "Make Others Matte"
	group "matte properties"
	(
		button MakeOthersMatteBT "Make Others Matte" across:2
		button UnMatteAllBT "Un-Matte All"
	)
	
	group "render config"
	(
		edittext RenderOutPutET "chemin"  readonly: true
		button RenderOutputBT "..."
		checkbox RenderEltsCB "Render Elements" across: 2
		checkbox NetRenderCB "Net Render"
	)
	
	button RenderOtherMatteBT "render others matte"
		

	-- actions
	
-- 	DeclareVRpropBT
	
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
	
	on RenderOtherMatteBT pressed do
	(
		InvertSel = invertSelFN (selection as array)
		VisiblesObj = ObjVisFN InvertSel
		VrInvertSel = VrPropFilterFN VisiblesObj
		for o in VrInvertSel do MakeObjVrMatteFN o
			
		render  frame: #current outputfile: RenderOutputName netrender: true
		
		AllObj = $* as array
		VisiblesObj = ObjVisFN AllObj
		VrSel = VrPropFilterFN VisiblesObj
		for o in VrSel do MakeObjVrUnMatteFN o
	)
	
	on RenderOutputBT pressed do
	(
		outputPath = selectSaveBitMap caption: ""
		if outputPath != undefined then
		(
			RenderOutputName = outputPath
			RenderOutPutET.text = outputPath
		)
		else
		(
			print "Fail"
		)
	)
	
	on RenderEltsCB changed theState do 
	(
		RenderEltInt = maxOps.GetCurRenderElementMgr ()
		RenderEltInt.SetElementsActive  theState
	)

	)

createdialog MakeSelectionMatte

	-- ameliorations
-- 	recuperer taille image, render elements, net render depuis commen render manager
-- 	pour render elements coché utiliser le clean output
-- 	envoyer le rendu complet
-- 	créer le rendu alpha de la selection
	
	



