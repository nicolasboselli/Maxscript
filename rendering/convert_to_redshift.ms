for m in scenematerials where classof m == VRayMtl do
(
	replaceInstances m (Redshift_Material name: m.name diffuse_color:(color (random 0 255)  (random 0 255) (random 0 255)))
)	


for m in scenematerials where classof m == Redshift_Material do
(
	m.refl_weight = 0
)