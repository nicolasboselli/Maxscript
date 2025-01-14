 fn collectObjsByMat =
(
	-- collecte objets par materiaux et sous multi mat
	smeAr = ((sme.getview 1).GetSelectedNodes())
	smeNode = smeAr[1]
	depAr = refs.dependents smeNode.reference

	objsByMat = #()
	for d in depAr do
	(
	-- 	format "d:%\n" d
		if iskindof d GeometryClass then
		(
-- 			format "	d: % d.class: %\n" d (classof d)
			append objsByMat d
		) 
	)
	format "Collect done\n\n"
	select objsByMat
)
-- collectObjsByMat()
 
 try(destroydialog repInstRLT)catch()
 rollout repInstRLT "slate tool"
 (
	local sel
	local refMat
	
	group "instance vrmtl"
	 (
		button selBT "sel node"
		checkbox keepNameCB "Keep Name:" checked: true
		edittext smeNodeET "mat name:" readonly: true
		button applyBT "instance" across: 2
		button copyMatBT2 "copy copy"
		button copyMatBT "copy"  enabled: false
	 )
	
	group "convert to vrbmp"
	 (
		button convertToVrBmpBT "bmp > vraybmp"
		button autodeskBmpToVrBmpBT "autodeskBmp > vraybmp"
	 )
	 
	group "convert to ggx/roughtness"
	 (
		 button convertToGGXBT "convert to GGX"
	 )
	 
	group "collect by material"
	 (
		button collectObjsByMatBT "collect by material" 
	 )
	 
	group "create materials"
	(
		button createMultiMatBT "create Multi Material"
	)
	
	on selBT pressed do
	(
		oneView = sme.GetView (sme.activeView)
		sel = oneView.GetSelectedNodes()
		if sel.count == 1 then 
		(
			refNode = sel[1]
			refMat = refNode.reference
			smeNodeET.text = refMat.name
		)
		else()
	)
	
	on applyBT pressed do
	(
		format "keepNameCB.checked: %\n" keepNameCB.checked
		
		oneView = sme.GetView (sme.activeView)
		sel = oneView.GetSelectedNodes()
		
		for s in sel do
		(
			replaceInstances  s.reference refMat
			if keepNameCB.checked then 
			(
				s.reference.name = s.name
			)
			else 
			(
				s.name =  s.reference.name
			)
		)
-- 		format "s:%\n" s
		oneView.SelectNone()
	)
	
	on copyMatBT pressed do
	(
		format "keepNameCB.checked: %\n" keepNameCB.checked
		
		
		
		oneView = sme.GetView (sme.activeView)
		sel = oneView.GetSelectedNodes()
		matToReplaceAr = for s in sel collect s.reference
		
		format "check1\n" 
		
		for m in matToReplaceAr do
		(
			format "check11\n" 
			format "refMat.reference: %\n" refMat.name
-- 			local copyMat = copy refMat.reference
			format "check12\n" 
			replaceInstances   m (copy refMat)
			
			if keepNameCB.checked then 
			(
				m.name = s.name
			)
			else 
			(
				s.name =  s.m
			)
		)

		format "check2\n" 
		
		oneView.SelectNone()
		format "check3\n" 
	)
	
	on copyMatBT2 pressed do
	(
		duplicateMat = copy refMat
		assignNewName duplicateMat
		local copyMat = (sme.getview 1).CreateNode (copy refMat) [0,0]
		
		
		oneView = sme.GetView (sme.activeView)
		sel = oneView.GetSelectedNodes()
		matToReplaceAr = for s in sel collect s.reference
		
		format "check1\n" 
		
		for m in matToReplaceAr do
		(
			local bakname = m.name
			format "check11\n" 
			format "refMat.reference: %\n" refMat.name
-- 			local copyMat = copy refMat.reference
			format "check12\n" 
			replaceInstances   m copyMat.reference
			
			if keepNameCB.checked then 
			(
				m.name = bakname
			)
			else 
			(
				m.name = refMat.name
				--copyMat.reference.name =  s.m
			)
		)

		format "check2\n" 
		
-- 		oneView.SetSelectedNodes copyMat
-- 		oneview.DeleteSelection() 
		oneView.SelectNone()
		format "check3\n" 
	)
	
	on convertToGGXBT pressed do
	(
		oneView = sme.GetView (sme.activeView)
		sel = oneView.GetSelectedNodes()
		
		for s in sel do 
		(
			try(s.reference.brdf_type = 4)catch(format "ggx fail: %\n" s.reference.name )
		)
	)
	
	on convertToVrBmpBT pressed do
	(
		smeAr = ((sme.getview 1).GetSelectedNodes())

		for smeNode in smeAr do
		(
			format "smeNode: %\n" (smeNode.reference)
			if iskindof smeNode.reference Bitmaptexture then 
			(
				bmpFile = smeNode.reference.filename
				vrBmp = VRayBitmap HDRIMapName: bmpfile
				
				propNamesAr = #( #mapping , #mapChannel, #mappingType, #UVW_Type, #U_Mirror, 
					#V_Mirror, #U_Tile, #V_Tile, #showMapOnBack, #Noise_On, 
					#Noise_Animate, #realWorldScale, #realWorldHeight, 
					#realWorldWidth, #phase, #U_Offset, #V_Offset, #U_Tiling, #V_Tiling, 
					#W_angle, #V_Angle, #U_Angle, #Blur_Offset, 
					#Noise_Amount, #Noise_Size, #Noise_Levels)
					
-- 				copie des propriétés de coordonnées ignore: #UVTransform, #blur
-- 				propNamesAr = getPropNames smeNode.reference.coords
				for p in propNamesAr do 
				(
-- 					format "p: % vrBmp.coords p: % smeNode.reference.coords p: %\n" p (getProperty vrBmp.coords p)  (getProperty smeNode.reference.coords p)
					setProperty vrBmp.coords p (getProperty smeNode.reference.coords p)
				)
				
-- 				test = (sme.getview 1).CreateNode vrBmp [0,0]
				replaceinstances smeNode.reference vrBmp
			)
		)
	)

	on autodeskBmpToVrBmpBT pressed do
	(
				smeAr = ((sme.getview 1).GetSelectedNodes())

		for smeNode in smeAr do
		(
			if iskindof smeNode.reference Autodesk_Map then 
			(
				bmpFile = smeNode.reference.Parameters_Source.filename
				vrBmp = VRayBitmap HDRIMapName: bmpfile
				
				replaceinstances smeNode.reference vrBmp
			)
		)
	)
	
	on collectObjsByMatBT pressed do
	(
				-- collecte objets par materiaux et sous multi mat
		smeAr = ((sme.getview 1).GetSelectedNodes())
		smeNode = smeAr[1]
		depAr = refs.dependents smeNode.reference

		objsByMat = #()
		for d in depAr do
		(
		-- 	format "d:%\n" d
			if iskindof d GeometryClass then
			(
				if isvalidnode d then append objsByMat d
	-- 			format "	d: % d.class: %\n" d (classof d)
				
			) 
		)
		format "Collect done:% \n\n" objsByMat
-- 		for o in objsByMat do print o
		
		select objsByMat
	)
	
	on createMultiMatBT pressed do
	(
		multiMatNode = Multimaterial numsubs: 2
		test = (sme.getview 1).CreateNode multiMatNode [0,0]
	)
 )
 createdialog repInstRLT
 
 
--  vrRAL = VRayColor color: blue
--  showproperties vrRAL
-- (sme.getview 1).CreateNode  vrRAL (point2 100 100)

 