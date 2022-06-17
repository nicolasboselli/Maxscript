
faceCount = polyop.getNumFaces $
-- polyop.getFaceNormal $ 1

for i = 1 to faceCount do
(
	nrl = polyop.getFaceNormal $ i
	format "i: % normal: %\n" i nrl
)

getFaceNormal  $.mesh 1