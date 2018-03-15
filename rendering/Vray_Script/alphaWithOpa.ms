


sel = selection as array
AutoIllumMat = vraylightmtl twoSided: on

Material_Bak = for o in sel collect o.material

vrayBak = renderers.current


fn VrayCamExpStateFN TheState = 
(
	for o in cameras do
	(
		if classof o == Vrayphysicalcamera then
		(
			o.exposure = TheState
		)
	)
)

fn standardToVrLightMtlOpa s =
(
	bakOpaMap = s.material.opacityMap
	vrLightMtl = vraylightmtl opacity_texmap: bakOpaMap opacity_multiplyColor: on  twoSided: on
	s.material = vrLightMtl
)

for s in sel do
(
	if (classof (s.material) == standard) then
	(
		if s.material.opacityMap != undefined then standardToVrLightMtlOpa s
	)
	else if (classof (s.material) == vraymtl ) then
	(
		s.material = AutoIllumMat
	)
	else if (classof (s.material) == multimaterial) then
	(
-- 		copy material
		multiOpaMat = copy s.material
-- 		for each material in multimaterial
		for m in multiOpaMat do
		(
			if (classof (s.material) == standard) then
			(
				if s.material.opacityMap != undefined then standardToVrLightMtlOpa s
			)
		)
			-- if opacity map create opacity material
	)
	else if (classof (s.material)== VRay2SidedMtl) then
	(
		vr2sideMtl =  copy s.material
		if classof vr2sideMtl.frontMtl == vraymtl then
		(
			if vr2sideMtl.frontMtl.opacity != undefined then
			(
				opaMap = s.material.frontMtl.opacity
				vr2sideMtl.frontMtl = vraylightmtl twoSided: on opacity_texmap: opaMap opacity_multiplyColor: on
				vrayBak.options_maps = true
			)
		)
		if classof vr2sideMtl.backMtl == vraymtl then
		(
			if vr2sideMtl.backMtl.opacity != undefined then
			(
				opaMap = s.material.backMtl.opacity
				vr2sideMtl.backMtl = vraylightmtl twoSided: on opacity_texmap: opaMap opacity_multiplyColor: on
				vrayBak.options_maps = true
			)
		)
		s.material = vr2sideMtl
	)
	else
	(
		s.material = AutoIllumMat
	)
)

VrayCamExpStateFN false
max quick render
for i = 1 to sel.count do sel[i].material = Material_Bak[i]
VrayCamExpStateFN true
	


