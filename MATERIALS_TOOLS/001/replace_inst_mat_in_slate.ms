 try(destroydialog repInstRLT)catch()
 rollout repInstRLT "slate tool"
 (
	local sel
	local refMat
	
	group "instance vrmatl"
	 (
		button selBT "sel node"
		edittext smeNodeET "mat name:"
		button applyBT "instance"
	 )
	
	group "convert to vrbmp"
	 (
		 button convertToVrBmpBT "convert to vraybmp"
	 )
	 
	group "convert to ggx/roughtness"
	 (
		 button convertToGGXBT "convert to GGX"
	 )
	
	on selBT pressed do
	(
		oneView = sme.GetView (sme.activeView)
		sel = oneView.GetSelectedNodes()
		if sel.count == 1 then 
		(
			refMat = sel[1]
			smeNodeET.text = refMat.reference.name
		)
		else()
	)
	
	on applyBT pressed do
	(
		oneView = sme.GetView (sme.activeView)
		sel = oneView.GetSelectedNodes()
		
		for s in sel do
		(
			replaceInstances  s.reference refMat.reference
			s.name =  s.reference.name
		)
-- 		format "s:%\n" s
		oneView.SelectNone()
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

 )
 createdialog repInstRLT
 
