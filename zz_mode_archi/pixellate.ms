-- test = nodeLocalBoundingBox $ $Point009
sel = selection as array

for obj in sel do
(
	s = copy obj
	resetxform s
	converttomesh s
	bb = nodeLocalBoundingBox s
	print bb
-- 	point pos: bb[1]
-- 	point pos: bb[2]
	
	xtmp= distance [bb[1].x,0,0] [bb[2].x,0,0]
	ytmp= distance [bb[1].y,0,0] [bb[2].y,0,0]
	ztmp= distance [bb[1].z,0,0] [bb[2].z,0,0]
	
	local cubeSize = 5
	
	xnum = ceil (xtmp/cubeSize)
	ynum = ceil (ytmp/cubeSize)
	znum = ceil (ztmp/cubeSize)
	
-- 	print #(xnum, ynum, znum)
	
	boxNum = xnum*ynum*znum
	print boxNum
-- 	startpos = bb[1]

	local boxList = #()
	for i = 1 to xnum do
	(
		xval = bb[1].x + i*5 - cubeSize/2
		for j = 1 to ynum do
		(
			yval = bb[1].y + j*5 - cubeSize/2
			for k = 1 to znum do
			(
				zval = bb[1].z + k*5 - cubeSize
				boxTmp = box length: cubeSize width: cubeSize height: cubeSize pos: [xval, yval, zval]
-- 				append boxList boxTmp
				print (intersects s boxTmp)
			)
		)
	)

	
-- 	test = box length:ytmp width:xtmp height: ztmp
-- 	test.center = s.center
	delete s
)
-- converttomesh $
-- resetxform $

