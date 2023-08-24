sel = selection as Array

for s in sel do
(
	bb = nodeGetBoundingBox  s s.transform
	r = (distance (point3 bb[1].x 0 0 ) (point3 bb[2].x 0 0)) as integer
	v = (distance (point3 0 bb[1].y 0 ) (point3 0 bb[2].y 0)) as integer
	b = (distance (point3 0 0 bb[1].z ) (point3 0 0 bb[2].z)) as integer
	s.wirecolor = color r v b
)


	
	