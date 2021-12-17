

fn convertToGGX =
(
	allVr = getClassInstances vraymtl
	for m in allVr do 
	(
		m.brdf_type = 4
		if m.brdf_useRoughness == false then
		(
			m.reflection_IOR = 1.6
			m.brdf_useRoughness = true
			m.Reflection = color 255 255 255
			m.reflection_glossiness = 1 - m.reflection_glossiness
		)
	)
)
convertToGGX()