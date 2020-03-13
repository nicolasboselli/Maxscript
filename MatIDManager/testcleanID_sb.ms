-- assign de maniere incrementale des id au materiaux en evitant d'appliquer plusieurs fois des id et en evitant de changer les id deja affecter

fn returnCleanId =
(
	-- collecter les ids de materiaux deja affecter dans la scene
	local usedIds = #()
	local sceneMat = getclassinstances vrayMtl target: scenematerials
	for m in sceneMat do appendifunique usedIds m.effect_id
	sort usedIds

	-- appliquer les ids de materiaux en evitant les ids deja attribuées
	local j = 0
	j += 1
	local jAr = #(j)

	local turn = 0

	-- determination d'une id disponible
	for id in jAr do
	(
		-- test de l'id			
		local res = finditem usedIds id
-- 		format "id: % res:%\n" id res
		
		-- si l'idée est dé
		if res > 0 then 
		(
			j += 1
			append jAR j
		)
		
		-- sécurité anti boucle
		turn +=1 
		if turn > 50 then exit
	)
	format "clean id:%\n" j
	j
)
returnCleanId()

for i = 1 to matArToDisp.count do
(
	-- si une id est deja affecté passer
	if matArToDisp[i].effect_id != 0 and not forceID then continue
	-- générer une id
	j =+ 1

	
	-- verifier l'id déja affecté 
	local res = finditem usedIds i
	
	-- si l'id est deja affecter passer
	if res > 0 and not forceID then continue
			
	-- si une id est déja affecter au materiaux
	if matAr[i].effect_id != 0 and not forceID then
	(
			-- eviter de l'affecter ailleurs
			-- 
		format "i: % deja assign: % id: %\n" i matAr[i].name matAr[i].effect_id
	)
	else
	(
		matAr[i].override_effect_id = on
		matAr[i].effect_id = i
		format "id: % assign: %\n" i matAr[i].name
	)
)