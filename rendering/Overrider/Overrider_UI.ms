macroscript Overrider
	category: "CustomRender"
	tooltip: "OverRider"

(
	rollout OverRiderRT "Vray OverRider Material "  
	(
	-- vars
		local vr=renderers.current

		local MatMaqDirt = VRayDirt radius: 100 occluded_color: (color 104 129 146) unoccluded_color: (color 230 230 230 )
		local OverMatMaquette = VRayMtl name: "over_maquette" diffuse:  (color 230 230 230 ) texmap_diffuse: MatMaqDirt
		
		local AtmosVRtoon =  VrayToon widthtype: 1 color: (color 72 96 108)	opacity: 0.8 lineworld: 2

		local OverMatVitre = VRayMtl name: "over_vitre" diffuse:  (color 92 175 196 ) 
	-- 	UI
		radiobuttons OverMat "Override materials" labels: #("defaut","maquette", "vitre")

		
		on OverMat changed theId do
		(
			if vr.options_overrideMtl_mtl != undefined AND vr.options_overrideMtl_mtl.name == "over_maquette" then
			(
				vr.options_overrideMtl_mtl = undefined
			vr.options_overrideMtl_on = false
			
			setActive AtmosVRtoon false
			deleteAtmospheric 1
			)
			
			if vr.options_overrideMtl_mtl != undefined AND vr.options_overrideMtl_mtl.name == "over_vitre" then
			(
				vr.options_overrideMtl_mtl = undefined
			vr.options_overrideMtl_on = false
			)
			
			if theId == 2 then
			(
				vr.options_overrideMtl_on = true
				vr.options_overrideMtl_mtl = OverMatMaquette
				
				addAtmospheric  AtmosVRtoon
				setActive AtmosVRtoon true
			)
			else if theId == 3 then
			(
				vr.options_overrideMtl_on = true
				vr.options_overrideMtl_mtl = OverMatVitre
			)
		)
	-- 	

	-- 	
		on OverRiderRT open do
		(
			if vr.options_overrideMtl_mtl != undefined AND vr.options_overrideMtl_mtl.name == "over_maquette" then
			(
				OverMat.state = 2
			)
			
			if vr.options_overrideMtl_mtl != undefined AND vr.options_overrideMtl_mtl.name == "over_vitre" then
			(
				OverMat.state = 3
			)
		)

	)

	createdialog OverRiderRT

)
