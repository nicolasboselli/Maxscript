
sel = selection as array
selAr = #()

ground = sel[sel.count]

-- s = $
-- for c in $.children.count

-- dans la selection faire un array par groupe
for i = 1 to (sel.count - 1) do
(
	if not isvalidnode sel[i].parent do
	(
		append selAr #(sel[i])
	)
)

for oneSet in selAr do
(
	for o in oneset do
	(
		for c in o.children do append oneset c
	)
)
selAr

-- appliquer le deplacement sur chaque tete de groupe

for oneSet in selAr do
(
	
	-- sur chaque groupe calculer le déplacement en z
	local zmax = point3 0 0 (10^6)
	local zMin = 10^6
	for s in oneSet where iskindof s GeometryClass do
	(
		-- ajouter edit mesh
		addModifier s (edit_mesh name: "tmp_EM" )

		-- compter le nombre Vertex
		vxCount = getnumverts s

		-- collecter la position du Vertex le plus bas
		vxPosAr = for v = 1 to vxCount collect getVert s v

		for v = 1 to vxCount do
		(
			onePos = getVert s v
			
			if onePos.z < zmax.z then
			(
-- 				format "v: %  zmax.z: % onePos: %\n" v zmax.z onePos
				zmax = onePos
			)
		)
		
-- 		point position: zmax

		-- suppression du modifier
		deletemodifier s 1

		-- tirer un rayon depuis le z le plus bas
		zMinRay = ray zmax (point3 0 0 -1)

-- 		format "ground: % zMinRay: %\n" ground.name zMinRay
		impacted = intersectRay ground zMinRay
-- 		format "zmax: % impacted: % distance: % \n" zmax impacted.position (distance zmax impacted.position)
		if distance zmax impacted.position < zMin then zmin = distance zmax impacted.position
	)	
	-- move object
	move oneSet[1] (point3 0 0 -zMin)

)