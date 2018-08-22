vertsAr = #( [0,0,0], [10,0,0], [0,10,0], [10,10,0], [0,0,10], [10,0,10], [0,10,10], [10,10,10] )
p = converttopoly (editable_mesh ())
for v in vertsAr do polyop.createVert p v

facesAr = #( #(2,1,3,4), #(7,5,6,8), #(7,5,1,3), #(8,6,2,4), #(8,7,3,4), #(5,6,2,1) )
for f in facesAr do
(
	res = polyop.createPolygon p f
	format "res: %\n" res
)
redrawviews ()

select p

faceSel = polyop.getFaceSelection $

for f in faceSel do
(
	format "f: %\n" f
	verts = polyop.getFaceVerts $ f
	format "verts: %\n" verts
	for v in verts  do
	(
		format "\tv: % coord: %\n"  v (polyop.getVert $ v)
	)
)