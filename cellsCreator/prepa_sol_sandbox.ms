-- getmaterialID $ 1 1

l = $
spCount = numsplines l
for i = 1 to spCount do
(
	segCount = numSegments l i
	for j = 1 to segCount do
	(
		idMat = getmaterialID l i j
		format "l: % sp: % seg: % id: %\n" l.name i j idMat
	)
)
