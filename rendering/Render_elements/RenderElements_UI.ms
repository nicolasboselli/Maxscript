Global re = maxOps.GetCurRenderElementMgr ()
Global RendEltState

global OccExcludeList = # ()
global OccluMap

-- function
fn CleanOutEltsFN = 
(
	num = re.numrenderelements ()
		
	clean_name = ""

	for i = 0 to (num - 1) do
	(
		re.SetRenderElementFilename i clean_name
	)
)


rollout CustVrayEltsRT "Custom Vray Render Elements Manager" width: 300
(

	-- vars

	-- UI
	group "Set Elements"
	(
		button addEltsBT "Add Elts pour Pers" across: 2
		button RemoveElts "Remove Elements"
		button DisplayRE "display dialog"
	)
	
	checkbox EltsActiveCB "Elements active" across: 2
	button cleanOutputBT "Clean Output"
	
	group "Gestion Occlusion"
	(
		button CheckOccluReadyBT "Check Occlu Ready"
		button ExcluForOccluBT "Exclude Selection from Occlusion"
		button SelectOccluExcludedBT "Selectionner Objets Exclus de l'Occlu"
		button ClearOccluExclusionBT "Nettoyer la liste des Exclusions"
	)

	-- Actions

	on CustVrayEltsRT open do
	(
		EltsActiveCB.state = (re.GetElementsActive ())
	)
	
	on addEltsBT pressed do
	(
		re.AddRenderElement (VRayRawGlobalIllumination ())
		re.AddRenderElement (VRaySpecular ())
		re.AddRenderElement (VRayRawShadow ())
		re.AddRenderElement (VRayRawLighting ())
		re.AddRenderElement (VRayRawReflection ())
		re.AddRenderElement (VRayRawRefraction ())
		re.AddRenderElement (VRayWireColor ())
			
		re.AddRenderElement (VRayExtraTex ())
			
		test = re.GetRenderElement 7
		occluMap = vraydirt name: "occlumap" radius: 100
		test.texture = occluMap

		test.enabled = true
			
		test.elementname = "occlu"

		CleanOutEltsFN ()
	)

	on cleanOutputBT pressed do
	(
		CleanOutEltsFN ()
	)
	
	on RemoveElts pressed do
	(
		re.removeallrenderelements ()
	)
	
	
	on DisplayRE pressed do
	(
		renderSceneDialog.open ()
	)
	
	on EltsActiveCB changed thestate do 
	(
		re.setElementsActive thestate
	)
	
	on CheckOccluReadyBT pressed do
	(
		CountElts = re.NumRenderElements ()

		CurrentElts = for i = 0 to (CountElts - 1) collect re.getRenderElement i

		OccluElt

		For o in CurrentElts do 
		(
			if (o.elementname == ("occlu")) then 
			(
				print "l'occlu map est recupérer"
				OccluMap = o.texture
				OccExcludeList = OccluMap.resultAffectExcludeList
			)		
		)

-- 		OccluMap = OccluElt.texture
	)
	
	on ExcluForOccluBT pressed do 
	(
		for o in ($selection as array) do append OccExcludeList o
		OccExcludeList = makeuniqueArray OccExcludeList
		OccluMap.resultAffectExcludeList = OccExcludeList
	)
	
	on SelectOccluExcludedBT pressed do
	(
		select OccluMap.resultAffectExcludeList
	)
	
	on ClearOccluExclusionBT pressec do
	(
		OccluMap.resultAffectExcludeList = #()
	)
	
	
)

createdialog CustVrayEltsRT


