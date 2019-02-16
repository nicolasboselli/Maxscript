/*
maj:
	-- calculer les couleur de manière à toujours retomber sur les memes
		-- en fonction des taille de boite?
*/

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
-- 	boxesAr[i].obj.wirecolor = colorAr[j]
	boxesAr[i].obj.wirecolor = randomColor
	boxesAr[i].obj.name = "fenetre_detach_" + (i as string)
	
	-- teste le seuil
	local res
	local lastRes
	
	if i < boxesAr.count then
	(
		res = boxesAr[i + 1].size - boxesAr[i].size 
		if res > tres then 
		(
		-- si le seuil est depassé, si l'objet suivant est beaucoup plus grand que l'objet traité alors  calcul d'une nouvelle couleur appliqué au prochain tour
			format "BREAK: %, size: %, %, %\n" res  boxesAr[i].size boxesAr[i].obj.name j
			randomColor = color (random 0 255) (random 0 255) (random 0 255)
		)
	)
	else if i == boxesAr.count then
	(
		-- traitement special pour le dernier objet de la selection
		lastRes = boxesAr[i].size - boxesAr[i-1].size
		if lastRes > tres then  boxesAr[i].obj.wirecolor = color (random 0 255) (random 0 255) (random 0 255)
	)
	else continue

)




