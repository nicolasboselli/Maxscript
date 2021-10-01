ref = (selection as array)[1]

-- compare les bounding box
bbref = nodeGetBoundingBox ref ref.transform
refSize = point3 (distance (point3 bb[1].x 0 0) (point3 bb[2].x 0 0)) (distance (point3 0 bb[1].y 0) (point3 0 bb[2].y 0)) (distance (point3 0 0 bb[1].z) (point3 0 0 bb[2].z))

similar = #()
for s in ($* as array) do
(
	-- compare la class
	if not classof s == classof ref then continue
	
	-- compare les bounding box
	bbs = nodeGetBoundingBox s s.transform
	sSize = point3 (distance (point3 bbs[1].x 0 0) (point3 bbs[2].x 0 0)) (distance (point3 0 bbs[1].y 0) (point3 0 bbs[2].y 0)) (distance (point3 0 0 bbs[1].z) (point3 0 0 bbs[2].z))
	
	if 	not refSize == sSize then 
	(
		format "% == % bbref:% bbs:%\n" refSize sSize ref.name s.name
	)
	-- pour les mesh
	-- compare le nombre de face
	ref.numfaces
)


fn isSimilar a b =
(
	if not classof s == classof ref then continue
		
	bbref = nodeGetBoundingBox a a.transform
	refSize = point3 (distance (point3 bb[1].x 0 0) (point3 bb[2].x 0 0)) (distance (point3 0 bb[1].y 0) (point3 0 bb[2].y 0)) (distance (point3 0 0 bb[1].z) (point3 0 0 bb[2].z))
		
	
)

