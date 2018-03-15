$.scale = [1,1,1]

sel = selection as array
for s in sel do 
(
-- 	print (s.rotation as eulerangles).z
	in coordsys local s.rotation =  (eulerAngles 0 0 (random 0 360))
	rs = random 0.9 1.1
	s.scale = [rs,rs,rs]
)
