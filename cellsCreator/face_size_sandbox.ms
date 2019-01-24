struct faceStr (id, size, idmat = 1)

surfaces = for i = 1 to $.numfaces collect  (faceStr id:i size: (polyop.getFaceArea $ i))

	
-- positions =for i = 1 to 10 collect (random [0,0,0] [100,100,0])
 
fn compareFN v1 v2 =
(
	local d = (v1.size) - (v2.size)
	case of
	(
		(d < 0.): -1
		(d > 0.): 1
		default: 0
	)
)
 
qsort surfaces compareFN
-- for p in positions do print p	

tres = 10000
idMat = 1
for i = 1 to (surfaces.count) do
(
	surfaces[i].idmat = idmat
	
	if i < surfaces.count then	res = surfaces[i + 1].size - surfaces[i].size else continue
	
-- 	format "%\n" res
	if res > tres then idmat += 1	
)

for s in surfaces do 
(
	format "%\n" s
	$.setMaterialIndex 
	polyop.setFaceMatID $ #{s.id} s.idmat
)


-- sort surfaces


-- b = box length: 10 width: 10 height:10
-- for s in surfaces do
-- (
-- 	format "size: %\n" ((s.size/1000.0))
-- 	
-- 	c = copy b
-- 	move b [50,0,0]
-- 	b.height = s.size/100.0
-- )



