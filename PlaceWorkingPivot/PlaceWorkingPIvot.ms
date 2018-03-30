-- place working pivot 
-- a partir d une edge
edg = polyop.getEdgeSelection $
edg as array
vx = polyop.getEdgeVerts $ (edg as array)[1]
vx1 = polyop.getVert $ vx[1]
vx2 = polyop.getVert $ vx[2]

vec1 = normalize(vx1 - vx2)
vec2 = cross vec1 [0,0,1]
vec3 = cross vec1 vec2

wpTM = matrix3 vec1 vec2 vec3 [0,0,0]

-- à partir d une face
-- WorkingPivot.getTM() 
WorkingPivot.setTM wpTM

