car = geometry as array
select car
-- remove meshsmooth
print car.count
for o in car do 
(
	mshMod = o.modifiers["MeshSmooth"]
	if mshMod != undefined do
	(
		deleteModifier  o  mshMod
	)
	
)

-- collect object with modifier
test = #()
for o in car do
(
	if o.modifiers.count > 0 do
	(
		append test o
	)
)
select test


-- diminue reflection sample
for mat in scenematerials do
(
	if classof mat == vraymtl then
	(
		if mat.reflection_subdivs > 8 do
		(
			mat.reflection_subdivs = 8
		)

	)
	else if classof mat == multimaterial then
	(
		for m in mat do
		(
			if classof m == vraymtl then
			(
				if m.reflection_subdivs > 8 do
				(
					m.reflection_subdivs = 8
				)
			)
		)
	)
)


-- collect non vraymtl
matList = #()

for mat in scenematerials do
(
	if classof mat == multimaterial then
	(
		for m in mat do
		(
			if classof m != vraymtl then
			(
				appendifunique matList m
			)
		)
	)
	else if classof mat != vraymtl then
	(
		appendifunique matList mat
	)
)

for i= 1 to matList.count do
(
	meditmaterials[i] = matList[i]
)

-- collect vraymtl with displacement
dispMat = #()
for mat in scenematerials do
(
	if classof mat == multimaterial then
	(
		for m in mat do
		(
			if classof m == vraymtl then
			(
				if m.texmap_displacement != undefined then
				(
					print m
					appendifunique dispMat m
				)
			)
		)
	)
	else if classof mat == vraymtl then
	(
		if mat.texmap_displacement != undefined then
		(
			print mat
			appendifunique dispMat mat
		)
	)
)
for i= 1 to dispMat.count do
(
	meditmaterials[i] = dispMat[i]
)



