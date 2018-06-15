/*
comment supprimer une texture bmp manquante d'un slot de material?
comment trouver le slot de materiaux contenant le bmp manquant?
faire une analyse récursive d'un matgeriaux
retourner la texture manquante avec son slot
retourner le slot sous la format d'id de subanim

*/



bmpAr = getclassinstances bitmaptexture target: scenematerials




i = 1
		
for b in bmpAr do
(
	if b.filename != undefined then
	(
		if doesfileexist b.filename then
		(
			format "%: Found: %, %\n" i b.name b.filename 
		)
		else if not doesfileexist b.filename then
		(
			format "%: Not Found: %, % \n" i b.name b.filename 
		)
		else()
		i += 1
	)
	else format "%: Undefined:  %, %\n" i undefined b.name
)

b = bmpAr[1]
-- delete b
-- b = undefined
refdep = refs.dependents b  -- immediateOnly: true
goodref = for r in refdep where superclassof r == material or superclassof r == texturemap collect r

superclassof b

mats_array = for m in sceneMaterials collect m
enumerateFiles mats_array[1] add_to_array mats_array[1]  #missing


--
bmpAr = getclassinstances bitmaptexture target: scenematerials

missBmpMatAr = #()
unBmpMatAr = #()
i = 1
for b in bmpAr do
(
	if b.filename != undefined then
	(
		if not doesfileexist b.filename then
		(
			format "missing filename: %\n" b.filename
			refdep = refs.dependents b  -- immediateOnly: true
	-- 				meditmaterials[i] = b
			
	-- 		i +=1
			
			for d in refdep do
			(
	-- 					format "d: % classof: %, i:%\n" d (classof d) i
				if classof d == vraymtl then 
				(
	-- 				format "d: % classof: %, i:%\n" d (classof d) i
					if i < 24 then
					(
	-- 					meditmaterials[i] = d
						appendifunique missBmpMatAr d
	-- 					i += 1
					)
				)
			)
		)
		else
		(
	-- 		format "filename: %\n" b.filename
		)
	)
	else
	(
		refdep = refs.dependents b  -- immediateOnly: true
		
		for d in refdep do
		(
-- 					format "d: % classof: %, i:%\n" d (classof d) i
			if classof d == vraymtl then 
			(
-- 				format "d: % classof: %, i:%\n" d (classof d) i
				if i < 24 then
				(
-- 					meditmaterials[i] = d
					appendifunique unBmpMatAr d
-- 					i += 1
				)
			)
		)
	)
	
-- 	if i == 24 then exit
)
missBmpMatAr.count

for i = 1 to 24 do meditmaterials[i] = missBmpMatAr[i]
unBmpMatAr.count

submax = unBmpMatAr[1].numsubs


unBmpMatAr[1][25].value
for i = 1 to submax do 
(
	format "% %\n" i unBmpMatAr[1][i] 
	if classof unBmpMatAr[1][i].value == bitmaptexture then
	(
		
		if unBmpMatAr[1][i].value.filename != undefined then 
		(
			
		)
		else
		(
-- 			unBmpMatAr[1][i] = undefined
			format "mat: % undefined map: %\n" unBmpMatAr[1].name unBmpMatAr[1][i].name
			unBmpMatAr[1][i].value = undefined
		)
	)
)
unBmpMatAr[1][48].value = undefined
subb = getSubAnim  unBmpMatAr[1] 48

for p in (getPropNames meditmaterials[activeMeditSlot]) do
(
	local slot =  getProperty  meditmaterials[activeMeditSlot] p
	if classof slot == bitmaptexture then
	(
		format "%\n" (getProperty  meditmaterials[activeMeditSlot] p)
		if slot.filename = undefined then setProperty  meditmaterials[activeMeditSlot] p undefined
		else if not doesfileexist slot.filename then setProperty  meditmaterials[activeMeditSlot] p undefined
		else()
	)
)

showproperties  meditmaterials[activeMeditSlot] 
getProperty  meditmaterials[activeMeditSlot] "texmap_diffuse"
setProperty  meditmaterials[activeMeditSlot] "texmap_diffuse" undefined
propNames = getPropNames meditmaterials[activeMeditSlot]
propNames.count

getNumSubMtls meditmaterials[activeMeditSlot] 

getNumSubTexmaps meditmaterials[activeMeditSlot] 
getSubTexmap  meditmaterials[activeMeditSlot] 

m = meditmaterials[activeMeditSlot]
maxsub = getNumSubTexmaps meditmaterials[activeMeditSlot]
reelmap = #()
for i = 1 to maxsub do
(
	if getSubTexmap  m i != undefined then append reelmap (getSubTexmap  m i)
)

for rm in reelmap do
(
	maxsub = getNumSubTexmaps rm
	for i = 1 to maxsub do
	(
		if getSubTexmap  rm i != undefined then append reelmap (getSubTexmap  rm i)
	)
)
reelmap


meditmaterials[activeMeditSlot][48][33].value

getSubTexmapSlotName meditmaterials[activeMeditSlot]  

refs.dependents meditmaterials[activeMeditSlot] immediateOnly: false 