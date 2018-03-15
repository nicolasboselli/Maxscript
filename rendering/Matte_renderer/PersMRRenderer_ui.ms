Global re = maxOps.GetCurRenderElementMgr ()
Global MR = renderers.production

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
	local ObjectSelected = $selection as array

	for o in ObjectSelected collect
	(
		elt2del = findItem  allObjects o
		deleteItem allObjects elt2del
	)
	
	return allObjects
)


/*
matteMat = Matte_Shadow_Reflection__mi name: "MatteMat" opacity: 1 catch_indirect: off catch_illuminators: off ao_on: off \
catch_shadows: on  ambient_intensity: 0.1
*/

rollout PersMRRenderRLT "Pers Render avec Mental Ray"
(
	struct objNMat (objetBak , materialBak)
	
	local otherObj = #()
	local objToMatte = #()
	local ObjNMatBak = #()
	
-- 	ui
	group "Reglage Matte Material"
	(
		checkbox catchIndLitCB "Illum indirecte" across: 4
		checkbox catchDirLitCB "Illum directe"
		checkbox catchShadowsCB "Ombre portée"
		checkbox OACB "Ambient Occlusion"
		spinner ambIntSP "Intensité de l'ambient :" range: [0,1,1] type: #float scale: 0.1 fieldwidth: 40 across: 2
		spinner opaSP "Opacité :" range: [0,1,1] type: #float scale: 0.1 fieldwidth: 40
	)
	
	group "Matte"
	(
		button ComboBT "Render others Matte!"
	)
	
-- 	events
	
	on comboBT pressed do
	(
		
	-- inversion et tri de la selection 

		objToMatte = #()
		
		otherObj =  (invertSelFN $)
		for o in otherObj do
		(				
			if ((superclassof o == GeometryClass) AND (classof o != Targetobject )) then
			(
				append objToMatte o
			)
		)
		
			
	-- memoriser pour chaque objet non selectionné le materiaux appliqué

		ObjNMatBak = for o in objToMatte collect
		(
			objNMat objetBak: o materialBak: o.material
		)
		print ObjNMatBak
	
	
	-- appliquer le matte mat aux objets nom selectionné
		matteMat = Matte_Shadow_Reflection__mi name: "MatteMat" \
		opacity: opaSP.value catch_indirect: catchIndLitCB.state \
		catch_illuminators: catchDirLitCB.state ao_on: OACB.state \
		catch_shadows: catchShadowsCB.state  ambient_intensity: 0.1

		for o in objToMatte do o.material = matteMat
	-- desactiver la photonmap
		GIback = MR.GlobalIllumEnable
		MR.GlobalIllumEnable = false

-- 	faire le rendu

		CleanOutEltsFN ()
		max quick render
	
		-- reactiver la photon map
		MR.GlobalIllumEnable = GIback
	
	-- reappliquer les materiaux d'origine au objets non selectionné

		for o in ObjNMatBak do o.objetBak.material = o.materialBak
	)
	
)


createdialog PersMRRenderRLT width: 500

 