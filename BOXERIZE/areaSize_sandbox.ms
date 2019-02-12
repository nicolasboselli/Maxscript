struct boxStr (size, obj)

colorAr = #(yellow, blue, red, orange, green, brown, gray)

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

sel = selection as array

boxesAr = #()
for s in sel do
(	
	bb = nodeLocalBoundingBox s
	ar = distance bb[1] bb[2]
	oneboxStr = boxStr ar s
	append boxesAr oneboxStr
)
boxesAr

qsort boxesAr compareFN

tres = 3
randomColor = color (random 0 255) (random 0 255) (random 0 255)
j = 1
for i = 1 to (boxesAr.count) do
(
	
-- 	boxesAr[i].obj.wirecolor = randomColor
	boxesAr[i].obj.wirecolor = colorAr[j]
	boxesAr[i].obj.name = "fenetre_detach_" + (i as string)
	-- teste le seuil
	local res
	if i < boxesAr.count then
	(
		res = boxesAr[i + 1].size - boxesAr[i].size 
	)
	else if i == boxesAr.count then
	(
		res = boxesAr[i].size - boxesAr[i-1].size 
	)
	else continue
	
	-- si le seuil est depassé calcule une nouvelle couleur
	if res > tres then 
	(
		format "BREAK: %, %, %, %\n" res  boxesAr[i].size boxesAr[i].obj.name j
		randomColor = color (random 0 255) (random 0 255) (random 0 255)
		
-- 		randomColor = colorAr[j]
-- 		j += 1
-- 		if j > 7 then j = 1
	)
	else
	(
-- 		boxesAr[i].obj.wirecolor = randomColor
-- 		format " %, %\n" res  boxesAr[i].obj.name
	)
	boxesAr[i].obj.wirecolor = randomColor
)




