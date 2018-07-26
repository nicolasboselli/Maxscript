vertsAr = #( [0,0,0], [10,0,0], [0,10,0], [10,10,0], [0,0,10], [10,0,10], [0,10,10], [10,10,10] )
facesAr = #( [1,2,3], [2,4,3], [1,2,6], [6,5,1], [6,2,8], [2,4,8], [8,7,3], [8,4,3] )
mesh vertices: vertsAr faces: facesAr




verts = #([0,0,0],[10,0,0],[0,10,0],[10,10,0])
p = converttopoly (editable_mesh ())
-- p = editable_poly ()
converttomesh t
p = converttopoly (trimesh ())
	for v in verts do polyop.createVert p v

polyop.createPolygon p #(1,2,3,4)