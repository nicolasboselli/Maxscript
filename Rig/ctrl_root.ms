-- $.boxsize = [10,20,30]

-- pour chaque objet de la selection relever la bounding box en coordonnée monde
xValAr = #()
yValAr = #()
zValAr = #()

sel = selection as array

for s in sel do
(
	coord = nodeGetBoundingBox s (matrix3 1)
	for i = 1 to 2 do
	(
		append xValAr coord[i].x
		append yValAr coord[i].y
		append zValAr coord[i].z
	)
)

-- retenir les valeurs maximale et minimale en x, y , z
pt1coord = [(amin xValAr), (amin yValAr), (amin zValAr)]
pt2coord = [(amax xValAr), (amax yValAr), (amax zValAr)]

-- calculer le centre
-- point pos: ((pt1coord + pt2coord)/2)

-- creer une box de la taille de la selection en boxmode et non rendable
w = distance [(amin xValAr), 0, 0] [(amax xValAr), 0, 0]
l = distance [0, (amin yValAr), 0] [0, (amax yValAr), 0] 
h = distance [0,0,(amin zValAr)] [0,0, (amax zValAr)]

-- placer au centre de la selection
ctrl = box width: w length: l height: h wirecolor: green boxmode: true renderable: false
ctrl.center = ((pt1coord + pt2coord)/2)


	